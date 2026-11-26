import { HttpStatus, Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { ApiError } from '../../common/api-error';
import { toPublicProfile, toPublicUser } from '../../common/mappers';
import { paginate, Paginated } from '../../common/pagination';
import { PrismaService } from '../../prisma/prisma.service';
import { SearchUsersDto, UpdateProfileDto, UpdateSettingsDto } from './dto/users.dto';

@Injectable()
export class UsersService {
  constructor(private readonly prisma: PrismaService) {}

  async me(userId: string) {
    const user = await this.prisma.user.findUnique({ where: { id: userId } });
    if (!user) throw new ApiError(HttpStatus.NOT_FOUND, 'USER_NOT_FOUND', 'User not found');
    return toPublicUser(user);
  }

  async updateProfile(userId: string, dto: UpdateProfileDto) {
    const user = await this.prisma.user.update({
      where: { id: userId },
      data: {
        ...(dto.displayName !== undefined ? { displayName: dto.displayName } : {}),
        ...(dto.avatarUrl !== undefined ? { avatarUrl: dto.avatarUrl } : {}),
        ...(dto.bio !== undefined ? { bio: dto.bio } : {}),
        ...(dto.locale !== undefined ? { locale: dto.locale } : {}),
      },
    });
    return toPublicUser(user);
  }

  async getSettings(userId: string) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      select: { settings: true, locale: true },
    });
    if (!user) throw new ApiError(HttpStatus.NOT_FOUND, 'USER_NOT_FOUND', 'User not found');
    return { settings: user.settings, locale: user.locale };
  }

  async updateSettings(userId: string, dto: UpdateSettingsDto) {
    const user = await this.prisma.user.update({
      where: { id: userId },
      data: {
        settings: dto.settings as Prisma.InputJsonValue,
        ...(dto.locale !== undefined ? { locale: dto.locale } : {}),
      },
      select: { settings: true, locale: true },
    });
    return user;
  }

  async publicProfile(id: string) {
    const user = await this.prisma.user.findUnique({ where: { id } });
    if (!user) throw new ApiError(HttpStatus.NOT_FOUND, 'USER_NOT_FOUND', 'User not found');
    return toPublicProfile(user);
  }

  async search(query: SearchUsersDto): Promise<Paginated<ReturnType<typeof toPublicProfile>>> {
    const limit = query.limit ?? 20;
    const rows = await this.prisma.user.findMany({
      where: query.q
        ? {
            OR: [
              { displayName: { contains: query.q, mode: 'insensitive' } },
              { email: { contains: query.q, mode: 'insensitive' } },
            ],
          }
        : {},
      take: limit + 1,
      ...(query.cursor ? { cursor: { id: query.cursor }, skip: 1 } : {}),
      orderBy: { displayName: 'asc' },
    });
    return paginate(rows.map(toPublicProfile), limit);
  }
}
