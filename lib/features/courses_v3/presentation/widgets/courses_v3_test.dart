import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tango/features/courses_v3/presentation/widgets/course_card_v3.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('course card shows title and progress', (tester) async {
    await tester.pumpWidget(_wrap(const CourseCardV3(
      course: CourseV3(title: 'Flutter', category: 'Flutter', lessons: 24, progress: 0.5, icon: Icons.school, color: Colors.blue),
      onTap: () {},
    )));
    expect(find.text('Flutter'), findsOneWidget);
    expect(find.text('24 lessons'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });

  testWidgets('locked card is not tappable', (tester) async {
    var tapped = false;
    await tester.pumpWidget(_wrap(CourseCardV3(
      course: const CourseV3(title: 'Locked', category: 'AI', lessons: 9, progress: 0, icon: Icons.lock, color: Colors.grey, locked: true),
      onTap: () => tapped = true,
    )));
    await tester.tap(find.byType(GestureDetector));
    expect(tapped, isFalse);
  });
}
