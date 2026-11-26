import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/app_states.dart';
import '../../data/quiz_repository.dart';
import '../../domain/quiz_scoring.dart';
import 'quiz_page.dart';

class ConnectedQuizPage extends ConsumerStatefulWidget {
  const ConnectedQuizPage({super.key, required this.quizId});

  final String quizId;

  @override
  ConsumerState<ConnectedQuizPage> createState() => _ConnectedQuizPageState();
}

class _ConnectedQuizPageState extends ConsumerState<ConnectedQuizPage> {
  Future<void> _submit(List<int?> answers) async {
    await ref
        .read(quizRepositoryProvider)
        .submitAttempt(quizId: widget.quizId, answers: answers);
  }

  @override
  Widget build(BuildContext context) {
    final quizAsync = ref.watch(quizFutureProvider(widget.quizId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: quizAsync.when(
        loading: () => const AppLoadingView(message: 'Preparing your quiz...'),
        error: (error, _) => AppErrorView(
          message: 'Could not load this quiz. Please try again.',
          onRetry: () => ref.invalidate(quizFutureProvider(widget.quizId)),
        ),
        data: (quiz) {
          if (quiz == null || quiz.questions.isEmpty) {
            return const AppEmptyView(
              title: 'No questions yet',
              message: 'This quiz will be available soon.',
            );
          }
          return QuizPage(questions: quiz.questions, onFinished: _submit);
        },
      ),
    );
  }
}
