import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_gradients.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );
    _pulseController.repeat(reverse: true);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.md),
                      _buildGreetingSection(),
                      const SizedBox(height: AppSpacing.xxl),
                      _buildStreakSection(),
                      const SizedBox(height: AppSpacing.xxl),
                      _buildXPSection(),
                      const SizedBox(height: AppSpacing.xxl),
                      _buildContinueLearningSection(),
                      const SizedBox(height: AppSpacing.xxl),
                      _buildDailyQuestsSection(),
                      const SizedBox(height: AppSpacing.xxl),
                      _buildStatsSection(),
                      const SizedBox(height: AppSpacing.xxl),
                      _buildCategoriesSection(),
                      const SizedBox(height: AppSpacing.xxl),
                      _buildChallengeSection(),
                      const SizedBox(height: AppSpacing.xxl),
                    ],
                  ),
                ),
              ),
              _buildBottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: AppGradients.primary,
                  borderRadius: AppRadius.circular(AppRadius.md),
                  boxShadow: [
                    AppGradients.glow(AppColors.primaryBlue, blurRadius: 12),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.terminal_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              const Text(
                'CodeBro',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.textSecondary,
              size: 22,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search_rounded,
              color: AppColors.textSecondary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreetingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back,',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Text(
              'Alex Rivera',
              style: AppTextStyles.displayMedium.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryYellow.withValues(alpha: 0.15),
                borderRadius: AppRadius.circular(AppRadius.xxl),
                border: Border.all(
                  color: AppColors.primaryYellow.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: const Text(
                'Senior',
                style: TextStyle(
                  color: AppColors.primaryYellow,
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            gradient: AppGradients.streak,
            borderRadius: AppRadius.circular(AppRadius.xl),
            boxShadow: [
              AppGradients.glow(AppColors.primaryOrange, blurRadius: 16),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ready to code today?',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your next lesson is waiting',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStreakSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.cardBorder, width: 1),
        boxShadow: [AppGradients.cardShadow()],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryOrange.withValues(alpha: 0.2),
                  AppColors.primaryYellow.withValues(alpha: 0.1),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.local_fire_department_rounded,
                color: AppColors.primaryOrange,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '12 Day Streak',
                      style: AppTextStyles.titleLarge.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withValues(alpha: 0.15),
                        borderRadius: AppRadius.circular(AppRadius.xxl),
                      ),
                      child: const Text(
                        'Active',
                        style: TextStyle(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w700,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Keep it going! Freeze available',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryPurple.withValues(alpha: 0.15),
              borderRadius: AppRadius.circular(AppRadius.xxl),
              border: Border.all(
                color: AppColors.primaryPurple.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.emoji_events_rounded,
                  color: AppColors.primaryPurple,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  'Gold League',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primaryPurple,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildXPSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.circular(AppRadius.xxl),
        border: Border.all(color: AppColors.cardBorder, width: 1),
        boxShadow: [AppGradients.cardShadow()],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Level 7',
                style: AppTextStyles.titleLarge.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.15),
                  borderRadius: AppRadius.circular(AppRadius.xxl),
                  border: Border.all(
                    color: AppColors.primaryBlue.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: const Text(
                  'Senior Developer',
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: AppRadius.circular(AppRadius.md),
            child: LinearProgressIndicator(
              value: 0.74,
              minHeight: 10,
              backgroundColor: AppColors.cardBorder,
              valueColor: const AlwaysStoppedAnimation(AppColors.primaryBlue),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '8,900 / 12,000 XP',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              Text(
                '3,100 XP to next level',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContinueLearningSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Continue Learning',
              style: AppTextStyles.titleLarge.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Resume',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.circular(AppRadius.xl),
            border: Border.all(color: AppColors.cardBorder, width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Flutter Fundamentals',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Lesson 4: Widgets Deep Dive',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppGradients.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    AppGradients.glow(AppColors.primaryBlue, blurRadius: 16),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDailyQuestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Daily Quests',
              style: AppTextStyles.titleLarge.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'View All',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Column(
          children: List.generate(4, (index) {
            final quests = [
              {
                'title': 'Complete a Flutter Lesson',
                'xp': 50,
                'icon': Icons.check_circle_rounded,
                'completed': false,
              },
              {
                'title': 'Maintain Your Streak',
                'xp': 100,
                'icon': Icons.local_fire_department_rounded,
                'completed': false,
              },
              {
                'title': 'Score 100% on a Quiz',
                'xp': 100,
                'icon': Icons.bolt_rounded,
                'completed': false,
              },
              {
                'title': 'Solve a Challenge',
                'xp': 50,
                'icon': Icons.flag_rounded,
                'completed': false,
              },
            ];
            final q = quests[index];
            return Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: AppRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.cardBorder, width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.15),
                      borderRadius: AppRadius.circular(AppRadius.md),
                    ),
                    child: Center(
                      child: Icon(
                        q['icon'] as IconData,
                        color: AppColors.primaryBlue,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          q['title'] as String,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '+${q['xp']} XP',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Checkbox(
                    value: q['completed'] as bool,
                    onChanged: null,
                    activeColor: AppColors.primaryGreen,
                  ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Stats',
          style: AppTextStyles.titleLarge.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 6,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.4,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
          ),
          itemBuilder: (context, index) {
            final stats = [
              {
                'icon': Icons.check_circle_rounded,
                'value': '48',
                'label': 'Lessons',
                'color': AppColors.primaryGreen,
              },
              {
                'icon': Icons.local_fire_department_rounded,
                'value': '12',
                'label': 'Streak',
                'color': AppColors.primaryOrange,
              },
              {
                'icon': Icons.bolt_rounded,
                'value': '12,450',
                'label': 'Total XP',
                'color': AppColors.primaryYellow,
              },
              {
                'icon': Icons.emoji_events_rounded,
                'value': '6',
                'label': 'Badges',
                'color': AppColors.primaryPurple,
              },
              {
                'icon': Icons.quiz_rounded,
                'value': '24',
                'label': 'Quizzes',
                'color': AppColors.primaryCyan,
              },
              {
                'icon': Icons.code_rounded,
                'value': '12',
                'label': 'Challenges',
                'color': AppColors.primaryGreen,
              },
            ];
            final s = stats[index];
            return Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.circular(AppRadius.xl),
                border: Border.all(color: AppColors.cardBorder, width: 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: s['color'].withValues(alpha: 0.15),
                      borderRadius: AppRadius.circular(AppRadius.md),
                    ),
                    child: Center(
                      child: Icon(
                        s['icon'] as IconData,
                        color: s['color'],
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    s['value'] as String,
                    style: AppTextStyles.titleLarge.copyWith(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    s['label'] as String,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Explore Categories',
              style: AppTextStyles.titleLarge.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'See All',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            itemBuilder: (context, index) {
              final categories = [
                {
                  'name': 'Flutter',
                  'icon': Icons.phone_android_rounded,
                  'color': AppColors.primaryBlue,
                  'count': 24,
                  'locked': false,
                },
                {
                  'name': 'Python',
                  'icon': Icons.code_rounded,
                  'color': AppColors.primaryYellow,
                  'count': 18,
                  'locked': false,
                },
                {
                  'name': 'Security',
                  'icon': Icons.security_rounded,
                  'color': AppColors.primaryGreen,
                  'count': 12,
                  'locked': false,
                },
                {
                  'name': 'Web Dev',
                  'icon': Icons.language_rounded,
                  'color': AppColors.primaryPurple,
                  'count': 30,
                  'locked': false,
                },
                {
                  'name': 'AI/ML',
                  'icon': Icons.psychology_rounded,
                  'color': AppColors.primaryCyan,
                  'count': 9,
                  'locked': true,
                },
                {
                  'name': 'Game Dev',
                  'icon': Icons.games_rounded,
                  'color': AppColors.primaryOrange,
                  'count': 15,
                  'locked': true,
                },
              ];
              final c = categories[index];
              return Container(
                width: 120,
                margin: const EdgeInsets.only(right: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.circular(AppRadius.xl),
                  border: Border.all(color: AppColors.cardBorder, width: 1),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: c['color'].withValues(alpha: 0.15),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(14),
                            topRight: Radius.circular(14),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            c['icon'] as IconData,
                            size: 36,
                            color: c['locked']
                                ? AppColors.textMuted
                                : c['color'] as Color,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: Column(
                        children: [
                          Text(
                            c['name'] as String,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: c['locked']
                                  ? AppColors.textMuted
                                  : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${c['count']} lessons',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          if (c['locked'] as bool) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.textMuted.withValues(alpha: 0.15),
                                borderRadius: AppRadius.circular(AppRadius.xxl),
                              ),
                              child: const Text(
                                'Locked',
                                style: TextStyle(
                                  color: AppColors.textMuted,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 8,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChallengeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryYellow.withValues(alpha: 0.2),
            AppColors.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.circular(AppRadius.xxl),
        border: Border.all(
          color: AppColors.primaryYellow.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          AppGradients.glow(AppColors.primaryYellow, blurRadius: 16),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.flag_rounded,
                color: AppColors.primaryYellow,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Challenge',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Build a Login UI',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '+50 XP',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primaryYellow,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Create a beautiful login screen with Flutter. Use dark theme and glassmorphism components.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.play_arrow_rounded,
                size: 18,
                color: Colors.white,
              ),
              label: const Text(
                'Start Challenge',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryYellow,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.circular(AppRadius.xl),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Home', 'color': AppColors.primaryGreen},
      {'icon': Icons.menu_book_rounded, 'label': 'Courses', 'color': AppColors.primaryBlue},
      {'icon': Icons.terminal_rounded, 'label': 'Code', 'color': AppColors.primaryOrange},
      {'icon': Icons.leaderboard_rounded, 'label': 'League', 'color': AppColors.primaryPurple},
      {'icon': Icons.person_rounded, 'label': 'Profile', 'color': AppColors.primaryCyan},
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.cardBorder, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isActive = index == _selectedIndex;
              return GestureDetector(
                onTap: () => setState(() => _selectedIndex = index),
                child: AnimatedContainer(
                  duration: AppMotion.normal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? item['color'].withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: AppRadius.circular(AppRadius.md),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        color: isActive
                            ? item['color'] as Color
                            : AppColors.textMuted,
                        size: 22,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['label'] as String,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: isActive
                              ? item['color'] as Color
                              : AppColors.textMuted,
                          fontWeight:
                              isActive ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
