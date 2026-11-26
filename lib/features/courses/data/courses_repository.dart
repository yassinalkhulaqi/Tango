import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/providers.dart';
import '../domain/course_model.dart';

class CoursesRepository {
  CoursesRepository(this._api);

  final ApiClient _api;

  Future<List<Course>> fetchCourses() async {
    try {
      final body = await _api.get('/courses', queryParameters: {'limit': 50});
      final raw = body['data'];
      final items = raw is List
          ? raw
          : (body['items'] is List ? body['items'] as List : const <dynamic>[]);
      if (items.isEmpty) return demoCourses;
      return items.whereType<Map>().map(_courseFromJson).toList();
    } on ApiException {
      return demoCourses;
    }
  }

  Course _courseFromJson(Map<dynamic, dynamic> json) {
    final lessons = (json['lessons'] is List)
        ? (json['lessons'] as List).whereType<Map>().map((lesson) {
            return Lesson(
              id: '${lesson['id'] ?? ''}',
              title: '${lesson['title'] ?? ''}',
              description: '${lesson['description'] ?? ''}',
            );
          }).toList()
        : <Lesson>[];
    final lessonCount =
        int.tryParse('${json['lessonCount'] ?? lessons.length}') ??
        lessons.length;
    return Course(
      id: '${json['id'] ?? ''}',
      title: '${json['title'] ?? 'Untitled course'}',
      subtitle: '${json['subtitle'] ?? json['description'] ?? ''}',
      category: '${json['category'] ?? 'General'}',
      thumbnail: '${json['thumbnail'] ?? 'flutter'}',
      lessonCount: lessonCount,
      progress: (json['progress'] is num)
          ? (json['progress'] as num).toDouble()
          : 0,
      isLocked: json['isLocked'] == true,
      unlockRequirement: '${json['unlockRequirement'] ?? ''}',
      lessons: lessons,
    );
  }
}

final coursesRepositoryProvider = Provider<CoursesRepository>((ref) {
  return CoursesRepository(ref.watch(apiClientProvider));
});

final demoCourses = <Course>[
  const Course(
    id: 'flutter-basics',
    title: 'Flutter Fundamentals',
    subtitle: 'Build beautiful cross-platform apps',
    category: 'Flutter',
    thumbnail: 'flutter',
    lessonCount: 24,
    progress: 12,
  ),
  const Course(
    id: 'python-101',
    title: 'Python 101',
    subtitle: 'From zero to your first script',
    category: 'Python',
    thumbnail: 'python',
    lessonCount: 18,
    progress: 6,
  ),
  const Course(
    id: 'web-dev',
    title: 'Web Development',
    subtitle: 'HTML, CSS, and modern JavaScript',
    category: 'Web Dev',
    thumbnail: 'web',
    lessonCount: 30,
  ),
  const Course(
    id: 'security',
    title: 'Cybersecurity Essentials',
    subtitle: 'Protect systems and data',
    category: 'Security',
    thumbnail: 'security',
    lessonCount: 12,
  ),
  const Course(
    id: 'ai-ml',
    title: 'AI / Machine Learning',
    subtitle: 'Intro to neural networks & models',
    category: 'AI / ML',
    thumbnail: 'ai',
    lessonCount: 9,
    isLocked: true,
    unlockRequirement: 'Reach Level 4',
  ),
];
