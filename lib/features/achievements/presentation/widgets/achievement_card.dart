import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../domain/achievement_model.dart';

class AchievementCard extends StatelessWidget {
  final Achievement achievement;

  const AchievementCard({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    final isUnlocked = achievement.unlocked;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.circular(AppRadius.xl),
        border: Border.all(
          color: isUnlocked ? AppColors.primaryYellow : AppColors.cardBorder,
          width: isUnlocked ? 2 : 1,
        ),
        boxShadow: [AppShadows.soft],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isUnlocked
                  ? achievement.color.withValues(alpha: 0.2)
                  : AppColors.cardBorder.withValues(alpha: 0.5),
              shape: BoxShape.circle,
              border: Border.all(
                color: isUnlocked ? achievement.color : AppColors.textMuted,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                achievement.icon,
                style: const TextStyle(fontSize: 30),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            achievement.name,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: isUnlocked ? AppColors.textPrimary : AppColors.textMuted,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            achievement.description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isUnlocked ? AppColors.textSecondary : AppColors.textMuted,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (isUnlocked) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star_rounded,
                  color: AppColors.primaryYellow,
                  size: 16,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '+${achievement.xpReward} XP',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primaryYellow,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
