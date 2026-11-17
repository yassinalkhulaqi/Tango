import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_shadows.dart';
import '../domain/course_model.dart';
import 'widgets/lesson_item.dart';

class CourseDetailPage extends StatelessWidget {
  final Course course;

  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            sliver: SliverToBoxAdapter(child: _buildHeader(context)),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            sliver: SliverToBoxAdapter(child: _buildProgressSection(context)),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            sliver: SliverToBoxAdapter(child: _buildLessonsSection(context)),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: AppSpacing.huge)),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220,
      floating: false,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.surface,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.all(AppSpacing.lg),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course.title,
              style: AppTextStyles.titleLarge.copyWith(fontSize: 20),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              course.category,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ],
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: course.isLocked
                ? const LinearGradient(colors: [Color(0xFF1E293B), Color(0xFF0F141C)])
                : LinearGradient(
                    colors: [
                      AppColors.primaryBlue.withValues(alpha: 0.25),
                      AppColors.surface,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          ),
          child: Center(
            child: Icon(
              _iconForCategory(course.category),
              size: 80,
              color: course.isLocked ? AppColors.textMuted : AppColors.primaryBlue,
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.bookmark_border_rounded, color: AppColors.textSecondary),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          course.subtitle,
          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            _buildStatChip('${course.lessonCount} lessons', Icons.menu_book_rounded),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('+${course.lessonCount * 50} XP', Icons.bolt_rounded),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('Beginner', Icons.school_rounded),
          ],
        ),
        if (course.isLocked) ...[
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.cardBorder.withValues(alpha: 0.5),
              borderRadius: AppRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.cardBorder, width: 1),
            ),
            child: Row(
              children: [
                const Icon(Icons.lock_outline_rounded, color: AppColors.textMuted, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Locked — ${course.unlockRequirement}',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: course.lessons.isNotEmpty
                  ? () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => LessonPlayerPage(lesson: course.lessons.first),
                        ),
                      )
                  : null,
              icon: const Icon(Icons.play_arrow_rounded, size: 20),
              label: const Text(
                'Start Learning',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shadowColor: AppColors.primaryBlue.withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.circular(AppRadius.xl),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circular(AppRadius.xxl),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primaryBlue, size: 16),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Progress',
          style: AppTextStyles.titleMedium.copyWith(fontSize: 17),
        ),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: AppRadius.circular(AppRadius.md),
          child: LinearProgressIndicator(
            value: course.progress / course.lessonCount.clamp(1, course.lessonCount),
            minHeight: 8,
            backgroundColor: AppColors.cardBorder,
            valueColor: const AlwaysStoppedAnimation(AppColors.primaryBlue),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${course.progress.toInt()} / ${course.lessonCount}',
              style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary),
            ),
            Text(
              '${(course.completionPercent * 100).round()}%',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLessonsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Lessons',
              style: AppTextStyles.titleMedium.copyWith(fontSize: 17),
            ),
            Text(
              '${course.lessons.length} lessons',
              style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: course.lessons.isNotEmpty ? course.lessons.length : 6,
          itemBuilder: (context, index) {
            if (course.lessons.isNotEmpty) {
              return LessonItem(
                lesson: course.lessons[index],
                index: index,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => LessonPlayerPage(lesson: course.lessons[index]),
                  ),
                ),
              );
            }
            return LessonItem(
              lesson: Lesson(
                id: 'lesson_$index',
                title: index == 0 ? 'Introduction to ${course.title}' : 'Lesson ${index + 1}',
                description: 'Start your ${course.category.toLowerCase()} journey',
                isLocked: index > 0,
                xpReward: 50,
              ),
              index: index,
              onTap: () {},
            );
          },
        ),
      ],
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

class LessonPlayerPage extends StatelessWidget {
  final Lesson lesson;

  const LessonPlayerPage({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(lesson.title, style: AppTextStyles.titleMedium),
        centerTitle: false,
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.description,
                    style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: AppRadius.circular(AppRadius.xl),
                      border: Border.all(color: AppColors.cardBorder, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.code_rounded, color: AppColors.primaryYellow, size: 20),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                'Code Example',
                                style: AppTextStyles.labelLarge.copyWith(color: AppColors.primaryYellow),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'print("Hello, CodeBro!")',
                          style: const TextStyle(
                            fontFamily: 'FiraCode',
                            fontSize: 14,
                            color: AppColors.textPrimary,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    lesson.title,
                    style: AppTextStyles.titleMedium.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'In this lesson you will learn the fundamentals of ${lesson.title.toLowerCase()}. '
                    'Complete the interactive exercises below to earn XP and level up.',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.7,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: const Border(top: BorderSide(color: AppColors.cardBorder, width: 1)),
              boxShadow: [AppShadows.soft],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lesson completed! +50 XP'),
                      backgroundColor: AppColors.green,
                    ),
                  );
                },
                icon: const Icon(Icons.check_rounded, size: 20),
                label: const Text(
                  'Mark Complete',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.circular(AppRadius.xl),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
