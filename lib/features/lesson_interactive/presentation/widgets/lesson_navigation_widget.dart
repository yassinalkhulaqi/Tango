import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_gradients.dart';

class LessonNavigationWidget extends StatelessWidget {
  final int currentSection;
  final int totalSections;
  final bool canGoPrevious;
  final bool canGoNext;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const LessonNavigationWidget({
    super.key,
    required this.currentSection,
    required this.totalSections,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(
          top: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${currentSection + 1} / $totalSections',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              SectionProgressIndicator(
                sectionStatus: List.generate(
                  totalSections,
                  (index) => index < currentSection,
                ),
                currentIndex: currentSection,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              if (canGoPrevious)
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: onPrevious,
                      icon: const Icon(Icons.arrow_back_rounded, size: 20),
                      label: const Text('Previous'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(color: AppColors.cardBorder),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.circular(AppRadius.xl),
                        ),
                      ),
                    ),
                  ),
                ),
              if (canGoPrevious) const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 52,
                  child: PremiumNavButton(
                    text: currentSection >= totalSections - 1
                        ? 'Complete Lesson'
                        : 'Next Section',
                    onPressed: canGoNext ? onNext : null,
                    isDisabled: !canGoNext,
                    gradient: AppGradients.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PremiumNavButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isDisabled;
  final LinearGradient gradient;

  const PremiumNavButton({
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

class SectionTabs extends StatelessWidget {
  final List<String> tabLabels;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const SectionTabs({
    super.key,
    required this.tabLabels,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabLabels.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onTabSelected(index),
            child: AnimatedContainer(
              duration: AppMotion.fast,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              margin: const EdgeInsets.only(right: AppSpacing.sm),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryBlue.withValues(alpha: 0.2)
                    : AppColors.surface,
                borderRadius: AppRadius.circular(AppRadius.xxl),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryBlue
                      : AppColors.cardBorder,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Text(
                tabLabels[index],
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isSelected
                      ? AppColors.primaryBlue
                      : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class LessonBreadcrumb extends StatelessWidget {
  final String category;
  final String lessonTitle;

  const LessonBreadcrumb({
    super.key,
    required this.category,
    required this.lessonTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          category,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.textMuted,
          size: 16,
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            lessonTitle,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
