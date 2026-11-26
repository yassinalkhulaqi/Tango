import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/providers.dart';
import '../domain/achievement_model.dart';
import 'achievement_dto.dart';

class AchievementsRepository {
  AchievementsRepository(this._api);

  final ApiClient _api;

  Future<List<Achievement>> fetchBadges() async {
    try {
      final body = await _api.get('/badges');
      final badges = AchievementDto.parse(body);
      if (badges.isNotEmpty) return badges;
    } on Object {
      return const <Achievement>[];
    }
    return const <Achievement>[];
  }

  Future<bool> evaluate() async {
    try {
      await _api.post('/badges/evaluate');
      return true;
    } on Object {
      return false;
    }
  }
}

final achievementsRepositoryProvider = Provider<AchievementsRepository>((ref) {
  return AchievementsRepository(ref.watch(apiClientProvider));
});

final badgesProvider = FutureProvider<List<Achievement>>((ref) async {
  return ref.watch(achievementsRepositoryProvider).fetchBadges();
});
