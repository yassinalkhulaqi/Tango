import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class LeaderboardRowV3 extends StatelessWidget {
  final int rank;
  final String name;
  final String avatar;
  final int xp;
  final bool isCurrentUser;

  const LeaderboardRowV3({super.key, required this.rank, required this.name, required this.avatar, required this.xp, this.isCurrentUser = false});

  @override
  Widget build(BuildContext context) {
    final color = rank == 1 ? AppColors.primaryYellow : rank == 2 ? Colors.grey.shade400 : rank == 3 ? Colors.brown.shade300 : AppColors.textMuted;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isCurrentUser ? AppColors.primaryBlue.withValues(alpha: 0.1) : AppColors.surface,
        borderRadius: AppRadius.circular(AppRadius.lg),
        border: Border.all(color: isCurrentUser ? AppColors.primaryBlue : AppColors.cardBorder, width: isCurrentUser ? 2 : 1),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: color, child: Text('$rank', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800))),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(name, style: AppTextStyles.bodyLarge.copyWith(color: isCurrentUser ? AppColors.primaryBlue : AppColors.textPrimary, fontWeight: FontWeight.w600))),
          Text('$xp XP', style: AppTextStyles.labelLarge.copyWith(color: AppColors.primaryYellow, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
