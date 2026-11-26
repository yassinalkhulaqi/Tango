import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../domain/leaderboard_model.dart';

class LeaderboardRow extends StatelessWidget {
  final LeaderboardEntry entry;
  final bool showRankBadge;

  const LeaderboardRow({
    super.key,
    required this.entry,
    this.showRankBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    final isCurrent = entry.isCurrentUser;
    final Color rankColor = entry.rank == 1
        ? AppColors.primaryYellow
        : entry.rank == 2
        ? const Color(0xFFCBD5E1)
        : entry.rank == 3
        ? const Color(0xFFE2E8F0)
        : AppColors.textMuted;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isCurrent
            ? AppColors.primaryBlue.withValues(alpha: 0.10)
            : AppColors.surface,
        borderRadius: AppRadius.circular(AppRadius.xl),
        border: Border.all(
          color: isCurrent ? AppColors.primaryBlue : AppColors.cardBorder,
          width: isCurrent ? 2 : 1,
        ),
        boxShadow: [AppShadows.soft],
      ),
      child: Row(
        children: [
          _buildRank(entry.rank, rankColor),
          const SizedBox(width: AppSpacing.md),
          _buildAvatar(entry.avatar),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.name,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isCurrent
                              ? AppColors.primaryBlue
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      'Lv.${entry.level}',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primaryYellow,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(
                      Icons.bolt_rounded,
                      color: AppColors.primaryYellow,
                      size: 16,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '${entry.xp.toStringAsFixed(0)} XP',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: AppRadius.circular(AppRadius.xxl),
              ),
              child: const Text(
                'YOU',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
            )
          else
            const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildRank(int rank, Color color) {
    if (showRankBadge && rank <= 3) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.2),
              color.withValues(alpha: 0.05),
            ],
          ),
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
        ),
        child: Center(
          child: Text(
            '$rank',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ),
      );
    }
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      child: Text(
        '#$rank',
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.textMuted,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildAvatar(String avatar) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          avatar,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
