# 🚀 CodeBro — Tango

A modern, gamified Flutter learning platform for mastering programming through interactive lessons, code challenges, quizzes, and a built-in code playground.

## ✨ Features

- **Gamified Learning** — XP, levels, streaks, badges, and leaderboards
- **Interactive Lessons** — Course catalog with lesson players and progress tracking
- **Code Playground** — Split editor + output console with run button
- **Quiz System** — Per-question quiz screens with instant feedback and results
- **Achievements** — Earned/locked badge grid with XP rewards
- **Profile & Settings** — Avatar, level, XP bar, stats, sign out
- **Dark Theme** — IDE-inspired dark UI with neon accents (glassmorphism cards, gradients)
- **Onboarding** — 3-screen splash + onboarding flow with authentication

## 📱 Screens

| Screen | Status |
|--------|--------|
| Splash / Onboarding (3 screens) | ✅ Done |
| Authentication (Login, Register, Forgot Password) | ✅ Done |
| Home Dashboard (streak, XP, continue learning, quests) | ✅ Done |
| Courses List + Course Detail | ✅ Done |
| Lesson Player | ✅ Done |
| Quiz System + Results | ✅ Done |
| Code Playground (editor + output) | ✅ Done |
| Leaderboard (Weekly / All-time) | ✅ Done |
| Achievements | ✅ Done |
| Profile + Settings | ✅ Done |

## 🛠 Tech Stack

- **Flutter** (SDK) — UI framework
- **Dart** — Language
- **Material Design** — Components

## 📁 Project Structure

```
lib/
  core/
    theme/          # app_colors, app_text_styles, app_spacing, app_radius, app_shadows
    constants/      # app_constants, app_strings
    extensions/     # context_extensions, widget_extensions
  features/
    onboarding/     # Splash + 3-screen onboarding
    authentication/ # Login, register, forgot password
    home/           # Dashboard, stats, quests, bottom nav
    courses/        # Course list, course detail, lesson player
    quiz/           # Quiz questions, options, results
    playground/     # Code editor + output console
    leaderboard/    # Weekly / all-time rankings
    achievements/   # Badge grid
    profile/        # Profile, settings, sign out
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.12+)
- Dart SDK

### Install & Run

```bash
# Clone the repo
git clone https://github.com/yassinalkhulaqi/Tango.git
cd Tango

# Get dependencies
flutter pub get

# Run the app
flutter run
```

## 🌿 Branching Strategy

Each feature is developed on its own branch, then merged into `main`:

- `feature/ui-*` — UI screens & components
- `feature/backend-*` — API / service layers
- `fix/*` — Bug fixes (navigation, state management)
- `refactor/*` — Architecture improvements
- `feat/*` — New capabilities (localization, etc.)

## 📄 License

MIT
