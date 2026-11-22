import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_helpers.dart';

void main() {
  testWidgets('TestPump.page renders widget', (tester) async {
    await TestPump.page(tester, const Text('Hello'));
    expect(find.text('Hello'), findsOneWidget);
  });

  testWidgets('TestPump.sized renders in given size', (tester) async {
    await TestPump.sized(tester, const Text('Sized'));
    expect(find.text('Sized'), findsOneWidget);
  });

  test('TestMatchers helpers', () {
    expect(TestMatchers.rendersText('x'), findsOneWidget);
    expect(TestMatchers.rendersN(2), findsNWidgets(2));
  });
}
