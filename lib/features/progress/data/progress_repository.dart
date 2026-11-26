import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/providers.dart';
import '../domain/progress_models.dart';

class ProgressRepository {
  ProgressRepository(this._api);

  final ApiClient _api;

  Future<UserProgress> fetchProgress() async {
    final body = await _api.get('/progress/me');
    return UserProgress.fromJson(body);
  }

  Future<StreakInfo> fetchStreak() async {
    final body = await _api.get('/streaks/me');
    return StreakInfo.fromJson(body);
  }

  Future<List<XpTransaction>> fetchLedger() async {
    final body = await _api.get('/xp/ledger');
    final raw = body['data'];
    if (raw is! List) return const <XpTransaction>[];
    return raw
        .whereType<Map>()
        .map((row) => XpTransaction.fromJson(Map<String, dynamic>.from(row)))
        .toList();
  }

  Future<List<DailyQuest>> fetchDailyQuests() async {
    final body = await _api.get('/quests/daily');
    final raw = body['data'];
    if (raw is! List) return const <DailyQuest>[];
    return raw
        .whereType<Map>()
        .map((row) => DailyQuest.fromJson(Map<String, dynamic>.from(row)))
        .toList();
  }

  Future<bool> checkIn() async {
    try {
      await _api.post('/streaks/check-in');
      return true;
    } on Object {
      return false;
    }
  }
}

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepository(ref.watch(apiClientProvider));
});

class HomeDashboardData {
  const HomeDashboardData({
    required this.progress,
    required this.streak,
    required this.quests,
    required this.ledger,
  });

  final UserProgress progress;
  final StreakInfo streak;
  final List<DailyQuest> quests;
  final List<XpTransaction> ledger;

  factory HomeDashboardData.demo() => HomeDashboardData(
    progress: const UserProgress(
      xp: 1250,
      level: 4,
      streak: 7,
      lessonsCompleted: 12,
      quizzesPassed: 5,
    ),
    streak: const StreakInfo(current: 7, longest: 12, activeToday: true),
    quests: const [
      DailyQuest(
        id: 'q1',
        title: 'Complete a lesson',
        target: 1,
        progress: 1,
        xpReward: 25,
      ),
      DailyQuest(
        id: 'q2',
        title: 'Pass a quiz',
        target: 1,
        progress: 0,
        xpReward: 40,
      ),
    ],
    ledger: const <XpTransaction>[],
  );
}

final homeDashboardProvider = FutureProvider<HomeDashboardData>((ref) async {
  final repository = ref.watch(progressRepositoryProvider);
  try {
    final progress = await repository.fetchProgress();
    final streak = await repository.fetchStreak();
    final quests = await repository.fetchDailyQuests();
    final ledger = await repository.fetchLedger();
    return HomeDashboardData(
      progress: progress,
      streak: streak,
      quests: quests,
      ledger: ledger,
    );
  } on Object {
    return HomeDashboardData.demo();
  }
});
