import 'package:flutter_test/flutter_test.dart';
import 'package:tango/features/lesson_interactive/data/lesson_dto.dart';
import 'package:tango/features/lesson_interactive/domain/lesson_models.dart';

void main() {
  test('parses sections, quiz questions and enums from API JSON', () {
    final lesson = LessonDto.fromJson({
      'id': 'flutter-widgets',
      'title': 'Widgets',
      'category': 'Flutter',
      'level': 2,
      'xpReward': 80,
      'estimatedMinutes': 15,
      'sections': [
        {
          'id': 's1',
          'title': 'Theory',
          'content': 'Everything is a widget',
          'type': 'theory',
          'order': 0,
        },
        {
          'id': 's2',
          'title': 'Code',
          'code': 'const Text("Hi")',
          'type': 'CODE',
          'order': 1,
        },
      ],
      'quizQuestions': [
        {
          'id': 'q1',
          'question': 'Which widget lays out children vertically?',
          'options': ['Row', 'Column', 'Stack', 'Container'],
          'correctIndex': 1,
          'points': 20,
        },
      ],
    });

    expect(lesson.id, 'flutter-widgets');
    expect(lesson.level, 2);
    expect(lesson.sections.length, 2);
    expect(lesson.sections.last.type, SectionType.code);
    expect(lesson.sections.last.codeExample, 'const Text("Hi")');
    expect(lesson.quizQuestions.single.correctIndex, 1);
    expect(lesson.quizQuestions.single.options, hasLength(4));
  });

  test('uses safe defaults for a minimal payload', () {
    final lesson = LessonDto.fromJson({'title': 'Intro'});

    expect(lesson.title, 'Intro');
    expect(lesson.level, 1);
    expect(lesson.xpReward, 50);
    expect(lesson.sections, isEmpty);
    expect(lesson.quizQuestions, isEmpty);
  });
}
