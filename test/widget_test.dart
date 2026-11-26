import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tango/app/app.dart';

void main() {
  testWidgets('App launches onboarding', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: CodeBroApp()));
    await tester.pump();

    expect(find.byType(CodeBroApp), findsOneWidget);
  });
}
