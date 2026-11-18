import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tango/features/design_v2/presentation/widgets/premium_widgets.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('PremiumButton', () {
    testWidgets('renders its label', (tester) async {
      await tester.pumpWidget(_wrap(const PremiumButton(label: 'Login')));
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('shows a spinner when loading', (tester) async {
      await tester.pumpWidget(_wrap(const PremiumButton(label: 'Login', isLoading: true)));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Login'), findsNothing);
    });

    testWidgets('disables onPressed while loading', (tester) async {
      var taps = 0;
      await tester.pumpWidget(_wrap(PremiumButton(
        label: 'Login',
        isLoading: true,
        onPressed: () => taps++,
      )));
      await tester.tap(find.byType(ElevatedButton));
      expect(taps, 0);
    });

    testWidgets('calls onPressed when enabled', (tester) async {
      var taps = 0;
      await tester.pumpWidget(_wrap(PremiumButton(
        label: 'Login',
        onPressed: () => taps++,
      )));
      await tester.tap(find.byType(ElevatedButton));
      expect(taps, 1);
    });
  });

  group('PremiumCard', () {
    testWidgets('shows title and subtitle', (tester) async {
      await tester.pumpWidget(_wrap(const PremiumCard(
        title: 'Flutter Basics',
        subtitle: '24 lessons',
      )));
      expect(find.text('Flutter Basics'), findsOneWidget);
      expect(find.text('24 lessons'), findsOneWidget);
    });

    testWidgets('handles taps', (tester) async {
      var taps = 0;
      await tester.pumpWidget(_wrap(PremiumCard(
        title: 'Course',
        onTap: () => taps++,
      )));
      await tester.tap(find.byType(InkWell));
      expect(taps, 1);
    });
  });

  group('SectionHeader', () {
    testWidgets('renders action', (tester) async {
      await tester.pumpWidget(_wrap(SectionHeader(
        title: 'Explore',
        actionLabel: 'See All',
        onAction: () {},
      )));
      expect(find.text('Explore'), findsOneWidget);
      expect(find.text('See All'), findsOneWidget);
    });
  });
}
