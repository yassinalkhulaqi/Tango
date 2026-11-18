import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tango/core/localization/app_locale.dart';
import 'package:tango/core/localization/string_keys.dart';
import 'package:tango/core/localization/catalogues/ar.dart';
import 'package:tango/core/localization/catalogues/catalogue.dart';
import 'package:tango/core/localization/locale_controller.dart';

void main() {
  group('AppLocale', () {
    test('supports six languages including two RTL locales', () {
      expect(AppLocale.values.length, 6);
      expect(AppLocale.values.where((l) => l.isRtl).map((l) => l.code).toList(), ['ar', 'ur']);
    });

    test('parses language-only and regional codes', () {
      expect(AppLocale.fromCode('AR'), AppLocale.ar);
      expect(AppLocaleHelper.matchLanguage('fr-FR'), AppLocale.fr);
      expect(AppLocaleHelper.parseLanguageTag('ur-PK'), AppLocale.ur);
    });

    test('falls back to English for unknown codes', () {
      expect(AppLocale.fromCode('zz'), AppLocale.en);
    });

    test('provides Flutter locales for MaterialApp', () {
      expect(AppLocale.flutterLocales.map((l) => l.languageCode), contains('ar'));
      expect(AppLocale.flutterLocales.map((l) => l.languageCode), contains('ur'));
    });

    test('groups locales by direction', () {
      expect(AppLocaleHelper.ltrLocales.length, 4);
      expect(AppLocaleHelper.rtlLocales.length, 2);
    });

    test('exposes accessible names in native and English', () {
      expect(AppLocale.fr.accessibleName, contains('French'));
      expect(AppLocale.en.accessibleName, 'English');
    });
  });

  group('Translation catalogues', () {
    test('every locale catalogue is registered', () {
      for (final locale in AppLocale.values) {
        expect(translationCatalogues.containsKey(locale.code), isTrue, reason: locale.code);
      }
    });

    test('English catalogue contains every key', () {
      final completeness = completenessOf('en', englishStrings);
      expect(completeness.isComplete, isTrue, reason: completeness.missing.join(', '));
    });

    test('Arabic catalogue contains every key', () {
      final completeness = completenessOf('ar', arabicStrings);
      expect(completeness.isComplete, isTrue, reason: completeness.missing.join(', '));
    });

    test('each locale resolves to a catalogue', () {
      for (final locale in AppLocale.values) {
        expect(catalogueFor(locale).isNotEmpty, isTrue);
      }
    });

    test('all locales cover the same key set', () {
      for (final entry in translationCatalogues.entries) {
        expect(entry.value.keys.length, StringKeys.allKeys.length, reason: entry.key);
      }
    });
  });

  group('LocaleController', () {
    test('starts with the given locale', () {
      final controller = LocaleController(AppLocale.ar);
      expect(controller.code, 'ar');
      expect(controller.isRtl, isTrue);
    });

    test('notifies listeners on change', () {
      final controller = LocaleController();
      var notified = 0;
      controller.addListener(() => notified++);
      expect(controller.setLocale(AppLocale.fr), isTrue);
      expect(notified, 1);
    });

    test('does not notify for the same locale', () {
      final controller = LocaleController();
      var notified = 0;
      controller.addListener(() => notified++);
      expect(controller.setLocale(AppLocale.en), isFalse);
      expect(notified, 0);
    });

    test('sets locale by code', () {
      final controller = LocaleController();
      expect(controller.setCode('ur'), isTrue);
      expect(controller.locale, AppLocale.ur);
      expect(controller.direction, TextDirection.rtl);
    });
  });
}
