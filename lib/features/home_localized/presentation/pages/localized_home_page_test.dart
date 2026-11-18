import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tango/core/localization/app_locale.dart';
import 'package:tango/core/localization/app_localizations.dart';
import 'package:tango/core/localization/locale_controller.dart';
import 'package:tango/features/home_localized/presentation/pages/localized_home_page.dart';

Widget _wrap(Locale locale, Widget child) => MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.delegates,
      supportedLocales: AppLocale.supportedLocales,
      home: child,
    );

void main() {
  testWidgets('renders localized home in English', (tester) async {
    await tester.pumpWidget(_wrap(
      const Locale('en'),
      LocalizedHomePage(localeController: LocaleController()),
    ));
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.textContaining('Day Streak'), findsOneWidget);
  });

  testWidgets('renders localized home in Arabic', (tester) async {
    await tester.pumpWidget(_wrap(
      const Locale('ar'),
      LocalizedHomePage(localeController: LocaleController(AppLocale.ar)),
    ));
    expect(find.text('مرحباً بعودتك'), findsOneWidget);
  });

  testWidgets('shows XP and level', (tester) async {
    await tester.pumpWidget(_wrap(
      const Locale('en'),
      LocalizedHomePage(localeController: LocaleController(), xp: 2450, level: 7),
    ));
    expect(find.textContaining('2,450'), findsOneWidget);
    expect(find.textContaining('Level 7'), findsOneWidget);
  });

  testWidgets('shows daily quests section', (tester) async {
    await tester.pumpWidget(_wrap(
      const Locale('en'),
      LocalizedHomePage(localeController: LocaleController()),
    ));
    expect(find.text('Daily Quests'), findsOneWidget);
  });
}
