import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tango/core/localization/app_locale.dart';
import 'package:tango/core/localization/app_localizations.dart';
import 'package:tango/core/localization/localized_widgets.dart';
import 'package:tango/core/localization/locale_controller.dart';

Widget _wrap(Widget child) => MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.delegates,
      supportedLocales: AppLocale.supportedLocales,
      home: Scaffold(body: child),
    );

void main() {
  group('LocalizedText', () {
    testWidgets('renders the selected string', (tester) async {
      await tester.pumpWidget(_wrap(LocalizedText((l) => l.welcome)));
      expect(find.text('Welcome to CodeBro'), findsOneWidget);
    });

    testWidgets('reads from the scoped locale', (tester) async {
      await tester.pumpWidget(MaterialApp(
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.delegates,
        supportedLocales: AppLocale.supportedLocales,
        home: Scaffold(body: LocalizedText((l) => l.welcome)),
      ));
      expect(find.text('مرحباً بك في CodeBro'), findsOneWidget);
    });
  });

  group('LocaleChip', () {
    testWidgets('shows the native name', (tester) async {
      await tester.pumpWidget(_wrap(LocaleChip(locale: AppLocale.fr)));
      expect(find.text('Français'), findsOneWidget);
    });

    testWidgets('calls onSelected with the locale', (tester) async {
      AppLocale? selected;
      await tester.pumpWidget(_wrap(LocaleChip(
        locale: AppLocale.ur,
        onSelected: (locale) => selected = locale,
      )));
      await tester.tap(find.byType(LocaleChip));
      await tester.pumpAndSettle();
      expect(selected, AppLocale.ur);
    });
  });

  group('LocalePicker', () {
    testWidgets('groups RTL and LTR locales', (tester) async {
      await tester.pumpWidget(_wrap(LocalePicker(
        current: AppLocale.en,
        onChanged: (_) {},
      )));
      expect(find.text('Right-to-left languages'), findsOneWidget);
      expect(find.text('Left-to-right languages'), findsOneWidget);
      expect(find.byType(LocaleChip), findsNWidgets(6));
    });
  });

  group('LocalizationScope', () {
    testWidgets('applies RTL direction from the controller', (tester) async {
      final controller = LocaleController(AppLocale.ar);
      await tester.pumpWidget(MaterialApp(
        home: LocalizationScope(
          controller: controller,
          child: const DirectionalityAssertion(),
        ),
      ));
      expect(find.byType(DirectionalityAssertion), findsOneWidget);
    });
  });
}

class DirectionalityAssertion extends StatelessWidget {
  const DirectionalityAssertion({super.key});

  @override
  Widget build(BuildContext context) {
    assert(Directionality.of(context) == TextDirection.rtl);
    return const SizedBox.shrink();
  }
}
