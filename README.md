# CodeBro (Tango)

> A gamified, developer-first learning platform — interactive coding lessons, quizzes, XP and streaks, badges, leaderboards and a social feed. Flutter client (Android · iOS · Web) + Node.js REST API.

[![Flutter](https://img.shields.io/badge/Flutter-3.44-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.12-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![NestJS](https://img.shields.io/badge/NestJS-10-E0234E?style=for-the-badge&logo=nestjs&logoColor=white)](https://nestjs.com)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)](https://postgresql.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)

---

## Status legend

`✅ implemented` · `🔄 in progress` · `⏳ planned`

| Area | Status |
|---|---|
| Design tokens, 6-locale i18n, RTL, responsive + a11y widgets | ✅ |
| Original app flow (onboarding, auth, home, courses, quiz, playground, leaderboard, achievements, profile) | ✅ |
| Riverpod + go_router canonical client shell | ✅ |
| NestJS REST API, Prisma schema, seed, Docker Compose | ✅ |
| CI workflow (Flutter + backend) | ✅ |
| Golden tests, release flavors | ⏳ |
| AI assistant chat, code-execution sandbox | ⏳ |

> **Honest note:** earlier revisions of this README claimed Riverpod, a REST backend, Hive persistence and 12 locales. Those were aspirational. The audited baseline has `setState`/`ChangeNotifier`, no networking or persistence packages and **6** locales. See [`docs/PROJECT_PLAN.md`](docs/PROJECT_PLAN.md) §2 for the full audit. Statuses above track the current implementation work, not wishes.

---

## Features

- **Learn by building** — course catalog, lesson player with theory, code blocks, exercises and a playground.
- **Gamification** — XP ledger with levels, daily streaks with freezes, badges, weekly/monthly/all-time/friend leaderboards.
- **Social** — friend requests, activity feed, posts, likes and comments.
- **Developer-native UI** — dark IDE-inspired theme, glassmorphism, tokenized motion, Inter + Fira Code typography.
- **Global** — English, Arabic, French, Spanish, Turkish, Urdu with full RTL mirroring and locale-aware number/date formatting.
- **Accessible** — semantic labels, focus order, 48dp targets and reduced-motion support.

---

## Architecture

```mermaid
flowchart LR
  App[Flutter client\nAndroid / iOS / Web] -->|HTTPS / JSON| API[Node.js 20\nNestJS REST API]
  API --> DB[(PostgreSQL 16)]
  API --> Cache[(Redis 7)]
```

- `lib/app/` — app shell, typed router, auth guard andThemeData assembly.
- `lib/core/` — design tokens, localization, network client, shared providers and UI kit.
- `lib/features/<area>/` — `domain` (entities + repository contracts), `data` (DTOs + repositories), `presentation` (pages + widgets).
- `backend/src/modules/` — auth, users, courses, progress, quizzes, xp, streaks, achievements, leaderboard, social, notifications, health.
- `backend/prisma/` — schema, migrations and deterministic seed.
- `archive/legacy_ui/` — reference-only copies of superseded UI layers; not compiled into the app.

Full details: [`docs/PROJECT_PLAN.md`](docs/PROJECT_PLAN.md) and [`UX_BLUEPRINT.md`](UX_BLUEPRINT.md).

---

## Tech stack

| Layer | Technology |
|---|---|
| Client | Flutter 3.44, Dart 3.12, Material 3 |
| State / routing | Riverpod, go_router |
| HTTP / data | Dio, Freezed, json_serializable |
| Local storage | shared_preferences, flutter_secure_storage |
| Backend | Node.js 20, TypeScript, NestJS 10 |
| Database / cache | PostgreSQL 16 + Prisma 5, Redis 7 |
| Auth | JWT access + rotating refresh tokens (bcrypt hashed at rest) |
| Docs / quality | Swagger/OpenAPI, flutter_test, Jest, ESLint, GitHub Actions |

---

## Quick start

### Client

```bash
git clone https://github.com/yassinalkhulaqi/Tango.git
cd Tango
flutter pub get
flutter run
```

Supported targets: Android (API 21+), iOS 12+, Web, and desktop.

```bash
flutter test
flutter analyze
flutter build apk --release
flutter build web --release
```

### API

```bash
cd backend
cp .env.example .env
docker compose up -d          # PostgreSQL + Redis + API
npm run prisma:migrate
npm run prisma:seed
npm run dev                   # http://localhost:3000/api/v1
```

Swagger UI: `http://localhost:3000/api/docs`. Tests: `npm test` (run without a live database).

### Configuration

| Variable | Purpose | Default (dev) |
|---|---|---|
| `DATABASE_URL` | PostgreSQL connection string | `postgresql://codebro:codebro@localhost:5432/codebro` |
| `REDIS_URL` | Redis connection string | `redis://localhost:6379` |
| `JWT_ACCESS_SECRET` | Access token signing key | *required — no default* |
| `JWT_REFRESH_SECRET` | Refresh token signing key | *required — no default* |
| `ACCESS_TOKEN_TTL` | Access token lifetime | `15m` |
| `REFRESH_TOKEN_TTL` | Refresh token lifetime | `30d` |
| `PORT` | HTTP port | `3000` |
| `API_PREFIX` | Global route prefix | `api/v1` |

Never commit real secrets; `.env` is git-ignored and `.env.example` contains placeholders only.

---

## Testing

```bash
# Flutter
flutter analyze
flutter test

# Backend
cd backend && npm test && npm run lint
```

List endpoints return `{ "data": [...], "meta": { "nextCursor": "...", "hasMore": false } }`; errors return `{ "error": { "code": "...", "message": "..." } }`.

---

## Contributing

1. Fork the repo and create a branch: `git checkout -b feat/short-name`.
2. Make your change with tests; keep `flutter analyze` and `npm test` clean.
3. Commit using [Conventional Commits](https://www.conventionalcommits.org/): `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`.
4. Push and open a pull request describing the behavior change and verification commands run.

Branch prefixes: `feat/`, `fix/`, `refactor/`, `docs/`, `test/`, `chore/`. See [`docs/PROJECT_PLAN.md`](docs/PROJECT_PLAN.md) §5 for the phased roadmap.

---

## Roadmap

Phases 0–4: documentation → client foundation & consolidation → backend service → UI/UX completion → quality, CI and release. Track progress in [`docs/PROJECT_PLAN.md`](docs/PROJECT_PLAN.md).

---

## License

MIT — see [LICENSE](LICENSE).

## Author

**yassinalkhulaqi** — [GitHub](https://github.com/yassinalkhulaqi)
