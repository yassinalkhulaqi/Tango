import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tango/core/localization/app_locale.dart';
import 'package:tango/core/localization/app_localizations.dart';
import 'package:tango/features/lesson_localized/presentation/pages/localized_lesson_page.dart';

Widget _wrap(Locale locale) => MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.delegates,
      supportedLocales: AppLocale.supportedLocales,
      home: LocalizedLessonPage(locale: AppLocale.fromCode(locale.languageCode)),
    );

void main() {
  testWidgets('renders lesson in English', (tester) async {
    await tester.pumpWidget(_wrap(const Locale('en')));
    expect(find.text('Flutter Basics'), findsOneWidget);
    expect(find.text('Code Example'), findsOneWidget);
  });

  testWidgets('renders code block', (tester) async {
    await tester.pumpWidget(_wrap(const Locale('en')));
    expect(find.textContaining('void main()'), findsOneWidget);
  });

  testWidgets('navigates between sections', (tester) async {
    await tester.pumpWidget(_wrap(const Locale('en')));
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    await tester.tap(find.text('Next Section'));
    await tester.pumpAndSettle();
  });

  testWidgets('renders in Arabic', (tester) async {
    await tester.pumpWidget(_wrap(const Locale('ar')));
    expect(find.text('مثال برمجي'), findsOneWidget);
  });
}
