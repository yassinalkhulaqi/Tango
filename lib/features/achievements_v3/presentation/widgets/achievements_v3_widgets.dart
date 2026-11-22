import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class AchievementCardV3 extends StatelessWidget {
  final String name;
  final String description;
  final String icon;
  final bool unlocked;
  final int target;
  final int progress;

  const AchievementCardV3({super.key, required this.name, required this.description, required this.icon, required this.unlocked, this.target = 10, this.progress = 0});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.circular(AppRadius.xl),
        side: BorderSide(color: unlocked ? AppColors.primaryYellow : AppColors.cardBorder, width: unlocked ? 2 : 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: unlocked ? AppColors.primaryYellow.withValues(alpha: 0.2) : AppColors.cardBorder.withValues(alpha: 0.5),
              child: Text(icon, style: const TextStyle(fontSize: 26)),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(name, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700, color: unlocked ? AppColors.textPrimary : AppColors.textMuted), textAlign: TextAlign.center),
            Text(description, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted, fontSize: 11), textAlign: TextAlign.center, maxLines: 2),
            const SizedBox(height: AppSpacing.sm),
            LinearProgressIndicator(value: target == 0 ? 0 : progress / target),
          ],
        ),
      ),
    );
  }
}

class AchievementGridV3 extends StatelessWidget {
  final List<AchievementCardV3> achievements;
  const AchievementGridV3({super.key, required this.achievements});

  @override
  Widget build(BuildContext context) {
    return GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), children: achievements);
  }
}
