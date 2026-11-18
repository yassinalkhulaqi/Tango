import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tango/core/localization/app_locale.dart';
import 'package:tango/core/localization/app_localizations.dart';
import 'package:tango/core/localization/locale_controller.dart';
import 'package:tango/features/settings/presentation/pages/language_settings_page.dart';

Widget _wrap(LocaleController controller) => MaterialApp(
      locale: Locale(controller.code),
      localizationsDelegates: AppLocalizations.delegates,
      supportedLocales: AppLocale.supportedLocales,
      home: LanguageSettingsPage(controller: controller),
    );

void main() {
  testWidgets('renders the language settings page', (tester) async {
    final controller = LocaleController();
    await tester.pumpWidget(_wrap(controller));
    expect(find.byType(LanguageSettingsPage), findsOneWidget);
    expect(find.text('Select Language'), findsOneWidget);
  });

  testWidgets('shows all six languages', (tester) async {
    final controller = LocaleController();
    await tester.pumpWidget(_wrap(controller));
    expect(find.byType(ChoiceChip), findsNWidgets(6));
  });

  testWidgets('changing language updates the controller', (tester) async {
    final controller = LocaleController();
    await tester.pumpWidget(_wrap(controller));
    await tester.tap(find.widgetWithText(ChoiceChip, 'Français'));
    await tester.pumpAndSettle();
    expect(controller.locale, AppLocale.fr);
  });

  testWidgets('shows RTL badge for Arabic', (tester) async {
    final controller = LocaleController(AppLocale.ar);
    await tester.pumpWidget(_wrap(controller));
    expect(find.text('RTL'), findsOneWidget);
  });
}
