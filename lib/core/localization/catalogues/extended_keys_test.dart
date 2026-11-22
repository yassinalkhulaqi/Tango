import 'package:flutter_test/flutter_test.dart';
import 'package:tango/core/localization/catalogues/extended_keys.dart';

void main() {
  test('extended keys list is complete', () {
    expect(ExtendedKeys.all.length, 16);
  });

  test('English catalogue has all keys', () {
    for (final key in ExtendedKeys.all) {
      expect(extendedEnglish.containsKey(key), isTrue, reason: key);
    }
  });

  test('Arabic catalogue has all keys', () {
    for (final key in ExtendedKeys.all) {
      expect(extendedArabic.containsKey(key), isTrue, reason: key);
    }
  });

  test('resolves catalogue by code', () {
    expect(extendedCatalogue('ar'), extendedArabic);
    expect(extendedCatalogue('en'), extendedEnglish);
    expect(extendedCatalogue('fr'), extendedEnglish);
  });
}
