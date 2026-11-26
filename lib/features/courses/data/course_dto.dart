import '../domain/course_model.dart';

class CourseDto {
  CourseDto({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.thumbnail,
    required this.lessonCount,
    this.progress = 0,
    this.isLocked = false,
    this.unlockRequirement = '',
    this.lessons = const <Lesson>[],
  });

  final String id;
  final String title;
  final String subtitle;
  final String category;
  final String thumbnail;
  final int lessonCount;
  final double progress;
  final bool isLocked;
  final String unlockRequirement;
  final List<Lesson> lessons;

  factory CourseDto.fromJson(Map<String, dynamic> json) {
    final rawLessons = json['lessons'];
    final lessons = <Lesson>[];
    if (rawLessons is List) {
      for (final item in rawLessons) {
        if (item is! Map) continue;
        final row = Map<String, dynamic>.from(item);
        lessons.add(
          Lesson(
            id: '${row['id'] ?? ''}',
            title: '${row['title'] ?? ''}',
            description: '${row['description'] ?? ''}',
            isLocked: row['isLocked'] == true,
            isCompleted: row['isCompleted'] == true,
            xpReward: (row['xpReward'] as num?)?.toInt() ?? 50,
          ),
        );
      }
    }

    final count =
        (json['lessonCount'] ??
                json['lesson_count'] ??
                json['totalLessons'] ??
                lessons.length)
            .toString();

    return CourseDto(
      id: '${json['id'] ?? json['slug'] ?? ''}',
      title: '${json['title'] ?? 'Untitled course'}',
      subtitle: '${json['subtitle'] ?? json['description'] ?? ''}',
      category: '${json['category'] ?? json['categoryName'] ?? 'General'}',
      thumbnail: '${json['thumbnail'] ?? json['icon'] ?? 'flutter'}',
      lessonCount: int.tryParse(count) ?? lessons.length,
      progress: (json['progress'] as num?)?.toDouble() ?? 0,
      isLocked: json['isLocked'] == true,
      unlockRequirement: '${json['unlockRequirement'] ?? ''}',
      lessons: lessons,
    );
  }

  Course toDomain() => Course(
    id: id,
    title: title,
    subtitle: subtitle,
    category: category,
    thumbnail: thumbnail,
    lessonCount: lessonCount,
    progress: progress,
    isLocked: isLocked,
    unlockRequirement: unlockRequirement,
    lessons: lessons,
  );
}
