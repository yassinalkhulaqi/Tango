import '../domain/course_model.dart';

enum CourseProgressFilter { all, inProgress, completed, locked }

class CourseQuery {
  const CourseQuery({
    this.search = '',
    this.category = 'All',
    this.progress = CourseProgressFilter.all,
    this.sort = CourseSort.popularity,
  });

  final String search;
  final String category;
  final CourseProgressFilter progress;
  final CourseSort sort;

  CourseQuery copyWith({
    String? search,
    String? category,
    CourseProgressFilter? progress,
    CourseSort? sort,
  }) {
    return CourseQuery(
      search: search ?? this.search,
      category: category ?? this.category,
      progress: progress ?? this.progress,
      sort: sort ?? this.sort,
    );
  }
}

enum CourseSort { popularity, alphabetical, progress }

List<String> availableCategories(List<Course> courses) {
  final categories = <String>{'All'};
  for (final course in courses) {
    if (course.category.isNotEmpty) categories.add(course.category);
  }
  final sorted = categories.toList()..sort();
  sorted.remove('All');
  return ['All', ...sorted];
}

bool _matchesProgress(Course course, CourseProgressFilter filter) {
  switch (filter) {
    case CourseProgressFilter.all:
      return true;
    case CourseProgressFilter.inProgress:
      return course.progress > 0 && course.progress < course.lessonCount;
    case CourseProgressFilter.completed:
      return course.lessonCount > 0 && course.progress >= course.lessonCount;
    case CourseProgressFilter.locked:
      return course.isLocked;
  }
}

List<Course> filterCourses(List<Course> courses, CourseQuery query) {
  final term = query.search.trim().toLowerCase();
  final visible = courses.where((course) {
    if (query.category != 'All' && course.category != query.category) {
      return false;
    }
    if (!_matchesProgress(course, query.progress)) return false;
    if (term.isEmpty) return true;
    return course.title.toLowerCase().contains(term) ||
        course.subtitle.toLowerCase().contains(term) ||
        course.category.toLowerCase().contains(term);
  }).toList();

  switch (query.sort) {
    case CourseSort.popularity:
      visible.sort((a, b) => b.lessonCount.compareTo(a.lessonCount));
      break;
    case CourseSort.alphabetical:
      visible.sort((a, b) => a.title.compareTo(b.title));
      break;
    case CourseSort.progress:
      visible.sort(
        (a, b) => b.completionPercent.compareTo(a.completionPercent),
      );
      break;
  }
  return visible;
}
