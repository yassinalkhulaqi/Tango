import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/paged_repository.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/ui/app_states.dart';
import '../../data/course_catalog_repository.dart';
import '../../data/course_filters.dart';
import '../../data/courses_repository.dart';
import '../../domain/course_model.dart';
import '../widgets/course_card.dart';
import 'course_detail_page.dart';

class CoursesListPage extends ConsumerStatefulWidget {
  const CoursesListPage({super.key});

  @override
  ConsumerState<CoursesListPage> createState() => _CoursesListPageState();
}

class _CoursesListPageState extends ConsumerState<CoursesListPage> {
  final TextEditingController _search = TextEditingController();
  CourseQuery _query = const CourseQuery();
  List<Course> _courses = demoCourses;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _search.addListener(_onSearchChanged);
    _loadCourses();
  }

  @override
  void dispose() {
    _search.removeListener(_onSearchChanged);
    _search.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() => _query = _query.copyWith(search: _search.text));
  }

  Future<void> _loadCourses({bool refresh = false}) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final controller = ref.read(coursesPagedControllerProvider.notifier);
    if (refresh) {
      await controller.refresh();
    } else {
      await controller.loadFirst();
    }
    final result = ref.read(coursesPagedControllerProvider);
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _courses = result.items.isEmpty ? demoCourses : result.items;
      _error = result.status == PagedStatus.failure ? result.message : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final visible = filterCourses(_courses, _query);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildCategoryChips(),
            _buildProgressChips(),
            Expanded(child: _buildCoursesGrid(visible)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Courses',
            style: AppTextStyles.displayMedium.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Pick a skill and start building',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _search,
            style: AppTextStyles.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Search courses',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textMuted,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppColors.primaryBlue,
              ),
              suffixIcon: _search.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () => _search.clear(),
                      icon: const Icon(Icons.close_rounded),
                      color: AppColors.textSecondary,
                    ),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: AppRadius.circular(AppRadius.lg),
                borderSide: const BorderSide(color: AppColors.cardBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.circular(AppRadius.lg),
                borderSide: const BorderSide(color: AppColors.cardBorder),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    final categories = availableCategories(_courses);
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final category = categories[index];
          return _chip(
            label: category,
            active: _query.category == category,
            onTap: () =>
                setState(() => _query = _query.copyWith(category: category)),
          );
        },
      ),
    );
  }

  Widget _buildProgressChips() {
    const options = <CourseProgressFilter>[
      CourseProgressFilter.all,
      CourseProgressFilter.inProgress,
      CourseProgressFilter.completed,
      CourseProgressFilter.locked,
    ];
    const labels = <String>['All', 'In progress', 'Completed', 'Locked'];
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Wrap(
        spacing: AppSpacing.sm,
        children: [
          for (var i = 0; i < options.length; i++)
            _chip(
              label: labels[i],
              active: _query.progress == options[i],
              onTap: () => setState(
                () => _query = _query.copyWith(progress: options[i]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _chip({
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return FilterChip(
      label: Text(
        label,
        style: AppTextStyles.labelMedium.copyWith(
          color: active ? Colors.white : AppColors.textSecondary,
          fontSize: 12,
        ),
      ),
      selected: active,
      onSelected: (_) => onTap(),
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.primaryBlue,
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.circular(AppRadius.xxl),
        side: BorderSide(
          color: active ? AppColors.primaryBlue : AppColors.cardBorder,
        ),
      ),
    );
  }

  Widget _buildCoursesGrid(List<Course> visible) {
    if (_isLoading) return const AppLoadingView(message: 'Loading courses...');
    if (_error != null) {
      return AppErrorView(
        message: _error!,
        onRetry: () => _loadCourses(refresh: true),
      );
    }
    if (visible.isEmpty) {
      return const AppEmptyView(
        title: 'No courses found',
        message: 'Try a different search or filter.',
      );
    }
    return RefreshIndicator(
      onRefresh: () => _loadCourses(refresh: true),
      child: GridView.builder(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: visible.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.78,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
        ),
        itemBuilder: (context, index) {
          final course = visible[index];
          return CourseCard(
            course: course,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CourseDetailPage(course: course),
              ),
            ),
          );
        },
      ),
    );
  }
}
