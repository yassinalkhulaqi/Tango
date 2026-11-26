import '../app_locale.dart';
import '../string_keys.dart';
import './ar.dart';
import './fr.dart';
import './es.dart';
import './tr.dart';
import './ur.dart';

/// English source catalogue. Other locales fall back to these values when a
/// key has not yet been translated.
const Map<String, String> englishStrings = {
  StringKeys.appName: 'CodeBro',
  StringKeys.appTagline: 'Learn to code by building real projects',
  StringKeys.welcome: 'Welcome to CodeBro',
  StringKeys.welcomeBack: 'Welcome back',
  StringKeys.startLearning: 'Start Learning',
  StringKeys.nextJourney: 'Next Journey',
  StringKeys.skip: 'Skip',
  StringKeys.continueLabel: 'Continue',
  StringKeys.retry: 'Try Again',
  StringKeys.cancel: 'Cancel',
  StringKeys.confirm: 'Confirm',
  StringKeys.save: 'Save',
  StringKeys.delete: 'Delete',
  StringKeys.back: 'Back',
  StringKeys.close: 'Close',
  StringKeys.search: 'Search',
  StringKeys.loading: 'Loading',
  StringKeys.unavailable: 'Unavailable',
  StringKeys.errorTitle: 'Something went wrong',
  StringKeys.errorMessage:
      'We couldn\'t complete that request. Please try again.',
  StringKeys.emptyTitle: 'Nothing here yet',
  StringKeys.emptyMessage: 'Your learning journey starts here.',
  StringKeys.language: 'Language',
  StringKeys.theme: 'Theme',
  StringKeys.darkMode: 'Dark',
  StringKeys.lightMode: 'Light',
  StringKeys.notifications: 'Notifications',
  StringKeys.settings: 'Settings',
  StringKeys.profile: 'Profile',
  StringKeys.signOut: 'Sign out',
  StringKeys.home: 'Home',
  StringKeys.courses: 'Courses',
  StringKeys.code: 'Code',
  StringKeys.league: 'League',
  StringKeys.lessons: 'Lessons',
  StringKeys.quizzes: 'Quizzes',
  StringKeys.challenges: 'Challenges',
  StringKeys.badges: 'Badges',
  StringKeys.streak: 'Streak',
  StringKeys.dayStreak: 'Day Streak',
  StringKeys.totalXp: 'Total XP',
  StringKeys.level: 'Level',
  StringKeys.rank: 'Rank',
  StringKeys.yourProgress: 'Your Progress',
  StringKeys.continueLearning: 'Continue Learning',
  StringKeys.dailyQuests: 'Daily Quests',
  StringKeys.dailyChallenge: 'Daily Challenge',
  StringKeys.explore: 'Explore',
  StringKeys.seeAll: 'See All',
  StringKeys.myCourses: 'My Courses',
  StringKeys.locked: 'Locked',
  StringKeys.completed: 'Completed',
  StringKeys.inProgress: 'In Progress',
  StringKeys.all: 'All',
  StringKeys.emailAddress: 'Email Address',
  StringKeys.password: 'Password',
  StringKeys.confirmPassword: 'Confirm Password',
  StringKeys.forgotPassword: 'Forgot Password?',
  StringKeys.login: 'Login',
  StringKeys.register: 'Register',
  StringKeys.createAccount: 'Create Account',
  StringKeys.rememberMe: 'Remember me',
  StringKeys.orContinueWith: 'or continue with',
  StringKeys.continueWithGoogle: 'Continue with Google',
  StringKeys.noAccount: 'Don\'t have an account?',
  StringKeys.haveAccount: 'Already have an account?',
  StringKeys.verificationCode: 'Verification code',
  StringKeys.digitsAccepted: 'Western and Arabic digits are accepted',
  StringKeys.changePassword: 'Choose a new password',
  StringKeys.currentPassword: 'Current password',
  StringKeys.newPassword: 'New password',
  StringKeys.sessions: 'Sessions',
  StringKeys.stepUp: 'Step-up confirmation',
  StringKeys.scanCode: 'Scan the code',
  StringKeys.enterCode: 'Enter a code',
  StringKeys.saveRecoveryCodes: 'Save recovery codes',
  StringKeys.lessonComplete: 'Lesson Complete!',
  StringKeys.markComplete: 'Mark Complete',
  StringKeys.nextSection: 'Next Section',
  StringKeys.previousSection: 'Previous',
  StringKeys.codeExample: 'Code Example',
  StringKeys.runCode: 'Run Code',
  StringKeys.output: 'Output',
  StringKeys.quizComplete: 'Quiz Complete',
  StringKeys.score: 'Score',
  StringKeys.xpEarned: 'XP Earned',
  StringKeys.reviewMistakes: 'Review Mistakes',
  StringKeys.correct: 'Correct!',
  StringKeys.incorrect: 'Incorrect',
  StringKeys.question: 'Question',
  StringKeys.leaderboard: 'Leaderboard',
  StringKeys.weekly: 'Weekly',
  StringKeys.allTime: 'All-time',
  StringKeys.friends: 'Friends',
  StringKeys.achievementsTitle: 'Achievements',
  StringKeys.unlocked: 'Unlocked',
  StringKeys.lockedBadge: 'Locked',
  StringKeys.playground: 'Playground',
  StringKeys.languageSettings: 'Language Settings',
  StringKeys.selectLanguage: 'Select Language',
  StringKeys.rtlLanguages: 'Right-to-left languages',
  StringKeys.ltrLanguages: 'Left-to-right languages',
};

/// All locale catalogues keyed by locale code.
const Map<String, Map<String, String>> translationCatalogues = {
  'en': englishStrings,
  'ar': arabicStrings,
  'fr': frenchStrings,
  'es': spanishStrings,
  'tr': turkishStrings,
  'ur': urduStrings,
};

/// Resolve a catalogue for a locale with English fallback.
Map<String, String> catalogueFor(AppLocale locale) =>
    translationCatalogues[locale.code] ?? englishStrings;

/// Completeness of a catalogue against the source keys.
TranslationCompleteness completenessOf(
  String code,
  Map<String, String> catalogue,
) {
  final missing = StringKeys.allKeys
      .where((key) => !catalogue.containsKey(key))
      .toList();
  return TranslationCompleteness(
    locale: code,
    translated: StringKeys.allKeys.length - missing.length,
    total: StringKeys.allKeys.length,
    missing: missing,
  );
}
