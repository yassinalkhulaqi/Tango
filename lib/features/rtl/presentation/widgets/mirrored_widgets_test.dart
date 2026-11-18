import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tango/features/rtl/presentation/widgets/mirrored_widgets.dart';

Widget _wrap(TextDirection direction, Widget child) => MaterialApp(
      home: Directionality(textDirection: direction, child: child),
    );

void main() {
  group('MirroredPadding', () {
    testWidgets('maps start to left in LTR', (tester) async {
      late double left;
      late double right;
      await tester.pumpWidget(_wrap(TextDirection.ltr, Directionality(
        textDirection: TextDirection.ltr,
        child: MirroredPadding(
          start: 16,
          child: Builder(builder: (context) {
            final p = context.findAncestorWidgetOfExactType<Padding>()!.padding as EdgeInsets;
            left = p.left;
            right = p.right;
            return const SizedBox();
          }),
        ),
      )));
      expect(left, 16);
      expect(right, 0);
    });

    testWidgets('maps start to right in RTL', (tester) async {
      double? right;
      await tester.pumpWidget(_wrap(TextDirection.rtl, MirroredPadding(
        start: 16,
        child: Builder(builder: (context) {
          right = (context.findAncestorWidgetOfExactType<Padding>()!.padding as EdgeInsets).right;
          return const SizedBox();
        }),
      )));
      expect(right, 16);
    });
  });

  group('MirroredRow', () {
    testWidgets('keeps order in LTR', (tester) async {
      await tester.pumpWidget(_wrap(TextDirection.ltr, MirroredRow(
        children: const [Text('A'), Text('B')],
      )));
      expect(tester.widget<Text>(find.text('A')).data, 'A');
    });

    testWidgets('reverses order in RTL', (tester) async {
      await tester.pumpWidget(_wrap(TextDirection.rtl, MirroredRow(
        children: const [Text('A'), Text('B')],
      )));
      final row = tester.widget<Row>(find.byType(Row));
      expect((row.children[0] as Text).data, 'B');
    });
  });

  group('MirroredIcon', () {
    testWidgets('flips in RTL', (tester) async {
      await tester.pumpWidget(_wrap(TextDirection.rtl, const MirroredIcon(Icons.arrow_back)));
      expect(find.byType(Transform), findsOneWidget);
    });

    testWidgets('does not flip when disabled', (tester) async {
      await tester.pumpWidget(_wrap(TextDirection.rtl, const MirroredIcon(Icons.arrow_back, flipInRtl: false)));
      expect(find.byType(Transform), findsNothing);
    });
  });

  group('MirroredAccentCard', () {
    testWidgets('renders in RTL', (tester) async {
      await tester.pumpWidget(_wrap(TextDirection.rtl, MirroredAccentCard(
        accent: Colors.blue,
        child: const Text('card'),
      )));
      expect(find.text('card'), findsOneWidget);
    });
  });
}
