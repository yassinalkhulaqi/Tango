# Release checklist

Use this checklist for every production release.

## 1. Version

- [ ] Bump `version:` in `pubspec.yaml` (`major.minor.patch+build`).
- [ ] Update `CHANGELOG.md` with Added / Changed / Fixed sections.
- [ ] Confirm `AppEnvironment.flavor` resolves to `prod` in the release build.

## 2. Quality gates

- [ ] `flutter analyze` — zero issues.
- [ ] `dart format --output=none --set-exit-if-changed lib test` — clean.
- [ ] `flutter test --coverage` — all tests pass; review coverage report.
- [ ] Backend: `npm run lint && npm run build && npm test` — all pass.
- [ ] `git diff --check` — no whitespace errors.
- [ ] Secret scan — no `.env`, keys or tokens staged.

## 3. Environments

- [ ] `dev`, `staging` and `prod` builds complete in CI.
- [ ] API base URL points to the correct environment for each flavor.
- [ ] Smoke test passes against staging (see `test/integration/smoke_test.dart`).

## 4. Backend deployment

- [ ] `docker compose config` is valid.
- [ ] Migrations applied: `npm run prisma:migrate deploy`.
- [ ] Seed data verified on staging only.
- [ ] JWT secrets are unique per environment and stored in the deployment secret manager.
- [ ] `/api/v1/health` returns `200`.

## 5. Store submission

- [ ] App icons and splash assets updated for all target densities.
- [ ] Screenshots captured on phone and tablet for en + ar.
- [ ] Privacy policy and terms links updated.
- [ ] Android App Bundle signed with the production keystore.
- [ ] iOS build signed with the production provisioning profile.
- [ ] Release notes copied from `CHANGELOG.md`.

## 6. Post-release

- [ ] Tag `vX.Y.Z` and push the tag.
- [ ] Monitor crash/analytics dashboards for 24 hours.
- [ ] Record any follow-up fixes in the next milestone.
