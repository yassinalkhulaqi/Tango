import 'package:flutter_test/flutter_test.dart';
import 'package:tango/features/quiz/domain/quiz_model.dart';
import 'package:tango/features/quiz/domain/quiz_scoring.dart';

List<QuizQuestion> _questions() => const [
  QuizQuestion(id: '1', question: 'Q1', options: ['a', 'b'], correctIndex: 0),
  QuizQuestion(id: '2', question: 'Q2', options: ['a', 'b'], correctIndex: 1),
];

void main() {
  test('correctCount handles unanswered and wrong answers', () {
    expect(QuizScoring.correctCount(_questions(), [0, 0]), 1);
    expect(QuizScoring.correctCount(_questions(), [0, 1]), 2);
    expect(QuizScoring.correctCount(_questions(), [null, 1]), 1);
  });

  test('scorePercent is between zero and one', () {
    expect(QuizScoring.scorePercent(_questions(), [0, 1]), 1);
    expect(QuizScoring.scorePercent(_questions(), [1, 0]), 0);
    expect(QuizScoring.scorePercent(const [], const []), 0);
  });

  test('xp is only awarded for a passing score', () {
    expect(QuizScoring.xpAwarded(questions: _questions(), answers: [0, 1]), 70);
    expect(QuizScoring.xpAwarded(questions: _questions(), answers: [1, 0]), 0);
  });

  test('grade maps percentages to letter grades', () {
    expect(QuizScoring.grade(0.95), 'S');
    expect(QuizScoring.grade(0.85), 'A');
    expect(QuizScoring.grade(0.75), 'B');
    expect(QuizScoring.grade(0.65), 'C');
    expect(QuizScoring.grade(0.4), 'F');
  });

  test('session pads and truncates answers safely', () {
    final session = QuizScoring.session(
      courseId: 'c1',
      questions: _questions(),
      answers: const [0],
    );
    expect(session.answers, [0, null]);

    final extra = QuizScoring.session(
      courseId: 'c1',
      questions: _questions(),
      answers: const [0, 1, 0],
    );
    expect(extra.answers, [0, 1]);
  });
}
