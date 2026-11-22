import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tango/features/responsive/presentation/widgets/responsive_layout.dart';

void main() {
  group('Breakpoints', () {
    test('phone below 600', () => expect(Breakpoints.isPhone(400), isTrue));
    test('tablet 600-840', () => expect(Breakpoints.isTablet(700), isTrue));
    test('desktop above 840', () => expect(Breakpoints.isDesktop(1000), isTrue));
  });

  testWidgets('responsive layout selects desktop builder', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SizedBox(
        width: 1000,
        child: ResponsiveLayout(
          phoneBuilder: (_, __) => const Text('phone'),
          desktopBuilder: (_, __) => const Text('desktop'),
        ),
      ),
    ));
    expect(find.text('desktop'), findsOneWidget);
  });

  testWidgets('responsive grid renders children', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: SizedBox(width: 400, child: ResponsiveGrid(children: [Text('A'), Text('B')])),
    ));
    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
  });
}
