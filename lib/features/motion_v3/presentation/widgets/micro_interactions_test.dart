import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tango/features/motion_v3/presentation/widgets/micro_interactions.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('PressScale handles tap', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      _wrap(PressScale(onTap: () => tapped = true, child: const Text('Press'))),
    );
    await tester.tap(find.text('Press'));
    expect(tapped, isTrue);
  });

  testWidgets('StaggerIn renders child', (tester) async {
    await tester.pumpWidget(
      _wrap(const StaggerIn(index: 1, child: Text('Item'))),
    );
    await tester.pumpAndSettle();
    expect(find.text('Item'), findsOneWidget);
  });
}
