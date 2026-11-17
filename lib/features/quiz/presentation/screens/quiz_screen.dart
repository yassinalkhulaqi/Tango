import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_gradients.dart';
import '../../ui_components/widgets/ui_component_library.dart';

class QuizScreen extends StatefulWidget {
  final List<Map<String, dynamic>> questions;

  const QuizScreen({super.key, required this.questions});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int? _selectedAnswer;
  bool _revealed = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _pulseAnimation = CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut);
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  bool get _isLast => _currentIndex == widget.questions.length - 1;

  void _selectAnswer(int index) {
    if (_revealed) return;
    setState(() {
      _selectedAnswer = index;
      _revealed = true;
    });
  }

  void _next() {
    if (_isLast) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => QuizResultScreen(questions: widget.questions)));
    } else {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _revealed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.questions[_currentIndex];
    final progress = (_currentIndex + 1) / widget.questions.length;
    final correctIndex = q['correctIndex'] as int;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(progress),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Question ${_currentIndex + 1} / ${widget.questions.length}', style: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.w700)),
                    const SizedBox(height: AppSpacing.md),
                    Text(q['question'], style: AppTextStyles.titleLarge.copyWith(fontSize: 20)),
                    const SizedBox(height: AppSpacing.xxl),
                    ...List.generate((q['options'] as List).length, (i) {
                      final isSelected = _selectedAnswer == i;
                      final isCorrect = i == correctIndex;
                      final isRevealed = _revealed;
                      return QuizOptionCard(
                        text: q['options'][i],
                        isSelected: isSelected,
                        isCorrect: isCorrect,
                        isRevealed: isRevealed,
                        onTap: () => _selectAnswer(i),
                      );
                    }),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            ),
            _buildActionBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double progress) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(bottom: BorderSide(color: AppColors.cardBorder, width: 1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Quiz', style: AppTextStyles.titleMedium.copyWith(fontSize: 18)),
              Text('${_currentIndex + 1} / ${widget.questions.length}', style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: AppRadius.circular(AppRadius.md),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.cardBorder,
              valueColor: const AlwaysStoppedAnimation(AppColors.primaryBlue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar() {
    final answered = _selectedAnswer != null;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.cardBorder, width: 1)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: PremiumButton(
          text: _isLast ? 'Finish Quiz' : 'Next',
          onPressed: answered ? _next : null,
        ),
      ),
    ),
    );
  }
}

class QuizResultScreen extends StatelessWidget {
  final List<Map<String, dynamic>> questions;

  const QuizResultScreen({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
    final correct = 3;
    final percent = correct / questions.length;
    final xp = correct * 10;
    final perfect = correct == questions.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.lg),
                    Text('Quiz Complete', style: AppTextStyles.displayMedium.copyWith(fontSize: 26)),
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.xxl),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppRadius.circular(AppRadius.xxl),
                        border: Border.all(color: AppColors.cardBorder, width: 1),
                        boxShadow: [AppGradients.cardShadow()],
                      ),
                      child: Column(
                        children: [
                          Text('${(percent * 100).round()}%', style: AppTextStyles.displayLarge.copyWith(color: perfect ? AppColors.primaryGreen : AppColors.primaryBlue)),
                          const SizedBox(height: AppSpacing.sm),
                          Text('$correct / ${questions.length} correct', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary)),
                          const SizedBox(height: AppSpacing.md),
                          Text('XP Earned: +$xp', style: AppTextStyles.labelLarge.copyWith(color: AppColors.primaryYellow, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    Text('Review Mistakes', style: AppTextStyles.titleMedium.copyWith(fontSize: 17)),
                    const SizedBox(height: AppSpacing.md),
                    ...List.generate(questions.length, (index) {
                      final q = questions[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: AppSpacing.md),
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: AppRadius.circular(AppRadius.lg),
                          border: Border.all(color: AppColors.cardBorder, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(q['question'], style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: AppSpacing.sm),
                            Text('Correct: ${q['options'][q['correctIndex']]}', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGreen)),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: AppSpacing.xxl),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: PremiumButton(text: 'Back to Courses', onPressed: () => Navigator.of(context).pop()),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizOptionCard extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool isRevealed;
  final VoidCallback onTap;

  const QuizOptionCard({super.key, required this.text, required this.isSelected, required this.isCorrect, required this.isRevealed, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color fill, border, textColor;
    if (isRevealed) {
      if (isCorrect) {
        fill = AppColors.primaryGreen.withValues(alpha: 0.15);
        border = AppColors.primaryGreen;
        textColor = AppColors.textPrimary;
      } else if (isSelected) {
        fill = AppColors.pink.withValues(alpha: 0.15);
        border = AppColors.pink;
        textColor = AppColors.textPrimary;
      } else {
        fill = AppColors.surface;
        border = AppColors.cardBorder;
        textColor = AppColors.textSecondary;
      }
    } else {
      fill = isSelected ? AppColors.primaryBlue.withValues(alpha: 0.15) : AppColors.surface;
      border = isSelected ? AppColors.primaryBlue : AppColors.cardBorder;
      textColor = AppColors.textPrimary;
    }

    return GestureDetector(
      onTap: isRevealed ? null : onTap,
      child: AnimatedContainer(
        duration: AppMotion.normal,
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: AppRadius.circular(AppRadius.xl),
          border: Border.all(color: border, width: 2),
          boxShadow: [AppGradients.cardShadow()],
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isRevealed && isCorrect ? AppColors.primaryGreen : isRevealed && isSelected ? AppColors.pink : isSelected ? AppColors.primaryBlue : AppColors.surfaceLight,
                shape: BoxShape.circle,
                border: Border.all(color: border, width: 2),
              ),
              child: Center(
                child: isRevealed && isCorrect
                    ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
                    : isRevealed && isSelected
                        ? const Icon(Icons.close_rounded, color: Colors.white, size: 18)
                        : null,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Text(text, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w500, color: textColor))),
          ],
        ),
      ),
    );
  }
}
