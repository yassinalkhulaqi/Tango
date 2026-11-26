import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../domain/lesson_models.dart';

class LessonDiffWidget extends StatelessWidget {
  final CodeDiff diff;

  const LessonDiffWidget({super.key, required this.diff});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Original Code',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Your Code',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: _buildCodePanel(
                  title: 'Original',
                  code: diff.originalCode,
                  changes: diff.changes,
                  isOriginal: true,
                ),
              ),
              Container(
                width: 1,
                color: AppColors.cardBorder.withValues(alpha: 0.3),
                height: double.infinity,
              ),
              Expanded(
                child: _buildCodePanel(
                  title: 'Modified',
                  code: diff.modifiedCode,
                  changes: diff.changes,
                  isOriginal: false,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildChangeSummary(diff),
      ],
    );
  }

  Widget _buildCodePanel({
    required String title,
    required String code,
    required List<DiffChange> changes,
    required bool isOriginal,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFF070A0F),
        borderRadius: AppRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textMuted,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: changes.map((change) {
                  return _buildDiffLine(change, isOriginal);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiffLine(DiffChange change, bool isOriginal) {
    Color lineColor;
    String displayText;

    if (isOriginal) {
      switch (change.type) {
        case DiffType.unchanged:
          lineColor = AppColors.textSecondary;
          displayText = change.originalLine;
          break;
        case DiffType.removed:
          lineColor = AppColors.pink;
          displayText = '- ${change.originalLine}';
          break;
        case DiffType.added:
          lineColor = AppColors.cardBorder.withValues(alpha: 0.3);
          displayText = '  ';
          break;
        case DiffType.changed:
          lineColor = AppColors.pink;
          displayText = '- ${change.originalLine}';
          break;
      }
    } else {
      switch (change.type) {
        case DiffType.unchanged:
          lineColor = AppColors.textSecondary;
          displayText = change.modifiedLine;
          break;
        case DiffType.removed:
          lineColor = AppColors.cardBorder.withValues(alpha: 0.3);
          displayText = '  ';
          break;
        case DiffType.added:
          lineColor = AppColors.primaryGreen;
          displayText = '+ ${change.modifiedLine}';
          break;
        case DiffType.changed:
          lineColor = AppColors.primaryGreen;
          displayText = '+ ${change.modifiedLine}';
          break;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            child: Text(
              '${change.lineNumber}',
              style: AppTextStyles.codeFont.copyWith(
                color: AppColors.textMuted,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              displayText,
              style: TextStyle(
                fontFamily: 'FiraCode',
                fontSize: 12,
                color: lineColor,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChangeSummary(CodeDiff diff) {
    final added = diff.changes.where((c) => c.type == DiffType.added).length;
    final removed = diff.changes
        .where((c) => c.type == DiffType.removed)
        .length;
    final changed = diff.changes
        .where((c) => c.type == DiffType.changed)
        .length;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Changes Summary',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _buildSummaryItem(
                icon: Icons.add_circle_rounded,
                label: 'Added',
                value: '$added',
                color: AppColors.primaryGreen,
              ),
              const SizedBox(width: AppSpacing.md),
              _buildSummaryItem(
                icon: Icons.remove_circle_rounded,
                label: 'Removed',
                value: '$removed',
                color: AppColors.pink,
              ),
              const SizedBox(width: AppSpacing.md),
              _buildSummaryItem(
                icon: Icons.edit_rounded,
                label: 'Changed',
                value: '$changed',
                color: AppColors.primaryYellow,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: color,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class InlineDiffMarker extends StatelessWidget {
  final DiffType type;

  const InlineDiffMarker({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;

    switch (type) {
      case DiffType.added:
        color = AppColors.primaryGreen;
        icon = Icons.add_circle_rounded;
        break;
      case DiffType.removed:
        color = AppColors.pink;
        icon = Icons.remove_circle_rounded;
        break;
      case DiffType.changed:
        color = AppColors.primaryYellow;
        icon = Icons.edit_rounded;
        break;
      case DiffType.unchanged:
        color = AppColors.textMuted;
        icon = Icons.circle;
        break;
    }

    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1),
      ),
      child: Center(child: Icon(icon, color: color, size: 10)),
    );
  }
}

class SideBySideDiff extends StatelessWidget {
  final String originalCode;
  final String modifiedCode;

  const SideBySideDiff({
    super.key,
    required this.originalCode,
    required this.modifiedCode,
  });

  @override
  Widget build(BuildContext context) {
    final originalLines = originalCode.split('\n');
    final modifiedLines = modifiedCode.split('\n');
    final maxLines = originalLines.length > modifiedLines.length
        ? originalLines.length
        : modifiedLines.length;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                color: AppColors.surface,
                child: Text(
                  'Original',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                color: AppColors.surface,
                child: Text(
                  'Modified',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  color: const Color(0xFF070A0F),
                  child: ListView.builder(
                    itemCount: maxLines,
                    itemBuilder: (context, index) {
                      final line = index < originalLines.length
                          ? originalLines[index]
                          : '';
                      return _buildLine(
                        index + 1,
                        line,
                        AppColors.textSecondary,
                      );
                    },
                  ),
                ),
              ),
              Container(
                width: 1,
                color: AppColors.cardBorder.withValues(alpha: 0.3),
              ),
              Expanded(
                child: Container(
                  color: const Color(0xFF070A0F),
                  child: ListView.builder(
                    itemCount: maxLines,
                    itemBuilder: (context, index) {
                      final line = index < modifiedLines.length
                          ? modifiedLines[index]
                          : '';
                      return _buildLine(index + 1, line, AppColors.textPrimary);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLine(int number, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        children: [
          Container(
            width: 24,
            child: Text(
              '$number',
              style: AppTextStyles.codeFont.copyWith(
                color: AppColors.textMuted,
                fontSize: 11,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'FiraCode',
                fontSize: 12,
                color: color,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
