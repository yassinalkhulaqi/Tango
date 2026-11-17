class Lesson {
  final String id;
  final String title;
  final String description;
  final bool isLocked;
  final bool isCompleted;
  final int xpReward;

  const Lesson({
    required this.id,
    required this.title,
    required this.description,
    this.isLocked = false,
    this.isCompleted = false,
    this.xpReward = 50,
  });
}

class Course {
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

  const Course({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.thumbnail,
    required this.lessonCount,
    this.progress = 0.0,
    this.isLocked = false,
    this.unlockRequirement = '',
    this.lessons = const [],
  });

  double get completionPercent => progress / lessonCount.clamp(1, lessonCount);
}
