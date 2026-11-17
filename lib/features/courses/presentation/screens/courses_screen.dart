import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_gradients.dart';
import '../../ui_components/widgets/ui_component_library.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildFilterChips(),
            Expanded(
              child: _buildCoursesGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Courses', style: AppTextStyles.displayMedium.copyWith(fontSize: 28)),
                const SizedBox(height: AppSpacing.xs),
                Text('Pick a skill and start building', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
              borderRadius: AppRadius.circular(AppRadius.md),
            ),
            child: const Icon(Icons.search_rounded, color: AppColors.primaryBlue, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'In Progress', 'Completed', 'Saved'];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final isActive = _filter == filters[index];
          return FilterChip(
            label: Text(filters[index], style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w600, color: isActive ? Colors.white : AppColors.textSecondary, fontSize: 12)),
            selected: isActive,
            onSelected: (_) => setState(() => _filter = filters[index]),
            backgroundColor: AppColors.surface,
            selectedColor: AppColors.primaryBlue,
            checkmarkColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.circular(AppRadius.xxl),
              side: BorderSide(color: isActive ? AppColors.primaryBlue : AppColors.cardBorder),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCoursesGrid() {
    final courses = [
      {'title': 'Flutter Fundamentals', 'category': 'Flutter', 'lessons': 24, 'progress': 0.5, 'color': AppColors.primaryBlue, 'icon': Icons.phone_android_rounded, 'locked': false},
      {'title': 'Python 101', 'category': 'Python', 'lessons': 18, 'progress': 0.33, 'color': AppColors.primaryYellow, 'icon': Icons.code_rounded, 'locked': false},
      {'title': 'Web Development', 'category': 'Web Dev', 'lessons': 30, 'progress': 0.0, 'color': AppColors.primaryPurple, 'icon': Icons.language_rounded, 'locked': false},
      {'title': 'Cybersecurity Essentials', 'category': 'Security', 'lessons': 12, 'progress': 0.0, 'color': AppColors.primaryGreen, 'icon': Icons.security_rounded, 'locked': false},
      {'title': 'AI / Machine Learning', 'category': 'AI/ML', 'lessons': 9, 'progress': 0.0, 'color': AppColors.primaryCyan, 'icon': Icons.psychology_rounded, 'locked': true},
    ];

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: GridView.builder(
        itemCount: courses.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.78,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
        ),
        itemBuilder: (context, index) {
          final c = courses[index];
          return CourseCard(
            title: c['title'],
            category: c['category'],
            lessonCount: c['lessons'],
            progress: c['progress'],
            isLocked: c['locked'],
            icon: c['icon'],
            color: c['color'],
            onTap: () {},
          );
        },
      ),
    );
  }
}
