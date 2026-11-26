import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../domain/quiz_model.dart';
import '../widgets/quiz_option_card.dart';

class QuizPage extends StatefulWidget {
  final List<QuizQuestion> questions;

  const QuizPage({super.key, required this.questions});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentIndex = 0;
  final List<int?> _answers = [];

  @override
  void initState() {
    super.initState();
    _answers.addAll(List.filled(widget.questions.length, null));
  }

  void _selectAnswer(int optionIndex) {
    setState(() => _answers[_currentIndex] = optionIndex);
  }

  bool get _isLast => _currentIndex == widget.questions.length - 1;

  void _next() {
    if (_isLast) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              QuizResultPage(questions: widget.questions, answers: _answers),
        ),
      );
    } else {
      setState(() => _currentIndex++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[_currentIndex];
    final progress = (_currentIndex + 1) / widget.questions.length;

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
                    Text(
                      'Question ${_currentIndex + 1} / ${widget.questions.length}',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      question.question,
                      style: AppTextStyles.titleLarge.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    ...List.generate(question.options.length, (i) {
                      final selected = _answers[_currentIndex] == i;
                      return QuizOptionCard(
                        text: question.options[i],
                        isSelected: selected,
                        isCorrect: i == question.correctIndex,
                        isRevealed: _answers[_currentIndex] != null,
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
        border: const Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quiz',
                style: AppTextStyles.titleMedium.copyWith(fontSize: 18),
              ),
              Text(
                '${(_currentIndex + 1)} / ${widget.questions.length}',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
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
    final answered = _answers[_currentIndex] != null;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(
          top: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: answered ? _next : null,
          child: Text(_isLast ? 'Finish Quiz' : 'Next'),
        ),
      ),
    );
  }
}

class QuizResultPage extends StatelessWidget {
  final List<QuizQuestion> questions;
  final List<int?> answers;

  const QuizResultPage({
    super.key,
    required this.questions,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    final correct = answers.asMap().entries.where((e) {
      final idx = e.key;
      final ans = e.value;
      return ans != null && ans == questions[idx].correctIndex;
    }).length;
    final percent = questions.isEmpty ? 0.0 : correct / questions.length;
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
                    Text(
                      'Quiz Complete',
                      style: AppTextStyles.displayMedium.copyWith(fontSize: 26),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.xxl),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppRadius.circular(AppRadius.xxl),
                        border: Border.all(
                          color: AppColors.cardBorder,
                          width: 1,
                        ),
                        boxShadow: [AppShadows.soft],
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${(percent * 100).round()}%',
                            style: AppTextStyles.displayLarge.copyWith(
                              color: perfect
                                  ? AppColors.green
                                  : AppColors.primaryBlue,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            '$correct / ${questions.length} correct',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'XP Earned: +$xp',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.primaryYellow,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    if (!perfect) ...[
                      Text(
                        'Review Mistakes',
                        style: AppTextStyles.titleMedium.copyWith(fontSize: 17),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ...List.generate(questions.length, (i) {
                        final q = questions[i];
                        final a = answers[i];
                        final isWrong = a != null && a != q.correctIndex;
                        if (!isWrong) return const SizedBox.shrink();
                        return Container(
                          margin: const EdgeInsets.only(bottom: AppSpacing.md),
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: AppRadius.circular(AppRadius.lg),
                            border: Border.all(
                              color: AppColors.cardBorder,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                q.question,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                'Correct: ${q.options[q.correctIndex]}',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.green,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                    const SizedBox(height: AppSpacing.xxl),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst),
                        child: const Text('Back to Courses'),
                      ),
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
