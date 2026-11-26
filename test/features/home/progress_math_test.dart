import 'package:flutter_test/flutter_test.dart';
import 'package:tango/features/progress/domain/progress_math.dart';
import 'package:tango/features/progress/domain/progress_models.dart';

void main() {
  test('level thresholds increase with every level', () {
    expect(ProgressMath.levelFromXp(0), 1);
    expect(ProgressMath.levelFromXp(99), 1);
    expect(ProgressMath.levelFromXp(100), 2);
    expect(ProgressMath.levelFromXp(250), 2);
    expect(ProgressMath.levelFromXp(2500), greaterThan(3));
  });

  test('xpForLevel and xpIntoLevel are consistent', () {
    final level = ProgressMath.levelFromXp(1250);
    final into = ProgressMath.xpIntoLevel(1250);
    expect(into >= 0, isTrue);
    expect(into < ProgressMath.xpNeededForNextLevel(1250), isTrue);
    expect(ProgressMath.xpForLevel(1), 0);
    expect(level, greaterThan(1));
  });

  test('levelProgress stays within 0 and 1', () {
    for (final xp in [0, 50, 100, 250, 1000, 5000]) {
      final progress = ProgressMath.levelProgress(xp);
      expect(progress >= 0 && progress <= 1, isTrue);
    }
  });

  test('streak multiplier unlocks at 7, 14 and 30 days', () {
    expect(ProgressMath.streakMultiplier(0), 0);
    expect(ProgressMath.streakMultiplier(6), 0);
    expect(ProgressMath.streakMultiplier(7), 1);
    expect(ProgressMath.streakMultiplier(14), 2);
    expect(ProgressMath.streakMultiplier(30), 3);
  });

  test('adjustedXp adds a streak bonus', () {
    expect(ProgressMath.adjustedXp(100, 0), 100);
    expect(ProgressMath.adjustedXp(100, 7), 125);
    expect(ProgressMath.adjustedXp(100, 30), 175);
  });

  test('questCompletion measures completed daily quests', () {
    final quests = [
      const DailyQuest(
        id: '1',
        title: 'One',
        target: 1,
        progress: 1,
        xpReward: 20,
      ),
      const DailyQuest(
        id: '2',
        title: 'Two',
        target: 2,
        progress: 1,
        xpReward: 30,
      ),
    ];

    expect(ProgressMath.questCompletion(quests), 0.5);
    expect(ProgressMath.totalQuestXp(quests), 20);
    expect(ProgressMath.questCompletion(const []), 0);
  });
}
