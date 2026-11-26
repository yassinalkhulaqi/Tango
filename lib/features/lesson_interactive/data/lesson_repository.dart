import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/providers.dart';
import '../domain/lesson_controller.dart';
import '../domain/lesson_models.dart';
import 'lesson_dto.dart';

class LessonRepository {
  LessonRepository(this._api);

  final ApiClient _api;

  Future<Lesson?> fetchLesson(String lessonId) async {
    try {
      final body = await _api.get('/lessons/$lessonId');
      final data = body['data'];
      if (data is! Map) return null;
      return LessonDto.fromJson(Map<String, dynamic>.from(data));
    } on Object {
      return null;
    }
  }

  Future<bool> saveProgress(LessonProgress progress) async {
    try {
      await _api.post(
        '/lessons/${progress.lessonId}/progress',
        data: {
          'currentSectionIndex': progress.currentSectionIndex,
          'sectionCompletion': progress.sectionCompletion,
          'quizAnswers': progress.quizAnswers.map(
            (key, value) => MapEntry(key, value.selectedAnswer),
          ),
          'xpEarned': progress.xpEarned,
          'isCompleted': progress.isCompleted,
        },
      );
      return true;
    } on Object {
      return false;
    }
  }
}

final lessonRepositoryProvider = Provider<LessonRepository>((ref) {
  return LessonRepository(ref.watch(apiClientProvider));
});

final lessonFutureProvider = FutureProvider.family<Lesson?, String>((
  ref,
  lessonId,
) async {
  final remote = await ref
      .watch(lessonRepositoryProvider)
      .fetchLesson(lessonId);
  if (remote != null) return remote;
  return LessonDataService.getLessonById(lessonId);
});
