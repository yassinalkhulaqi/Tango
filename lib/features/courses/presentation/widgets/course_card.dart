import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_shadows.dart';
import '../domain/course_model.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onTap;

  const CourseCard({super.key, required this.course, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 170,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.circular(AppRadius.xl),
          border: Border.all(
            color: course.isLocked ? AppColors.cardBorder : AppColors.divider,
            width: 1,
          ),
          boxShadow: [AppShadows.soft],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: AppRadius.circular(AppRadius.xl),
                      gradient: course.isLocked
                          ? const LinearGradient(
                              colors: [Color(0xFF1E293B), Color(0xFF0F141C)],
                            )
                          : LinearGradient(
                              colors: [
                                AppColors.primaryBlue.withValues(alpha: 0.15),
                                AppColors.surface,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                    ),
                    child: Center(
                      child: Icon(
                        _iconForCategory(course.category),
                        size: 40,
                        color: course.isLocked
                            ? AppColors.textMuted
                            : AppColors.primaryBlue,
                      ),
                    ),
                  ),
                  if (course.isLocked)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        borderRadius: AppRadius.circular(AppRadius.xl),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.lock_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryYellow,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(14),
                          topLeft: Radius.circular(14),
                        ),
                      ),
                      child: Text(
                        '${(course.completionPercent * 100).round()}%',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.background,
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: course.isLocked ? AppColors.textMuted : AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${course.lessonCount} lessons',
                    style: AppTextStyles.labelMedium.copyWith(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }

  IconData _iconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'flutter':
        return Icons.phone_android_rounded;
      case 'python':
        return Icons.code_rounded;
      case 'security':
        return Icons.security_rounded;
      case 'web dev':
      case 'webdev':
        return Icons.language_rounded;
      case 'ai / ml':
      case 'ai/ml':
        return Icons.psychology_rounded;
      default:
        return Icons.menu_book_rounded;
    }
  }
}
