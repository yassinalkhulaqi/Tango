# Flavors and environments

## Flutter

Flavors are compile-time Dart defines, not separate source trees.

| Flavor | `--dart-define` | API base URL |
|---|---|---|
| dev | `FLAVOR=dev` | `http://10.0.2.2:3000/api/v1` |
| staging | `FLAVOR=staging` | `https://api.staging.codebro.dev/api/v1` |
| prod | `FLAVOR=prod` | `https://api.codebro.dev/api/v1` |

Override the URL explicitly with `API_BASE_URL` when needed.

```bash
flutter run --dart-define=FLAVOR=dev
flutter build apk --release --dart-define=FLAVOR=prod
flutter build web --release --dart-define=FLAVOR=staging
flutter build appbundle --release --dart-define=FLAVOR=prod
```

`AppEnvironment` (`lib/app/flavors.dart`) is the single source of truth; `apiBaseUrlProvider` reads from it.

## Backend

| Variable | dev | staging/prod |
|---|---|---|
| `NODE_ENV` | development | production |
| `DATABASE_URL` | local Postgres | managed Postgres (secret) |
| `REDIS_URL` | local Redis | managed Redis (secret) |
| `JWT_ACCESS_SECRET` | local placeholder | secret manager |
| `JWT_REFRESH_SECRET` | local placeholder | secret manager |

Never commit `.env`; only `.env.example` with placeholders is tracked.

## CI matrix

`.github/workflows/ci.yml` runs analyze, format check, tests with coverage and a web build for each flavor, plus an Android release bundle and the backend build/test suite.
