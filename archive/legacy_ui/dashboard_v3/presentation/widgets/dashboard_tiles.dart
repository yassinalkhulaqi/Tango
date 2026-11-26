import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Quick-stat tile for the dashboard's stats row.
class QuickStatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const QuickStatTile({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: AppSpacing.sm),
            Text(value, style: AppTextStyles.titleLarge.copyWith(color: AppColors.textPrimary)),
            Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

/// Greeting header with level badge.
class DashboardGreeting extends StatelessWidget {
  final String greeting;
  final String name;
  final String level;
  final String avatar;

  const DashboardGreeting({
    super.key,
    required this.greeting,
    required this.name,
    required this.level,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.primaryBlue,
          child: Text(avatar, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(greeting, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, fontSize: 12)),
              Text(name, style: AppTextStyles.titleLarge.copyWith(color: AppColors.textPrimary)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primaryYellow.withValues(alpha: 0.15),
            borderRadius: AppRadius.circular(AppRadius.xxl),
            border: Border.all(color: AppColors.primaryYellow.withValues(alpha: 0.3)),
          ),
          child: Text(level, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryYellow, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
