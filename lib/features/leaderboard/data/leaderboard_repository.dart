import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/providers.dart';
import '../domain/leaderboard_model.dart';
import 'leaderboard_dto.dart';

class LeaderboardRepository {
  LeaderboardRepository(this._api);

  final ApiClient _api;

  Future<List<LeaderboardEntry>> fetch(LeaderboardPeriod period) async {
    try {
      final body = await _api.get(
        '/leaderboard',
        queryParameters: {'period': period.value, 'limit': 50},
      );
      final entries = LeaderboardDto.parse(body);
      if (entries.isNotEmpty) return entries;
    } on Object {
      return const <LeaderboardEntry>[];
    }
    return const <LeaderboardEntry>[];
  }
}

final leaderboardRepositoryProvider = Provider<LeaderboardRepository>((ref) {
  return LeaderboardRepository(ref.watch(apiClientProvider));
});

final leaderboardProvider =
    FutureProvider.family<List<LeaderboardEntry>, LeaderboardPeriod>((
      ref,
      period,
    ) async {
      return ref.watch(leaderboardRepositoryProvider).fetch(period);
    });
