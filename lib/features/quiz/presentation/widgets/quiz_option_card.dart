import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_shadows.dart';
import '../domain/quiz_model.dart';

class QuizOptionCard extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool isRevealed;
  final VoidCallback onTap;

  const QuizOptionCard({
    super.key,
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.isRevealed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color fill;
    Color border;
    Color textColor;

    if (isRevealed) {
      if (isCorrect) {
        fill = AppColors.green.withValues(alpha: 0.15);
        border = AppColors.green;
        textColor = AppColors.textPrimary;
      } else if (isSelected) {
        fill = AppColors.pink.withValues(alpha: 0.15);
        border = AppColors.pink;
        textColor = AppColors.textPrimary;
      } else {
        fill = AppColors.surface;
        border = AppColors.cardBorder;
        textColor = AppColors.textSecondary;
      }
    } else {
      fill = isSelected ? AppColors.primaryBlue.withValues(alpha: 0.15) : AppColors.surface;
      border = isSelected ? AppColors.primaryBlue : AppColors.cardBorder;
      textColor = AppColors.textPrimary;
    }

    return GestureDetector(
      onTap: isRevealed ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: AppRadius.circular(AppRadius.xl),
          border: Border.all(color: border, width: 2),
          boxShadow: [AppShadows.soft],
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isRevealed && isCorrect
                    ? AppColors.green
                    : isRevealed && isSelected
                        ? AppColors.pink
                        : isSelected
                            ? AppColors.primaryBlue
                            : AppColors.surfaceLight,
                shape: BoxShape.circle,
                border: Border.all(color: border, width: 2),
              ),
              child: Center(
                child: isRevealed && isCorrect
                    ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
                    : isRevealed && isSelected
                        ? const Icon(Icons.close_rounded, color: Colors.white, size: 18)
                        : null,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
