# CodeBro — Complete UI/UX Design Blueprint

> *A professional-grade UX strategy document for the CodeBro gamified learning platform.*

---

## 1. Brand Identity

### 1.1 Design Philosophy

CodeBro's visual language is rooted in three worlds:

| Influence | Why |
|-----------|-----|
| **Code editors** (VS Code, JetBrains) | The user *is* a developer; the UI should feel familiar, not foreign |
| **Modern gaming UIs** (Overwatch 2, Valorant) | Gamification must feel earned; HUD-style stats, clean loading states, parallax depth |
| **Premium fintech/edtech** (Duolingo, Brilliant, Robinhood) | Delightful micro-interactions, progress streaks, celebration animations |

**Principle:** A developer's IDE is their sanctuary. CodeBro's UI should feel like entering a beautifully themed IDE that happens to teach you.

### 1.2 Color System (Existing)

```
Background: #070A0F   (Deep space — never pure black)
Surface:    #0F141C   (Subtle blue tint, like a dimmed editor)
Accent:     #38BDF8   (Electric blue — primary CTAs, links)
Gold:       #FACC15   (Python yellow — XP, achievements, rarity)
```

**Usage rules:**

- Blue is for **action** (buttons, active states, links)
- Yellow is for **reward** (XP, streaks, achievement unlocks)
- Green is for **completion** (finished lessons, checkmarks)
- Purple is for **premium/rare** (special badges, pro features)
- Red/pink only for **errors** or **urgent empty states** — never for decoration

**Gradient strategy:**

- Primary CTA: `#38BDF8 → #818CF8` (confidence + energy)
- Reward elements: `#FACC15 → #F97316` (warmth, excitement)
- Cards on dark: subtle 15% opacity gradient from top-left to add depth without noise

### 1.3 Typography (Existing)

```
Primary font: Inter (clean, legible, developer-friendly)
Code font:    Fira Code (for snippets, terminal UIs, variable names)
```

**Voice & tone in text:**

| Context | Tone |
|---------|------|
| Onboarding headlines | "Welcome to CodeBro" — warm, confident |
| Lesson titles | "Control Flow Mastery" — precise, academic |
| Empty states | "No challenges yet. Start one?" — encouraging, never blaming |
| Error messages | "Connection lost. Your progress is saved." — reassuring |
| Achievement names | "Bug Squasher", "Commit Master" — playful, dev-culture |

### 1.4 Icon Style

- **Outline + fill hybrid:** Icons are outlined by default, fill with color when active or achieved
- **Rounded corners** on all custom icons (2px stroke, rounded caps)
- **Monochrome system icons** from Material (consistent, recognizable)
- **Custom illustrations** use a "low-poly / geometric" style — not flat, not 3D, but structured like circuit boards

### 1.5 Illustration Style

Every illustration should follow a **"developer sketchbook"** aesthetic:

- Geometric shapes (hexagons, nodes, connecting lines)
- Code symbols embedded (braces `{}`, arrows `->`, brackets `[]`)
- Muted neon glows behind key elements
- No human faces — use avatars with coding gear (headphones, glasses, hoodie silhouettes)

### 1.6 Component Design Language

| Component | Style |
|-----------|-------|
| Cards | Glassmorphism (`BackdropFilter` blur + 1.5px subtle border) |
| Buttons | Gradient-filled with soft outer glow shadow; pressed: scale 0.97 |
| Text fields | Dark surface background, 1.5px border, rounded 14px |
| Progress bars | Thin (6px), rounded caps, gradient fill, subtle track glow |
| Bottom nav | Active: blue tint background + filled icon; inactive: outlined + muted |
| Dividers | Single pixel `#1E293B` — near invisible, only for structure |
| Chips/Badges | Small, colored background at 12% opacity, border at 20%, no elevation |

### 1.7 Animation Language

| Motion | Timing | Curve |
|--------|--------|-------|
| Page transitions | 350ms | `easeInOut` |
| Button press | 120ms | `easeIn` scale 1.0→0.97 |
| Fade in (content) | 400ms | `easeOut` |
| Streak / XP counter | 600ms per digit | `spring()` with slight overshoot |
| Celebration (star burst) | 800ms | `easeOutBack` |
| Card entrance (stagger) | 300ms each, 80ms delay | `easeOutCubic` |
| Skeleton shimmer | 1.5s loop | Linear (shimmer offset) |

**Rule:** Never animate for longer than 800ms. Fast = responsive. Slow = annoying.

---

## 2. User Experience Flow

### 2.1 First Launch Journey

```
Splash (1.2s) 
  → Fade logo + breathing glow on terminal icon
  → Preloads initial assets in background
  ↓
Onboarding (3 screens, PageView)
  → Screen 1: "Welcome to CodeBro" (emotional hook)
  → Screen 2: "Learn By Building" (value prop — courses, challenges, projects)
  → Screen 3: "Level Up Your Skills" (gamification hook — XP, badges, leaderboard)
  → Skip available on each screen
  → "Start Learning" CTA on final screen
  ↓
Authentication
  → /login  (returning user)
  → /register  (new user)
  → /forgot-password
  ↓
Skill Selection  *[NEW — not yet implemented]*
  → "What do you want to learn?"
  → Horizontal category picker (Flutter, Python, Web, etc.)
  → Multi-select allowed
  → "Pick at least one" validation
  ↓
Goal Setting  *[NEW — not yet implemented]*
  → "How much time can you spend?"
  → 5 min/day — Casual
  → 15 min/day — Regular
  → 30 min/day — Serious
  → 60 min/day — Hardcore
  → "We'll personalize your daily plan"
  ↓
Home Dashboard
  → Personalized greeting
  → XP bar
  → Continue learning (most recent course)
  → Suggested next lesson (based on skill selection)
  → Daily challenge
```

### 2.2 Core Engagement Loop

```
Enter App
  ↓
See Daily Challenge / Streak Reminder
  ↓
Complete 1 Lesson (5-15 min)
  ↓
Earn XP + Streak update
  ↓
Check Progress / Leaderboard
  ↓
(Optional) Attempt a Challenge / Quiz
  ↓
Exit → Notification: "Your streak is waiting!"
```

**Key metric:** Each session should deliver **one clear win** — completing a lesson, earning an achievement, or moving up on the leaderboard.

### 2.3 Navigation Architecture

```
Bottom Navigation (5 tabs)
├── Home
│   ├── Greeting + XP bar
│   ├── Continue Learning card
│   ├── Quick stats row
│   ├── Categories (horizontal scroll)
│   └── Daily Challenge
├── Courses
│   ├── Enrolled courses (grid)
│   ├── Discover (horizontal featured)
│   └── Filter by category
├── Playground
│   ├── Code editor (web preview)
│   ├── Run output
│   └── Save/share snippets
├── Leaderboard
│   ├── Weekly / All-time tabs
│   ├── Friends tab
│   ├── User rank highlighted
│   └── XP progression chart
└── Profile
    ├── Avatar + level + XP bar
    ├── Achievements grid
    ├── Stats (lessons, streak, accuracy)
    ├── Settings
    └── Sign out
```

---

## 3. Gamification System

### 3.1 XP & Leveling

| Level | Title | XP Required |
|-------|-------|-------------|
| 1 | Newbie | 0 |
| 2 | Apprentice | 200 |
| 3 | Coder | 500 |
| 4 | Junior Dev | 1,000 |
| 5 | Mid-Level | 2,000 |
| 6 | Senior | 4,000 |
| 7 | Lead | 7,000 |
| 8 | Architect | 12,000 |
| 9 | Legend | 20,000 |

**XP Sources:**

| Action | XP |
|--------|----|
| Complete a lesson | +50 |
| Perfect quiz (100%) | +100 |
| Daily login (streak) | +10 × streak day |
| Daily challenge | +50 |
| Earn achievement | +200 |
| Comment / help others | +25 |

**Visual feedback for XP gain:**  
A floating `+50 XP` badge that scales up, drifts upward 40dp, and fades out over 800ms.

### 3.2 Streak System

- Streak count displayed as a flame icon with number
- Freeze item: 1 streak freeze per week (earned at 7-day streak)
- Break threshold: 48 hours (24h = warning, 48h = break)
- Visual: progress ring around streak flame that fills as day progresses

### 3.3 Achievements

| Category | Examples |
|----------|----------|
| Learning | "First Commit" (first lesson), "Polyglot" (3 categories) |
| Streak | "Week Warrior" (7-day streak), "Monthly Master" (30 days) |
| Skill | "Bug Squasher" (10 challenges), "Speed Runner" (5 min quiz) |
| Social | "Helping Hand" (5 comments), "Mentor" (first referral) |

**Unlock animation:**  
Card flip → particle burst (small colored circles) → achievement name revealed with glow → haptic feedback (on mobile).

### 3.4 Leaderboard Psychology

- **Weekly reset** — everyone starts fresh, low barrier to compete
- **All-time** — shows dedication, aspirational
- **Friends tab** — social accountability
- **Your rank always visible** — even outside leaderboard (in profile header)
- **Never show negative movement** — "You're #42" not "You dropped 3 spots"

---

## 4. Screen-by-Screen UX Analysis

### 4.1 Home Dashboard

**What works:**
- User greeting with name + emoji creates emotional connection
- XP progress bar visible immediately — motivation to fill it
- Continue Learning card uses gradient + glow = feels important
- Daily Challenge stands out with yellow/orange gradient

**What to improve:**

| Issue | Fix |
|-------|-----|
| Stats row (4 items) is information-dense, hard to scan | Reduce to 3 stats; make each a small horizontal bar instead of stacked |
| Categories scroll has no "active category" state | Tap a category → highlight it + show mini course list below |
| No streak widget visible at top | Add streak flame next to level badge — always visible |
| Bottom nav items lack labels under icons | Already implemented; good |

### 4.2 Courses Screen

**Key UX decisions:**

- **Course cards** show: thumbnail area (gradient + icon), title, progress %, "Continue" button
- **Progress** uses a thin gradient bar at card bottom — glanceable
- **Locked courses** show a subtle lock overlay + "Reach Level X" label — no bright colors, no shame
- **Sort/Filter** via horizontal chips above grid: "All", "In Progress", "Completed", "Saved"

### 4.3 Lesson Screen

**Layout (top to bottom):**
1. **AppBar** — lesson title + back button + XP reward badge
2. **Progress stepper** — horizontal dots (completed=green, current=blue, locked=grey)
3. **Content area** — code blocks with syntax highlighting, explanations, interactive widgets
4. **Action bar** — "Next →" button pinned at bottom

**Reading experience:**
- Code blocks have a dark IDE background, line numbers, copy button
- Important terms are highlighted with a subtle underline tooltip
- Each page is swipeable (horizontal PageView) — but also has "Next" button

### 4.4 Quiz Screen

- Single question per screen (reduces cognitive load, like Duolingo)
- Option cards: dark surface, rounded, tap → highlight blue if correct, red if wrong
- Correct answer feedback: green glow + haptic + subtle scale
- Progress bar at top: 1/8, 2/8, etc.
- Result screen: score %, XP earned, confetti if 100%, "Review Mistakes" button

### 4.5 Playground Screen

- Split view: code editor (top 60%) / output console (bottom 40%)
- Draggable divider between them
- Run button: green, prominent, with play icon
- Language selector chip next to run button
- Reset / Save / Share actions in toolbar

### 4.6 AI Assistant (Chat)

- Floating action button on lesson screens → opens bottom sheet
- Chat bubbles: user = blue gradient (right-aligned), AI = dark surface (left-aligned)
- Suggested prompts appear as chips above input ("Explain this code", "Give me a hint")
- Code blocks in AI responses rendered with syntax highlighting

### 4.7 Profile Screen

- **Header:** Avatar (customizable), name, level badge, XP bar, rank
- **Achievement showcase:** horizontal scroll of earned badges (max 6 visible)
- **Stats grid:** Lessons completed, Streak days, Total XP, Accuracy %
- **Settings list:** dark surface items with arrow icons

---

## 5. Empty States & Placeholders

Every empty state must:
1. **Acknowledge** the emptiness (no shame)
2. **Explain** why it's empty (normalizing)
3. **Suggest** an action (clear CTA)

| Screen | Empty State Message | CTA |
|--------|---------------------|-----|
| Courses (no enrollment) | "Your learning journey starts here" | "Browse Courses" |
| Achievements (none yet) | "Great things take time. Complete your first lesson to earn a badge." | "Start Learning" |
| Leaderboard (no friends) | "Learning is better together. Invite friends to compete." | "Invite Friends" |
| Playground (no snippets) | "Your code playground is ready. Write your first snippet." | "Open Editor" |
| Daily Challenge (completed) | "Great work today! Come back tomorrow for a new challenge." | "Explore Courses" |

---

## 6. Micro-Interactions Catalog

| Trigger | Effect | Duration |
|---------|--------|----------|
| Button tap | Scale 1.0→0.97 | 120ms |
| Bottom nav switch | Icon fill transition + subtle upward bounce | 200ms |
| XP earned | Floating "+50 XP" label → drift up 40dp → fade | 800ms |
| Streak increment | Flame icon pulse + count number animation | 400ms |
| Level up | Full-screen overlay: level number scales in from center with glow | 1.2s |
| Achievement unlock | Card flip → particle burst → haptic | 800ms |
| Quiz correct | Card border green glow + subtle scale + checkmark | 300ms |
| Quiz incorrect | Card shake (x-axis oscillation) + red border flash | 400ms |
| Pull to refresh | Custom loader: spinning terminal prompt `_` blinking | loop |
| Page transition | Slide + opacity (like a fade-through) | 350ms |
| Tab switch | Content fades out → new content fades in | 250ms |

---

## 7. Reusable Component Architecture

### 7.1 Widget Hierarchy

```
Scaffold (custom dark theme)
└── PremiumBackground (gradient + glow spots)
    └── SafeArea
        ├── AppBar (optional)
        ├── GlassCard (wrapping content)
        ├── PremiumButton (gradient)
        ├── AuthTextField (themed)
        ├── PasswordField (with toggle)
        ├── XPProgressBar
        ├── StreakIndicator
        ├── AchievementCard
        ├── CourseCard
        ├── LessonCard
        ├── QuizOptionCard
        ├── LeaderboardRow
        ├── BottomNavBar (custom)
        └── ShimmerLoading (skeleton)
```

### 7.2 Design System Structure

```
lib/core/
├── theme/
│   ├── app_colors.dart        ← Static color constants + gradients
│   ├── app_text_styles.dart   ← Static text style constants
│   ├── app_spacing.dart       ← 4dp grid system (4, 8, 12, 16, 20, 24, 32, 40, 48, 64)
│   ├── app_radius.dart        ← BorderRadius constants (8, 12, 14, 16, 20, 24)
│   └── app_shadows.dart       ← BoxShadow presets (soft, medium, strong, glow)
├── constants/
│   ├── app_constants.dart     ← XP thresholds, level caps, timeouts
│   └── app_strings.dart       ← All user-facing strings (prep for localization)
└── extensions/
    ├── context_extensions.dart  ← Theme, MediaQuery shortcuts
    └── widget_extensions.dart   ← Padding, animation helpers
```

### 7.3 Animation Strategy

- **Use `AnimationController` sparingly** — prefer `AnimatedContainer`, `AnimatedOpacity`, `AnimatedSwitcher`, `TweenAnimationBuilder` for 90% of cases
- **Reserve `AnimationController`** for: custom page transitions, XP float animation, celebration sequences, streak pulse
- **Stagger animations** using `Interval` curves — items in a list should not all appear at once
- **Reduce motion** — respect `MediaQuery.alwaysUse24HourFormat`? No — use `MediaQuery.disableAnimations` (Flutter 3.10+) to disable animations for a11y

### 7.4 Responsive Rules

| Breakpoint | Behavior |
|------------|----------|
| < 360dp | Single column, reduce padding to 16dp, hide labels in bottom nav |
| 360–600dp | Default phone layout, 20dp padding |
| 600–840dp | Tablet: 2-column grid for courses, wider cards |
| > 840dp | Large tablet: side navigation + content pane (adaptive layout) |

**Key responsive principles:**
- Never use `MediaQuery.sizeOf(context).height * 0.38` — use `Expanded` + `Flexible` + `ConstrainedBox(maxHeight)`
- Text sizes should scale using `MediaQuery.textScaleFactor` (but cap at 1.3x for design integrity)
- Use `LayoutBuilder` for grid layouts, not hardcoded column counts

---

## 8. Implementation Roadmap (Priority Order)

| Phase | Feature | Effort |
|-------|---------|--------|
| ✅ Done | Splash/Onboarding (3 screens) | — |
| ✅ Done | Authentication (login, register, forgot password) | — |
| ✅ Done | Home Dashboard | — |
| 🔜 P1 | Courses list + Course detail | 3–4 days |
| 🔜 P1 | Lesson player (content + interactive) | 4–5 days |
| 🔜 P1 | Quiz system | 3 days |
| 🔜 P2 | Playground (code editor) | 5–6 days |
| 🔜 P2 | Leaderboard | 2 days |
| 🔜 P2 | Achievements system | 2 days |
| 🔜 P2 | Profile + Settings | 2 days |
| 🔜 P3 | AI Assistant | 4–5 days |
| 🔜 P3 | Skill selection onboarding | 1 day |
| 🔜 P3 | Goal setting onboarding | 1 day |
| 🔜 P4 | Notifications + Streak reminders | 2 days |
| 🔜 P4 | Social features (friends, share) | 3 days |

---

## 9. UX Quality Checklist

Every screen must pass:

- [ ] **No overflow on smallest supported device** (360dp width, 640dp height)
- [ ] **All text readable** at 1x and 1.3x text scale
- [ ] **Empty state exists** for every list
- [ ] **Loading state exists** (shimmer or skeleton) for every dynamic section
- [ ] **Error state exists** (with retry CTA) for every network-dependent section
- [ ] **Feedback on every action** (button → response within 200ms)
- [ ] **Consistent spacing** (use `app_spacing.dart`, not random padding values)
- [ ] **No hardcoded strings** (all strings in `app_strings.dart`)
- [ ] **Dark theme only** (CodeBro does not support light mode)
- [ ] **Keyboard handled** (text fields dismiss on tap outside, scroll into view)

---

## 10. Key UX Decisions

1. **No light mode.** CodeBro is a developer IDE-like experience. Dark is identity, not a preference toggle.

2. **No sound effects by default.** Users in public spaces (coffee shops, transport) don't want noise. Optional "sound pack" for premium.

3. **Lessons before leaderboard.** New users should complete 3 lessons before they appear on the leaderboard. This prevents empty leaderboard discouragement.

4. **Streak freeze is earned, not bought.** At 7-day streak, user gets 1 freeze. Keeps streaks meaningful.

5. **XP should always round up.** 50 XP for a lesson? Display "+50 XP", not just the total. The micro-dopamine of seeing the number is crucial.

6. **Confetti is reserved for milestones.** Level up, 100% quiz, achievement unlock. Too much confetti devalues it.

7. **Error messages should blame themselves, not the user.** Never "You entered wrong credentials" → Always "We couldn't log you in. Check your email and password."

8. **Skip is always visible.** During onboarding and lessons, the user should never feel trapped.

---

*This blueprint serves as the UX north star for CodeBro. Every screen, every animation, every micro-interaction should be traced back to one of the principles documented here.*
