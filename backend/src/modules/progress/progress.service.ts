import { HttpStatus, Injectable } from '@nestjs/common';
import {
  EnrollmentStatus,
  QuestKind,
  XPReason,
} from '@prisma/client';
import { ApiError } from '../../common/api-error';
import { startOfUtcDay } from '../../common/streak';
import { PrismaService } from '../../prisma/prisma.service';
import { levelFromXp } from '../../common/xp';
import { AchievementsService } from '../achievements/achievements.service';
import { StreaksService } from '../streaks/streaks.service';
import { XpService } from '../xp/xp.service';
import { CompleteLessonDto, EnrollDto } from './dto/progress.dto';

const QUEST_TARGETS: Record<QuestKind, number> = {
  LESSONS: 3,
  QUIZZES: 1,
  XP: 100,
  STREAK: 1,
};

@Injectable()
export class ProgressService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly xp: XpService,
    private readonly streaks: StreaksService,
    private readonly achievements: AchievementsService,
  ) {}

  async enroll(userId: string, dto: EnrollDto) {
    const course = await this.prisma.course.findFirst({
      where: {
        ...(dto.courseId ? { id: dto.courseId } : { slug: dto.slug ?? '' }),
        published: true,
      },
      select: { id: true },
    });
    if (!course) {
      throw new ApiError(HttpStatus.NOT_FOUND, 'COURSE_NOT_FOUND', 'Course not found');
    }
    return this.prisma.enrollment.upsert({
      where: { userId_courseId: { userId, courseId: course.id } },
      create: { userId, courseId: course.id },
      update: { status: EnrollmentStatus.ACTIVE },
    });
  }

  async completeLesson(userId: string, lessonId: string, dto: CompleteLessonDto) {
    const lesson = await this.prisma.lesson.findUnique({
      where: { id: lessonId },
      select: { id: true, title: true, xpReward: true, module: { select: { courseId: true } } },
    });
    if (!lesson) {
      throw new ApiError(HttpStatus.NOT_FOUND, 'LESSON_NOT_FOUND', 'Lesson not found');
    }

    const previous = await this.prisma.lessonProgress.findUnique({
      where: { userId_lessonId: { userId, lessonId } },
    });
    const nowCompleted = !previous?.completed;

    await this.prisma.lessonProgress.upsert({
      where: { userId_lessonId: { userId, lessonId } },
      create: {
        userId,
        lessonId,
        completed: true,
        attempts: 1,
        completedAt: new Date(),
        ...(dto.codeSnapshot ? { codeSnapshot: dto.codeSnapshot } : {}),
      },
      update: {
        completed: true,
        attempts: { increment: 1 },
        completedAt: previous?.completedAt ?? new Date(),
        ...(dto.codeSnapshot ? { codeSnapshot: dto.codeSnapshot } : {}),
      },
    });

    let xpAwarded = 0;
    if (nowCompleted) {
      xpAwarded = lesson.xpReward;
      await this.xp.award(
        userId,
        lesson.xpReward,
        XPReason.LESSON_COMPLETE,
        lesson.id,
        `Lesson completed: ${lesson.title}`,
      );
      await this.advanceQuest(userId, QuestKind.LESSONS, 1);
      await this.advanceQuest(userId, QuestKind.XP, lesson.xpReward);
    }

    await this.syncCourseProgress(userId, lesson.module.courseId);
    const streak = await this.streaks.checkIn(userId);
    await this.achievements.evaluate(userId);

    return {
      lessonId,
      completed: true,
      xpAwarded,
      streakCount: streak.streakCount,
      courseProgressPercent: await this.coursePercent(userId, lesson.module.courseId),
    };
  }

  async overview(userId: string) {
    const [user, enrollments, lessons, quizzes, weekStart] = await Promise.all([
      this.prisma.user.findUnique({ where: { id: userId } }),
      this.prisma.enrollment.count({ where: { userId, status: EnrollmentStatus.ACTIVE } }),
      this.prisma.lessonProgress.count({ where: { userId, completed: true } }),
      this.prisma.quizAttempt.count({ where: { userId, passed: true } }),
      Promise.resolve(new Date(Date.now() - 7 * 86_400_000)),
    ]);
    if (!user) {
      throw new ApiError(HttpStatus.NOT_FOUND, 'USER_NOT_FOUND', 'User not found');
    }
    const weeklyXp = await this.prisma.xPTransaction.aggregate({
      where: { userId, createdAt: { gte: weekStart } },
      _sum: { amount: true },
    });
    return {
      xp: user.xp,
      level: user.level,
      computedLevel: levelFromXp(user.xp),
      streakCount: user.streakCount,
      longestStreak: user.longestStreak,
      activeCourses: enrollments,
      completedLessons: lessons,
      passedQuizzes: quizzes,
      weeklyXp: weeklyXp._sum.amount ?? 0,
    };
  }

  async courseProgress(userId: string, slug: string) {
    const course = await this.prisma.course.findUnique({
      where: { slug },
      select: { id: true, published: true },
    });
    if (!course || !course.published) {
      throw new ApiError(HttpStatus.NOT_FOUND, 'COURSE_NOT_FOUND', 'Course not found');
    }
    const [enrollment, completed, total] = await Promise.all([
      this.prisma.enrollment.findUnique({
        where: { userId_courseId: { userId, courseId: course.id } },
      }),
      this.prisma.lessonProgress.count({
        where: { userId, completed: true, lesson: { module: { courseId: course.id } } },
      }),
      this.prisma.lesson.count({ where: { module: { courseId: course.id } } }),
    ]);
    return {
      courseId: course.id,
      enrolled: enrollment !== null,
      status: enrollment?.status ?? null,
      completedLessons: completed,
      totalLessons: total,
      progressPercent: total === 0 ? 0 : Math.round((completed / total) * 100),
    };
  }

  async dailyQuests(userId: string) {
    const today = startOfUtcDay(new Date());
    const kinds: QuestKind[] = [QuestKind.LESSONS, QuestKind.QUIZZES, QuestKind.XP];
    for (const kind of kinds) {
      await this.prisma.dailyQuest.upsert({
        where: { userId_kind_date: { userId, kind, date: today } },
        create: { userId, kind, date: today, target: QUEST_TARGETS[kind] },
        update: {},
      });
    }
    const quests = await this.prisma.dailyQuest.findMany({
      where: { userId, date: today },
      orderBy: { kind: 'asc' },
    });
    return {
      data: quests.map((quest) => ({
        id: quest.id,
        kind: quest.kind,
        target: quest.target,
        progress: Math.min(quest.progress, quest.target),
        xpReward: quest.xpReward,
        completed: quest.completedAt !== null,
      })),
      meta: { nextCursor: null, hasMore: false, total: quests.length },
    };
  }

  async advanceQuest(userId: string, kind: QuestKind, amount: number): Promise<void> {
    const today = startOfUtcDay(new Date());
    const target = QUEST_TARGETS[kind];
    const quest = await this.prisma.dailyQuest.findUnique({
      where: { userId_kind_date: { userId, kind, date: today } },
    });
    const progress = (quest?.progress ?? 0) + amount;
    const completed = !quest?.completedAt && progress >= target;

    await this.prisma.dailyQuest.upsert({
      where: { userId_kind_date: { userId, kind, date: today } },
      create: {
        userId,
        kind,
        date: today,
        target,
        progress: Math.min(progress, target),
        ...(completed ? { completedAt: new Date() } : {}),
      },
      update: {
        progress: Math.min(progress, target),
        ...(completed ? { completedAt: new Date() } : {}),
      },
    });

    if (completed) {
      await this.xp.award(userId, quest?.xpReward ?? 30, XPReason.DAILY_QUEST, kind, 'Daily quest complete');
    }
  }

  private async coursePercent(userId: string, courseId: string): Promise<number> {
    const [completed, total] = await Promise.all([
      this.prisma.lessonProgress.count({
        where: { userId, completed: true, lesson: { module: { courseId } } },
      }),
      this.prisma.lesson.count({ where: { module: { courseId } } }),
    ]);
    return total === 0 ? 0 : Math.round((completed / total) * 100);
  }

  private async syncCourseProgress(userId: string, courseId: string): Promise<void> {
    const percent = await this.coursePercent(userId, courseId);
    await this.prisma.enrollment.updateMany({
      where: { userId, courseId },
      data: {
        progressPercent: percent,
        status: percent === 100 ? EnrollmentStatus.COMPLETED : EnrollmentStatus.ACTIVE,
        completedAt: percent === 100 ? new Date() : null,
      },
    });
  }
}
