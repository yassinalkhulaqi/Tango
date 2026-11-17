import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_gradients.dart';

class LessonProgressWidget extends StatelessWidget {
  final double progress;
  final int completed;
  final int total;

  const LessonProgressWidget({
    super.key,
    required this.progress,
    required this.completed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Lesson Progress',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        ClipRRect(
          borderRadius: AppRadius.circular(AppRadius.md),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: AppColors.cardBorder,
            valueColor: const AlwaysStoppedAnimation(AppColors.primaryBlue),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            ...List.generate(total, (index) {
              final isCompleted = index < completed;
              return Expanded(
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    color: isCompleted ? AppColors.primaryGreen : AppColors.cardBorder.withValues(alpha: 0.3),
                    borderRadius: AppRadius.circular(AppRadius.md),
                  ),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }
}

class SectionProgressIndicator extends StatelessWidget {
  final List<bool> sectionStatus;
  final int currentIndex;

  const SectionProgressIndicator({
    super.key,
    required this.sectionStatus,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(sectionStatus.length, (index) {
        final isCompleted = sectionStatus[index];
        final isCurrent = index == currentIndex;
        return Padding(
          padding: const EdgeInsets.only(right: AppSpacing.sm),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.primaryGreen
                  : isCurrent
                      ? AppColors.primaryBlue
                      : AppColors.cardBorder,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                  : Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
            ),
          ),
        );
      }),
    );
  }
}

class XPIndicator extends StatelessWidget {
  final int xp;
  final int totalXP;
  final Color color;

  const XPIndicator({
    super.key,
    required this.xp,
    required this.totalXP,
    this.color = AppColors.primaryYellow,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.bolt_rounded, color: AppColors.primaryYellow, size: 16),
        const SizedBox(width: AppSpacing.xs),
        Text(
          '$xp / $totalXP XP',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class LessonStreakIndicator extends StatelessWidget {
  final int streak;
  final bool animated;

  const LessonStreakIndicator({
    super.key,
    required this.streak,
    this.animated = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryOrange.withValues(alpha: 0.2), AppColors.primaryYellow.withValues(alpha: 0.1)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: AppRadius.circular(AppRadius.xxl),
        border: Border.all(color: AppColors.primaryOrange.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_fire_department_rounded, color: AppColors.primaryOrange, size: 18),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '$streak Day Streak',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.primaryOrange,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
