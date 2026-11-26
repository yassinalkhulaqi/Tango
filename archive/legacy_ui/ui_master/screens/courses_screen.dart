import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_gradients.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen>
    with TickerProviderStateMixin {
  String _filter = 'All';
  String _category = 'All';
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.md),
                      _buildHeader(),
                      const SizedBox(height: AppSpacing.xxl),
                      _buildFilterChips(),
                      const SizedBox(height: AppSpacing.xxl),
                      _buildSectionHeader('Featured Courses', 'See All'),
                      const SizedBox(height: AppSpacing.md),
                      _buildFeaturedGrid(),
                      const SizedBox(height: AppSpacing.xxl),
                      _buildSectionHeader('In Progress', 'Continue'),
                      const SizedBox(height: AppSpacing.md),
                      _buildInProgressList(),
                      const SizedBox(height: AppSpacing.xxl),
                      _buildSectionHeader('By Category', 'Browse All'),
                      const SizedBox(height: AppSpacing.md),
                      _buildCategoryGrid(),
                      const SizedBox(height: AppSpacing.xxl),
                    ],
                  ),
                ),
              ),
              _buildBottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: AppGradients.primary,
                  borderRadius: AppRadius.circular(AppRadius.md),
                  boxShadow: [
                    AppGradients.glow(AppColors.primaryBlue, blurRadius: 12),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.menu_book_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              const Text(
                'Courses',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.cardBorder, width: 1),
            ),
            child: const Icon(
              Icons.filter_list_rounded,
              color: AppColors.textSecondary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pick a skill',
          style: AppTextStyles.displayMedium.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Start learning from our curated course catalog',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.circular(AppRadius.xl),
            border: Border.all(color: AppColors.cardBorder, width: 1),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.search_rounded,
                color: AppColors.textMuted,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search courses...',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Filter',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
            Text(
              'Clear All',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildFilterChip(
                label: 'All',
                isSelected: _filter == 'All',
                onTap: () => setState(() => _filter = 'All'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildFilterChip(
                label: 'In Progress',
                isSelected: _filter == 'In Progress',
                onTap: () => setState(() => _filter = 'In Progress'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildFilterChip(
                label: 'Completed',
                isSelected: _filter == 'Completed',
                onTap: () => setState(() => _filter = 'Completed'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildFilterChip(
                label: 'Saved',
                isSelected: _filter == 'Saved',
                onTap: () => setState(() => _filter = 'Saved'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        Row(
          children: [
            Expanded(
              child: _buildFilterChip(
                label: 'All Categories',
                isSelected: _category == 'All',
                onTap: () => setState(() => _category = 'All'),
                icon: Icons.category_rounded,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildFilterChip(
                label: 'Flutter',
                isSelected: _category == 'Flutter',
                onTap: () => setState(() => _category = 'Flutter'),
                icon: Icons.phone_android_rounded,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildFilterChip(
                label: 'Python',
                isSelected: _category == 'Python',
                onTap: () => setState(() => _category = 'Python'),
                icon: Icons.code_rounded,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildFilterChip(
                label: 'Web',
                isSelected: _category == 'Web',
                onTap: () => setState(() => _category = 'Web'),
                icon: Icons.language_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppMotion.fast,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : AppColors.surface,
          borderRadius: AppRadius.circular(AppRadius.xxl),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.cardBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                size: 16,
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.titleLarge.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              Text(
                action,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.primaryBlue,
                size: 12,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedGrid() {
    final courses = [
      {
        'title': 'Flutter Fundamentals',
        'category': 'Flutter',
        'lessons': 24,
        'progress': 0.5,
        'color': AppColors.primaryBlue,
        'icon': Icons.phone_android_rounded,
        'locked': false,
      },
      {
        'title': 'Python 101',
        'category': 'Python',
        'lessons': 18,
        'progress': 0.33,
        'color': AppColors.primaryYellow,
        'icon': Icons.code_rounded,
        'locked': false,
      },
      {
        'title': 'Web Development',
        'category': 'Web Dev',
        'lessons': 30,
        'progress': 0.0,
        'color': AppColors.primaryPurple,
        'icon': Icons.language_rounded,
        'locked': false,
      },
      {
        'title': 'Cybersecurity',
        'category': 'Security',
        'lessons': 12,
        'progress': 0.0,
        'color': AppColors.primaryGreen,
        'icon': Icons.security_rounded,
        'locked': false,
      },
      {
        'title': 'AI / Machine Learning',
        'category': 'AI/ML',
        'lessons': 9,
        'progress': 0.0,
        'color': AppColors.primaryCyan,
        'icon': Icons.psychology_rounded,
        'locked': true,
      },
      {
        'title': 'Game Development',
        'category': 'Game Dev',
        'lessons': 15,
        'progress': 0.0,
        'color': AppColors.primaryOrange,
        'icon': Icons.games_rounded,
        'locked': true,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: courses.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.78,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemBuilder: (context, index) {
        final c = courses[index];
        return _buildCourseCard(
          title: c['title'] as String,
          category: c['category'] as String,
          lessons: c['lessons'] as int,
          progress: c['progress'] as double,
          color: c['color'] as Color,
          icon: c['icon'] as IconData,
          locked: c['locked'] as bool,
        );
      },
    );
  }

  Widget _buildCourseCard({
    required String title,
    required String category,
    required int lessons,
    required double progress,
    required Color color,
    required IconData icon,
    required bool locked,
  }) {
    return Container(
      width: 170,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.circular(AppRadius.xl),
        border: Border.all(
          color: locked ? AppColors.cardBorder : AppColors.divider,
          width: 1,
        ),
        boxShadow: [AppGradients.cardShadow()],
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
                    gradient: locked
                        ? const LinearGradient(
                            colors: [
                              Color(0xFF1E293B),
                              Color(0xFF0F141C),
                            ],
                          )
                        : LinearGradient(
                            colors: [
                              color.withValues(alpha: 0.15),
                              AppColors.surface,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      size: 40,
                      color: locked ? AppColors.textMuted : color,
                    ),
                  ),
                ),
                if (locked)
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
                      '${(progress * 100).round()}%',
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
                  title,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: locked ? AppColors.textMuted : AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  category,
                  style: AppTextStyles.labelMedium.copyWith(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '$lessons lessons',
                  style: AppTextStyles.bodyMedium.copyWith(
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
    );
  }

  Widget _buildInProgressList() {
    final courses = [
      {
        'title': 'Flutter Fundamentals',
        'category': 'Flutter',
        'progress': 0.5,
        'lastAccessed': '2 hours ago',
        'color': AppColors.primaryBlue,
        'icon': Icons.phone_android_rounded,
      },
      {
        'title': 'Python 101',
        'category': 'Python',
        'progress': 0.33,
        'lastAccessed': '1 day ago',
        'color': AppColors.primaryYellow,
        'icon': Icons.code_rounded,
      },
      {
        'title': 'Web Development',
        'category': 'Web Dev',
        'progress': 0.1,
        'lastAccessed': '3 days ago',
        'color': AppColors.primaryPurple,
        'icon': Icons.language_rounded,
      },
    ];

    return Column(
      children: List.generate(courses.length, (index) {
        final c = courses[index];
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.circular(AppRadius.xl),
            border: Border.all(color: AppColors.cardBorder, width: 1),
            boxShadow: [AppGradients.cardShadow()],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: c['color'].withValues(alpha: 0.15),
                  borderRadius: AppRadius.circular(AppRadius.md),
                ),
                child: Center(
                  child: Icon(
                    c['icon'] as IconData,
                    color: c['color'],
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            c['title'] as String,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withValues(alpha: 0.15),
                            borderRadius: AppRadius.circular(AppRadius.xxl),
                          ),
                          child: Text(
                            '${(c['progress'] as double * 100).round()}%',
                            style: const TextStyle(
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      c['category'] as String,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Last accessed ${c['lastAccessed']}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: AppGradients.primary,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCategoryGrid() {
    final categories = [
      {'name': 'Flutter', 'icon': Icons.phone_android_rounded, 'color': AppColors.primaryBlue, 'count': 24},
      {'name': 'Python', 'icon': Icons.code_rounded, 'color': AppColors.primaryYellow, 'count': 18},
      {'name': 'Security', 'icon': Icons.security_rounded, 'color': AppColors.primaryGreen, 'count': 12},
      {'name': 'Web Dev', 'icon': Icons.language_rounded, 'color': AppColors.primaryPurple, 'count': 30},
      {'name': 'AI/ML', 'icon': Icons.psychology_rounded, 'color': AppColors.primaryCyan, 'count': 9},
      {'name': 'Game Dev', 'icon': Icons.games_rounded, 'color': AppColors.primaryOrange, 'count': 15},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemBuilder: (context, index) {
        final c = categories[index];
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.circular(AppRadius.xl),
            border: Border.all(color: AppColors.cardBorder, width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: c['color'].withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    c['icon'] as IconData,
                    color: c['color'],
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                c['name'] as String,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${c['count']} courses',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigation() {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Home', 'color': AppColors.primaryGreen},
      {'icon': Icons.menu_book_rounded, 'label': 'Courses', 'color': AppColors.primaryBlue},
      {'icon': Icons.terminal_rounded, 'label': 'Code', 'color': AppColors.primaryOrange},
      {'icon': Icons.leaderboard_rounded, 'label': 'League', 'color': AppColors.primaryPurple},
      {'icon': Icons.person_rounded, 'label': 'Profile', 'color': AppColors.primaryCyan},
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.cardBorder, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isActive = index == 1;
              return GestureDetector(
                onTap: () {},
                child: AnimatedContainer(
                  duration: AppMotion.normal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? item['color'].withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: AppRadius.circular(AppRadius.md),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        color: isActive
                            ? item['color'] as Color
                            : AppColors.textMuted,
                        size: 22,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['label'] as String,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: isActive
                              ? item['color'] as Color
                              : AppColors.textMuted,
                          fontWeight:
                              isActive ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
