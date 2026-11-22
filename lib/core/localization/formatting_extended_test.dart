import 'package:flutter_test/flutter_test.dart';
import 'package:tango/core/localization/app_locale.dart';
import 'package:tango/core/localization/formatting_extended.dart';

void main() {
  group('relativeTime', () {
    test('English past', () => expect(FormattingExtended.relativeTime(const Duration(hours: -2), AppLocale.en), contains('ago')));
    test('English future', () => expect(FormattingExtended.relativeTime(const Duration(hours: 2), AppLocale.en), contains('in')));
    test('Arabic has suffix', () => expect(FormattingExtended.relativeTime(const Duration(hours: -2), AppLocale.ar), contains('مضت')));
    test('picks days', () {
      final (v, u) = FormattingExtended._pickUnit(172800);
      expect(v, 2);
      expect(u, 'day');
    });
  });

  group('pluralCount', () {
    test('English singular/plural', () {
      expect(FormattingExtended.pluralCount(1, AppLocale.en, 'lesson', 'lessons'), '1 lesson');
      expect(FormattingExtended.pluralCount(3, AppLocale.en, 'lesson', 'lessons'), '3 lessons');
    });
    test('Arabic zero form', () {
      expect(FormattingExtended.pluralCount(0, AppLocale.ar, 'درس', 'دروس'), contains('لا'));
    });
  });

  test('initials', () => expect(FormattingExtended.initials('Alex Rivera'), 'AR'));
}
