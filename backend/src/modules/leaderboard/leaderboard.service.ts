import { Injectable } from '@nestjs/common';
import { paginateOffset, Paginated } from '../../common/pagination';
import { PrismaService } from '../../prisma/prisma.service';
import { RedisService } from '../../redis/redis.service';
import { LeaderboardQueryDto } from './dto/leaderboard.dto';
import { LeaderboardPeriod, leaderboardKey } from './leaderboard.keys';

export interface LeaderboardEntry {
  id: string;
  displayName: string;
  avatarUrl: string | null;
  xp: number;
  level: number;
  streakCount: number;
  rank: number;
}

const USER_SELECT = {
  id: true,
  displayName: true,
  avatarUrl: true,
  xp: true,
  level: true,
  streakCount: true,
} as const;

@Injectable()
export class LeaderboardService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly redis: RedisService,
  ) {}

  async list(
    userId: string,
    query: LeaderboardQueryDto,
  ): Promise<Paginated<LeaderboardEntry>> {
    const limit = query.limit ?? 20;
    const period = query.period ?? 'allTime';
    const offset = this.offset(query.cursor);
    const key = leaderboardKey(period, userId);

    const ids = await this.safeIds(key, offset, limit);
    if (ids.length > 0) {
      const users = await this.prisma.user.findMany({
        where: { id: { in: ids } },
        select: USER_SELECT,
      });
      const byId = new Map(users.map((user) => [user.id, user]));
      const data = ids
        .map((id, index) => {
          const user = byId.get(id);
          return user ? { ...user, rank: offset + index + 1 } : null;
        })
        .filter((entry): entry is LeaderboardEntry => entry !== null);
      const total = await this.countUsers(userId, period);
      return paginateOffset(data, limit, offset, total);
    }

    const scope = await this.scopeIds(userId, period);
    const total = scope ? scope.length : await this.prisma.user.count();
    const users = await this.prisma.user.findMany({
      where: scope ? { id: { in: scope } } : {},
      orderBy: [{ xp: 'desc' }, { id: 'asc' }],
      skip: offset,
      take: limit,
      select: USER_SELECT,
    });
    const data = users.map((user, index) => ({
      ...user,
      rank: offset + index + 1,
    }));
    await this.redis.zadd(
      key,
      users.map((user) => [user.xp, user.id] as [number, string]),
    ).catch(() => undefined);
    return paginateOffset(data, limit, offset, total);
  }

  async myRank(
    userId: string,
    period: LeaderboardPeriod,
  ): Promise<{ rank: number | null; xp: number; period: LeaderboardPeriod }> {
    const key = leaderboardKey(period, userId);
    const cachedRank = await this.redis.zrank(key, userId).catch(() => null);
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      select: { xp: true },
    });
    const xp = user?.xp ?? 0;
    if (cachedRank !== null) {
      return { rank: cachedRank + 1, xp, period };
    }
    const scope = await this.scopeIds(userId, period);
    const ahead = await this.prisma.user.count({
      where: {
        ...(scope ? { id: { in: scope } } : {}),
        xp: { gt: xp },
      },
    });
    return { rank: ahead + 1, xp, period };
  }

  async syncFriendLeaderboards(userId: string): Promise<void> {
    const friends = await this.prisma.friendship.findMany({
      where: { userId },
      select: { friendId: true },
    });
    const ids = [userId, ...friends.map((item) => item.friendId)];
    const users = await this.prisma.user.findMany({
      where: { id: { in: ids } },
      select: { id: true, xp: true },
    });
    const key = leaderboardKey('friends', userId);
    await this.redis.del(key).catch(() => undefined);
    await this.redis
      .zadd(
        key,
        users.map((user) => [user.xp, user.id] as [number, string]),
      )
      .catch(() => undefined);
  }

  private async safeIds(
    key: string,
    offset: number,
    limit: number,
  ): Promise<string[]> {
    try {
      return await this.redis.zrevrange(key, offset, offset + limit - 1);
    } catch {
      return [];
    }
  }

  private async countUsers(
    userId: string,
    period: LeaderboardPeriod,
  ): Promise<number> {
    const scope = await this.scopeIds(userId, period);
    return scope ? scope.length : this.prisma.user.count();
  }

  private async scopeIds(
    userId: string,
    period: LeaderboardPeriod,
  ): Promise<string[] | null> {
    if (period !== 'friends') return null;
    const friends = await this.prisma.friendship.findMany({
      where: { userId },
      select: { friendId: true },
    });
    return [userId, ...friends.map((item) => item.friendId)];
  }

  private offset(cursor?: string): number {
    if (!cursor) return 0;
    const value = Number(cursor);
    return Number.isInteger(value) && value >= 0 ? value : 0;
  }
}
