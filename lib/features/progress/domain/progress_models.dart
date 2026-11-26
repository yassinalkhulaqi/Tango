class UserProgress {
  const UserProgress({
    this.xp = 0,
    this.level = 1,
    this.streak = 0,
    this.longestStreak = 0,
    this.lessonsCompleted = 0,
    this.quizzesPassed = 0,
    this.rank,
  });

  final int xp;
  final int level;
  final int streak;
  final int longestStreak;
  final int lessonsCompleted;
  final int quizzesPassed;
  final int? rank;

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    final user = json['user'] is Map
        ? Map<String, dynamic>.from(json['user'] as Map)
        : json;
    int asInt(Object? value) =>
        value is num ? value.toInt() : int.tryParse('$value') ?? 0;
    return UserProgress(
      xp: asInt(user['xp'] ?? json['totalXp']),
      level: asInt(user['level']) == 0 ? 1 : asInt(user['level']),
      streak: asInt(user['streakCount'] ?? user['streak']),
      longestStreak: asInt(user['longestStreak']),
      lessonsCompleted: asInt(json['lessonsCompleted']),
      quizzesPassed: asInt(json['quizzesPassed']),
      rank: json['rank'] == null ? null : asInt(json['rank']),
    );
  }
}

class XpTransaction {
  const XpTransaction({
    required this.id,
    required this.amount,
    required this.reason,
    required this.createdAt,
  });

  final String id;
  final int amount;
  final String reason;
  final DateTime createdAt;

  factory XpTransaction.fromJson(Map<String, dynamic> json) {
    return XpTransaction(
      id: '${json['id'] ?? ''}',
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      reason: '${json['reason'] ?? 'lesson'}',
      createdAt: DateTime.tryParse('${json['createdAt']}') ?? DateTime.now(),
    );
  }
}

class StreakInfo {
  const StreakInfo({
    this.current = 0,
    this.longest = 0,
    this.frozen = 0,
    this.activeToday = false,
  });

  final int current;
  final int longest;
  final int frozen;
  final bool activeToday;

  factory StreakInfo.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;
    int asInt(Object? value) =>
        value is num ? value.toInt() : int.tryParse('$value') ?? 0;
    return StreakInfo(
      current: asInt(data['current'] ?? data['streakCount']),
      longest: asInt(data['longest'] ?? data['longestStreak']),
      frozen: asInt(data['freezes'] ?? data['frozen']),
      activeToday: data['activeToday'] == true,
    );
  }
}

class DailyQuest {
  const DailyQuest({
    required this.id,
    required this.title,
    required this.target,
    required this.progress,
    required this.xpReward,
  });

  final String id;
  final String title;
  final int target;
  final int progress;
  final int xpReward;

  bool get isComplete => progress >= target;

  double get percent =>
      target == 0 ? 0 : (progress / target).clamp(0, 1).toDouble();

  factory DailyQuest.fromJson(Map<String, dynamic> json) {
    final target = (json['target'] as num?)?.toInt() ?? 1;
    return DailyQuest(
      id: '${json['id'] ?? ''}',
      title: '${json['title'] ?? ''}',
      target: target == 0 ? 1 : target,
      progress:
          (json['progress'] as num?)?.toInt() ??
          (json['completed'] as num?)?.toInt() ??
          0,
      xpReward: (json['xpReward'] as num?)?.toInt() ?? 25,
    );
  }
}
