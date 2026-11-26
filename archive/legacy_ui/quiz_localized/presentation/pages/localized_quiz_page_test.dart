import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tango/core/localization/app_locale.dart';
import 'package:tango/core/localization/app_localizations.dart';
import 'package:tango/features/quiz_localized/presentation/pages/localized_quiz_page.dart';

Widget _wrap(Locale locale) => MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.delegates,
      supportedLocales: AppLocale.supportedLocales,
      home: LocalizedQuizPage(locale: AppLocale.fromCode(locale.languageCode)),
    );

void main() {
  testWidgets('renders quiz question', (tester) async {
    await tester.pumpWidget(_wrap(const Locale('en')));
    expect(find.text('What is Flutter?'), findsOneWidget);
    expect(find.text('Framework'), findsOneWidget);
  });

  testWidgets('selecting answer reveals continue button', (tester) async {
    await tester.pumpWidget(_wrap(const Locale('en')));
    await tester.tap(find.text('Framework'));
    await tester.pumpAndSettle();
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('shows result after last question', (tester) async {
    await tester.pumpWidget(_wrap(const Locale('en')));
    await tester.tap(find.text('Framework'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('class'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Quiz Complete'), findsOneWidget);
  });

  testWidgets('renders in Arabic', (tester) async {
    await tester.pumpWidget(_wrap(const Locale('ar')));
    expect(find.textContaining('سؤال'), findsOneWidget);
  });
}
