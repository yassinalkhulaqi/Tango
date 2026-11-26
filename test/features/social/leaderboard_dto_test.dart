import 'package:flutter_test/flutter_test.dart';
import 'package:tango/features/leaderboard/data/leaderboard_dto.dart';
import 'package:tango/features/leaderboard/domain/leaderboard_model.dart';

void main() {
  test('parses ranked entries from a data envelope', () {
    final entries = LeaderboardDto.parse({
      'data': [
        {
          'rank': 2,
          'xp': 1200,
          'user': {
            'id': 'u2',
            'displayName': 'Sam Chen',
            'level': 8,
            'xp': 1200,
          },
        },
        {
          'rank': 1,
          'xp': 1800,
          'user': {
            'id': 'u1',
            'displayName': 'Alex Rivera',
            'level': 12,
            'xp': 1800,
          },
          'isCurrentUser': true,
        },
      ],
    });

    expect(entries, hasLength(2));
    expect(entries.first.rank, 1);
    expect(entries.first.name, 'Alex Rivera');
    expect(entries.first.isCurrentUser, isTrue);
  });

  test('builds initials from a display name', () {
    final entries = LeaderboardDto.parse({
      'data': [
        {
          'rank': 1,
          'user': {'displayName': 'Jordan Lee'},
        },
      ],
    });

    expect(entries.single.avatar, 'JL');
  });

  test('returns an empty list for malformed payloads', () {
    expect(LeaderboardDto.parse({'data': null}), isEmpty);
    expect(LeaderboardDto.parse(const <String, dynamic>{}), isEmpty);
    expect(LeaderboardDto.parse(null), isEmpty);
  });

  test('periods expose API values and labels', () {
    expect(LeaderboardPeriod.values.map((p) => p.value), [
      'weekly',
      'monthly',
      'allTime',
      'friends',
    ]);
    expect(LeaderboardPeriod.friends.label, 'Friends');
  });
}
