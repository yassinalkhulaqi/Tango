import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Code editor pane with a header bar and a monospace input area.
class EditorPaneV3 extends StatelessWidget {
  final TextEditingController controller;
  final String language;
  const EditorPaneV3({super.key, required this.controller, required this.language});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF070A0F),
        borderRadius: AppRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: const BoxDecoration(
              color: Color(0xFF0F141C),
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              children: [
                const Icon(Icons.code_rounded, color: AppColors.primaryYellow, size: 16),
                const SizedBox(width: AppSpacing.sm),
                Text(language, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted)),
              ],
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: null,
              expands: true,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 14, color: AppColors.textPrimary, height: 1.5),
              decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.all(16)),
            ),
          ),
        ],
      ),
    );
  }
}

/// Output console pane that shows run results or a placeholder.
class OutputPaneV3 extends StatelessWidget {
  final String output;
  const OutputPaneV3({super.key, required this.output});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF05070A),
        borderRadius: AppRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: const BoxDecoration(
              color: Color(0xFF0F141C),
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: const Row(
              children: [
                Icon(Icons.terminal_rounded, color: AppColors.primaryCyan, size: 16),
                SizedBox(width: 8),
                Text('Output', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                output.isEmpty ? 'Run your code to see output here.' : output,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 13, color: AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
