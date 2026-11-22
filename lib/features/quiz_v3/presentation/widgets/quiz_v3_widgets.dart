import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class QuizOptionV3 extends StatelessWidget {
  final String text;
  final bool selected;
  final bool correct;
  final bool revealed;
  final VoidCallback onTap;

  const QuizOptionV3({super.key, required this.text, required this.selected, required this.correct, required this.revealed, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color bg = AppColors.surface;
    Color border = AppColors.cardBorder;
    if (revealed && correct) { bg = AppColors.primaryGreen.withValues(alpha: 0.15); border = AppColors.primaryGreen; }
    if (revealed && selected && !correct) { bg = AppColors.pink.withValues(alpha: 0.15); border = AppColors.pink; }
    if (!revealed && selected) { bg = AppColors.primaryBlue.withValues(alpha: 0.15); border = AppColors.primaryBlue; }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: AppRadius.circular(AppRadius.xl),
          border: Border.all(color: border, width: 2),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: border,
              child: Text(text.isEmpty ? '?' : text[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Text(text, style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary))),
          ],
        ),
      ),
    );
  }
}

class QuizResultV3 extends StatelessWidget {
  final int score;
  final int total;
  const QuizResultV3({super.key, required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.emoji_events_rounded, size: 72, color: AppColors.primaryYellow),
          const SizedBox(height: AppSpacing.lg),
          Text('$score / $total', style: AppTextStyles.displayLarge.copyWith(color: AppColors.primaryBlue)),
          Text('Quiz Complete', style: AppTextStyles.titleMedium),
        ],
      ),
    );
  }
}
