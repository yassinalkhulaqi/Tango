import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tango/core/localization/app_locale.dart';
import 'package:tango/core/localization/app_localizations.dart';
import 'package:tango/features/courses_localized/presentation/pages/localized_courses_page.dart';

Widget _wrap(Locale locale) => MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.delegates,
      supportedLocales: AppLocale.supportedLocales,
      home: LocalizedCoursesPage(locale: AppLocale.fromCode(locale.languageCode)),
    );

void main() {
  testWidgets('renders course list in English', (tester) async {
    await tester.pumpWidget(_wrap(const Locale('en')));
    expect(find.text('Flutter Fundamentals'), findsOneWidget);
    expect(find.text('Python 101'), findsOneWidget);
  });

  testWidgets('renders localized title in Arabic', (tester) async {
    await tester.pumpWidget(_wrap(const Locale('ar')));
    expect(find.text('الدورات'), findsOneWidget);
  });

  testWidgets('filters courses by category', (tester) async {
    await tester.pumpWidget(_wrap(const Locale('en')));
    await tester.tap(find.widgetWithText(ChoiceChip, 'Python'));
    await tester.pumpAndSettle();
    expect(find.text('Flutter Fundamentals'), findsNothing);
    expect(find.text('Python 101'), findsOneWidget);
  });

  testWidgets('shows locked course', (tester) async {
    await tester.pumpWidget(_wrap(const Locale('en')));
    expect(find.byIcon(Icons.lock_rounded), findsWidgets);
  });
}
