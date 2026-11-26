import '../domain/quiz_model.dart';

class QuizDto {
  const QuizDto({
    required this.id,
    required this.title,
    required this.questions,
  });

  final String id;
  final String title;
  final List<QuizQuestion> questions;

  factory QuizDto.fromJson(Map<String, dynamic> json) {
    final raw = json['questions'] ?? json['items'] ?? json['data'];
    final questions = <QuizQuestion>[];
    if (raw is List) {
      for (var i = 0; i < raw.length; i++) {
        final item = raw[i];
        if (item is! Map) continue;
        final row = Map<String, dynamic>.from(item);
        final options = row['options'] ?? row['choices'];
        questions.add(
          QuizQuestion(
            id: '${row['id'] ?? 'q$i'}',
            question: '${row['question'] ?? row['prompt'] ?? ''}',
            options: options is List
                ? options.map((value) => '$value').toList()
                : const <String>[],
            correctIndex: (row['correctIndex'] as num?)?.toInt() ?? 0,
            explanation: '${row['explanation'] ?? ''}',
          ),
        );
      }
    }
    return QuizDto(
      id: '${json['id'] ?? json['slug'] ?? ''}',
      title: '${json['title'] ?? 'Quiz'}',
      questions: questions,
    );
  }
}

class QuizAttemptResult {
  const QuizAttemptResult({
    required this.attemptId,
    required this.scorePercent,
    required this.correctCount,
    required this.totalQuestions,
    required this.xpAwarded,
  });

  final String attemptId;
  final double scorePercent;
  final int correctCount;
  final int totalQuestions;
  final int xpAwarded;

  bool get passed => scorePercent >= 0.6;

  factory QuizAttemptResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;
    return QuizAttemptResult(
      attemptId: '${data['id'] ?? data['attemptId'] ?? ''}',
      scorePercent: (data['scorePercent'] as num?)?.toDouble() ?? 0,
      correctCount: (data['correctCount'] as num?)?.toInt() ?? 0,
      totalQuestions: (data['totalQuestions'] as num?)?.toInt() ?? 0,
      xpAwarded: (data['xpAwarded'] as num?)?.toInt() ?? 0,
    );
  }
}
