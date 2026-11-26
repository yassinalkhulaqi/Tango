import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../ui_components/widgets/ui_component_library.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: AppMotion.smooth,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.md),
                _buildStreakBar(),
                const SizedBox(height: AppSpacing.lg),
                const UserHeader(
                  name: 'Alex Rivera',
                  level: 'Level 7 • Senior Developer',
                  avatar: 'AR',
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildXPSection(),
                const SizedBox(height: AppSpacing.xxl),
                _buildSectionHeader('Your Learning Path', 'See All'),
                const SizedBox(height: AppSpacing.md),
                LessonPathWidget(
                  path: [
                    {
                      'title': 'Flutter Basics',
                      'completed': true,
                      'current': false,
                    },
                    {
                      'title': 'Widgets Deep Dive',
                      'completed': true,
                      'current': false,
                    },
                    {
                      'title': 'State Management',
                      'completed': false,
                      'current': true,
                    },
                    {
                      'title': 'Navigation & Routing',
                      'completed': false,
                      'current': false,
                    },
                    {
                      'title': 'Deploy to Play Store',
                      'completed': false,
                      'current': false,
                    },
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),
                _buildSectionHeader('Continue Learning', 'My Courses'),
                const SizedBox(height: AppSpacing.md),
                const ContinueLearningCard(),
                const SizedBox(height: AppSpacing.xxl),
                _buildSectionHeader('Daily Quests', 'View All'),
                const SizedBox(height: AppSpacing.md),
                DailyQuestsCard(
                  quests: [
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
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),
                _buildSectionHeader('Daily Challenge', '+50 XP'),
                const SizedBox(height: AppSpacing.md),
                ChallengeCard(
                  title: 'Build a Login UI',
                  description:
                      'Create a beautiful login screen with Flutter. Use dark theme and glassmorphism.',
                  xpReward: 50,
                ),
                const SizedBox(height: AppSpacing.xxl),
                _buildSectionHeader('Your Stats', null),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: StatsCard(
                        icon: Icons.check_circle_rounded,
                        value: '48',
                        label: 'Lessons',
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: StatsCard(
                        icon: Icons.local_fire_department_rounded,
                        value: '12',
                        label: 'Day Streak',
                        color: AppColors.primaryOrange,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: StatsCard(
                        icon: Icons.bolt_rounded,
                        value: '12,450',
                        label: 'Total XP',
                        color: AppColors.primaryYellow,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: StatsCard(
                        icon: Icons.emoji_events_rounded,
                        value: '6',
                        label: 'Badges',
                        color: AppColors.primaryPurple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),
                _buildSectionHeader('Explore Categories', 'See All'),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 150,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final categories = [
                        {
                          'name': 'Flutter',
                          'icon': Icons.phone_android_rounded,
                          'color': AppColors.primaryBlue,
                          'count': 24,
                        },
                        {
                          'name': 'Python',
                          'icon': Icons.code_rounded,
                          'color': AppColors.primaryYellow,
                          'count': 18,
                        },
                        {
                          'name': 'Security',
                          'icon': Icons.security_rounded,
                          'color': AppColors.primaryGreen,
                          'count': 12,
                        },
                        {
                          'name': 'Web Dev',
                          'icon': Icons.language_rounded,
                          'color': AppColors.primaryPurple,
                          'count': 30,
                        },
                        {
                          'name': 'AI/ML',
                          'icon': Icons.psychology_rounded,
                          'color': AppColors.primaryCyan,
                          'count': 9,
                          'locked': true,
                        },
                      ];
                      final c = categories[index];
                      return CategoryCard(
                        name: c['name'],
                        icon: c['icon'],
                        color: c['color'],
                        lessonCount: c['count'],
                        isLocked: c['locked'] ?? false,
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildStreakBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        gradient: AppGradients.streak,
        borderRadius: AppRadius.circular(AppRadius.lg),
        boxShadow: [AppGradients.glow(AppColors.primaryOrange, blurRadius: 16)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: AppRadius.circular(AppRadius.md),
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          const Text('12 Day Streak', style: AppTextStyles.streakCount),
          const Spacer(),
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
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Gold League',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primaryPurple,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
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
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Level 7',
                style: AppTextStyles.titleMedium.copyWith(fontSize: 18),
              ),
              Text(
                '8,900 / 12,000 XP',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const XPProgressBar(value: 0.74),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Text(
                'Senior Developer',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
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
                  'Rank #42',
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String? seeAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.titleMedium.copyWith(fontSize: 18)),
        if (seeAll != null)
          Text(
            seeAll,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
      ],
    );
  }

  Widget _buildBottomNav() {
    final items = [
      {
        'icon': Icons.home_rounded,
        'label': 'Home',
        'color': AppColors.primaryGreen,
      },
      {
        'icon': Icons.menu_book_rounded,
        'label': 'Courses',
        'color': AppColors.primaryBlue,
      },
      {
        'icon': Icons.terminal_rounded,
        'label': 'Code',
        'color': AppColors.primaryOrange,
      },
      {
        'icon': Icons.leaderboard_rounded,
        'label': 'League',
        'color': AppColors.primaryPurple,
      },
      {
        'icon': Icons.person_rounded,
        'label': 'Profile',
        'color': AppColors.primaryCyan,
      },
    ];
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(
          top: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
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
              final isActive = index == _currentIndex;
              return GestureDetector(
                onTap: () => setState(() => _currentIndex = index),
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
                        item['icon'],
                        color: isActive ? item['color'] : AppColors.textMuted,
                        size: 22,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['label'],
                        style: AppTextStyles.labelSmall.copyWith(
                          color: isActive ? item['color'] : AppColors.textMuted,
                          fontWeight: isActive
                              ? FontWeight.w700
                              : FontWeight.w500,
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

class ContinueLearningCard extends StatelessWidget {
  const ContinueLearningCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Continue Learning',
                style: AppTextStyles.titleMedium.copyWith(fontSize: 17),
              ),
              Text(
                'Resume',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Flutter Fundamentals',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Lesson 4: Widgets Deep Dive',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
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
          const SizedBox(height: AppSpacing.md),
          const XPProgressBar(value: 0.45),
        ],
      ),
    );
  }
}
