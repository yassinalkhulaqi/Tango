import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_gradients.dart';

class LessonScreen extends StatefulWidget {
  final String lessonId;

  const LessonScreen({super.key, required this.lessonId});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen>
    with TickerProviderStateMixin {
  int _currentSection = 0;
  bool _showSidebar = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> _sections = [
    {
      'title': 'Introduction',
      'type': 'theory',
      'completed': true,
      'content':
          'Flutter is Google\\'s UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.',
      'code': 'void main() {\n  runApp(const MyApp());\n}',
    },
    {
      'title': 'Widgets',
      'type': 'code',
      'completed': true,
      'content':
          'Everything in Flutter is a widget. Widgets are the building blocks of your app\\'s user interface.',
      'code': 'class MyApp extends StatelessWidget {\n  @override\n  Widget build(BuildContext context) {\n    return MaterialApp(\n      home: Scaffold(\n        body: Center(child: Text(\\'Hello Flutter!\\')),\n      ),\n    );\n  }\n}',
    },
    {
      'title': 'State Management',
      'type': 'interactive',
      'completed': false,
      'current': true,
      'content':
          'Learn how to manage state with StatefulWidget and create interactive UIs that respond to user input.',
      'code': 'class CounterWidget extends StatefulWidget {\n  @override\n  _CounterWidgetState createState() => _CounterWidgetState();\n}\n\nclass _CounterWidgetState extends State<CounterWidget> {\n  int _count = 0;\n  void _increment() => setState(() => _count++);\n}',
    },
    {
      'title': 'Quiz',
      'type': 'quiz',
      'completed': false,
      'content': 'Test your understanding of Flutter basics.',
      'code': '',
    },
    {
      'title': 'Summary',
      'type': 'summary',
      'completed': false,
      'content': 'You\\'ve learned the basics of Flutter! Continue to the next lesson.',
      'code': '',
    },
  ];

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

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Offset(-1.0, 0.0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _toggleSidebar() {
    setState(() => _showSidebar = !_showSidebar);
    if (_showSidebar) {
      _slideController.forward();
    } else {
      _slideController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Row(
          children: [
            if (_showSidebar)
              SlideTransition(
                position: _slideAnimation,
                child: _buildSidebar(),
              ),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    _buildTopBar(),
                    Expanded(
                      child: _buildBody(),
                    ),
                    _buildBottomBar(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleSidebar,
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(
          Icons.menu_rounded,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(
          right: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(4, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: AppGradients.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'L',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Lesson Outline',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _toggleSidebar,
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _sections.length,
                itemBuilder: (context, index) {
                  final section = _sections[index];
                  final isCompleted = section['completed'] as bool;
                  final isCurrent = section['current'] as bool ?? false;
                  return ListTile(
                    leading: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppColors.primaryGreen
                            : isCurrent
                                ? AppColors.primaryBlue
                                : AppColors.cardBorder,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: isCompleted
                            ? const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 16,
                              )
                                : Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13,
                                    ),
                                  ),
                    ),
                  ),
                  title: Text(
                    section['title'] as String,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isCurrent
                          ? AppColors.primaryBlue
                          : AppColors.textPrimary,
                    ),
                  ),
                  trailing: isCompleted
                      ? const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.primaryGreen,
                          size: 20,
                        )
                      : null,
                    onTap: () {
                      setState(() {
                        _currentSection = index;
                        _showSidebar = false;
                      });
                      _slideController.reverse();
                    },
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Progress',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ClipRRect(
                    borderRadius: AppRadius.circular(AppRadius.md),
                    child: LinearProgressIndicator(
                      value: 0.6,
                      minHeight: 8,
                      backgroundColor: AppColors.cardBorder,
                      valueColor: const AlwaysStoppedAnimation(AppColors.primaryBlue),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '60% Complete',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
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
                    Icons.school_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              const Text(
                'Lesson Player',
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
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.bookmark_border_rounded,
                  color: AppColors.textSecondary,
                  size: 22,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.textSecondary,
                  size: 22,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final section = _sections[_currentSection];
    final isCurrent = section['current'] as bool ?? false;
    final isCompleted = section['completed'] as bool;

    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${_currentSection + 1}',
                      style: const TextStyle(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        section['title'] as String,
                        style: AppTextStyles.titleLarge.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${_sections[_currentSection]['type']} • Section ${_currentSection + 1} of ${_sections.length}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    if (_currentSection > 0)
                      IconButton(
                        onPressed: () => setState(() => _currentSection--),
                        icon: const Icon(
                          Icons.chevron_left_rounded,
                          color: AppColors.primaryBlue,
                          size: 22,
                        ),
                      ),
                    if (_currentSection < _sections.length - 1)
                      IconButton(
                        onPressed: () => setState(() => _currentSection++),
                        icon: const Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.primaryBlue,
                          size: 22,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            if (section['type'] == 'theory') ...[
              _buildTheorySection(section),
            ] else if (section['type'] == 'code') ...[
              _buildCodeSection(section),
            ] else if (section['type'] == 'interactive') ...[
              _buildInteractiveSection(section),
            ] else if (section['type'] == 'quiz') ...[
              _buildQuizSection(section),
            ] else if (section['type'] == 'summary') ...[
              _buildSummarySection(section),
            ],
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildTheorySection(Map<String, dynamic> section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section['content'] as String,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
            height: 1.7,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        _buildCodeBlock(section['code'] as String),
        const SizedBox(height: AppSpacing.xxl),
        _buildExplanationBox(
          'The main function is the entry point of every Dart application. '
          'runApp() inflates the given widget and attaches it to the screen.',
        ),
      ],
    );
  }

  Widget _buildCodeSection(Map<String, dynamic> section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section['content'] as String,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
            height: 1.7,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildCodeBlock(section['code'] as String),
        const SizedBox(height: AppSpacing.xxl),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildInteractiveSection(Map<String, dynamic> section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section['content'] as String,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
            height: 1.7,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.circular(AppRadius.xl),
            border: Border.all(color: AppColors.cardBorder, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Interactive Exercise',
                style: AppTextStyles.titleMedium.copyWith(fontSize: 16),
              ),
              const SizedBox(height: AppSpacing.md),
              _buildCodeBlock(section['code'] as String),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: const Text(
                    'Check Solution',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.circular(AppRadius.xl),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildQuizSection(Map<String, dynamic> section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section['content'] as String,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
            height: 1.7,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        ...List.generate(3, (index) {
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.circular(AppRadius.xl),
              border: Border.all(color: AppColors.cardBorder, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question ${index + 1}',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'What is the entry point of a Dart application?',
                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.md),
                ...List.generate(4, (optIndex) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: BorderSide(color: AppColors.cardBorder, width: 1),
                        backgroundColor: AppColors.surfaceLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.circular(AppRadius.md),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: AppColors.cardBorder,
                                borderRadius: AppRadius.circular(AppRadius.sm),
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + optIndex),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Text(
                                ['start()', 'main()', 'init()', 'run()'][optIndex],
                                style: AppTextStyles.bodyLarge.copyWith(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSummarySection(Map<String, dynamic> section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section['content'] as String,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
            height: 1.7,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            gradient: AppGradients.reward,
            borderRadius: AppRadius.circular(AppRadius.xxl),
            boxShadow: [
              AppGradients.glow(AppColors.primaryYellow, blurRadius: 20),
            ],
          ),
          child: Column(
            children: [
              const Icon(
                Icons.celebration_rounded,
                color: Colors.white,
                size: 48,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Lesson Complete!',
                style: AppTextStyles.titleLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'You\\'ve mastered Flutter basics. Great job!',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      icon: Icons.check_circle_rounded,
                      label: 'Lessons',
                      value: '5',
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      icon: Icons.bolt_rounded,
                      label: 'XP Earned',
                      value: '+50 XP',
                      color: AppColors.primaryYellow,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      icon: Icons.local_fire_department_rounded,
                      label: 'Streak',
                      value: '12 days',
                      color: AppColors.primaryOrange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.background,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.circular(AppRadius.xl),
                    ),
                  ),
                  child: const Text(
                    'Next Lesson',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCodeBlock(String code) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF070A0F),
        borderRadius: AppRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.cardBorder, width: 1),
        boxShadow: [AppGradients.cardShadow()],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF0F141C),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.code_rounded,
                  color: AppColors.primaryYellow,
                  size: 16,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'main.dart',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.copy_rounded,
                    color: AppColors.textMuted,
                    size: 18,
                  ),
                  tooltip: 'Copy code',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(
              code,
              style: const TextStyle(
                fontFamily: 'FiraCode',
                fontSize: 14,
                color: AppColors.textPrimary,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExplanationBox(String text) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.lightbulb_rounded,
            color: AppColors.primaryYellow,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              side: BorderSide(color: AppColors.cardBorder, width: 1),
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.circular(AppRadius.xl),
              ),
            ),
            child: const Text(
              'Reset Code',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: SizedBox(
            height: 44,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.play_arrow_rounded,
                size: 18,
                color: Colors.white,
              ),
              label: const Text(
                'Run Code',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
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
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Center(child: Icon(icon, color: color, size: 16)),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          value,
          style: AppTextStyles.labelLarge.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textSecondary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
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
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _currentSection > 0 ? () => setState(() => _currentSection--) : null,
              icon: const Icon(Icons.arrow_back_rounded, size: 20),
              label: const Text('Previous'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                side: BorderSide(color: AppColors.cardBorder, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.circular(AppRadius.xl),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 44,
              child: ElevatedButton(
                onPressed: _currentSection < _sections.length - 1
                    ? () => setState(() => _currentSection++)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.circular(AppRadius.xl),
                  ),
                ),
                child: const Text(
                  'Next Section',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
