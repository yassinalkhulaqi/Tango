import { HttpStatus } from '@nestjs/common';
import * as bcrypt from 'bcryptjs';
import { AuthService } from './auth.service';
import { RegisterDto } from './dto/auth.dto';

const configValues: Record<string, string> = {
  JWT_ACCESS_SECRET: 'test-access-secret',
  JWT_REFRESH_SECRET: 'test-refresh-secret',
  JWT_ACCESS_TTL: '15m',
  JWT_REFRESH_TTL: '7d',
  BCRYPT_ROUNDS: '4',
};

const user = {
  id: 'user-1',
  email: 'learner@codebro.app',
  passwordHash: '',
  displayName: 'Learner',
  avatarUrl: null,
  bio: null,
  locale: 'en',
  xp: 0,
  level: 1,
  streakCount: 0,
  longestStreak: 0,
  role: 'USER',
  createdAt: new Date('2026-01-01T00:00:00.000Z'),
};

function buildService() {
  const prisma = {
    user: { findUnique: jest.fn(), create: jest.fn() },
    refreshToken: {
      create: jest.fn().mockResolvedValue({ id: 'rt-1' }),
      findUnique: jest.fn(),
      update: jest.fn().mockResolvedValue({}),
      updateMany: jest.fn().mockResolvedValue({ count: 1 }),
    },
  };
  const jwt = {
    signAsync: jest.fn(async (payload: { jti?: string }, options?: { secret?: string }) =>
      options?.secret === configValues.JWT_REFRESH_SECRET
        ? `refresh.${payload.jti}`
        : 'access.token',
    ),
    verifyAsync: jest.fn(),
  };
  const config = { get: jest.fn((key: string) => configValues[key]) };
  const service = new AuthService(prisma as never, jwt as never, config as never);
  return { service, prisma, jwt, config };
}

describe('AuthService', () => {
  const registerDto: RegisterDto = {
    email: 'Learner@CodeBro.App',
    password: 'StrongPass123!',
    displayName: 'Learner',
  };

  it('registers a user and stores only a bcrypt hash of the refresh token', async () => {
    const { service, prisma } = buildService();
    prisma.user.findUnique.mockResolvedValue(null);
    prisma.user.create.mockResolvedValue(user);

    const result = await service.register(registerDto);
    expect(result.accessToken).toBe('access.token');
    expect(result.refreshToken).toMatch(/^refresh\./);
    expect(result.user.email).toBe('learner@codebro.app');
    expect(result.user).not.toHaveProperty('passwordHash');

    const created = prisma.user.create.mock.calls[0][0].data;
    expect(created.passwordHash).not.toBe(registerDto.password);
    expect(await bcrypt.compare(registerDto.password, created.passwordHash)).toBe(true);

    const stored = prisma.refreshToken.create.mock.calls[0][0].data;
    expect(stored.tokenHash).not.toBe(result.refreshToken);
    expect(await bcrypt.compare(result.refreshToken, stored.tokenHash)).toBe(true);
  });

  it('rejects duplicate emails', async () => {
    const { service, prisma } = buildService();
    prisma.user.findUnique.mockResolvedValue(user);
    await expect(service.register(registerDto)).rejects.toMatchObject({
      status: HttpStatus.CONFLICT,
      code: 'EMAIL_IN_USE',
    });
  });

  it('rejects an incorrect password', async () => {
    const { service, prisma } = buildService();
    prisma.user.findUnique.mockResolvedValue({
      ...user,
      passwordHash: await bcrypt.hash('correct-password', 4),
    });
    await expect(
      service.login({ email: user.email, password: 'wrong-password' }),
    ).rejects.toMatchObject({ status: HttpStatus.UNAUTHORIZED, code: 'INVALID_CREDENTIALS' });
  });

  it('rotates a valid refresh token', async () => {
    const { service, prisma, jwt } = buildService();
    const token = 'refresh.rotating-jti';
    jwt.verifyAsync.mockResolvedValue({ sub: user.id, jti: 'rotating-jti', type: 'refresh' });
    prisma.refreshToken.findUnique.mockResolvedValue({
      id: 'rt-old',
      userId: user.id,
      jti: 'rotating-jti',
      tokenHash: await bcrypt.hash(token, 4),
      expiresAt: new Date(Date.now() + 60_000),
      revokedAt: null,
    });
    prisma.user.findUnique.mockResolvedValue(user);

    const result = await service.refresh(token);
    expect(prisma.refreshToken.update).toHaveBeenCalledWith(
      expect.objectContaining({ where: { id: 'rt-old' } }),
    );
    expect(prisma.refreshToken.create).toHaveBeenCalled();
    expect(result.refreshToken).not.toBe(token);
  });

  it('rejects a reused refresh token', async () => {
    const { service, prisma, jwt } = buildService();
    jwt.verifyAsync.mockResolvedValue({ sub: user.id, jti: 'jti', type: 'refresh' });
    prisma.refreshToken.findUnique.mockResolvedValue({
      id: 'rt-old',
      userId: user.id,
      jti: 'jti',
      tokenHash: await bcrypt.hash('refresh.old', 4),
      expiresAt: new Date(Date.now() + 60_000),
      revokedAt: new Date(),
    });
    await expect(service.refresh('refresh.old')).rejects.toMatchObject({
      status: HttpStatus.UNAUTHORIZED,
      code: 'INVALID_REFRESH_TOKEN',
    });
  });
});
