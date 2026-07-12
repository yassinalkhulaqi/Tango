import 'package:flutter_test/flutter_test.dart';

import 'package:tango/main.dart';

void main() {
  testWidgets('App launches onboarding', (WidgetTester tester) async {
    await tester.pumpWidget(const CodeBroApp());
    await tester.pumpAndSettle();

    expect(find.text('Welcome to CodeBro'), findsOneWidget);
  });
}
