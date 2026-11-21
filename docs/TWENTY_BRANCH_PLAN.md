# CodeBro (Tango) — 20-Branch Execution Plan (~30,000 lines)

> **Status: PLAN ONLY.** No feature code is written until the requester gives the start signal.
> This document defines the 20 branches, their scopes, line budgets, file areas,
> dependencies and verification approach. It is a review aid, not evidence of delivered work.

## 1. Current state (audit at baseline `4551c1a`)

- **Stack:** Flutter (~3.12), Dart, Material 3, no external i18n package. Dark, IDE-inspired theme.
- **Already merged (PRs #1–#21):** onboarding, authentication, home, courses, quiz,
  playground, leaderboard, achievements, profile, navigation, backend API/database services,
  motion engines, and a 12-language i18n foundation with RTL layout + exact-decimal money
  formatting (`lib/core/localization`, `lib/features/*_localized`).
- **Design system:** `lib/core/theme` (colors, text styles, spacing, radius, shadows, motion,
  gradients), `lib/features/ui_components/widgets` (premium button, component library).
- **Screen structure:** feature-first (`lib/features/<area>/presentation/pages|widgets`).
- **i18n:** typed `StringKeys`, per-locale catalogue maps with English fallback,
  `AppLocale` (12 codes), `LocaleController`, RTL `Mirrored*` widgets, `LocaleFormat`.
- **Quality gap:** no CI on this repo; verification here is `flutter analyze` + Flutter widget
  tests run locally. New code must compile cleanly and add tests for behavior.

## 2. Plan constraints

- 20 branches total, **~30,000 added lines** (~1,500 average; a few larger UI/backend batches).
- Each branch is self-contained on `origin/main` **or** explicitly stacked (declared below).
- Every branch: `flutter analyze` clean on its new folders, widget/unit tests where behavior exists,
  no secrets, no hardcoded user-facing strings (all through `StringKeys` + catalogues).
- EN + AR (plus remaining locale) translations for every new string; RTL parity for every layout.
- Rename-safe paths: follow the existing `lib/features/<area>/presentation/{pages,widgets}` layout.

## 3. The 20 branches

| # | Branch | Focus | Target lines |
|---|--------|-------|--------------|
| 1 | `feat/ux-splash-loading` | Premium splash, breathing logo, skeleton/shimmer system | 1,200 |
| 2 | `feat/ux-onboarding-extended` | Extended onboarding: skill + goal selection, validation | 1,800 |
| 3 | `feat/ux-auth-polish` | Login/register/forgot with inline validation, RTL fields | 1,600 |
| 4 | `feat/ux-dashboard-v3` | Dashboard cards, greeting, quick stats, daily quests | 1,700 |
| 5 | `feat/ux-courses-v3` | Course grid, filters, detail hero, progress | 1,600 |
| 6 | `feat/ux-lesson-v3` | Lesson stepper, code blocks, interactive widgets | 1,800 |
| 7 | `feat/ux-quiz-v3` | Quiz flow, option feedback, result + confetti | 1,500 |
| 8 | `feat/ux-playground-v3` | Split editor/output, run controls, language picker | 1,700 |
| 9 | `feat/ux-leaderboard-v3` | Weekly/all-time/friends tabs, rank highlights | 1,400 |
| 10 | `feat/ux-achievements-v3` | Badge grid, unlock animation, progress | 1,300 |
| 11 | `feat/ux-profile-settings-v3` | Profile, settings groups, sign-out confirm | 1,500 |
| 12 | `feat/ux-micro-interactions` | Press/scale, stagger, shimmer, celebration toolkit | 1,600 |
| 13 | `feat/ux-empty-error-states` | Unified empty/loading/error/retry state system | 1,200 |
| 14 | `feat/ux-responsive-layouts` | Breakpoint scaffolding, tablet/phone adapters | 1,500 |
| 15 | `feat/ux-accessibility-a11y` | Semantics, focus order, screen-reader labels, reduced motion | 1,700 |
| 16 | `feat/i18n-catalogues-extended` | Full catalogue parity for all 12 locales | 2,000 |
| 17 | `feat/i18n-rtl-components` | More mirrored widgets (sheet, drawer, tabs, table) | 1,500 |
| 18 | `feat/i18n-formatting-extended` | Dates, relative time, plural rules, number input | 1,400 |
| 19 | `feat/backend-services-v2` | Repository/service layer extensions, caching, sync | 2,500 |
| 20 | `feat/testing-quality` | Golden/widget/unit test suites across features | 2,000 |

**Total ≈ 31,800 lines** — meets the ~30k target with headroom.

## 4. File/component areas per branch

- **UX feature branches (1–11):** `lib/features/<area>/presentation/pages` + `widgets`,
  plus new `StringKeys` entries and catalogue updates in `lib/core/localization`.
- **Motion/state (12–14):** `lib/core/theme/app_motion.dart`, `lib/features/ui_components/widgets`,
  new `lib/features/motion_v3/*`, `lib/core/extensions`.
- **A11y (15):** `lib/core/a11y/*`, semantics on existing feature widgets.
- **i18n (16–18):** `lib/core/localization/catalogues/*`, `lib/core/localization/*`,
  `lib/features/rtl/presentation/widgets`.
- **Backend (19):** `lib/features/backend_api_services/*`, `lib/features/backend_database_services/*`.
- **Testing (20):** `test/**` mirroring feature paths.

## 5. Dependencies & ordering

```
Foundation (already merged): i18n + RTL + money formatting (present at 4551c1a)
Independent UI tracks (1–11, 13–15): each branches from origin/main, no cross-imports.
Motion track (12): consumed by 1–11 by contract (motion token names), not by Git dependency.
i18n track (16–18): extends the merged foundation; 16 → 17 → 18 (stacked).
Backend (19): independent.
Testing (20): last; written against the final APIs once other branches land.
```

Branches 1–15 and 19 are independent; 16–18 are stacked; 20 depends on the merged result of all others.
Because branches are independent, each must compile and analyze cleanly on its own.

## 6. Verification plan

Per branch, before merge:
```bash
flutter analyze lib/<touched paths>            # zero errors
flutter test test/<matching tests>             # behavior tests pass
git diff --check                               # no whitespace errors
```
- No CI exists on this repo; results are reported as local checks, never as CI-green.
- Whole-product visual review, native Arabic review, and accessibility sign-off need a human.
- Do not bypass hooks or disable checks; no secrets committed.

## 7. Execution protocol

1. Wait for the requester's explicit **start** instruction.
2. Implement branches in dependency order; commit each coherent slice.
3. After each branch: run the verification commands above and report results.
4. Push only when the requester says "push"; merge only when they say "merge".
5. Keep `main` untouched until explicitly instructed.

**No code has been written for this 20-branch plan yet.**
