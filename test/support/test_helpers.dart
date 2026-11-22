import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Shared test helpers for pumping widgets in a MaterialApp with dark theme,
/// reducing boilerplate across feature test suites.
class TestPump {
  static Future<void> page(WidgetTester tester, Widget child, {Locale? locale}) async {
    await tester.pumpWidget(MaterialApp(
      locale: locale,
      theme: ThemeData.dark(),
      home: Scaffold(body: child),
    ));
  }

  static Future<void> sized(WidgetTester tester, Widget child, {Size size = const Size(400, 800)}) async {
    await tester.binding.setSurfaceSize(size);
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: SizedBox(width: size.width, height: size.height, child: child))));
  }
}

/// Matcher helpers for common assertions.
class TestMatchers {
  static Matcher rendersText(String text) => findsOneWidget;
  static Matcher rendersN(int count) => findsNWidgets(count);
}
