import { HttpStatus, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { Locale, User } from '@prisma/client';
import * as bcrypt from 'bcryptjs';
import { randomUUID } from 'node:crypto';
import { ApiError } from '../../common/api-error';
import { toPublicUser } from '../../common/mappers';
import { PrismaService } from '../../prisma/prisma.service';
import { JwtPayload } from '../../common/types';
import { ForgotPasswordDto, LoginDto, RegisterDto } from './dto/auth.dto';

export interface AuthResult {
  user: ReturnType<typeof toPublicUser>;
  accessToken: string;
  refreshToken: string;
  tokenType: 'Bearer';
  expiresIn: number;
}

@Injectable()
export class AuthService {
  private readonly accessSecret: string;
  private readonly refreshSecret: string;
  private readonly accessTtl: string;
  private readonly refreshTtl: string;
  private readonly rounds: number;

  constructor(
    private readonly prisma: PrismaService,
    private readonly jwt: JwtService,
    private readonly config: ConfigService,
  ) {
    this.accessSecret = this.config.get<string>('JWT_ACCESS_SECRET') ?? '';
    this.refreshSecret = this.config.get<string>('JWT_REFRESH_SECRET') ?? '';
    this.accessTtl = this.config.get<string>('JWT_ACCESS_TTL') ?? '15m';
    this.refreshTtl = this.config.get<string>('JWT_REFRESH_TTL') ?? '7d';
    this.rounds = Number(this.config.get<string>('BCRYPT_ROUNDS') ?? 12);
  }

  async register(dto: RegisterDto): Promise<AuthResult> {
    const email = dto.email.trim().toLowerCase();
    const existing = await this.prisma.user.findUnique({ where: { email } });
    if (existing) {
      throw new ApiError(HttpStatus.CONFLICT, 'EMAIL_IN_USE', 'Email is already registered');
    }

    const passwordHash = await bcrypt.hash(dto.password, this.rounds);
    const user = await this.prisma.user.create({
      data: {
        email,
        passwordHash,
        displayName: dto.displayName.trim(),
        locale: dto.locale ?? Locale.en,
      },
    });
    return this.issueTokens(user);
  }

  async login(dto: LoginDto): Promise<AuthResult> {
    const email = dto.email.trim().toLowerCase();
    const user = await this.prisma.user.findUnique({ where: { email } });
    if (!user || !(await bcrypt.compare(dto.password, user.passwordHash))) {
      throw new ApiError(
        HttpStatus.UNAUTHORIZED,
        'INVALID_CREDENTIALS',
        'Invalid email or password',
      );
    }
    return this.issueTokens(user);
  }

  async refresh(refreshToken: string): Promise<AuthResult> {
    let payload: JwtPayload;
    try {
      payload = await this.jwt.verifyAsync<JwtPayload>(refreshToken, {
        secret: this.refreshSecret,
      });
    } catch {
      throw new ApiError(
        HttpStatus.UNAUTHORIZED,
        'INVALID_REFRESH_TOKEN',
        'Refresh token is invalid or expired',
      );
    }
    if (payload.type !== 'refresh' || !payload.sub || !payload.jti) {
      throw new ApiError(
        HttpStatus.UNAUTHORIZED,
        'INVALID_REFRESH_TOKEN',
        'Refresh token has an invalid payload',
      );
    }

    const stored = await this.prisma.refreshToken.findUnique({
      where: { jti: payload.jti },
    });
    if (
      !stored ||
      stored.userId !== payload.sub ||
      stored.revokedAt ||
      stored.expiresAt.getTime() <= Date.now() ||
      !(await bcrypt.compare(refreshToken, stored.tokenHash))
    ) {
      throw new ApiError(
        HttpStatus.UNAUTHORIZED,
        'INVALID_REFRESH_TOKEN',
        'Refresh token is no longer valid',
      );
    }

    const user = await this.prisma.user.findUnique({ where: { id: payload.sub } });
    if (!user) {
      throw new ApiError(HttpStatus.UNAUTHORIZED, 'INVALID_REFRESH_TOKEN', 'User not found');
    }

    await this.prisma.refreshToken.update({
      where: { id: stored.id },
      data: { revokedAt: new Date() },
    });
    return this.issueTokens(user);
  }

  async logout(userId: string, refreshToken?: string): Promise<{ revoked: boolean }> {
    if (refreshToken) {
      try {
        const payload = await this.jwt.verifyAsync<JwtPayload>(refreshToken, {
          secret: this.refreshSecret,
        });
        if (payload.jti) {
          await this.prisma.refreshToken.updateMany({
            where: { jti: payload.jti, userId, revokedAt: null },
            data: { revokedAt: new Date() },
          });
        }
      } catch {
        return { revoked: false };
      }
      return { revoked: true };
    }
    await this.prisma.refreshToken.updateMany({
      where: { userId, revokedAt: null },
      data: { revokedAt: new Date() },
    });
    return { revoked: true };
  }

  async forgotPassword(_dto: ForgotPasswordDto): Promise<{ accepted: boolean; message: string }> {
    return {
      accepted: true,
      message: 'If the account exists, a password reset link has been sent.',
    };
  }

  private async issueTokens(user: User): Promise<AuthResult> {
    const accessToken = await this.jwt.signAsync(
      {
        sub: user.id,
        email: user.email,
        role: user.role,
        type: 'access',
      },
      { secret: this.accessSecret, expiresIn: this.accessTtl as never },
    );

    const jti = randomUUID();
    const refreshToken = await this.jwt.signAsync(
      { sub: user.id, jti, type: 'refresh' },
      { secret: this.refreshSecret, expiresIn: this.refreshTtl as never },
    );

    await this.prisma.refreshToken.create({
      data: {
        userId: user.id,
        jti,
        tokenHash: await bcrypt.hash(refreshToken, this.rounds),
        expiresAt: new Date(Date.now() + this.ttlToMs(this.refreshTtl)),
      },
    });

    return {
      user: toPublicUser(user),
      accessToken,
      refreshToken,
      tokenType: 'Bearer',
      expiresIn: Math.floor(this.ttlToMs(this.accessTtl) / 1000),
    };
  }

  private ttlToMs(ttl: string): number {
    const match = /^(\d+)([smhd])$/.exec(ttl.trim());
    if (!match) return 15 * 60 * 1000;
    const amount = Number(match[1]);
    const factor =
      match[2] === 's'
        ? 1000
        : match[2] === 'm'
          ? 60_000
          : match[2] === 'h'
            ? 3_600_000
            : 86_400_000;
    return amount * factor;
  }
}
