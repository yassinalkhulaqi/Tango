import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tango/features/onboarding_extended/presentation/pages/extended_onboarding_page.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('starts on skill step with disabled next', (tester) async {
    await tester.pumpWidget(_wrap(ExtendedOnboardingPage(
      skillsLabel: ['What do you want to learn?', 'Pick at least one'],
      goalsLabel: ['Daily goal', 'Pick a goal'],
      onFinish: () {},
    )));
    expect(find.text('Next'), findsOneWidget);
    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('enables next after selecting a skill', (tester) async {
    await tester.pumpWidget(_wrap(ExtendedOnboardingPage(
      skillsLabel: ['Skills', 'Pick one'],
      goalsLabel: ['Goal', 'Pick one'],
      onFinish: () {},
    )));
    await tester.tap(find.byType(FilterChip).first);
    await tester.pumpAndSettle();
    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('advances to goal step', (tester) async {
    await tester.pumpWidget(_wrap(ExtendedOnboardingPage(
      skillsLabel: ['Skills', 'Pick one'],
      goalsLabel: ['Daily goal', 'Pick a goal'],
      onFinish: () {},
    )));
    await tester.tap(find.byType(FilterChip).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Daily goal'), findsOneWidget);
  });

  testWidgets('calls finish after skill and goal selected', (tester) async {
    var finished = false;
    await tester.pumpWidget(_wrap(ExtendedOnboardingPage(
      skillsLabel: ['Skills', 'Pick one'],
      goalsLabel: ['Goal', 'Pick one'],
      onFinish: () => finished = true,
    )));
    await tester.tap(find.byType(FilterChip).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ListTile).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Finish'));
    expect(finished, isTrue);
  });
}
