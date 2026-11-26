import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../progress/data/progress_repository.dart';
import '../../../progress/domain/progress_math.dart';

class LiveProgressHeader extends ConsumerWidget {
  const LiveProgressHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(homeDashboardProvider);
    final data = dataAsync.valueOrNull ?? HomeDashboardData.demo();
    final levelProgress = ProgressMath.levelProgress(data.progress.xp);
    final questProgress = ProgressMath.questCompletion(data.quests);

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LEVEL ${data.progress.level}',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${data.progress.xp} XP',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              _metric(
                Icons.local_fire_department,
                '${data.streak.current}',
                AppColors.primaryOrange,
              ),
              const SizedBox(width: AppSpacing.md),
              _metric(
                Icons.check_circle_outline,
                '${data.quests.length}',
                AppColors.primaryGreen,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          LinearProgressIndicator(
            value: levelProgress,
            minHeight: 6,
            backgroundColor: AppColors.cardBorder,
            valueColor: const AlwaysStoppedAnimation(AppColors.primaryBlue),
          ),
          const SizedBox(height: 4),
          Text(
            'Daily quests ${(questProgress * 100).round()}% complete',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _metric(IconData icon, String value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 4),
        Text(value, style: AppTextStyles.labelLarge.copyWith(color: color)),
      ],
    );
  }
}
