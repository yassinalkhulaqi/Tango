import 'package:flutter_test/flutter_test.dart';
import 'package:tango/features/courses/data/course_filters.dart';
import 'package:tango/features/courses/domain/course_model.dart';

List<Course> _courses() => [
  const Course(
    id: '1',
    title: 'Flutter Fundamentals',
    subtitle: 'Cross-platform apps',
    category: 'Flutter',
    thumbnail: 'flutter',
    lessonCount: 24,
    progress: 12,
  ),
  const Course(
    id: '2',
    title: 'Python 101',
    subtitle: 'Scripting basics',
    category: 'Python',
    thumbnail: 'python',
    lessonCount: 18,
  ),
  const Course(
    id: '3',
    title: 'Advanced Flutter',
    subtitle: 'Deep dive',
    category: 'Flutter',
    thumbnail: 'flutter',
    lessonCount: 30,
    isLocked: true,
  ),
];

void main() {
  test('categories are unique, sorted and start with All', () {
    expect(availableCategories(_courses()), ['All', 'Flutter', 'Python']);
  });

  test('search matches title, subtitle and category case-insensitively', () {
    const query = CourseQuery(search: 'FLUTTER');
    final result = filterCourses(_courses(), query);

    expect(result, hasLength(2));
    expect(result.map((c) => c.id), containsAll(['1', '3']));
  });

  test('category and progress filters combine', () {
    const query = CourseQuery(
      category: 'Flutter',
      progress: CourseProgressFilter.inProgress,
    );
    final result = filterCourses(_courses(), query);

    expect(result, hasLength(1));
    expect(result.first.id, '1');
  });

  test('locked filter returns locked courses', () {
    const query = CourseQuery(progress: CourseProgressFilter.locked);
    expect(filterCourses(_courses(), query).map((c) => c.id), ['3']);
  });

  test('completed filter excludes not-started courses', () {
    const query = CourseQuery(progress: CourseProgressFilter.completed);
    expect(filterCourses(_courses(), query), isEmpty);
  });

  test('sort by popularity orders by lesson count descending', () {
    final result = filterCourses(
      _courses(),
      const CourseQuery(sort: CourseSort.popularity),
    );
    expect(result.map((c) => c.id), ['3', '1', '2']);
  });

  test('sort by alphabetical orders by title', () {
    final result = filterCourses(
      _courses(),
      const CourseQuery(sort: CourseSort.alphabetical),
    );
    expect(result.first.title, 'Advanced Flutter');
  });

  test('copyWith preserves unspecified query fields', () {
    const original = CourseQuery(category: 'Flutter');
    final updated = original.copyWith(search: 'widgets');

    expect(updated.category, 'Flutter');
    expect(updated.search, 'widgets');
  });
}
