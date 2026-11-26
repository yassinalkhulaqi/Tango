import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tango/features/profile_settings_v3/presentation/widgets/settings_v3_widgets.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('settings group renders title and tiles', (tester) async {
    await tester.pumpWidget(_wrap(const SettingsGroupV3(
      title: 'Preferences',
      items: [SettingsTileV3(icon: Icons.language, title: 'Language')],
    )));
    expect(find.text('Preferences'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
  });

  testWidgets('tile responds to tap', (tester) async {
    var tapped = false;
    await tester.pumpWidget(_wrap(SettingsTileV3(icon: Icons.logout, title: 'Sign out', onTap: () => tapped = true)));
    await tester.tap(find.byType(ListTile));
    expect(tapped, isTrue);
  });
}
