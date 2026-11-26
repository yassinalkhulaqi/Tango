import 'package:flutter_test/flutter_test.dart';
import 'package:tango/features/courses/data/course_dto.dart';
import 'package:tango/features/courses/domain/course_model.dart';

void main() {
  test('maps a full API course payload', () {
    final course = CourseDto.fromJson({
      'id': 'flutter-101',
      'title': 'Flutter 101',
      'subtitle': 'Build apps',
      'category': 'Flutter',
      'lessonCount': 12,
      'progress': 25.5,
      'lessons': [
        {
          'id': 'l1',
          'title': 'Widgets',
          'description': 'Everything is a widget',
          'xpReward': 75,
          'isCompleted': true,
        },
      ],
    }).toDomain();

    expect(course.id, 'flutter-101');
    expect(course.category, 'Flutter');
    expect(course.lessonCount, 12);
    expect(course.progress, 25.5);
    expect(course.lessons, hasLength(1));
    expect(course.lessons.first.xpReward, 75);
    expect(course.lessons.first.isCompleted, isTrue);
  });

  test('falls back to slug, description and lesson length', () {
    final course = CourseDto.fromJson({
      'slug': 'python-basics',
      'title': 'Python Basics',
      'description': 'Start scripting',
      'lessons': [
        {'id': '1', 'title': 'Variables'},
        {'id': '2', 'title': 'Loops'},
      ],
    }).toDomain();

    expect(course.id, 'python-basics');
    expect(course.subtitle, 'Start scripting');
    expect(course.lessonCount, 2);
    expect(course.category, 'General');
  });

  test('handles snake_case lesson counts and locked courses', () {
    final course = CourseDto.fromJson({
      'id': 'ai',
      'title': 'AI',
      'lesson_count': '9',
      'isLocked': true,
      'unlockRequirement': 'Level 4',
    }).toDomain();

    expect(course.lessonCount, 9);
    expect(course.isLocked, isTrue);
    expect(course.unlockRequirement, 'Level 4');
  });
}
