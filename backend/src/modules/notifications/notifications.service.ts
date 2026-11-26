import { HttpStatus, Injectable } from '@nestjs/common';
import { NotificationType, Prisma } from '@prisma/client';
import { ApiError } from '../../common/api-error';
import { paginate, Paginated } from '../../common/pagination';
import { PrismaService } from '../../prisma/prisma.service';
import { NotificationQueryDto } from './dto/notifications.dto';

@Injectable()
export class NotificationsService {
  constructor(private readonly prisma: PrismaService) {}

  async list(userId: string, query: NotificationQueryDto): Promise<Paginated<any>> {
    const limit = query.limit ?? 20;
    const rows = await this.prisma.notification.findMany({
      where: {
        userId,
        ...(query.read !== undefined ? { read: query.read } : {}),
      },
      take: limit + 1,
      ...(query.cursor ? { cursor: { id: query.cursor }, skip: 1 } : {}),
      orderBy: [{ read: 'asc' }, { createdAt: 'desc' }],
    });
    return paginate(rows, limit);
  }

  async unreadCount(userId: string): Promise<{ count: number }> {
    const count = await this.prisma.notification.count({
      where: { userId, read: false },
    });
    return { count };
  }

  async markRead(userId: string, notificationId: string) {
    const result = await this.prisma.notification.updateMany({
      where: { id: notificationId, userId },
      data: { read: true },
    });
    if (result.count === 0) {
      throw new ApiError(HttpStatus.NOT_FOUND, 'NOTIFICATION_NOT_FOUND', 'Notification not found');
    }
    return { id: notificationId, read: true };
  }

  async markAllRead(userId: string) {
    const result = await this.prisma.notification.updateMany({
      where: { userId, read: false },
      data: { read: true },
    });
    return { updated: result.count };
  }

  async create(
    userId: string,
    type: NotificationType,
    title: string,
    body?: string,
    data?: Prisma.InputJsonValue,
  ) {
    return this.prisma.notification.create({
      data: {
        userId,
        type,
        title,
        ...(body ? { body } : {}),
        ...(data ? { data } : {}),
      },
    });
  }
}
