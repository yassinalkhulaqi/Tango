class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation = '',
  });
}

class QuizSession {
  final String courseId;
  final List<QuizQuestion> questions;
  final List<int?> answers; // null = unanswered

  const QuizSession({
    required this.courseId,
    required this.questions,
    this.answers = const [],
  });

  int get answeredCount => answers.where((a) => a != null).length;
  int get correctCount {
    int correct = 0;
    for (int i = 0; i < questions.length; i++) {
      if (answers[i] != null && answers[i] == questions[i].correctIndex) {
        correct++;
      }
    }
    return correct;
  }

  double get scorePercent =>
      questions.isEmpty ? 0 : correctCount / questions.length;
}
