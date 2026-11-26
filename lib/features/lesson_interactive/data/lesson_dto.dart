import '../domain/lesson_models.dart';

extension SectionTypeParser on SectionType {
  static SectionType from(String? value) {
    switch (value?.toLowerCase()) {
      case 'code':
        return SectionType.code;
      case 'interactive':
        return SectionType.interactive;
      case 'quiz':
        return SectionType.quiz;
      case 'challenge':
        return SectionType.challenge;
      case 'summary':
        return SectionType.summary;
      case 'theory':
      default:
        return SectionType.theory;
    }
  }
}

class LessonDto {
  LessonDto._();

  static Lesson fromJson(Map<String, dynamic> json) {
    final sections = <LessonSection>[];
    final rawSections = json['sections'];
    if (rawSections is List) {
      for (var i = 0; i < rawSections.length; i++) {
        final item = rawSections[i];
        if (item is! Map) continue;
        final row = Map<String, dynamic>.from(item);
        sections.add(
          LessonSection(
            id: '${row['id'] ?? 'section-$i'}',
            title: '${row['title'] ?? ''}',
            content: '${row['content'] ?? ''}',
            codeExample: '${row['codeExample'] ?? row['code'] ?? ''}',
            explanation: '${row['explanation'] ?? ''}',
            type: SectionTypeParser.from('${row['type']}'),
            isCompleted: row['isCompleted'] == true,
            isLocked: row['isLocked'] == true,
            order: (row['order'] as num?)?.toInt() ?? i,
            metadata: row['metadata'] is Map
                ? Map<String, dynamic>.from(row['metadata'] as Map)
                : const <String, dynamic>{},
          ),
        );
      }
    }

    final questions = <LessonQuizQuestion>[];
    final rawQuiz = json['quizQuestions'] ?? json['quiz'] ?? json['questions'];
    if (rawQuiz is List) {
      for (var i = 0; i < rawQuiz.length; i++) {
        final item = rawQuiz[i];
        if (item is! Map) continue;
        final row = Map<String, dynamic>.from(item);
        final options = row['options'];
        questions.add(
          LessonQuizQuestion(
            id: '${row['id'] ?? 'q-$i'}',
            question: '${row['question'] ?? ''}',
            options: options is List
                ? options.map((option) => '$option').toList()
                : const <String>[],
            correctIndex: (row['correctIndex'] as num?)?.toInt() ?? 0,
            explanation: '${row['explanation'] ?? ''}',
            points: (row['points'] as num?)?.toInt() ?? 10,
          ),
        );
      }
    }

    return Lesson(
      id: '${json['id'] ?? json['slug'] ?? ''}',
      title: '${json['title'] ?? 'Untitled lesson'}',
      description: '${json['description'] ?? ''}',
      category: '${json['category'] ?? 'General'}',
      level: (json['level'] as num?)?.toInt() ?? 1,
      xpReward: (json['xpReward'] as num?)?.toInt() ?? 50,
      estimatedMinutes: (json['estimatedMinutes'] as num?)?.toInt() ?? 10,
      sections: sections,
      quizQuestions: questions,
      isLocked: json['isLocked'] == true,
      isCompleted: json['isCompleted'] == true,
      metadata: json['metadata'] is Map
          ? Map<String, dynamic>.from(json['metadata'] as Map)
          : const <String, dynamic>{},
    );
  }
}
