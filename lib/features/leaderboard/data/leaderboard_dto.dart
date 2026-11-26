import '../domain/leaderboard_model.dart';

enum LeaderboardPeriod {
  weekly('weekly', 'Weekly'),
  monthly('monthly', 'Monthly'),
  allTime('allTime', 'All time'),
  friends('friends', 'Friends');

  const LeaderboardPeriod(this.value, this.label);

  final String value;
  final String label;
}

class LeaderboardDto {
  LeaderboardDto._();

  static List<LeaderboardEntry> parse(Object? body) {
    final map = body is Map<String, dynamic> ? body : <String, dynamic>{};
    final raw = map['data'] ?? map['entries'] ?? map['leaderboard'];
    if (raw is! List) return const <LeaderboardEntry>[];

    final rows = raw.whereType<Map>().map((row) {
      final json = Map<String, dynamic>.from(row);
      final user = json['user'] is Map
          ? Map<String, dynamic>.from(json['user'] as Map)
          : json;
      int asInt(Object? value) =>
          value is num ? value.toInt() : int.tryParse('$value') ?? 0;
      final name = '${user['displayName'] ?? user['name'] ?? 'Learner'}';
      final initials = name
          .split(RegExp(r'\s+'))
          .where((part) => part.isNotEmpty)
          .map((part) => part[0])
          .take(2)
          .join()
          .toUpperCase();
      return LeaderboardEntry(
        id: '${user['id'] ?? json['id'] ?? ''}',
        name: name,
        avatar: '${user['avatarUrl'] ?? user['avatar'] ?? initials}',
        level: asInt(user['level'] ?? json['level']),
        xp: asInt(user['xp'] ?? json['xp'] ?? json['score']),
        rank: asInt(json['rank'] ?? json['position']),
        isCurrentUser: json['isCurrentUser'] == true || user['isMe'] == true,
      );
    }).toList();

    rows.sort((a, b) => a.rank.compareTo(b.rank));
    return rows;
  }
}
