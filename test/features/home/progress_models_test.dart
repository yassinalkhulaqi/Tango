import 'package:flutter_test/flutter_test.dart';
import 'package:tango/features/progress/domain/progress_models.dart';

void main() {
  test('parses user progress with camelCase keys', () {
    final progress = UserProgress.fromJson({
      'xp': 1250,
      'level': 4,
      'streakCount': 7,
      'longestStreak': 12,
      'lessonsCompleted': 20,
      'quizzesPassed': 8,
      'rank': 3,
    });

    expect(progress.xp, 1250);
    expect(progress.level, 4);
    expect(progress.streak, 7);
    expect(progress.rank, 3);
  });

  test('falls back to level one when level is missing', () {
    final progress = UserProgress.fromJson({'xp': '500'});
    expect(progress.level, 1);
    expect(progress.xp, 500);
  });

  test('parses streak info from a data envelope', () {
    final streak = StreakInfo.fromJson({
      'data': {'current': 9, 'longest': 20, 'freezes': 2, 'activeToday': true},
    });

    expect(streak.current, 9);
    expect(streak.frozen, 2);
    expect(streak.activeToday, isTrue);
  });

  test('daily quest percent is clamped', () {
    const quest = DailyQuest(
      id: 'q',
      title: 'Practice',
      target: 3,
      progress: 5,
      xpReward: 30,
    );

    expect(quest.isComplete, isTrue);
    expect(quest.percent, 1);
  });

  test('xp transactions parse a date safely', () {
    final transaction = XpTransaction.fromJson({
      'id': 't1',
      'amount': 40,
      'reason': 'quiz',
      'createdAt': '2026-01-01T00:00:00.000Z',
    });

    expect(transaction.amount, 40);
    expect(transaction.createdAt.year, 2026);
  });
}
