import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tango/app/app.dart';
import 'package:tango/app/flavors.dart';

void main() {
  test('flavor resolves from a compile-time define', () {
    expect(AppFlavor.from('prod'), AppFlavor.prod);
    expect(AppFlavor.from('staging'), AppFlavor.staging);
    expect(AppFlavor.from('unknown'), AppFlavor.dev);
    expect(AppFlavor.dev.apiBaseUrl, contains('/api/v1'));
  });

  testWidgets('app shell boots inside ProviderScope', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: CodeBroApp()));
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
