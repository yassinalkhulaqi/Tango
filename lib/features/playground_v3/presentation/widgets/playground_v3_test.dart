import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tango/features/playground_v3/presentation/widgets/playground_v3_widgets.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: SizedBox(height: 300, child: child)));

void main() {
  testWidgets('editor shows language', (tester) async {
    await tester.pumpWidget(_wrap(EditorPaneV3(controller: TextEditingController(), language: 'Dart')));
    expect(find.text('Dart'), findsOneWidget);
  });

  testWidgets('output shows placeholder when empty', (tester) async {
    await tester.pumpWidget(_wrap(const OutputPaneV3(output: '')));
    expect(find.text('Run your code to see output here.'), findsOneWidget);
  });

  testWidgets('output shows result', (tester) async {
    await tester.pumpWidget(_wrap(const OutputPaneV3(output: 'Hello')));
    expect(find.text('Hello'), findsOneWidget);
  });
}
