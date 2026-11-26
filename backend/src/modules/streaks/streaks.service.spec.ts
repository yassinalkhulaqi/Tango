import { NotificationType, StreakEventType, XPReason } from '@prisma/client';
import { StreaksService } from './streaks.service';

const now = new Date('2026-05-10T12:00:00.000Z');

function buildService(userOverrides: Record<string, unknown> = {}) {
  const prisma = {
    user: {
      findUnique: jest.fn().mockResolvedValue({
        lastActiveAt: null,
        streakCount: 0,
        longestStreak: 0,
        streakFreezes: 2,
        ...userOverrides,
      }),
      update: jest.fn().mockResolvedValue({}),
    },
    streakEvent: {
      upsert: jest.fn().mockResolvedValue({}),
      findUnique: jest.fn().mockResolvedValue(null),
      create: jest.fn().mockResolvedValue({}),
      findMany: jest.fn().mockResolvedValue([]),
    },
    notification: { create: jest.fn().mockResolvedValue({}) },
    $transaction: jest.fn(async (operations: Array<Promise<unknown>>) => Promise.all(operations)),
  };
  const xp = { award: jest.fn().mockResolvedValue({ xp: 10, level: 1, leveledUp: false }) };
  const service = new StreaksService(prisma as never, xp as never);
  return { service, prisma, xp };
}

describe('StreaksService', () => {
  it('starts a new streak and awards check-in XP', async () => {
    const { service, prisma, xp } = buildService();
    const result = await service.checkIn('user-1', now);
    expect(result).toMatchObject({ streakCount: 1, longestStreak: 1, xpAwarded: 10 });
    expect(prisma.user.update).toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({ streakCount: 1, lastActiveAt: now }),
      }),
    );
    expect(prisma.streakEvent.upsert).toHaveBeenCalledWith(
      expect.objectContaining({
        where: {
          userId_type_date: {
            userId: 'user-1',
            type: StreakEventType.CHECK_IN,
            date: new Date('2026-05-10T00:00:00.000Z'),
          },
        },
      }),
    );
    expect(xp.award).toHaveBeenCalledWith('user-1', 10, XPReason.STREAK_CHECK_IN, undefined, 'Daily check-in');
  });

  it('does not award XP twice on the same day', async () => {
    const { service, xp, prisma } = buildService({
      lastActiveAt: now,
      streakCount: 5,
      longestStreak: 5,
    });
    const result = await service.checkIn('user-1', now);
    expect(result).toMatchObject({ streakCount: 5, xpAwarded: 0 });
    expect(xp.award).not.toHaveBeenCalled();
    expect(prisma.notification.create).not.toHaveBeenCalled();
  });

  it('increments a streak on consecutive days', async () => {
    const { service } = buildService({
      lastActiveAt: new Date('2026-05-09T09:00:00.000Z'),
      streakCount: 4,
      longestStreak: 4,
    });
    const result = await service.checkIn('user-1', now);
    expect(result.streakCount).toBe(5);
    expect(result.longestStreak).toBe(5);
  });

  it('notifies on a seven-day milestone', async () => {
    const { service, prisma } = buildService({
      lastActiveAt: new Date('2026-05-09T09:00:00.000Z'),
      streakCount: 6,
      longestStreak: 6,
    });
    await service.checkIn('user-1', now);
    expect(prisma.notification.create).toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({ type: NotificationType.STREAK_MILESTONE }),
      }),
    );
  });

  it('consumes one freeze for the day', async () => {
    const { service, prisma } = buildService({ streakFreezes: 2 });
    const result = await service.freeze('user-1', now);
    expect(result).toEqual({ freezesLeft: 1, date: new Date('2026-05-10T00:00:00.000Z') });
    expect(prisma.$transaction).toHaveBeenCalled();
  });
});
