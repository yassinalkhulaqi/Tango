import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../domain/course_model.dart';
import '../widgets/course_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/courses_repository.dart';

class CoursesListPage extends ConsumerStatefulWidget {
  const CoursesListPage({super.key});

  @override
  ConsumerState<CoursesListPage> createState() => _CoursesListPageState();
}

class _CoursesListPageState extends ConsumerState<CoursesListPage> {
  String _filter = 'All';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    setState(() => _isLoading = true);
    final courses = await ref.read(coursesRepositoryProvider).fetchCourses();
    if (!mounted) return;
    setState(() {
      _allCourses = courses;
      _isLoading = false;
    });
  }

  List<Course> _allCourses = [
    Course(
      id: 'flutter-basics',
      title: 'Flutter Fundamentals',
      subtitle: 'Build beautiful cross-platform apps',
      category: 'Flutter',
      thumbnail: 'flutter',
      lessonCount: 24,
      progress: 12.0,
    ),
    Course(
      id: 'python-101',
      title: 'Python 101',
      subtitle: 'From zero to your first script',
      category: 'Python',
      thumbnail: 'python',
      lessonCount: 18,
      progress: 6.0,
    ),
    Course(
      id: 'web-dev',
      title: 'Web Development',
      subtitle: 'HTML, CSS, and modern JavaScript',
      category: 'Web Dev',
      thumbnail: 'web',
      lessonCount: 30,
      progress: 0.0,
    ),
    Course(
      id: 'security',
      title: 'Cybersecurity Essentials',
      subtitle: 'Protect systems and data',
      category: 'Security',
      thumbnail: 'security',
      lessonCount: 12,
      progress: 0.0,
    ),
    Course(
      id: 'ai-ml',
      title: 'AI / Machine Learning',
      subtitle: 'Intro to neural networks & models',
      category: 'AI / ML',
      thumbnail: 'ai',
      lessonCount: 9,
      progress: 0.0,
      isLocked: true,
      unlockRequirement: 'Reach Level 4',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildFilterChips(),
            Expanded(child: _buildCoursesGrid()),
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
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
              borderRadius: AppRadius.circular(AppRadius.md),
            ),
            child: const Icon(
              Icons.search_rounded,
              color: AppColors.primaryBlue,
              size: 22,
            ),
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
            label: Text(
              filters[index],
              style: AppTextStyles.labelMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            selected: isActive,
            onSelected: (_) => setState(() => _filter = filters[index]),
            backgroundColor: AppColors.surface,
            selectedColor: AppColors.primaryBlue,
            checkmarkColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.circular(AppRadius.xxl),
              side: BorderSide(
                color: isActive ? AppColors.primaryBlue : AppColors.cardBorder,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCoursesGrid() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final visibleCourses = _filter == 'All'
        ? _allCourses
        : _allCourses.where((c) {
            if (_filter == 'In Progress')
              return c.progress > 0 && c.progress < c.lessonCount;
            if (_filter == 'Completed') return c.progress >= c.lessonCount;
            if (_filter == 'Saved') return false;
            return true;
          }).toList();

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: GridView.builder(
        itemCount: visibleCourses.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.78,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
        ),
        itemBuilder: (context, index) {
          final course = visibleCourses[index];
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
