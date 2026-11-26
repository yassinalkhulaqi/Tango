import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tango/features/rtl_components/presentation/widgets/rtl_components.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('nav row shows label', (tester) async {
    await tester.pumpWidget(_wrap(RtlNavRow(label: 'Settings', onTap: () {})));
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('RTL nav row uses left chevron', (tester) async {
    await tester.pumpWidget(
      _wrap(RtlNavRow(label: 'Home', onTap: () {}, rtl: true)),
    );
    expect(find.byIcon(Icons.chevron_left_rounded), findsOneWidget);
  });

  testWidgets('tab bar renders tabs', (tester) async {
    await tester.pumpWidget(
      _wrap(
        RtlTabBar(
          labels: ['Weekly', 'All-time'],
          selected: 0,
          onChanged: (_) {},
        ),
      ),
    );
    expect(find.text('Weekly'), findsOneWidget);
    expect(find.text('All-time'), findsOneWidget);
  });

  testWidgets('tab bar responds to tap', (tester) async {
    int? selected;
    await tester.pumpWidget(
      _wrap(
        RtlTabBar(
          labels: ['A', 'B'],
          selected: 0,
          onChanged: (i) => selected = i,
        ),
      ),
    );
    await tester.tap(find.text('B'));
    expect(selected, 1);
  });
}
