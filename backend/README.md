# CodeBro Backend

Production-grade NestJS 10 / TypeScript / Prisma 5 API for the CodeBro Flutter app.

- Node 20, PostgreSQL 16, Redis 7
- JWT access tokens + rotating refresh tokens (bcrypt hashes at rest)
- Global `/api/v1` prefix, Swagger at `/api/docs`
- Envelopes: lists `{ data, meta: { nextCursor, hasMore, total? } }`, errors `{ error: { code, message, details? } }`, camelCase JSON
- Global `ValidationPipe` (whitelist + transform), helmet, throttling, guards, exception filter

## Setup

```bash
cd backend
npm install                 # postinstall runs `prisma generate`
cp .env.example .env        # fill in real secrets; never commit .env
npm run prisma:migrate      # create the schema / first migration
npm run prisma:seed         # deterministic demo data
npm run dev                 # http://localhost:3000/api/v1
```

If `prisma generate` did not run, run `npm run prisma:generate` manually before build/test.

## Environment variables

| Variable | Example | Purpose |
| --- | --- | --- |
| `NODE_ENV` | `development` | Runtime mode |
| `PORT` | `3000` | HTTP port |
| `API_PREFIX` | `api/v1` | Global route prefix |
| `SWAGGER_PATH` | `api/docs` | Swagger UI path |
| `CORS_ORIGINS` | `http://localhost:3000,http://10.0.2.2:3000` | Comma-separated CORS allowlist |
| `DATABASE_URL` | `postgresql://user:pass@localhost:5432/codebro?schema=public` | Prisma connection string |
| `REDIS_ENABLED` | `true` | Set `false` to force Postgres-only leaderboards |
| `REDIS_HOST` / `REDIS_PORT` / `REDIS_DB` / `REDIS_PASSWORD` | `localhost` / `6379` / `0` / `` | ioredis connection |
| `JWT_ACCESS_SECRET` / `JWT_REFRESH_SECRET` | long random strings | Separate signing secrets |
| `JWT_ACCESS_TTL` / `JWT_REFRESH_TTL` | `15m` / `7d` | Token lifetimes |
| `BCRYPT_ROUNDS` | `12` | Password/token hash cost |
| `THROTTLE_TTL` / `THROTTLE_LIMIT` | `60000` / `100` | Rate limiting window (ms) / max requests |
| `PRISMA_LOG` | `false` | Enable Prisma query logging |
| `PRISMA_SKIP_CONNECT` | `false` | Skip `$connect()` (unit tests only) |
| `SEED_DEMO_PASSWORD` | choose one | Password for the 12 seeded demo users |

## Endpoint table

All paths are relative to `/api/v1`. `🔒` requires `Authorization: Bearer <accessToken>`.

| Method | Path | Auth | Description |
| --- | --- | --- | --- |
| POST | `/auth/register` | – | Register, returns access + refresh tokens |
| POST | `/auth/login` | – | Log in |
| POST | `/auth/refresh` | – | Rotate refresh token, issue new pair |
| POST | `/auth/logout` | 🔒 | Revoke refresh token(s) |
| POST | `/auth/forgot-password` | – | Reset stub (no email sent) |
| GET | `/auth/me` | 🔒 | Current user |
| GET | `/users/me`, `PATCH /users/me` | 🔒 | Profile read/update |
| GET/PATCH | `/users/settings` | 🔒 | User settings |
| GET | `/users/search?q=&limit=&cursor=` | 🔒 | Search users |
| GET | `/users/:id` | 🔒 | Public profile |
| GET | `/courses`, `/courses/categories` | 🔒 | Filtered/paginated courses and categories |
| GET | `/courses/:slug`, `/courses/:slug/modules`, `/courses/:slug/lessons` | 🔒 | Course detail, modules, lessons |
| POST | `/progress/enroll` | 🔒 | Enroll by `courseId` or `slug` |
| POST | `/progress/lessons/:lessonId/complete` | 🔒 | Complete lesson, award XP, advance quests |
| GET | `/progress/overall`, `/progress/courses/:slug`, `/progress/daily-quests` | 🔒 | Progress dashboard |
| GET | `/quizzes/:id` | 🔒 | Quiz without correct options |
| POST | `/quizzes/:id/attempts` | 🔒 | Submit answers, score, award XP |
| GET | `/quizzes/:id/attempts` | 🔒 | My attempts |
| GET | `/xp/summary`, `/xp/ledger` | 🔒 | XP totals and ledger |
| POST | `/streaks/check-in`, `/streaks/freeze` | 🔒 | Check in / use a freeze |
| GET | `/streaks/stats` | 🔒 | Streak summary + events |
| GET | `/achievements/badges`, `/achievements/me` | 🔒 | Badge catalogue / unlocked badges |
| POST | `/achievements/evaluate` | 🔒 | Evaluate and unlock badges |
| GET | `/leaderboard?period=weekly|monthly|allTime|friends`, `/leaderboard/me` | 🔒 | Rankings |
| POST/GET | `/social/friend-requests` | 🔒 | Send / list requests |
| POST | `/social/friend-requests/:id/accept|reject` | 🔒 | Handle requests |
| GET/DELETE | `/social/friends`, `/social/friends/:id` | 🔒 | Friends |
| POST/GET/DELETE | `/social/posts`, `/social/posts/:id` | 🔒 | Posts |
| POST/DELETE | `/social/posts/:id/like` | 🔒 | Likes |
| POST/GET | `/social/posts/:id/comments` | 🔒 | Comments |
| DELETE | `/social/comments/:id` | 🔒 | Delete own comment |
| GET | `/notifications`, `/notifications/unread-count` | 🔒 | Notifications |
| PATCH | `/notifications/:id/read`, `/notifications/read-all` | 🔒 | Mark read |
| GET | `/health` | – | Dependency health |

## Architecture

```
src/
  main.ts                 bootstrap: helmet, CORS, prefix, pipes, filters, Swagger
  app.module.ts           global config/throttler/guards + feature modules
  prisma/                 PrismaService (global), PrismaModule
  redis/                  RedisService (global, lazy ioredis), RedisModule
  common/                 guards, decorators, filter, pagination, xp/streak math, mappers
  modules/                auth, users, courses, progress, quiz, xp, streaks,
                          achievements, leaderboard, social, notifications, health
prisma/                   schema.prisma, seed.ts
test/                     auth.e2e-spec.ts
```

- `JwtAuthGuard` verifies the access token and populates `req.user`; `RolesGuard` enforces `@Roles(...)`; `@Public()` opts out.
- `AllExceptionsFilter` maps Prisma/HTTP/validation errors to the error envelope.
- XP mutations are transactional (`user.xp` + `XPTransaction`) and update Redis leaderboard z-sets best-effort; leaderboard reads fall back to PostgreSQL.
- All list endpoints use cursor pagination with `limit + 1` lookahead.

## Tests

```bash
npm run test       # unit specs (no database, no Redis)
npm run test:e2e   # supertest with mocked PrismaService/JwtService
npm run test:cov   # coverage
npm run lint
npm run build
```

The e2e suite builds a minimal Nest application around `AuthController` with mocked providers, so it requires no running services. Demo login password comes from `SEED_DEMO_PASSWORD` (seed default: `CodeBro123!`).

## Docker

```bash
docker compose up -d --build
docker compose exec backend npm run prisma:migrate
docker compose exec backend npm run prisma:seed
```

`docker-compose.yml` starts PostgreSQL 16, Redis 7 and the backend; the Dockerfile uses a builder stage and a production-only runtime image. Override secrets via the environment (or a root `.env`) before deploying; defaults in the compose file are placeholders, not production values.

## Limitations

- `forgot-password` is an intentional stub and sends no email.
- Leaderboard weekly/monthly buckets are time-scoped Redis keys; a fresh deployment rebuilds them from PostgreSQL on first read.
- XP is a single lifetime counter (no decay); time-window rankings are driven by incremental Redis scores.
