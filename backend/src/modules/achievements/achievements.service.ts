import { HttpStatus, Injectable } from '@nestjs/common';
import {
  Badge,
  BadgeCriteriaType,
  EnrollmentStatus,
  NotificationType,
  XPReason,
} from '@prisma/client';
import { ApiError } from '../../common/api-error';
import { paginate } from '../../common/pagination';
import { PrismaService } from '../../prisma/prisma.service';
import { XpService } from '../xp/xp.service';
import { AchievementsQueryDto } from './dto/achievements.dto';

@Injectable()
export class AchievementsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly xp: XpService,
  ) {}

  async listBadges(query: AchievementsQueryDto) {
    const limit = query.limit ?? 20;
    const rows = await this.prisma.badge.findMany({
      take: limit + 1,
      ...(query.cursor ? { cursor: { id: query.cursor }, skip: 1 } : {}),
      orderBy: [{ rarity: 'asc' }, { code: 'asc' }],
    });
    return paginate(rows, limit);
  }

  async myBadges(userId: string, query: AchievementsQueryDto) {
    const limit = query.limit ?? 20;
    const rows = await this.prisma.userBadge.findMany({
      where: { userId },
      take: limit + 1,
      ...(query.cursor ? { cursor: { id: query.cursor }, skip: 1 } : {}),
      orderBy: { unlockedAt: 'desc' },
      include: { badge: true },
    });
    return paginate(rows, limit);
  }

  async evaluate(userId: string): Promise<{ evaluated: number; unlocked: Badge[] }> {
    const [user, badges, unlocked] = await Promise.all([
      this.prisma.user.findUnique({
        where: { id: userId },
        select: { xp: true, longestStreak: true },
      }),
      this.prisma.badge.findMany(),
      this.prisma.userBadge.findMany({ where: { userId }, select: { badgeId: true } }),
    ]);
    if (!user) {
      throw new ApiError(HttpStatus.NOT_FOUND, 'USER_NOT_FOUND', 'User not found');
    }

    const alreadyUnlocked = new Set(unlocked.map((item) => item.badgeId));
    const newlyUnlocked: Badge[] = [];

    for (const badge of badges) {
      if (alreadyUnlocked.has(badge.id)) continue;
      const qualifies = await this.qualifies(badge, userId, user.xp, user.longestStreak);
      if (!qualifies) continue;

      await this.prisma.userBadge.create({
        data: { userId, badgeId: badge.id },
      });
      await this.xp.award(
        userId,
        badge.xpReward,
        XPReason.BADGE_UNLOCK,
        badge.id,
        `Badge unlocked: ${badge.name}`,
      );
      await this.prisma.notification.create({
        data: {
          userId,
          type: NotificationType.ACHIEVEMENT_UNLOCKED,
          title: `Badge unlocked: ${badge.name}`,
          body: badge.description,
          data: { badgeId: badge.id, code: badge.code },
        },
      });
      newlyUnlocked.push(badge);
    }

    return { evaluated: badges.length, unlocked: newlyUnlocked };
  }

  private async qualifies(
    badge: Badge,
    userId: string,
    xp: number,
    longestStreak: number,
  ): Promise<boolean> {
    switch (badge.criteriaType) {
      case BadgeCriteriaType.XP_THRESHOLD:
        return xp >= badge.criteriaValue;
      case BadgeCriteriaType.STREAK_DAYS:
        return longestStreak >= badge.criteriaValue;
      case BadgeCriteriaType.LESSON_COUNT:
        return (
          (await this.prisma.lessonProgress.count({
            where: { userId, completed: true },
          })) >= badge.criteriaValue
        );
      case BadgeCriteriaType.QUIZ_COUNT:
        return (
          (await this.prisma.quizAttempt.count({
            where: { userId, passed: true },
          })) >= badge.criteriaValue
        );
      case BadgeCriteriaType.COURSE_COUNT:
        return (
          (await this.prisma.enrollment.count({
            where: { userId, status: EnrollmentStatus.COMPLETED },
          })) >= badge.criteriaValue
        );
      case BadgeCriteriaType.FRIEND_COUNT:
        return (
          (await this.prisma.friendship.count({ where: { userId } })) >= badge.criteriaValue
        );
      case BadgeCriteriaType.POST_COUNT:
        return (
          (await this.prisma.socialPost.count({ where: { authorId: userId } })) >=
          badge.criteriaValue
        );
      default:
        return false;
    }
  }
}
