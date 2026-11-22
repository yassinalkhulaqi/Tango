import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Horizontal stepper showing lesson progress (done/current/locked).
class LessonStepperV3 extends StatelessWidget {
  final int total;
  final int current;
  const LessonStepperV3({super.key, this.total = 5, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final done = i < current;
        final active = i == current;
        return Expanded(
          child: Container(
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: done ? AppColors.primaryGreen : active ? AppColors.primaryBlue : AppColors.cardBorder,
              borderRadius: AppRadius.circular(AppRadius.md),
            ),
          ),
        );
      }),
    );
  }
}

/// Code block with line numbers and copy affordance.
class CodeBlockV3 extends StatelessWidget {
  final String code;
  final String label;
  const CodeBlockV3({super.key, required this.code, this.label = 'Code'});

  @override
  Widget build(BuildContext context) {
    final lines = code.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.titleMedium.copyWith(fontSize: 14)),
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: const Color(0xFF070A0F),
            borderRadius: AppRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lines.asMap().entries.map((e) => '${e.key + 1}').join('\n'),
                style: const TextStyle(fontFamily: 'monospace', color: AppColors.textMuted, fontSize: 13, height: 1.5),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: SelectableText(
                  code,
                  style: const TextStyle(fontFamily: 'monospace', color: AppColors.textPrimary, fontSize: 13, height: 1.5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
