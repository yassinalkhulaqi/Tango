import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../domain/course_model.dart';

class LessonItem extends StatelessWidget {
  final Lesson lesson;
  final int index;
  final VoidCallback onTap;

  const LessonItem({
    super.key,
    required this.lesson,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = lesson.isCompleted;
    final isLocked = lesson.isLocked;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: isLocked ? AppColors.surface : AppColors.surfaceLight,
        borderRadius: AppRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isLocked ? AppColors.cardBorder : AppColors.divider,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppRadius.circular(AppRadius.lg),
          onTap: isLocked ? null : onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.green
                        : isLocked
                        ? AppColors.cardBorder
                        : AppColors.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isLocked
                              ? AppColors.textMuted
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        lesson.description,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (isCompleted)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.green,
                    size: 20,
                  )
                else if (isLocked)
                  const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.textMuted,
                    size: 20,
                  )
                else
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.primaryBlue,
                    size: 16,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
