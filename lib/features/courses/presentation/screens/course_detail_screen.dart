import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_gradients.dart';
import '../../ui_components/widgets/ui_component_library.dart';

class CourseDetailScreen extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverPadding(padding: const EdgeInsets.all(AppSpacing.lg), sliver: SliverToBoxAdapter(child: _buildHeader(context))),
          SliverPadding(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg), sliver: SliverToBoxAdapter(child: _buildProgressSection())),
          SliverPadding(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg), sliver: SliverToBoxAdapter(child: _buildLessonsSection())),
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
            Text(course['title'], style: AppTextStyles.titleLarge.copyWith(fontSize: 20)),
            const SizedBox(height: AppSpacing.xs),
            Text(course['category'], style: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.w700, fontSize: 11)),
          ],
        ),
        background: Container(
          decoration: BoxDecoration(gradient: LinearGradient(colors: [course['color'].withValues(alpha: 0.25), AppColors.surface], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          child: Center(child: Icon(course['icon'], size: 80, color: course['color'])),
        ),
      ),
      actions: [IconButton(icon: const Icon(Icons.bookmark_border_rounded, color: AppColors.textSecondary), onPressed: () {})],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(course['subtitle'] ?? 'Master this skill step by step', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            _buildStatChip('${course['lessons']} lessons', Icons.menu_book_rounded),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('+${course['lessons'] * 50} XP', Icons.bolt_rounded),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('Beginner', Icons.school_rounded),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: PremiumButton(text: 'Start Learning', onPressed: () {}, icon: Icons.play_arrow_rounded),
        ),
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
          Text(label, style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your Progress', style: AppTextStyles.titleMedium.copyWith(fontSize: 17)),
        const SizedBox(height: AppSpacing.sm),
        const XPProgressBar(value: 0.5),
        const SizedBox(height: AppSpacing.xs),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('12 / 24', style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary)),
            Text('50%', style: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.w700)),
          ],
        ),
      ],
    );
  }

  Widget _buildLessonsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Lessons', style: AppTextStyles.titleMedium.copyWith(fontSize: 17)),
            Text('24 lessons', style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 6,
          itemBuilder: (context, index) {
            return LessonItem(
              title: index == 0 ? 'Introduction to Flutter' : 'Lesson ${index + 1}',
              description: index == 0 ? 'Start your Flutter journey' : 'Build your skills',
              index: index,
              isCompleted: index < 2,
              isLocked: index > 2,
              onTap: () {},
            );
          },
        ),
      ],
    );
  }
}
