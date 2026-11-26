import { INestApplication, ValidationPipe } from '@nestjs/common';
import { APP_GUARD } from '@nestjs/core';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { Test } from '@nestjs/testing';
import * as bcrypt from 'bcryptjs';
import request from 'supertest';
import { AllExceptionsFilter } from '../src/common/filters/all-exceptions.filter';
import { JwtAuthGuard } from '../src/common/guards/jwt-auth.guard';
import { PrismaService } from '../src/prisma/prisma.service';
import { AuthController } from '../src/modules/auth/auth.controller';
import { AuthService } from '../src/modules/auth/auth.service';

const config: Record<string, string> = {
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

describe('Auth (e2e)', () => {
  let app: INestApplication;
  let prisma: any;
  let jwt: any;

  beforeAll(async () => {
    prisma = {
      user: { findUnique: jest.fn(), create: jest.fn() },
      refreshToken: {
        create: jest.fn().mockResolvedValue({ id: 'rt-1' }),
        findUnique: jest.fn(),
        update: jest.fn().mockResolvedValue({}),
        updateMany: jest.fn().mockResolvedValue({ count: 1 }),
      },
    };
    jwt = {
      signAsync: jest.fn(async (payload: { jti?: string }, options?: { secret?: string }) =>
        options?.secret === config.JWT_REFRESH_SECRET
          ? `refresh.${payload.jti}`
          : 'access.token',
      ),
      verifyAsync: jest.fn(async (token: string) => {
        if (token === 'access.token') {
          return { sub: user.id, email: user.email, role: user.role, type: 'access' };
        }
        if (token.startsWith('refresh.')) {
          return { sub: user.id, jti: token.slice('refresh.'.length), type: 'refresh' };
        }
        throw new Error('invalid token');
      }),
    };

    const moduleRef = await Test.createTestingModule({
      controllers: [AuthController],
      providers: [
        AuthService,
        { provide: PrismaService, useValue: prisma },
        { provide: JwtService, useValue: jwt },
        { provide: ConfigService, useValue: { get: (key: string) => config[key] } },
        { provide: APP_GUARD, useClass: JwtAuthGuard },
      ],
    }).compile();

    app = moduleRef.createNestApplication();
    app.useGlobalPipes(
      new ValidationPipe({ whitelist: true, forbidNonWhitelisted: true, transform: true }),
    );
    app.useGlobalFilters(new AllExceptionsFilter());
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  it('registers a user', async () => {
    prisma.user.findUnique.mockResolvedValue(null);
    prisma.user.create.mockImplementation(async ({ data }: any) => ({ ...user, ...data }));
    const response = await request(app.getHttpServer())
      .post('/auth/register')
      .send({ email: 'learner@codebro.app', password: 'StrongPass123!', displayName: 'Learner' })
      .expect(201);
    expect(response.body.data.accessToken).toBe('access.token');
    expect(response.body.data.user.email).toBe('learner@codebro.app');
    expect(response.body.data.user).not.toHaveProperty('passwordHash');
  });

  it('returns the error envelope for invalid input', async () => {
    const response = await request(app.getHttpServer())
      .post('/auth/register')
      .send({ email: 'not-an-email', password: 'x', displayName: '' })
      .expect(400);
    expect(response.body.error.code).toBe('VALIDATION_ERROR');
    expect(response.body.error.message).toEqual(expect.any(String));
  });

  it('rejects bad credentials', async () => {
    prisma.user.findUnique.mockResolvedValue({
      ...user,
      passwordHash: await bcrypt.hash('StrongPass123!', 4),
    });
    const response = await request(app.getHttpServer())
      .post('/auth/login')
      .send({ email: user.email, password: 'wrong-password' })
      .expect(401);
    expect(response.body.error.code).toBe('INVALID_CREDENTIALS');
  });

  it('logs in with valid credentials', async () => {
    prisma.user.findUnique.mockResolvedValue({
      ...user,
      passwordHash: await bcrypt.hash('StrongPass123!', 4),
    });
    const response = await request(app.getHttpServer())
      .post('/auth/login')
      .send({ email: user.email, password: 'StrongPass123!' })
      .expect(200);
    expect(response.body.data.refreshToken).toMatch(/^refresh\./);
  });

  it('rotates a refresh token', async () => {
    const token = 'refresh.jti-1';
    prisma.refreshToken.findUnique.mockResolvedValue({
      id: 'rt-1',
      userId: user.id,
      jti: 'jti-1',
      tokenHash: await bcrypt.hash(token, 4),
      expiresAt: new Date(Date.now() + 60_000),
      revokedAt: null,
    });
    prisma.user.findUnique.mockResolvedValue(user);
    const response = await request(app.getHttpServer())
      .post('/auth/refresh')
      .send({ refreshToken: token })
      .expect(200);
    expect(response.body.data.accessToken).toBe('access.token');
    expect(prisma.refreshToken.update).toHaveBeenCalled();
  });

  it('protects non-public routes', async () => {
    await request(app.getHttpServer()).get('/auth/me').expect(401).expect({
      error: {
        code: 'UNAUTHENTICATED',
        message: 'Bearer access token is required',
      },
    });
    prisma.user.findUnique.mockResolvedValue(user);
    const response = await request(app.getHttpServer())
      .get('/auth/me')
      .set('Authorization', 'Bearer access.token')
      .expect(200);
    expect(response.body.data.id).toBe(user.id);
  });
});
