import 'package:flutter_test/flutter_test.dart';
import 'package:tango/core/localization/app_locale.dart';
import 'package:tango/core/localization/locale_format.dart';

void main() {
  group('LocaleFormat.number', () {
    test('formats Western digits for English', () {
      expect(LocaleFormat.number(1234, AppLocale.en), '1234');
    });
    test('formats Arabic-Indic digits for Arabic', () {
      expect(LocaleFormat.number(123, AppLocale.ar), '١٢٣');
    });
    test('formats Persian digits for Urdu', () {
      expect(LocaleFormat.number(123, AppLocale.ur), '۱۲۳');
    });
    test('degrades unknown values', () {
      expect(LocaleFormat.number(null, AppLocale.en), '\u2014');
    });
    test('supports fraction digits', () {
      expect(LocaleFormat.number(1.5, AppLocale.en, fractionDigits: 2), '1.50');
    });
  });

  group('LocaleFormat.percent', () {
    test('formats a ratio', () {
      expect(LocaleFormat.percent(0.5, AppLocale.en), '50%');
    });
    test('degrades unknown values', () {
      expect(LocaleFormat.percent(null, AppLocale.en), '\u2014');
    });
  });

  group('LocaleFormat.money', () {
    test('groups integer digits', () {
      expect(LocaleFormat.money('1234567.89', AppLocale.en), '1,234,567.89');
    });
    test('pads minor digits', () {
      expect(LocaleFormat.money('12.5', AppLocale.en), '12.50');
    });
    test('keeps the sign', () {
      expect(LocaleFormat.money('-12.50', AppLocale.en), '-12.50');
    });
    test('localises digits for Arabic', () {
      expect(LocaleFormat.money('12.50', AppLocale.ar), contains('١٢.٥٠'));
    });
    test('adds an explicit currency', () {
      expect(
        LocaleFormat.money('10.00', AppLocale.en, currency: 'YER'),
        '10.00 YER',
      );
    });
    test('degrades unknown values', () {
      expect(LocaleFormat.money(null, AppLocale.en), '\u2014');
    });
  });

  group('LocaleFormat.date', () {
    test('formats a date', () {
      expect(
        LocaleFormat.date(DateTime(2026, 3, 15), AppLocale.en),
        '15/3/2026',
      );
    });
    test('degrades null', () {
      expect(LocaleFormat.date(null, AppLocale.en), '\u2014');
    });
  });
}
