import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final int lessonCount;
  final bool isLocked;

  const CategoryCard({
    super.key,
    required this.name,
    required this.icon,
    required this.color,
    required this.lessonCount,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isLocked ? AppColors.cardBorder : color.withValues(alpha: 0.2),
          width: isLocked ? 1 : 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isLocked
                      ? AppColors.surfaceLight
                      : color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: isLocked ? AppColors.textMuted : color,
                  size: 24,
                ),
              ),
              if (isLocked)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: const Icon(Icons.lock_rounded, size: 10, color: AppColors.textMuted),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: AppTextStyles.labelMedium.copyWith(
              fontSize: 12,
              color: isLocked ? AppColors.textMuted : AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            '$lessonCount lessons',
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 10,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
