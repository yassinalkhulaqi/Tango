import { HttpStatus, Injectable } from '@nestjs/common';
import { NotificationType, StreakEventType, XPReason } from '@prisma/client';
import { ApiError } from '../../common/api-error';
import { PrismaService } from '../../prisma/prisma.service';
import {
  calculateStreak,
  isStreakActiveToday,
  startOfUtcDay,
} from '../../common/streak';
import { XpService } from '../xp/xp.service';
import { StreakQueryDto } from './dto/streaks.dto';

@Injectable()
export class StreaksService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly xp: XpService,
  ) {}

  async checkIn(userId: string, now: Date = new Date()) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      select: {
        lastActiveAt: true,
        streakCount: true,
        longestStreak: true,
        streakFreezes: true,
      },
    });
    if (!user) {
      throw new ApiError(HttpStatus.NOT_FOUND, 'USER_NOT_FOUND', 'User not found');
    }

    const snapshot = calculateStreak(
      user.lastActiveAt,
      user.streakCount,
      user.longestStreak,
      now,
    );

    await this.prisma.user.update({
      where: { id: userId },
      data: {
        lastActiveAt: now,
        streakCount: snapshot.streakCount,
        longestStreak: snapshot.longestStreak,
      },
    });

    await this.prisma.streakEvent.upsert({
      where: {
        userId_type_date: {
          userId,
          type: StreakEventType.CHECK_IN,
          date: startOfUtcDay(now),
        },
      },
      create: {
        userId,
        type: StreakEventType.CHECK_IN,
        date: startOfUtcDay(now),
        streak: snapshot.streakCount,
      },
      update: { streak: snapshot.streakCount },
    });

    let xpAwarded = 0;
    if (!snapshot.sameDay) {
      xpAwarded = 10;
      await this.xp.award(userId, xpAwarded, XPReason.STREAK_CHECK_IN, undefined, 'Daily check-in');
      if (snapshot.streakCount > 0 && snapshot.streakCount % 7 === 0) {
        await this.prisma.notification.create({
          data: {
            userId,
            type: NotificationType.STREAK_MILESTONE,
            title: `${snapshot.streakCount}-day streak!`,
            body: 'You reached a streak milestone. Keep learning!',
          },
        });
      }
    }

    return {
      streakCount: snapshot.streakCount,
      longestStreak: snapshot.longestStreak,
      freezesLeft: user.streakFreezes,
      activeToday: true,
      xpAwarded,
    };
  }

  async freeze(userId: string, now: Date = new Date()) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      select: { streakFreezes: true },
    });
    if (!user) {
      throw new ApiError(HttpStatus.NOT_FOUND, 'USER_NOT_FOUND', 'User not found');
    }
    if (user.streakFreezes <= 0) {
      throw new ApiError(
        HttpStatus.BAD_REQUEST,
        'NO_FREEZE_AVAILABLE',
        'No streak freezes remaining',
      );
    }
    const date = startOfUtcDay(now);
    const existing = await this.prisma.streakEvent.findUnique({
      where: {
        userId_type_date: { userId, type: StreakEventType.FREEZE, date },
      },
    });
    if (existing) {
      throw new ApiError(
        HttpStatus.CONFLICT,
        'FREEZE_ALREADY_USED',
        'A freeze was already used today',
      );
    }
    await this.prisma.$transaction([
      this.prisma.user.update({
        where: { id: userId },
        data: { streakFreezes: { decrement: 1 } },
      }),
      this.prisma.streakEvent.create({
        data: { userId, type: StreakEventType.FREEZE, date, streak: 0 },
      }),
    ]);
    return { freezesLeft: user.streakFreezes - 1, date };
  }

  async stats(userId: string, query: StreakQueryDto) {
    const [user, events] = await Promise.all([
      this.prisma.user.findUnique({
        where: { id: userId },
        select: {
          streakCount: true,
          longestStreak: true,
          streakFreezes: true,
          lastActiveAt: true,
        },
      }),
      this.prisma.streakEvent.findMany({
        where: { userId },
        take: (query.limit ?? 20) + 1,
        ...(query.cursor ? { cursor: { id: query.cursor }, skip: 1 } : {}),
        orderBy: { date: 'desc' },
      }),
    ]);
    if (!user) {
      throw new ApiError(HttpStatus.NOT_FOUND, 'USER_NOT_FOUND', 'User not found');
    }
    const limit = query.limit ?? 20;
    return {
      data: {
        stats: {
          current: user.streakCount,
          longest: user.longestStreak,
          freezesLeft: user.streakFreezes,
          activeToday: isStreakActiveToday(user.lastActiveAt),
        },
        events: events.slice(0, limit),
      },
      meta: {
        nextCursor: events.length > limit ? events[limit - 1].id : null,
        hasMore: events.length > limit,
      },
    };
  }
}
