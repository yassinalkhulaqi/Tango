/// Translation key constants shared by every locale catalogue.
///
/// Keeping keys in one place means a typo fails at compile time instead of
/// showing a raw key on screen. Every user-facing string must have an entry in
/// each locale map; [translationCompleteness] is the guard used in tests.
abstract final class StringKeys {
  static const String appName = 'appName';
  static const String appTagline = 'appTagline';
  static const String welcome = 'welcome';
  static const String welcomeBack = 'welcomeBack';
  static const String startLearning = 'startLearning';
  static const String nextJourney = 'nextJourney';
  static const String skip = 'skip';
  static const String continueLabel = 'continueLabel';
  static const String retry = 'retry';
  static const String cancel = 'cancel';
  static const String confirm = 'confirm';
  static const String save = 'save';
  static const String delete = 'delete';
  static const String back = 'back';
  static const String close = 'close';
  static const String search = 'search';
  static const String loading = 'loading';
  static const String unavailable = 'unavailable';
  static const String errorTitle = 'errorTitle';
  static const String errorMessage = 'errorMessage';
  static const String emptyTitle = 'emptyTitle';
  static const String emptyMessage = 'emptyMessage';
  static const String language = 'language';
  static const String theme = 'theme';
  static const String darkMode = 'darkMode';
  static const String lightMode = 'lightMode';
  static const String notifications = 'notifications';
  static const String settings = 'settings';
  static const String profile = 'profile';
  static const String signOut = 'signOut';
  static const String home = 'home';
  static const String courses = 'courses';
  static const String code = 'code';
  static const String league = 'league';
  static const String lessons = 'lessons';
  static const String quizzes = 'quizzes';
  static const String challenges = 'challenges';
  static const String badges = 'badges';
  static const String streak = 'streak';
  static const String dayStreak = 'dayStreak';
  static const String totalXp = 'totalXp';
  static const String level = 'level';
  static const String rank = 'rank';
  static const String yourProgress = 'yourProgress';
  static const String continueLearning = 'continueLearning';
  static const String dailyQuests = 'dailyQuests';
  static const String dailyChallenge = 'dailyChallenge';
  static const String explore = 'explore';
  static const String seeAll = 'seeAll';
  static const String myCourses = 'myCourses';
  static const String locked = 'locked';
  static const String completed = 'completed';
  static const String inProgress = 'inProgress';
  static const String all = 'all';
  static const String emailAddress = 'emailAddress';
  static const String password = 'password';
  static const String confirmPassword = 'confirmPassword';
  static const String forgotPassword = 'forgotPassword';
  static const String login = 'login';
  static const String register = 'register';
  static const String createAccount = 'createAccount';
  static const String rememberMe = 'rememberMe';
  static const String orContinueWith = 'orContinueWith';
  static const String continueWithGoogle = 'continueWithGoogle';
  static const String noAccount = 'noAccount';
  static const String haveAccount = 'haveAccount';
  static const String verificationCode = 'verificationCode';
  static const String digitsAccepted = 'digitsAccepted';
  static const String changePassword = 'changePassword';
  static const String currentPassword = 'currentPassword';
  static const String newPassword = 'newPassword';
  static const String sessions = 'sessions';
  static const String stepUp = 'stepUp';
  static const String scanCode = 'scanCode';
  static const String enterCode = 'enterCode';
  static const String saveRecoveryCodes = 'saveRecoveryCodes';
  static const String lessonComplete = 'lessonComplete';
  static const String markComplete = 'markComplete';
  static const String nextSection = 'nextSection';
  static const String previousSection = 'previousSection';
  static const String codeExample = 'codeExample';
  static const String runCode = 'runCode';
  static const String output = 'output';
  static const String quizComplete = 'quizComplete';
  static const String score = 'score';
  static const String xpEarned = 'xpEarned';
  static const String reviewMistakes = 'reviewMistakes';
  static const String correct = 'correct';
  static const String incorrect = 'incorrect';
  static const String question = 'question';
  static const String leaderboard = 'leaderboard';
  static const String weekly = 'weekly';
  static const String allTime = 'allTime';
  static const String friends = 'friends';
  static const String achievementsTitle = 'achievementsTitle';
  static const String unlocked = 'unlocked';
  static const String lockedBadge = 'lockedBadge';
  static const String playground = 'playground';
  static const String languageSettings = 'languageSettings';
  static const String selectLanguage = 'selectLanguage';
  static const String rtlLanguages = 'rtlLanguages';
  static const String ltrLanguages = 'ltrLanguages';

  static const List<String> allKeys = [
    appName, appTagline, welcome, welcomeBack, startLearning, nextJourney,
    skip, continueLabel, retry, cancel, confirm, save, delete, back, close,
    search, loading, unavailable, errorTitle, errorMessage, emptyTitle,
    emptyMessage, language, theme, darkMode, lightMode, notifications,
    settings, profile, signOut, home, courses, code, league, lessons,
    quizzes, challenges, badges, streak, dayStreak, totalXp, level, rank,
    yourProgress, continueLearning, dailyQuests, dailyChallenge, explore,
    seeAll, myCourses, locked, completed, inProgress, all, emailAddress,
    password, confirmPassword, forgotPassword, login, register,
    createAccount, rememberMe, orContinueWith, continueWithGoogle, noAccount,
    haveAccount, verificationCode, digitsAccepted, changePassword,
    currentPassword, newPassword, sessions, stepUp, scanCode, enterCode,
    saveRecoveryCodes, lessonComplete, markComplete, nextSection,
    previousSection, codeExample, runCode, output, quizComplete, score,
    xpEarned, reviewMistakes, correct, incorrect, question, leaderboard,
    weekly, allTime, friends, achievementsTitle, unlocked, lockedBadge,
    playground, languageSettings, selectLanguage, rtlLanguages, ltrLanguages,
  ];
}

/// Completeness report for a translation catalogue.
class TranslationCompleteness {
  final String locale;
  final int translated;
  final int total;
  final List<String> missing;

  const TranslationCompleteness({
    required this.locale,
    required this.translated,
    required this.total,
    required this.missing,
  });

  double get ratio => total == 0 ? 0 : translated / total;
  bool get isComplete => missing.isEmpty;
}
