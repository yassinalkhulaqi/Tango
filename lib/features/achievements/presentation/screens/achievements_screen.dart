import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_gradients.dart';
import '../../ui_components/widgets/ui_component_library.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  final List<Map<String, dynamic>> _achievements = [
    {'name': 'First Commit', 'description': 'Complete your very first lesson', 'icon': '🚀', 'color': AppColors.primaryBlue, 'unlocked': true, 'xp': 100},
    {'name': 'Bug Squasher', 'description': 'Solve 10 challenge quizzes', 'icon': '🐛', 'color': AppColors.primaryGreen, 'unlocked': false, 'xp': 200},
    {'name': 'Week Warrior', 'description': 'Maintain a 7-day streak', 'icon': '🔥', 'color': AppColors.primaryOrange, 'unlocked': false, 'xp': 200},
    {'name': 'Polyglot', 'description': 'Learn 3 different categories', 'icon': '🌐', 'color': AppColors.primaryPurple, 'unlocked': false, 'xp': 300},
    {'name': 'Speed Runner', 'description': 'Complete a quiz in under 5 minutes', 'icon': '⚡', 'color': AppColors.primaryYellow, 'unlocked': false, 'xp': 150},
    {'name': 'Monthly Master', 'description': 'Stay active for 30 days', 'icon': '🏆', 'color': AppColors.primaryCyan, 'unlocked': false, 'xp': 500},
  ];

  @override
  Widget build(BuildContext context) {
    final earned = _achievements.where((a) => a['unlocked'] as bool).length;

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
                return AchievementCard(
                  achievement: _achievements[index],
                );
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
              Text('Badges', style: AppTextStyles.titleMedium.copyWith(fontSize: 18)),
              Text('$earned / ${_achievements.length}', style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const XPProgressBar(value: 0.17),
        ],
      ),
    );
  }
}

class AchievementCard extends StatelessWidget {
  final Map<String, dynamic> achievement;

  const AchievementCard({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    final isUnlocked = achievement['unlocked'] as bool;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.circular(AppRadius.xl),
        border: Border.all(
          color: isUnlocked ? achievement['color'] : AppColors.cardBorder,
          width: isUnlocked ? 2 : 1,
        ),
        boxShadow: [AppGradients.cardShadow()],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isUnlocked ? achievement['color'].withValues(alpha: 0.2) : AppColors.cardBorder.withValues(alpha: 0.4),
              shape: BoxShape.circle,
              border: Border.all(color: isUnlocked ? achievement['color'] : AppColors.textMuted, width: 2),
            ),
            child: Center(child: Text(achievement['icon'], style: const TextStyle(fontSize: 28))),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            achievement['name'],
            style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700, color: isUnlocked ? AppColors.textPrimary : AppColors.textMuted),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            achievement['description'],
            style: AppTextStyles.bodyMedium.copyWith(color: isUnlocked ? AppColors.textSecondary : AppColors.textMuted, fontSize: 11),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (isUnlocked) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star_rounded, color: AppColors.primaryYellow, size: 16),
                const SizedBox(width: AppSpacing.xs),
                Text('+${achievement['xp']} XP', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryYellow, fontWeight: FontWeight.w700)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
