import 'lesson_models.dart';

class LessonProgressSync {
  const LessonProgressSync._();

  static Map<String, dynamic> toPayload(LessonProgress progress) {
    return <String, dynamic>{
      'lessonId': progress.lessonId,
      'currentSectionIndex': progress.currentSectionIndex,
      'sectionCompletion': progress.sectionCompletion,
      'quizAnswers': progress.quizAnswers.map(
        (key, value) => MapEntry(key, value.selectedAnswer),
      ),
      'xpEarned': progress.xpEarned,
      'isCompleted': progress.isCompleted,
    };
  }

  static LessonProgress merge(
    LessonProgress local,
    Map<String, dynamic> remote,
  ) {
    final completion = remote['sectionCompletion'];
    final completeFlags = <String, bool>{};
    if (completion is Map) {
      completion.forEach((key, value) {
        completeFlags['$key'] = value == true || value == 'true';
      });
    }
    final index = remote['currentSectionIndex'];
    return local.copyWith(
      currentSectionIndex: index is num
          ? index.toInt()
          : (index is String ? int.tryParse(index) : null) ??
                local.currentSectionIndex,
      sectionCompletion: completion is Map
          ? {...local.sectionCompletion, ...completeFlags}
          : local.sectionCompletion,
      xpEarned: remote['xpEarned'] is num
          ? (remote['xpEarned'] as num).toInt()
          : local.xpEarned,
      isCompleted:
          remote['isCompleted'] == true || remote['isCompleted'] == 'true',
    );
  }

  static int earnedXp(Lesson lesson, LessonProgress progress) {
    final divisor = lesson.totalSections == 0 ? 1 : lesson.totalSections;
    var earned =
        progress.sectionCompletion.values.where((done) => done).length *
        (lesson.xpReward ~/ divisor);
    for (final answer in progress.quizAnswers.values) {
      if (answer.isCorrect) earned += answer.points;
    }
    return earned;
  }
}
