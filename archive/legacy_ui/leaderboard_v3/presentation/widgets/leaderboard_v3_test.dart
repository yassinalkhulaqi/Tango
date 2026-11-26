import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tango/features/leaderboard_v3/presentation/widgets/leaderboard_v3_widget.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('shows rank, name and xp', (tester) async {
    await tester.pumpWidget(_wrap(const LeaderboardRowV3(rank: 1, name: 'Alex', avatar: 'A', xp: 18400)));
    expect(find.text('1'), findsOneWidget);
    expect(find.text('Alex'), findsOneWidget);
    expect(find.text('18400 XP'), findsOneWidget);
  });

  testWidgets('highlights current user', (tester) async {
    await tester.pumpWidget(_wrap(const LeaderboardRowV3(rank: 5, name: 'You', avatar: 'Y', xp: 8900, isCurrentUser: true)));
    expect(find.text('You'), findsOneWidget);
  });
}
