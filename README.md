# 🚀 CodeBro — Tango

> **A gamified, developer-first learning platform** for mastering programming through interactive lessons, code challenges, quizzes, AI assistance, and social competition. Built with Flutter, featuring a dark IDE-inspired UI, glassmorphism components, and advanced motion design.

[![Flutter](https://img.shields.io/badge/Flutter-3.12+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-blue?style=for-the-badge)](https://flutter.dev)

---

## ✨ Features

### 🎮 Gamified Learning
- **XP & Leveling System** — Earn experience points, level up from Newbie to Legend
- **Streak Tracking** — Build daily coding habits with streak freezes and flame indicators
- **Achievements & Badges** — Unlock rare badges for milestones and skill mastery
- **Leaderboards** — Weekly, monthly, and all-time rankings with friend competition

### 📚 Interactive Lessons
- **Course Catalog** — Browse Flutter, Python, Web Dev, Cybersecurity, AI/ML, and Game Development
- **Lesson Player** — Theory, code examples, interactive exercises, and knowledge checks
- **Built-in Code Editor** — Syntax-highlighted editor with run button and output console
- **Quiz System** — Per-question quizzes with instant feedback and result screens
- **Diff Comparison** — Side-by-side code comparison for challenge solutions

### 🎨 Premium UI/UX
- **Dark IDE Theme** — Deep space backgrounds with neon accents (no light mode)
- **Glassmorphism** — Backdrop-filter blur cards with subtle gradients and borders
- **Micro-interactions** — Button presses, XP floats, celebration bursts, streak pulses
- **Responsive Design** — Mobile, tablet, and desktop adaptive layouts
- **Smooth Animations** — Page transitions, staggered reveals, spring-based effects

### 🤖 Social & Community
- **Friends System** — Add friends, track their progress, compete on friend leaderboards
- **Activity Feed** — Share achievements, like and comment on posts
- **Friend Requests** — Send, accept, and reject friend requests
- **Progress Sharing** — Share XP, badges, and streaks to social media

### 🔧 Backend & Infrastructure
- **REST API Services** — Authentication, courses, lessons, quizzes, progress, leaderboards
- **Database Layer** — User profiles, progress tracking, friend relationships, achievements
- **State Management** — Riverpod-based reactive state across the app
- **Local Persistence** — Secure storage for user data and offline progress
- **Analytics** — Learning analytics, event tracking, and performance metrics

---

## 📱 Screens Overview

| Screen | Description | Status |
|--------|-------------|--------|
| Splash / Onboarding | 3-screen welcome flow with skill selection | ✅ |
| Authentication | Login, register, forgot password | ✅ |
| Home Dashboard | Streak, XP, continue learning, daily quests | ✅ |
| Courses List | Browse and filter courses by category | ✅ |
| Course Detail | Lesson list, progress, start learning | ✅ |
| Lesson Player | Theory, code, interactive exercises, quiz | ✅ |
| Quiz System | Question screens, results, XP rewards | ✅ |
| Code Playground | Editor, output console, run button | ✅ |
| Leaderboard | Weekly / all-time / friends rankings | ✅ |
| Achievements | Badge grid with earned/locked states | ✅ |
| Profile | Avatar, level, stats, settings, sign out | ✅ |
| Animation Showcase | Micro-interactions demo | ✅ |
| Social Feed | Posts, likes, comments, sharing | ✅ |

---

## 🛠 Tech Stack

| Layer | Technology |
|-------|------------|
| **Framework** | Flutter 3.12+ |
| **Language** | Dart 3.x |
| **UI Toolkit** | Material Design 3 |
| **State Management** | Riverpod |
| **Backend** | REST API (Dart/Node/FastAPI) |
| **Database** | PostgreSQL + Redis |
| **Local Storage** | Secure Storage + Hive |
| **Icons** | Material Icons + Custom |

---

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point & routing
├── core/
│   ├── theme/
│   │   ├── app_colors.dart            # Color palette & gradients
│   │   ├── app_text_styles.dart       # Typography system
│   │   ├── app_spacing.dart           # 4dp grid spacing
│   │   ├── app_radius.dart            # Border radius constants
│   │   ├── app_shadows.dart           # Shadow presets & glows
│   │   ├── app_motion.dart            # Animation durations & curves
│   │   └── app_gradients.dart         # Linear gradient definitions
│   ├── constants/
│   │   ├── app_constants.dart         # XP thresholds, level caps
│   │   └── app_strings.dart           # User-facing strings
│   └── extensions/
│       ├── context_extensions.dart    # BuildContext shortcuts
│       └── widget_extensions.dart     # Widget padding/helpers
├── features/
│   ├── onboarding/                    # Splash & welcome flow
│   ├── onboarding_wizard/             # Multi-step skill/goal setup
│   ├── authentication/                # Login, register, auth
│   ├── home/                          # Dashboard, quests, stats
│   ├── courses/                       # Course catalog & detail
│   ├── lesson_interactive/            # Lesson player, code editor, quiz
│   ├── playground/                    # Code playground editor
│   ├── quiz/                          # Quiz system & results
│   ├── leaderboard/                   # Rankings & competition
│   ├── social_leaderboard/            # Friends, activity, sharing
│   ├── achievements/                  # Badge system
│   ├── profile/                       # User profile & settings
│   └── ui_components/                 # Reusable widget library
└── backend/                           # API services & database
    ├── services/
    ├── models/
    └── repositories/
```

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK** 3.12 or higher
- **Dart SDK** 3.x
- **Android Studio** or **VS Code** with Flutter extensions
- **Git** for version control

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/yassinalkhulaqi/Tango.git
cd Tango

# 2. Get Flutter dependencies
flutter pub get

# 3. Run the app
flutter run
```

### Supported Platforms

- ✅ Android (API 21+)
- ✅ iOS (iOS 12+)
- ✅ Web (Chrome, Safari, Edge)
- ✅ Windows / macOS / Linux (desktop)

### Build for Release

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS (requires macOS + Xcode)
flutter build ios --release

# Web
flutter build web --release
```

---

## 🌿 Branching Strategy

Each feature is developed on a dedicated branch, then merged into `main` via pull request.

| Branch Pattern | Purpose |
|---------------|---------|
| `feature/ui-*` | User interface screens & components |
| `feature/motion-*` | Animations & motion design |
| `feature/backend-*` | API services & backend logic |
| `fix/*` | Bug fixes & patches |
| `refactor/*` | Code refactoring & architecture |
| `feat/*` | New features & capabilities |

### Active Branches

- `feature/ui-ux-master` — Comprehensive UI/UX (5000+ lines)
- `feature/motion-animations-1` — Core animation engine (4000+ lines)
- `feature/motion-animations-2` — Advanced motion effects (4000+ lines)
- `feature/backend-api-services` — REST API layer (10k+ lines)
- `feature/backend-database-services` — Database & persistence (10k+ lines)

---

## 🤝 Contributing

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/your-feature`
3. **Commit** your changes: `git commit -m "feat: your message"`
4. **Push** to your branch: `git push origin feature/your-feature`
5. **Open** a pull request

### Commit Convention

- `feat:` — New feature
- `fix:` — Bug fix
- `docs:` — Documentation changes
- `style:` — Formatting, missing semicolons, etc.
- `refactor:` — Code refactoring
- `test:` — Adding tests
- `chore:` — Maintenance tasks

---

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## 👥 Author

**yassinalkhulaqi** — [GitHub](https://github.com/yassinalkhulaqi)

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design for design guidelines
- The open-source community for packages and inspiration

---

*Happy coding with CodeBro! 🚀*
