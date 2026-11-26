import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class CourseV3 {
  final String title;
  final String category;
  final int lessons;
  final double progress;
  final IconData icon;
  final Color color;
  final bool locked;

  const CourseV3({required this.title, required this.category, required this.lessons, required this.progress, required this.icon, required this.color, this.locked = false});
}

class CourseCardV3 extends StatelessWidget {
  final CourseV3 course;
  final VoidCallback onTap;
  const CourseCardV3({super.key, required this.course, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: course.locked ? null : onTap,
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.circular(AppRadius.xl),
          border: Border.all(color: course.locked ? AppColors.cardBorder : course.color.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: course.color.withValues(alpha: 0.12),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Center(child: Icon(course.icon, size: 40, color: course.locked ? AppColors.textMuted : course.color)),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.title, style: AppTextStyles.titleMedium.copyWith(fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text('${course.lessons} lessons', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, fontSize: 11)),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(value: course.progress, minHeight: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
