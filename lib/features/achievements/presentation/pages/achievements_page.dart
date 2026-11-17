import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_shadows.dart';
import '../domain/achievement_model.dart';
import 'achievement_card.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  final List<Achievement> _achievements = [
    Achievement(
      id: 'first_commit',
      name: 'First Commit',
      description: 'Complete your very first lesson',
      icon: '🚀',
      color: AppColors.primaryBlue,
      xpReward: 100,
      unlocked: true,
      unlockedAt: DateTime.now().subtract(const Duration(days: 12)),
    ),
    Achievement(
      id: 'bug_squasher',
      name: 'Bug Squasher',
      description: 'Solve 10 challenge quizzes',
      icon: '🐛',
      color: AppColors.green,
      xpReward: 200,
      unlocked: false,
    ),
    Achievement(
      id: 'week_warrior',
      name: 'Week Warrior',
      description: 'Maintain a 7-day streak',
      icon: '🔥',
      color: AppColors.primaryOrange,
      xpReward: 200,
      unlocked: false,
    ),
    Achievement(
      id: 'polyglot',
      name: 'Polyglot',
      description: 'Learn 3 different categories',
      icon: '🌐',
      color: AppColors.primaryPurple,
      xpReward: 300,
      unlocked: false,
    ),
    Achievement(
      id: 'speed_runner',
      name: 'Speed Runner',
      description: 'Complete a quiz in under 5 minutes',
      icon: '⚡',
      color: AppColors.primaryYellow,
      xpReward: 150,
      unlocked: false,
    ),
    Achievement(
      id: 'monthly_master',
      name: 'Monthly Master',
      description: 'Stay active for 30 days',
      icon: '🏆',
      color: AppColors.primaryCyan,
      xpReward: 500,
      unlocked: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final earned = _achievements.where((a) => a.unlocked).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Achievements'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        children: [
          _buildProgressHeader(earned),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.88,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
              ),
              itemCount: _achievements.length,
              itemBuilder: (context, index) {
                return AchievementCard(achievement: _achievements[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressHeader(int earned) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(bottom: BorderSide(color: AppColors.cardBorder, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Badges',
                style: AppTextStyles.titleMedium.copyWith(fontSize: 18),
              ),
              Text(
                '$earned / ${_achievements.length}',
                style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: AppRadius.circular(AppRadius.md),
            child: LinearProgressIndicator(
              value: earned / _achievements.length,
              minHeight: 8,
              backgroundColor: AppColors.cardBorder,
              valueColor: const AlwaysStoppedAnimation(AppColors.primaryYellow),
            ),
          ),
        ],
      ),
    );
  }
}
