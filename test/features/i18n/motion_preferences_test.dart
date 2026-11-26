import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tango/core/a11y/motion_preferences.dart';

void main() {
  testWidgets('reduced motion disables durations and curves', (tester) async {
    late bool reduced;

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Builder(
            builder: (context) {
              reduced = AppMotionPreferences.reduced(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );

    expect(reduced, isTrue);
  });

  testWidgets('duration is zero when animations are disabled', (tester) async {
    late Duration duration;

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: Builder(
          builder: (context) {
            duration = AppMotionPreferences.duration(
              context,
              const Duration(milliseconds: 400),
            );
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(duration, Duration.zero);
  });

  test('semantic labels are readable by screen readers', () {
    expect(SemanticLabels.counter('XP', 1200), 'XP: 1200');
    expect(SemanticLabels.action('Open', 'profile'), 'Open profile');
    expect(SemanticLabels.progress('Lessons', 2, 5), 'Lessons: 2 of 5');
  });
}
