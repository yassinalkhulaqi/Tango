import '../domain/quiz_model.dart';

class QuizScoring {
  const QuizScoring._();

  static QuizSession session({
    required String courseId,
    required List<QuizQuestion> questions,
    List<int?> answers = const <int?>[],
  }) {
    final remaining = questions.length > answers.length
        ? questions.length - answers.length
        : 0;
    final padded = <int?>[
      ...answers.take(questions.length),
      ...List<int?>.filled(remaining, null),
    ];
    return QuizSession(
      courseId: courseId,
      questions: questions,
      answers: padded,
    );
  }

  static int correctCount(List<QuizQuestion> questions, List<int?> answers) {
    var correct = 0;
    for (var i = 0; i < questions.length && i < answers.length; i++) {
      final answer = answers[i];
      if (answer != null && answer == questions[i].correctIndex) correct++;
    }
    return correct;
  }

  static double scorePercent(List<QuizQuestion> questions, List<int?> answers) {
    if (questions.isEmpty) return 0;
    return correctCount(questions, answers) / questions.length;
  }

  static int xpAwarded({
    required List<QuizQuestion> questions,
    required List<int?> answers,
    int baseXp = 50,
    int bonusPerCorrect = 10,
  }) {
    final percent = scorePercent(questions, answers);
    if (percent < 0.6) return 0;
    return baseXp + correctCount(questions, answers) * bonusPerCorrect;
  }

  static String grade(double percent) {
    if (percent >= 0.9) return 'S';
    if (percent >= 0.8) return 'A';
    if (percent >= 0.7) return 'B';
    if (percent >= 0.6) return 'C';
    return 'F';
  }
}
