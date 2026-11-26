import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/providers.dart';
import '../domain/quiz_model.dart';
import 'quiz_dto.dart';

class QuizRepository {
  QuizRepository(this._api);

  final ApiClient _api;

  Future<QuizDto?> fetchQuiz(String quizId) async {
    try {
      final body = await _api.get('/quizzes/$quizId');
      final data = body['data'];
      if (data is! Map) return null;
      return QuizDto.fromJson(Map<String, dynamic>.from(data));
    } on Object {
      return null;
    }
  }

  Future<QuizAttemptResult?> submitAttempt({
    required String quizId,
    required List<int?> answers,
  }) async {
    try {
      final body = await _api.post(
        '/quizzes/$quizId/attempts',
        data: {'answers': answers},
      );
      return QuizAttemptResult.fromJson(body);
    } on Object {
      return null;
    }
  }
}

final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  return QuizRepository(ref.watch(apiClientProvider));
});

final quizFutureProvider = FutureProvider.family<QuizDto?, String>((
  ref,
  quizId,
) async {
  final remote = await ref.watch(quizRepositoryProvider).fetchQuiz(quizId);
  if (remote != null && remote.questions.isNotEmpty) return remote;
  return QuizDto(
    id: quizId,
    title: 'Dart Basics',
    questions: fallbackQuestions,
  );
});

const List<QuizQuestion> fallbackQuestions = [
  QuizQuestion(
    id: 'q1',
    question: 'What does "void" mean in a Dart function?',
    options: [
      'Returns no value',
      'Returns null',
      'Returns 0',
      'Returns String',
    ],
    correctIndex: 0,
  ),
  QuizQuestion(
    id: 'q2',
    question: 'Which keyword defines a class in Dart?',
    options: ['class', 'struct', 'interface', 'type'],
    correctIndex: 0,
  ),
  QuizQuestion(
    id: 'q3',
    question: 'What is the entry point function in Dart?',
    options: ['start()', 'run()', 'main()', 'init()'],
    correctIndex: 2,
  ),
];
