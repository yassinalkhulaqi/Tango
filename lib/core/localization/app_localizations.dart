import 'package:flutter/material.dart';
import './app_locale.dart';
import './string_keys.dart';
import './catalogues/catalogue.dart';

/// Typed access to localized strings for one locale.
///
/// Every getter maps to a [StringKeys] constant and resolves through the
/// catalogue with an English fallback. Missing keys are reported by tests via
/// [completenessOf], so aocale can never ship with a raw key on screen.
class AppLocalizations {
  final AppLocale locale;
  final Map<String, String> _strings;

  AppLocalizations(this.locale) : _strings = catalogueFor(locale);

  static AppLocalizations of(BuildContext context) {
    final localizations = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    if (localizations != null) return localizations;
    return AppLocalizations(AppLocale.en);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> delegates = [delegate];

  String _t(String key) => _strings[key] ?? englishStrings[key] ?? key;

  String get appName => _t(StringKeys.appName);
  String get appTagline => _t(StringKeys.appTagline);
  String get welcome => _t(StringKeys.welcome);
  String get welcomeBack => _t(StringKeys.welcomeBack);
  String get startLearning => _t(StringKeys.startLearning);
  String get nextJourney => _t(StringKeys.nextJourney);
  String get skip => _t(StringKeys.skip);
  String get continueLabel => _t(StringKeys.continueLabel);
  String get retry => _t(StringKeys.retry);
  String get cancel => _t(StringKeys.cancel);
  String get confirm => _t(StringKeys.confirm);
  String get save => _t(StringKeys.save);
  String get delete => _t(StringKeys.delete);
  String get back => _t(StringKeys.back);
  String get close => _t(StringKeys.close);
  String get search => _t(StringKeys.search);
  String get loading => _t(StringKeys.loading);
  String get unavailable => _t(StringKeys.unavailable);
  String get errorTitle => _t(StringKeys.errorTitle);
  String get errorMessage => _t(StringKeys.errorMessage);
  String get emptyTitle => _t(StringKeys.emptyTitle);
  String get emptyMessage => _t(StringKeys.emptyMessage);
  String get language => _t(StringKeys.language);
  String get theme => _t(StringKeys.theme);
  String get darkMode => _t(StringKeys.darkMode);
  String get lightMode => _t(StringKeys.lightMode);
  String get notifications => _t(StringKeys.notifications);
  String get settings => _t(StringKeys.settings);
  String get profile => _t(StringKeys.profile);
  String get signOut => _t(StringKeys.signOut);
  String get home => _t(StringKeys.home);
  String get courses => _t(StringKeys.courses);
  String get code => _t(StringKeys.code);
  String get league => _t(StringKeys.league);
  String get lessons => _t(StringKeys.lessons);
  String get quizzes => _t(StringKeys.quizzes);
  String get challenges => _t(StringKeys.challenges);
  String get badges => _t(StringKeys.badges);
  String get streak => _t(StringKeys.streak);
  String get dayStreak => _t(StringKeys.dayStreak);
  String get totalXp => _t(StringKeys.totalXp);
  String get level => _t(StringKeys.level);
  String get rank => _t(StringKeys.rank);
  String get yourProgress => _t(StringKeys.yourProgress);
  String get continueLearning => _t(StringKeys.continueLearning);
  String get dailyQuests => _t(StringKeys.dailyQuests);
  String get dailyChallenge => _t(StringKeys.dailyChallenge);
  String get explore => _t(StringKeys.explore);
  String get seeAll => _t(StringKeys.seeAll);
  String get myCourses => _t(StringKeys.myCourses);
  String get locked => _t(StringKeys.locked);
  String get completed => _t(StringKeys.completed);
  String get inProgress => _t(StringKeys.inProgress);
  String get all => _t(StringKeys.all);
  String get emailAddress => _t(StringKeys.emailAddress);
  String get password => _t(StringKeys.password);
  String get confirmPassword => _t(StringKeys.confirmPassword);
  String get forgotPassword => _t(StringKeys.forgotPassword);
  String get login => _t(StringKeys.login);
  String get register => _t(StringKeys.register);
  String get createAccount => _t(StringKeys.createAccount);
  String get rememberMe => _t(StringKeys.rememberMe);
  String get orContinueWith => _t(StringKeys.orContinueWith);
  String get continueWithGoogle => _t(StringKeys.continueWithGoogle);
  String get noAccount => _t(StringKeys.noAccount);
  String get haveAccount => _t(StringKeys.haveAccount);
  String get verificationCode => _t(StringKeys.verificationCode);
  String get digitsAccepted => _t(StringKeys.digitsAccepted);
  String get changePassword => _t(StringKeys.changePassword);
  String get currentPassword => _t(StringKeys.currentPassword);
  String get newPassword => _t(StringKeys.newPassword);
  String get sessions => _t(StringKeys.sessions);
  String get stepUp => _t(StringKeys.stepUp);
  String get scanCode => _t(StringKeys.scanCode);
  String get enterCode => _t(StringKeys.enterCode);
  String get saveRecoveryCodes => _t(StringKeys.saveRecoveryCodes);
  String get lessonComplete => _t(StringKeys.lessonComplete);
  String get markComplete => _t(StringKeys.markComplete);
  String get nextSection => _t(StringKeys.nextSection);
  String get previousSection => _t(StringKeys.previousSection);
  String get codeExample => _t(StringKeys.codeExample);
  String get runCode => _t(StringKeys.runCode);
  String get output => _t(StringKeys.output);
  String get quizComplete => _t(StringKeys.quizComplete);
  String get score => _t(StringKeys.score);
  String get xpEarned => _t(StringKeys.xpEarned);
  String get reviewMistakes => _t(StringKeys.reviewMistakes);
  String get correct => _t(StringKeys.correct);
  String get incorrect => _t(StringKeys.incorrect);
  String get question => _t(StringKeys.question);
  String get leaderboard => _t(StringKeys.leaderboard);
  String get weekly => _t(StringKeys.weekly);
  String get allTime => _t(StringKeys.allTime);
  String get friends => _t(StringKeys.friends);
  String get achievementsTitle => _t(StringKeys.achievementsTitle);
  String get unlocked => _t(StringKeys.unlocked);
  String get lockedBadge => _t(StringKeys.lockedBadge);
  String get playground => _t(StringKeys.playground);
  String get languageSettings => _t(StringKeys.languageSettings);
  String get selectLanguage => _t(StringKeys.selectLanguage);
  String get rtlLanguages => _t(StringKeys.rtlLanguages);
  String get ltrLanguages => _t(StringKeys.ltrLanguages);

  /// Format a message with positional placeholders by index.
  String format(String key, List<Object?> values) {
    var text = _t(key);
    for (var i = 0; i < values.length; i++) {
      text = text.replaceAll('{$i}', values[i].toString());
    }
    return text;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocaleHelper.codes.contains(locale.languageCode.toLowerCase());

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(AppLocale.fromCode(locale.languageCode));

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
