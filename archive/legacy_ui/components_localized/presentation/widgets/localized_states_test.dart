import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tango/core/localization/app_locale.dart';
import 'package:tango/features/components_localized/presentation/widgets/localized_states.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('LocalizedStateView', () {
    testWidgets('shows spinner for loading', (tester) async {
      await tester.pumpWidget(_wrap(const LocalizedStateView(locale: AppLocale.en, kind: StateKind.loading)));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows message and retry for error', (tester) async {
      var retried = false;
      await tester.pumpWidget(_wrap(LocalizedStateView(
        locale: AppLocale.en,
        kind: StateKind.error,
        title: 'Something went wrong',
        message: 'Please try again',
        onRetry: () => retried = true,
      )));
      expect(find.text('Something went wrong'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      expect(retried, isTrue);
    });

    testWidgets('shows empty icon', (tester) async {
      await tester.pumpWidget(_wrap(const LocalizedStateView(locale: AppLocale.en, kind: StateKind.empty)));
      expect(find.byIcon(Icons.inbox_rounded), findsOneWidget);
    });
  });

  group('LocalizedStatusBadge', () {
    testWidgets('renders label', (tester) async {
      await tester.pumpWidget(_wrap(const LocalizedStatusBadge(label: 'Completed', tone: StatusTone.success)));
      expect(find.text('Completed'), findsOneWidget);
    });

    testWidgets('renders icon and label', (tester) async {
      await tester.pumpWidget(_wrap(const LocalizedStatusBadge(label: 'Locked', icon: Icons.lock_rounded)));
      expect(find.byIcon(Icons.lock_rounded), findsOneWidget);
    });
  });

  group('LocalizedMoneyRow', () {
    testWidgets('formats money with currency', (tester) async {
      await tester.pumpWidget(_wrap(const LocalizedMoneyRow(
        label: 'Total',
        amount: '1234.50',
        locale: AppLocale.en,
        currency: 'YER',
      )));
      expect(find.text('Total'), findsOneWidget);
      expect(find.textContaining('YER'), findsOneWidget);
    });

    testWidgets('localizes digits for Arabic', (tester) async {
      await tester.pumpWidget(_wrap(const LocalizedMoneyRow(
        label: 'الإجمالي',
        amount: '1234.50',
        locale: AppLocale.ar,
      )));
      expect(find.text('الإجمالي'), findsOneWidget);
    });
  });
}
