import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tango/core/localization/app_locale.dart';
import 'package:tango/core/localization/app_localizations.dart';
import 'package:tango/core/localization/locale_controller.dart';
import 'package:tango/features/profile_localized/presentation/pages/localized_profile_page.dart';

Widget _wrap(Locale locale) => MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.delegates,
      supportedLocales: AppLocale.supportedLocales,
      home: LocalizedProfilePage(
        localeController: LocaleController(AppLocale.fromCode(locale.languageCode)),
      ),
    );

void main() {
  testWidgets('renders profile in English', (tester) async {
    await tester.pumpWidget(_wrap(const Locale('en')));
    expect(find.text('Alex Rivera'), findsOneWidget);
    expect(find.text('Level 7'), findsOneWidget);
  });

  testWidgets('shows stats', (tester) async {
    await tester.pumpWidget(_wrap(const Locale('en')));
    expect(find.text('2,450'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
  });

  testWidgets('shows settings options', (tester) async {
    await tester.pumpWidget(_wrap(const Locale('en')));
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Sign out'), findsOneWidget);
  });

  testWidgets('renders in Arabic', (tester) async {
    await tester.pumpWidget(_wrap(const Locale('ar')));
    expect(find.text('الملف الشخصي'), findsOneWidget);
    expect(find.text('الإعدادات'), findsOneWidget);
  });
}
