import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tango/features/quiz_v3/presentation/widgets/quiz_v3_widgets.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('option responds to tap', (tester) async {
    var tapped = false;
    await tester.pumpWidget(_wrap(QuizOptionV3(text: 'Flutter', selected: false, correct: false, revealed: false, onTap: () => tapped = true)));
    await tester.tap(find.byType(GestureDetector));
    expect(tapped, isTrue);
  });

  testWidgets('result shows score', (tester) async {
    await tester.pumpWidget(_wrap(const QuizResultV3(score: 3, total: 5)));
    expect(find.text('3 / 5'), findsOneWidget);
  });
}
