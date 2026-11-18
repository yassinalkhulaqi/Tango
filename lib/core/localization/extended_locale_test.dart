import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tango/core/localization/extended_locale.dart';

void main() {
  group('ExtendedLocale', () {
    test('adds six new languages', () {
      expect(ExtendedLocale.values.length, 6);
    });

    test('parses codes case-insensitively', () {
      expect(ExtendedLocale.fromCode('DE'), ExtendedLocale.de);
      expect(ExtendedLocale.fromCode('ja'), ExtendedLocale.ja);
    });

    test('falls back safely', () {
      expect(ExtendedLocale.fromCode('zz'), ExtendedLocale.de);
    });

    test('provides Flutter locales', () {
      expect(ExtendedLocale.flutterLocales.map((l) => l.languageCode), contains('zh'));
    });

    test('checks support', () {
      expect(ExtendedLocale.isSupported('pt'), isTrue);
      expect(ExtendedLocale.isSupported('xx'), isFalse);
    });
  });

  group('CombinedLocales', () {
    test('lists twelve supported codes', () {
      expect(CombinedLocales.allCodes.length, 12);
    });

    test('separates RTL and LTR codes', () {
      expect(CombinedLocales.rtlCodes, ['ar', 'ur']);
      expect(CombinedLocales.ltrCodes.length, 10);
    });

    test('provides native names for every locale', () {
      for (final code in CombinedLocales.allCodes) {
        expect(CombinedLocales.nativeName(code).isNotEmpty, isTrue);
      }
    });

    test('provides formatting locales', () {
      expect(CombinedLocales.formattingLocale('ar'), 'ar-EG');
      expect(CombinedLocales.formattingLocale('ja'), 'ja-JP');
      expect(CombinedLocales.formattingLocale('zh'), 'zh-CN');
    });

    test('searches by native name and code', () {
      expect(CombinedLocales.search('fran'), contains('fr'));
      expect(CombinedLocales.search('de'), contains('de'));
    });

    test('returns all codes for an empty query', () {
      expect(CombinedLocales.search('').length, 12);
    });
  });
}
