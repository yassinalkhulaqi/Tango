import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tango/features/splash/presentation/pages/premium_splash_screen.dart';
import 'package:tango/features/splash/presentation/widgets/splash_mark.dart';
import 'package:tango/features/splash/presentation/widgets/shimmer_loading.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('SplashMark', () {
    testWidgets('renders terminal glyph', (tester) async {
      await tester.pumpWidget(_wrap(const SplashMark()));
      expect(find.byIcon(Icons.terminal_rounded), findsOneWidget);
    });

    testWidgets('respects reduced motion', (tester) async {
      await tester.pumpWidget(_wrap(const SplashMark(reducedMotion: true)));
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull);
    });
  });

  group('PremiumSplashScreen', () {
    testWidgets('shows brand and tagline', (tester) async {
      await tester.pumpWidget(const PremiumSplashScreen(
        brandName: 'CodeBro',
        tagline: 'Learn by building',
      ));
      expect(find.text('CodeBro'), findsOneWidget);
      expect(find.text('Learn by building'), findsOneWidget);
    });

    testWidgets('calls onReady after hold', (tester) async {
      var ready = false;
      await tester.pumpWidget(PremiumSplashScreen(
        brandName: 'CodeBro',
        hold: const Duration(milliseconds: 50),
        onReady: () => ready = true,
      ));
      await tester.pump(const Duration(milliseconds: 100));
      expect(ready, isTrue);
    });
  });

  group('ShimmerBlock', () {
    testWidgets('renders a block', (tester) async {
      await tester.pumpWidget(_wrap(const ShimmerBlock(width: 100, height: 20)));
      expect(find.byType(ShimmerBlock), findsOneWidget);
    });

    testWidgets('disables when told', (tester) async {
      await tester.pumpWidget(_wrap(const ShimmerBlock(width: 100, height: 20, enabled: false)));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  group('SkeletonTable', () {
    testWidgets('labeled for screen readers', (tester) async {
      await tester.pumpWidget(_wrap(const SkeletonTable(label: 'Loading payments')));
      expect(find.bySemanticsLabel('Loading payments'), findsOneWidget);
    });
  });
}
