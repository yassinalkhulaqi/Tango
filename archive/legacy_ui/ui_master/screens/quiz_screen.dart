import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_gradients.dart';

class QuizScreen extends StatefulWidget {
  final String quizId;

  const QuizScreen({super.key, required this.quizId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with TickerProviderStateMixin {
  int _currentQuestion = 0;
  int? _selectedAnswer;
  bool _showResult = false;
  int _score = 0;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is the entry point of a Dart application?',
      'options': ['start()', 'main()', 'init()', 'run()'],
      'correctIndex': 1,
      'explanation': 'The main() function is where execution begins.',
    },
    {
      'question': 'Which widget is immutable in Flutter?',
      'options': ['StatefulWidget', 'StatelessWidget', 'Both', 'Neither'],
      'correctIndex': 1,
      'explanation': 'StatelessWidget cannot change its state after being built.',
    },
    {
      'question': 'What method rebuilds a widget\\'s UI?',
      'options': ['build()', 'render()', 'display()', 'show()'],
      'correctIndex': 0,
      'explanation': 'The build() method describes how to display the widget.',
    },
    {
      'question': 'Which package manages state in Flutter?',
      'options': ['Provider', 'Redux', 'Bloc', 'All of the above'],
      'correctIndex': 3,
      'explanation': 'Provider, Redux, and Bloc are all state management solutions.',
    },
    {
      'question': 'What is hot reload in Flutter?',
      'options': [
        'Restarting the app',
        'Updating UI without restart',
        'Clearing cache',
        'Deploying to production',
      ],
      'correctIndex': 1,
      'explanation': 'Hot reload updates the UI instantly without restarting.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );
    _pulseController.repeat(reverse: true);

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
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  bool get _isLast => _currentQuestion == _questions.length - 1;

  void _selectAnswer(int index) {
    if (_showResult) return;
    setState(() {
      _selectedAnswer = index;
      _showResult = true;
      if (index == _questions[_currentQuestion]['correctIndex']) {
        _score++;
      }
    });
  }

  void _next() {
    if (_isLast) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => QuizResultScreen(
            score: _score,
            total: _questions.length,
          ),
        ),
      );
    } else {
      setState(() {
        _currentQuestion++;
        _selectedAnswer = null;
        _showResult = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Question ${_currentQuestion + 1} / ${_questions.length}',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      _questions[_currentQuestion]['question'] as String,
                      style: AppTextStyles.titleLarge.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    ...List.generate(
                      (_questions[_currentQuestion]['options'] as List).length,
                      (index) {
                        final isSelected = _selectedAnswer == index;
                        final isCorrect =
                            index ==
                            _questions[_currentQuestion]['correctIndex'];
                        final isRevealed = _showResult;
                        return _buildOptionCard(
                          text:
                              _questions[_currentQuestion]['options'][index],
                          isSelected: isSelected,
                          isCorrect: isCorrect,
                          isRevealed: isRevealed,
                          onTap: () => _selectAnswer(index),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    if (_showResult && _selectedAnswer != null)
                      _buildFeedback(),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
              Text(
                'Quiz',
                style: AppTextStyles.titleMedium.copyWith(fontSize: 18),
              ),
              Text(
                '${_currentQuestion + 1} / ${_questions.length}',
                style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: AppRadius.circular(AppRadius.md),
            child: LinearProgressIndicator(
              value: (_currentQuestion + 1) / _questions.length,
              minHeight: 6,
              backgroundColor: AppColors.cardBorder,
              valueColor: const AlwaysStoppedAnimation(AppColors.primaryBlue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required String text,
    required bool isSelected,
    required bool isCorrect,
    required bool isRevealed,
    required VoidCallback onTap,
  }) {
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
                color: isRevealed && isCorrect
                    ? AppColors.primaryGreen
                    : isRevealed && isSelected
                        ? AppColors.pink
                        : isSelected
                            ? AppColors.primaryBlue
                            : AppColors.surfaceLight,
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
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedback() {
    final isCorrect =
        _selectedAnswer == _questions[_currentQuestion]['correctIndex'];
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: (isCorrect ? AppColors.primaryGreen : AppColors.pink)
            .withValues(alpha: 0.15),
        borderRadius: AppRadius.circular(AppRadius.lg),
        border: Border.all(
          color: (isCorrect ? AppColors.primaryGreen : AppColors.pink)
              .withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isCorrect ? Icons.check_circle_rounded : Icons.error_outline_rounded,
            color: isCorrect ? AppColors.primaryGreen : AppColors.pink,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCorrect ? 'Correct!' : 'Incorrect',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isCorrect ? AppColors.primaryGreen : AppColors.pink,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _questions[_currentQuestion]['explanation'] as String,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
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
        child: ElevatedButton(
          onPressed: _selectedAnswer != null ? _next : null,
          child: Text(_isLast ? 'Finish Quiz' : 'Next'),
        ),
      ),
    );
  }
}

class QuizResultScreen extends StatelessWidget {
  final int score;
  final int total;

  const QuizResultScreen({super.key, required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    final percent = score / total;
    final xp = score * 10;
    final perfect = score == total;

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
                        border: Border.all(color: AppColors.cardBorder, width: 1),
                        boxShadow: [AppGradients.cardShadow()],
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${(percent * 100).round()}%',
                            style: AppTextStyles.displayLarge.copyWith(
                              color: perfect ? AppColors.primaryGreen : AppColors.primaryBlue,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            '$score / $total correct',
                            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
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
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
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
