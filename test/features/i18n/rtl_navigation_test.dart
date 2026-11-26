import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tango/features/rtl/presentation/widgets/rtl_navigation.dart';

void main() {
  testWidgets('MirroredNavRow reverses children in RTL', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.rtl,
        child: MirroredNavRow(children: [Text('first'), Text('second')]),
      ),
    );

    final first = tester.getTopLeft(find.text('first'));
    final second = tester.getTopLeft(find.text('second'));
    expect(first.dx, greaterThan(second.dx));
  });

  testWidgets('MirroredNavRow keeps order in LTR', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: MirroredNavRow(children: [Text('first'), Text('second')]),
      ),
    );

    final first = tester.getTopLeft(find.text('first'));
    final second = tester.getTopLeft(find.text('second'));
    expect(first.dx, lessThan(second.dx));
  });

  testWidgets('MirroredBottomSheet swaps horizontal padding in RTL', (
    tester,
  ) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.rtl,
        child: MirroredBottomSheet(
          padding: EdgeInsets.only(left: 8, right: 24),
          child: SizedBox.shrink(),
        ),
      ),
    );

    final paddings = tester.widgetList<Padding>(find.byType(Padding));
    expect(
      paddings.any(
        (padding) =>
            padding.padding == const EdgeInsets.only(left: 24, right: 8),
      ),
      isTrue,
    );
  });
}
