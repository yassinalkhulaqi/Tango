import '../string_keys.dart';

/// Extended catalogue keys for dashboard, gamification and settings surfaces.
abstract final class ExtendedKeys {
  static const String streakTitle = 'streakTitle';
  static const String streakFreeze = 'streakFreeze';
  static const String levelUp = 'levelUp';
  static const String nextLevel = 'nextLevel';
  static const String dailyGoal = 'dailyGoal';
  static const String weeklyGoal = 'weeklyGoal';
  static const String completedLessons = 'completedLessons';
  static const String perfectQuiz = 'perfectQuiz';
  static const String continueStreak = 'continueStreak';
  static const String achievementUnlocked = 'achievementUnlocked';
  static const String shareProgress = 'shareProgress';
  static const String inviteFriends = 'inviteFriends';
  static const String darkMode = 'darkMode';
  static const String lightMode = 'lightMode';
  static const String systemTheme = 'systemTheme';
  static const String languageChanged = 'languageChanged';

  static const List<String> all = [
    streakTitle, streakFreeze, levelUp, nextLevel, dailyGoal, weeklyGoal,
    completedLessons, perfectQuiz, continueStreak, achievementUnlocked,
    shareProgress, inviteFriends, darkMode, lightMode, systemTheme, languageChanged,
  ];
}

const Map<String, String> extendedEnglish = {
  ExtendedKeys.streakTitle: 'Your Streak',
  ExtendedKeys.streakFreeze: 'Streak Freeze',
  ExtendedKeys.levelUp: 'Level Up!',
  ExtendedKeys.nextLevel: 'Next Level',
  ExtendedKeys.dailyGoal: 'Daily Goal',
  ExtendedKeys.weeklyGoal: 'Weekly Goal',
  ExtendedKeys.completedLessons: 'Completed Lessons',
  ExtendedKeys.perfectQuiz: 'Perfect Quiz',
  ExtendedKeys.continueStreak: 'Keep your streak going',
  ExtendedKeys.achievementUnlocked: 'Achievement unlocked',
  ExtendedKeys.shareProgress: 'Share progress',
  ExtendedKeys.inviteFriends: 'Invite friends',
  ExtendedKeys.darkMode: 'Dark mode',
  ExtendedKeys.lightMode: 'Light mode',
  ExtendedKeys.systemTheme: 'System theme',
  ExtendedKeys.languageChanged: 'Language changed',
};

const Map<String, String> extendedArabic = {
  ExtendedKeys.streakTitle: 'سلسلتك',
  ExtendedKeys.streakFreeze: 'تجميد السلسلة',
  ExtendedKeys.levelUp: 'تم ترقية المستوى!',
  ExtendedKeys.nextLevel: 'المستوى التالي',
  ExtendedKeys.dailyGoal: 'الهدف اليومي',
  ExtendedKeys.weeklyGoal: 'الهدف الأسبوعي',
  ExtendedKeys.completedLessons: 'الدروس المكتملة',
  ExtendedKeys.perfectQuiz: 'اختبار مثالي',
  ExtendedKeys.continueStreak: 'واصل سلسلتك',
  ExtendedKeys.achievementUnlocked: 'تم فتح إنجاز',
  ExtendedKeys.shareProgress: 'مشاركة التقدم',
  ExtendedKeys.inviteFriends: 'دعوة الأصدقاء',
  ExtendedKeys.darkMode: 'الوضع الداكن',
  ExtendedKeys.lightMode: 'الوضع الفاتح',
  ExtendedKeys.systemTheme: 'مظهر النظام',
  ExtendedKeys.languageChanged: 'تم تغيير اللغة',
};

Map<String, String> extendedCatalogue(String code) =>
    code == 'ar' ? extendedArabic : extendedEnglish;
