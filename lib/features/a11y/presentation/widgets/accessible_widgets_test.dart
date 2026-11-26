import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tango/features/a11y/presentation/widgets/accessible_widgets.dart';

void main() {
  group('A11y helpers', () {
    test(
      'icon button label',
      () => expect(A11y.iconButtonLabel('Delete', 'course'), 'Delete course'),
    );
    test('progress hint', () => expect(A11y.progressHint(3, 5), '3 of 5'));
    test('nav label', () => expect(A11y.navLabel('Home'), 'Go to Home'));
  });

  testWidgets('icon button has semantic label', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AccessibleIconButton(
          icon: Icons.delete,
          label: 'Delete course',
          onPressed: () {},
        ),
      ),
    );
    expect(find.bySemanticsLabel('Delete course'), findsOneWidget);
  });

  testWidgets('progress announces value', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AccessibleProgress(value: 0.5, label: 'Course progress'),
      ),
    );
    expect(find.bySemanticsLabel('Course progress'), findsOneWidget);
  });
}
