import 'package:flutter_test/flutter_test.dart';
import 'package:tango/features/quiz/data/quiz_dto.dart';
import 'package:tango/features/quiz/domain/quiz_model.dart';

void main() {
  test('parses quiz questions from an API envelope', () {
    final quiz = QuizDto.fromJson({
      'id': 'dart-basics',
      'title': 'Dart Basics',
      'questions': [
        {
          'id': 'q1',
          'prompt': 'What is a widget?',
          'options': ['UI block', 'Database', 'Package'],
          'correctIndex': 0,
          'explanation': 'Widgets describe UI.',
        },
      ],
    });

    expect(quiz.id, 'dart-basics');
    expect(quiz.questions.single.question, 'What is a widget?');
    expect(quiz.questions.single.options, hasLength(3));
    expect(quiz.questions.single.explanation, 'Widgets describe UI.');
  });

  test('parses an attempt result with a passing score', () {
    final result = QuizAttemptResult.fromJson({
      'data': {
        'id': 'a1',
        'scorePercent': 0.8,
        'correctCount': 4,
        'totalQuestions': 5,
        'xpAwarded': 90,
      },
    });

    expect(result.attemptId, 'a1');
    expect(result.scorePercent, 0.8);
    expect(result.xpAwarded, 90);
    expect(result.passed, isTrue);
  });

  test('a score below 60 percent is not passed', () {
    final result = QuizAttemptResult.fromJson({
      'scorePercent': 0.5,
      'correctCount': 1,
      'totalQuestions': 2,
      'xpAwarded': 0,
    });

    expect(result.passed, isFalse);
  });
}
