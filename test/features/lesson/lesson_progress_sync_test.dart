import 'package:flutter_test/flutter_test.dart';
import 'package:tango/features/lesson_interactive/domain/lesson_models.dart';
import 'package:tango/features/lesson_interactive/domain/lesson_progress_sync.dart';

Lesson _lesson() => const Lesson(
  id: 'l1',
  title: 'Lesson',
  description: 'Description',
  category: 'Flutter',
  level: 1,
  xpReward: 100,
  estimatedMinutes: 10,
  sections: [
    LessonSection(
      id: 's1',
      title: 'One',
      content: 'A',
      codeExample: '',
      explanation: '',
      type: SectionType.theory,
      order: 0,
    ),
    LessonSection(
      id: 's2',
      title: 'Two',
      content: 'B',
      codeExample: '',
      explanation: '',
      type: SectionType.code,
      order: 1,
    ),
  ],
  quizQuestions: [],
);

void main() {
  test('toPayload serializes completion and answers', () {
    final progress = LessonProgress(
      lessonId: 'l1',
      currentSectionIndex: 1,
      sectionCompletion: {'s1': true, 's2': false},
      quizAnswers: const {},
    );

    final payload = LessonProgressSync.toPayload(progress);

    expect(payload['lessonId'], 'l1');
    expect(payload['currentSectionIndex'], 1);
    expect(payload['sectionCompletion'], {'s1': true, 's2': false});
  });

  test('merge applies remote values over local progress', () {
    final local = LessonProgress(
      lessonId: 'l1',
      currentSectionIndex: 0,
      sectionCompletion: {'s1': false},
    );
    final merged = LessonProgressSync.merge(local, {
      'currentSectionIndex': '1',
      'sectionCompletion': {'s1': true, 's2': false},
      'xpEarned': 40,
      'isCompleted': false,
    });

    expect(merged.currentSectionIndex, 1);
    expect(merged.sectionCompletion['s1'], isTrue);
    expect(merged.xpEarned, 40);
  });

  test('earnedXp awards section and correct-answer points', () {
    final lesson = _lesson();
    final answer = LessonQuizQuestion(
      id: 'q1',
      question: 'Question',
      options: ['a', 'b'],
      correctIndex: 0,
      explanation: '',
      points: 20,
      isCorrect: true,
    );
    final progress = LessonProgress(
      lessonId: 'l1',
      currentSectionIndex: 1,
      sectionCompletion: {'s1': true, 's2': false},
      quizAnswers: {'q1': answer},
    );

    expect(LessonProgressSync.earnedXp(lesson, progress), 70);
  });

  test('earnedXp is zero for an empty lesson', () {
    const empty = Lesson(
      id: 'l',
      title: 'T',
      description: 'D',
      category: 'C',
      level: 1,
      xpReward: 50,
      estimatedMinutes: 1,
      sections: [],
      quizQuestions: [],
    );
    const progress = LessonProgress(lessonId: 'l', currentSectionIndex: 0);

    expect(LessonProgressSync.earnedXp(empty, progress), 0);
  });
}
