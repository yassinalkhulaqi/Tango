import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../domain/lesson_models.dart';
import '../../domain/lesson_controller.dart';
import '../widgets/code_editor_widget.dart';
import '../widgets/lesson_content_widget.dart';
import '../widgets/quiz_embedded_widget.dart';
import '../widgets/lesson_progress_widget.dart';
import '../widgets/lesson_navigation_widget.dart';
import '../widgets/lesson_completion_widget.dart';
import '../widgets/lesson_diff_widget.dart';

class LessonPlayerScreen extends StatefulWidget {
  final String lessonId;

  const LessonPlayerScreen({super.key, required this.lessonId});

  @override
  State<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends State<LessonPlayerScreen>
    with TickerProviderStateMixin {
  late LessonController _controller;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _showDiff = false;

  @override
  void initState() {
    super.initState();
    final lesson = LessonDataService.getLessonById(widget.lessonId);
    final progress = LessonProgress(
      lessonId: lesson.id,
      currentSectionIndex: 0,
      sectionCompletion: {},
      quizAnswers: {},
      xpEarned: 0,
      isCompleted: false,
    );
    _controller = LessonController(lesson: lesson, progress: progress);
    _fadeController = AnimationController(
      vsync: this,
      duration: AppMotion.smooth,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Consumer<LessonController>(
        builder: (context, controller, child) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Stack(
              children: [
                const GradientBackground(),
                SafeArea(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        _buildHeader(controller),
                        Expanded(child: _buildBody(controller)),
                        _buildBottomBar(controller),
                      ],
                    ),
                  ),
                ),
                if (_showDiff) _buildDiffOverlay(context, controller),
                if (controller.isMarkingComplete)
                  _buildCompletionOverlay(controller),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(LessonController controller) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 44,
                height: 44,
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
                    size: 24,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Icon(
                  Icons.close_rounded,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            controller.lesson.title,
            style: AppTextStyles.displayMedium.copyWith(
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${controller.lesson.category} • Level ${controller.lesson.level} • ${controller.lesson.estimatedMinutes} min',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          LessonProgressWidget(
            progress: controller.sectionProgress,
            completed: controller.completedSections,
            total: controller.lesson.totalSections,
          ),
        ],
      ),
    );
  }

  Widget _buildBody(LessonController controller) {
    final section = controller.currentSection;

    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
                      '${controller.currentSectionIndex + 1}',
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
                        section.title,
                        style: AppTextStyles.titleLarge.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        section.content,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            _buildSectionContent(controller, section),
            const SizedBox(height: AppSpacing.xxl),
            if (section.explanation.isNotEmpty)
              _buildExplanationBox(section.explanation),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionContent(
    LessonController controller,
    LessonSection section,
  ) {
    switch (section.type) {
      case SectionType.code:
      case SectionType.interactive:
        return CodeEditorWidget(
          initialCode: section.codeExample,
          onCodeChanged: controller.setCode,
          onRunPressed: controller.runCode,
          isRunning: controller.isRunningCode,
          output: controller.codeOutput,
        );
      case SectionType.quiz:
        return QuizEmbeddedWidget(
          question: controller.currentQuizQuestion!,
          selectedAnswer: controller.selectedQuizAnswer,
          showResult: controller.showQuizResult,
          onAnswerSelected: controller.selectQuizAnswer,
          onNext: controller.nextQuizQuestion,
          isSubmitting: controller.isSubmittingQuiz,
        );
      case SectionType.theory:
        return LessonContentWidget(
          content: section.content,
          codeExample: section.codeExample,
          explanation: section.explanation,
        );
      case SectionType.challenge:
        return _buildChallengeSection(controller);
      case SectionType.summary:
        return _buildSummarySection(controller);
    }
  }

  Widget _buildChallengeSection(LessonController controller) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: AppGradients.reward,
        borderRadius: AppRadius.circular(AppRadius.xxl),
        boxShadow: [AppGradients.glow(AppColors.primaryYellow, blurRadius: 20)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flag_rounded, color: Colors.white, size: 24),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Challenge: Fix the Code',
                      style: AppTextStyles.titleLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Find and fix the bug in the code below',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          CodeEditorWidget(
            initialCode: 'void main() {\n  print(\\"Helo World\\");\n}',
            onCodeChanged: controller.setCode,
            onRunPressed: controller.runCode,
            isRunning: controller.isRunningCode,
            output: controller.codeOutput,
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: PremiumLessonButton(
              text: 'Submit Solution',
              onPressed: () {
                setState(() => _showDiff = true);
              },
              gradient: AppGradients.neonGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(LessonController controller) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.circular(AppRadius.xxl),
        border: Border.all(color: AppColors.cardBorder, width: 1),
        boxShadow: [AppGradients.cardShadow()],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.summary_rounded,
                color: AppColors.primaryBlue,
                size: 24,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Lesson Complete',
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildSummaryItem(
            icon: Icons.check_circle_rounded,
            label: 'Sections Completed',
            value:
                '${controller.completedSections} / ${controller.lesson.totalSections}',
            color: AppColors.primaryGreen,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildSummaryItem(
            icon: Icons.bolt_rounded,
            label: 'XP Reward',
            value: '+${controller.lesson.xpReward} XP',
            color: AppColors.primaryYellow,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildSummaryItem(
            icon: Icons.access_time_rounded,
            label: 'Time Spent',
            value: '${controller.lesson.estimatedMinutes} min',
            color: AppColors.primaryCyan,
          ),
          const SizedBox(height: AppSpacing.xxl),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: PremiumLessonButton(
              text: controller.lesson.isCompleted
                  ? 'Review Lesson'
                  : 'Mark Complete & Earn XP',
              onPressed: controller.markLessonComplete,
              gradient: AppGradients.primary,
              isLoading: controller.isMarkingComplete,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
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
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExplanationBox(String explanation) {
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
              explanation,
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

  Widget _buildBottomBar(LessonController controller) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(
          top: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
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
          if (controller.currentSectionIndex > 0)
            Expanded(
              child: SizedBox(
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: controller.previousSection,
                  icon: const Icon(Icons.arrow_back_rounded, size: 20),
                  label: const Text('Previous'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.cardBorder),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.circular(AppRadius.xl),
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 52,
              child: PremiumLessonButton(
                text: controller.isLastSection
                    ? controller.lesson.isCompleted
                          ? 'Review Lesson'
                          : 'Complete Lesson'
                    : 'Next Section',
                onPressed: controller.nextSection,
                gradient: AppGradients.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiffOverlay(BuildContext context, LessonController controller) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.8),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Code Comparison',
                    style: AppTextStyles.titleLarge.copyWith(fontSize: 20),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _showDiff = false),
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: LessonDiffWidget(
                  diff: controller.getCodeDiff(
                    'void main() {\n  print("Hello World");\n}',
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: PremiumLessonButton(
                  text: 'Close Comparison',
                  onPressed: () => setState(() => _showDiff = false),
                  gradient: AppGradients.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompletionOverlay(LessonController controller) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.85),
        child: SafeArea(
          child: Center(
            child: LessonCompletionWidget(
              xpEarned: controller.lesson.xpReward,
              onClose: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class PremiumLessonButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final LinearGradient gradient;

  const PremiumLessonButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.gradient = AppGradients.primary,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    return AnimatedContainer(
      duration: AppMotion.fast,
      decoration: BoxDecoration(
        gradient: enabled ? gradient : null,
        color: enabled ? null : AppColors.cardBorder.withValues(alpha: 0.4),
        borderRadius: AppRadius.circular(AppRadius.xl),
        boxShadow: enabled
            ? [AppGradients.glow(AppColors.primaryBlue, blurRadius: 20)]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppRadius.circular(AppRadius.xl),
          onTap: enabled ? onPressed : null,
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : Text(
                    text,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF070A0F), Color(0xFF0C111A), Color(0xFF080D14)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
