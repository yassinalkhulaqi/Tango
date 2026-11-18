import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tango/core/localization/app_locale.dart';
import 'package:tango/core/localization/directional_layout.dart';

void main() {
  group('DirectionalLayout', () {
    test('maps start padding to left in LTR', () {
      final padding = DirectionalLayout.directionalPadding(start: 16, direction: TextDirection.ltr);
      expect(padding.left, 16);
      expect(padding.right, 0);
    });

    test('maps start padding to right in RTL', () {
      final padding = DirectionalLayout.directionalPadding(start: 16, direction: TextDirection.rtl);
      expect(padding.right, 16);
      expect(padding.left, 0);
    });

    test('maps end padding correctly', () {
      final ltr = DirectionalLayout.directionalPadding(end: 8, direction: TextDirection.ltr);
      final rtl = DirectionalLayout.directionalPadding(end: 8, direction: TextDirection.rtl);
      expect(ltr.right, 8);
      expect(rtl.left, 8);
    });

    test('resolves alignments', () {
      expect(DirectionalLayout.alignment('start'), AlignmentDirectional.centerStart);
      expect(DirectionalLayout.alignment('end'), AlignmentDirectional.centerEnd);
    });

    test('resolves text alignment', () {
      expect(DirectionalLayout.textAlign(TextDirection.ltr), TextAlign.left);
      expect(DirectionalLayout.textAlign(TextDirection.rtl), TextAlign.right);
      expect(DirectionalLayout.textAlign(TextDirection.rtl, centered: true), TextAlign.center);
    });

    test('flips navigation icons in RTL', () {
      expect(DirectionalLayout.flipIcon(Icons.arrow_back, TextDirection.rtl), isTrue);
      expect(DirectionalLayout.flipIcon(Icons.arrow_back, TextDirection.ltr), isFalse);
      expect(DirectionalLayout.flipIcon(Icons.home, TextDirection.rtl), isFalse);
    });

    test('provides a sign helper for offsets', () {
      expect(DirectionalLayout.sign(TextDirection.ltr), 1.0);
      expect(DirectionalLayout.sign(TextDirection.rtl), -1.0);
      expect(DirectionalLayout.offset(10, TextDirection.rtl).dx, -10);
    });

    test('reads direction from locale', () {
      expect(DirectionalLayout.directionFor(AppLocale.ar), TextDirection.rtl);
      expect(DirectionalLayout.directionFor(AppLocale.fr), TextDirection.ltr);
    });
  });
}
