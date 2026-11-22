import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tango/features/lesson_v3/presentation/widgets/lesson_v3_widgets.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('stepper renders segments', (tester) async {
    await tester.pumpWidget(_wrap(const LessonStepperV3(total: 5, current: 2)));
    expect(find.byType(Container), findsNWidgets(5));
  });

  testWidgets('code block shows line numbers', (tester) async {
    await tester.pumpWidget(_wrap(const CodeBlockV3(code: 'line1\nline2', label: 'Example')));
    expect(find.text('Example'), findsOneWidget);
    expect(find.byType(SelectableText), findsOneWidget);
  });
}
