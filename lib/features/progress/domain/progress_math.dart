import '../domain/progress_models.dart';

class ProgressMath {
  const ProgressMath._();

  static int levelFromXp(int xp) {
    if (xp <= 0) return 1;
    var level = 1;
    var threshold = 0;
    while (level < 100) {
      final required = 100 + (level - 1) * 50;
      if (xp < threshold + required) break;
      threshold += required;
      level++;
    }
    return level;
  }

  static int xpForLevel(int level) {
    if (level <= 1) return 0;
    var total = 0;
    for (var current = 1; current < level; current++) {
      total += 100 + (current - 1) * 50;
    }
    return total;
  }

  static int xpIntoLevel(int xp) => xp - xpForLevel(levelFromXp(xp));

  static int xpNeededForNextLevel(int xp) {
    final level = levelFromXp(xp);
    return 100 + (level - 1) * 50;
  }

  static double levelProgress(int xp) {
    final needed = xpNeededForNextLevel(xp);
    if (needed <= 0) return 0;
    return (xpIntoLevel(xp) / needed).clamp(0, 1).toDouble();
  }

  static int streakMultiplier(int streak) {
    if (streak >= 30) return 3;
    if (streak >= 14) return 2;
    if (streak >= 7) return 1;
    return 0;
  }

  static int adjustedXp(int baseXp, int streak) {
    return baseXp + (baseXp * streakMultiplier(streak) ~/ 4);
  }

  static double questCompletion(List<DailyQuest> quests) {
    if (quests.isEmpty) return 0;
    final done = quests.where((quest) => quest.isComplete).length;
    return done / quests.length;
  }

  static int totalQuestXp(List<DailyQuest> quests) => quests
      .where((quest) => quest.isComplete)
      .fold(0, (sum, q) => sum + q.xpReward);
}
