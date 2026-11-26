import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/user_header.dart';
import '../widgets/xp_progress_card.dart';
import '../widgets/continue_learning_card.dart';
import '../widgets/stats_card.dart';
import '../widgets/category_card.dart';
import '../widgets/challenge_card.dart';
import '../widgets/lesson_path_widget.dart';
import '../widgets/daily_quests_card.dart';
import 'package:go_router/go_router.dart';
import '../../../courses/presentation/pages/courses_list_page.dart';
import '../../../leaderboard/presentation/pages/leaderboard_page.dart';
import '../../../playground/presentation/pages/playground_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  static const _navItems = [
    _NavItem(Icons.home_rounded, 'Home', AppColors.primaryGreen, '/home'),
    _NavItem(
      Icons.menu_book_rounded,
      'Courses',
      AppColors.primaryBlue,
      '/courses',
    ),
    _NavItem(
      Icons.terminal_rounded,
      'Code',
      AppColors.primaryOrange,
      '/playground',
    ),
    _NavItem(
      Icons.leaderboard_rounded,
      'League',
      AppColors.primaryPurple,
      '/leaderboard',
    ),
    _NavItem(
      Icons.person_rounded,
      'Profile',
      AppColors.primaryCyan,
      '/profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _buildPage(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildPage() {
    switch (_currentIndex) {
      case 1:
        return const CoursesListPage();
      case 2:
        return const PlaygroundPage();
      case 3:
        return const LeaderboardPage();
      case 4:
        return const ProfilePage();
      default:
        return _buildHome();
    }
  }

  Widget _buildHome() {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // Top streak bar (Duolingo-style)
              _buildStreakBar(),
              const SizedBox(height: 16),
              const UserHeader(),
              const SizedBox(height: 16),
              const XPProgressCard(),
              const SizedBox(height: 24),
              // Section: Learning Path
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Your Path 🗺️', style: AppTextStyles.titleMedium),
                  Text(
                    'See All',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const LessonPathWidget(),
              const SizedBox(height: 24),
              // Section: Continue Learning
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Continue 📖', style: AppTextStyles.titleMedium),
                  Text(
                    'My Courses',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const ContinueLearningCard(),
              const SizedBox(height: 24),
              // Section: Daily Quests
              const Text('Daily Quests 🎯', style: AppTextStyles.titleMedium),
              const SizedBox(height: 12),
              const DailyQuestsCard(),
              const SizedBox(height: 24),
              // Section: Challenge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Challenge 🏆', style: AppTextStyles.titleMedium),
                  Text(
                    '+50 XP',
                    style: AppTextStyles.xpAmount.copyWith(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const ChallengeCard(),
              const SizedBox(height: 24),
              // Section: Stats
              Text('Your Stats 📊', style: AppTextStyles.titleMedium),
              const SizedBox(height: 12),
              _buildStatsRow(),
              const SizedBox(height: 24),
              // Section: Categories
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Explore 📚', style: AppTextStyles.titleMedium),
                  Text(
                    'See All',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildCategoryRow(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStreakBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryOrange.withValues(alpha: 0.1),
            AppColors.primaryYellow.withValues(alpha: 0.05),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryOrange.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primaryOrange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: AppColors.primaryOrange,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Text('12 Day Streak', style: AppTextStyles.streakCount),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryPurple.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
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

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: StatsCard(
            icon: Icons.check_circle_rounded,
            value: '48',
            label: 'Lessons',
            color: AppColors.primaryGreen,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatsCard(
            icon: Icons.local_fire_department_rounded,
            value: '12',
            label: 'Day Streak',
            color: AppColors.primaryOrange,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatsCard(
            icon: Icons.bolt_rounded,
            value: '2,450',
            label: 'Total XP',
            color: AppColors.primaryYellow,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatsCard(
            icon: Icons.emoji_events_rounded,
            value: '8',
            label: 'Badges',
            color: AppColors.primaryPurple,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryRow() {
    final categories = [
      CategoryCard(
        name: 'Flutter',
        icon: Icons.phone_android_rounded,
        color: AppColors.primaryBlue,
        lessonCount: 24,
      ),
      CategoryCard(
        name: 'Python',
        icon: Icons.code_rounded,
        color: AppColors.primaryYellow,
        lessonCount: 18,
      ),
      CategoryCard(
        name: 'Security',
        icon: Icons.security_rounded,
        color: AppColors.primaryGreen,
        lessonCount: 12,
      ),
      CategoryCard(
        name: 'Web Dev',
        icon: Icons.language_rounded,
        color: AppColors.primaryPurple,
        lessonCount: 30,
      ),
      CategoryCard(
        name: 'AI / ML',
        icon: Icons.psychology_rounded,
        color: AppColors.primaryCyan,
        lessonCount: 9,
        isLocked: true,
      ),
    ];

    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, index) => categories[index],
      ),
    );
  }

  Widget _buildBottomNav() {
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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navItems.length, (index) {
              final isActive = index == _currentIndex;
              final item = _navItems[index];
              return GestureDetector(
                onTap: () {
                  if (index == 0) {
                    setState(() => _currentIndex = 0);
                  } else {
                    GoRouter.of(context).go(item.route);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? item.color.withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        color: isActive ? item.color : AppColors.textMuted,
                        size: 22,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: isActive ? item.color : AppColors.textMuted,
                          fontSize: 10,
                          fontWeight: isActive
                              ? FontWeight.w700
                              : FontWeight.w500,
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

class _NavItem {
  final IconData icon;
  final String label;
  final Color color;
  final String route;

  const _NavItem(this.icon, this.label, this.color, this.route);
}
