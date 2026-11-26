import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../domain/lesson_models.dart';

class QuizEmbeddedWidget extends StatefulWidget {
  final LessonQuizQuestion question;
  final int? selectedAnswer;
  final bool showResult;
  final ValueChanged<int> onAnswerSelected;
  final VoidCallback onNext;
  final bool isSubmitting;

  const QuizEmbeddedWidget({
    super.key,
    required this.question,
    required this.selectedAnswer,
    required this.showResult,
    required this.onAnswerSelected,
    required this.onNext,
    required this.isSubmitting,
  });

  @override
  State<QuizEmbeddedWidget> createState() => _QuizEmbeddedWidgetState();
}

class _QuizEmbeddedWidgetState extends State<QuizEmbeddedWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Knowledge Check',
              style: AppTextStyles.titleMedium.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryBlue,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.15),
                borderRadius: AppRadius.circular(AppRadius.xxl),
              ),
              child: Text(
                '${widget.question.points} XP',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          widget.question.question,
          style: AppTextStyles.titleLarge.copyWith(fontSize: 20),
        ),
        const SizedBox(height: AppSpacing.xxl),
        ...List.generate(widget.question.options.length, (index) {
          final isSelected = widget.selectedAnswer == index;
          final isCorrect = index == widget.question.correctIndex;
          final isRevealed = widget.showResult;
          return QuizOptionWidget(
            text: widget.question.options[index],
            isSelected: isSelected,
            isCorrect: isCorrect,
            isRevealed: isRevealed,
            onTap: widget.isSubmitting
                ? null
                : () => widget.onAnswerSelected(index),
          );
        }),
        if (widget.showResult && widget.selectedAnswer != null) ...[
          const SizedBox(height: AppSpacing.md),
          _buildFeedback(widget.question),
        ],
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: PremiumQuizButton(
            text: widget.showResult && widget.selectedAnswer != null
                ? (widget.selectedAnswer == widget.question.correctIndex
                      ? 'Correct! Next'
                      : 'Try Again')
                : 'Submit Answer',
            onPressed: widget.showResult && widget.selectedAnswer != null
                ? widget.onNext
                : (widget.selectedAnswer != null
                      ? () => widget.submitAnswer()
                      : null),
            isDisabled: widget.selectedAnswer == null && !widget.showResult,
            gradient: AppGradients.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildFeedback(LessonQuizQuestion question) {
    final isCorrect = widget.selectedAnswer == question.correctIndex;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: (isCorrect ? AppColors.primaryGreen : AppColors.pink).withValues(
          alpha: 0.15,
        ),
        borderRadius: AppRadius.circular(AppRadius.lg),
        border: Border.all(
          color: (isCorrect ? AppColors.primaryGreen : AppColors.pink)
              .withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isCorrect
                ? Icons.check_circle_rounded
                : Icons.error_outline_rounded,
            color: isCorrect ? AppColors.primaryGreen : AppColors.pink,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCorrect ? 'Correct!' : 'Incorrect',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isCorrect ? AppColors.primaryGreen : AppColors.pink,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  question.explanation,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QuizOptionWidget extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool isRevealed;
  final VoidCallback? onTap;

  const QuizOptionWidget({
    super.key,
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.isRevealed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color fill, border, textColor;
    if (isRevealed) {
      if (isCorrect) {
        fill = AppColors.primaryGreen.withValues(alpha: 0.15);
        border = AppColors.primaryGreen;
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
      fill = isSelected
          ? AppColors.primaryBlue.withValues(alpha: 0.15)
          : AppColors.surface;
      border = isSelected ? AppColors.primaryBlue : AppColors.cardBorder;
      textColor = AppColors.textPrimary;
    }

    return GestureDetector(
      onTap: isRevealed ? null : onTap,
      child: AnimatedContainer(
        duration: AppMotion.normal,
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: AppRadius.circular(AppRadius.xl),
          border: Border.all(color: border, width: 2),
          boxShadow: [AppGradients.cardShadow()],
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isRevealed && isCorrect
                    ? AppColors.primaryGreen
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
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 18,
                      )
                    : isRevealed && isSelected
                    ? const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 18,
                      )
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

class PremiumQuizButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isDisabled;
  final LinearGradient gradient;

  const PremiumQuizButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isDisabled = false,
    this.gradient = AppGradients.primary,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isDisabled;
    return AnimatedContainer(
      duration: AppMotion.fast,
      decoration: BoxDecoration(
        gradient: enabled ? gradient : null,
        color: enabled ? null : AppColors.cardBorder.withValues(alpha: 0.4),
        borderRadius: AppRadius.circular(AppRadius.xl),
        boxShadow: enabled
            ? [AppGradients.glow(AppColors.primaryBlue, blurRadius: 20)]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppRadius.circular(AppRadius.xl),
          onTap: enabled ? onPressed : null,
          child: Center(
            child: Text(
              text,
              style: AppTextStyles.labelLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension on QuizEmbeddedWidget {
  void submitAnswer() {}
}
