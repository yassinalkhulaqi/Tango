import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tango/features/dashboard_v3/presentation/pages/dashboard_v3_page.dart';
import 'package:tango/features/dashboard_v3/presentation/widgets/dashboard_tiles.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('renders greeting and name', (tester) async {
    await tester.pumpWidget(_wrap(const DashboardGreeting(greeting: 'Welcome back', name: 'Alex', level: 'Lv 7', avatar: 'A')));
    expect(find.text('Alex'), findsOneWidget);
    expect(find.text('Welcome back'), findsOneWidget);
  });

  testWidgets('renders four quick stats', (tester) async {
    await tester.pumpWidget(_wrap(const DashboardV3Page(greeting: 'Hi', name: 'Alex', level: 'Lv 7', avatar: 'A')));
    expect(find.byType(QuickStatTile), findsNWidgets(4));
    expect(find.text('48'), findsOneWidget);
  });
}
