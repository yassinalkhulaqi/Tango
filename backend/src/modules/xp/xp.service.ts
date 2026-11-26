import { HttpStatus, Injectable } from '@nestjs/common';
import { XPReason } from '@prisma/client';
import { ApiError } from '../../common/api-error';
import { paginate, Paginated, PaginationQueryDto } from '../../common/pagination';
import { PrismaService } from '../../prisma/prisma.service';
import { applyXp } from '../../common/xp';

export interface XpSummary {
  total: number;
  earnedThisWeek: number;
  transactions: number;
  level: number;
}

@Injectable()
export class XpService {
  constructor(private readonly prisma: PrismaService) {}

  async award(
    userId: string,
    amount: number,
    reason: XPReason,
    referenceId?: string,
    description?: string,
  ) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      select: { xp: true },
    });
    if (!user) {
      throw new ApiError(HttpStatus.NOT_FOUND, 'USER_NOT_FOUND', 'User not found');
    }

    const result = applyXp(user.xp, amount);
    await this.prisma.$transaction([
      this.prisma.user.update({
        where: { id: userId },
        data: { xp: result.xp, level: result.level },
      }),
      this.prisma.xPTransaction.create({
        data: { userId, amount, reason, referenceId, description },
      }),
    ]);
    return result;
  }

  async ledger(userId: string, query: PaginationQueryDto): Promise<Paginated<{
    id: string;
    amount: number;
    reason: XPReason;
    description: string | null;
    referenceId: string | null;
    createdAt: Date;
  }>> {
    const limit = query.limit ?? 20;
    const rows = await this.prisma.xPTransaction.findMany({
      where: { userId },
      take: limit + 1,
      ...(query.cursor ? { cursor: { id: query.cursor }, skip: 1 } : {}),
      orderBy: { createdAt: 'desc' },
    });
    return paginate(rows, limit);
  }

  async summary(userId: string): Promise<XpSummary> {
    const weekStart = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000);
    const [user, aggregate, weekly] = await Promise.all([
      this.prisma.user.findUnique({ where: { id: userId }, select: { xp: true, level: true } }),
      this.prisma.xPTransaction.aggregate({
        where: { userId },
        _count: { _all: true },
      }),
      this.prisma.xPTransaction.aggregate({
        where: { userId, createdAt: { gte: weekStart } },
        _sum: { amount: true },
      }),
    ]);
    return {
      total: user?.xp ?? 0,
      level: user?.level ?? 1,
      earnedThisWeek: weekly._sum.amount ?? 0,
      transactions: aggregate._count._all,
    };
  }
}
