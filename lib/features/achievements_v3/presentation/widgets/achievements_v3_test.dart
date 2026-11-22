import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tango/features/achievements_v3/presentation/widgets/achievements_v3_widgets.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('achievement card shows name', (tester) async {
    await tester.pumpWidget(_wrap(const AchievementCardV3(name: 'First Commit', description: 'Complete a lesson', icon: '🚀', unlocked: true)));
    expect(find.text('First Commit'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });

  testWidgets('grid lays out cards', (tester) async {
    await tester.pumpWidget(_wrap(const AchievementGridV3(achievements: [
      AchievementCardV3(name: 'A', description: 'a', icon: '1', unlocked: true),
      AchievementCardV3(name: 'B', description: 'b', icon: '2', unlocked: false),
    ])));
    expect(find.byType(AchievementCardV3), findsNWidgets(2));
  });
}
