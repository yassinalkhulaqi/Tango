import 'package:flutter/material.dart';

/// Extended locale registry adding six more languages to the foundation's
/// original six, for twelve supported locales in total.
enum ExtendedLocale {
  de('de', 'Deutsch', 'German', 'de-DE', TextDirection.ltr),
  it('it', 'Italiano', 'Italian', 'it-IT', TextDirection.ltr),
  pt('pt', 'Português', 'Portuguese', 'pt-PT', TextDirection.ltr),
  ru('ru', 'Русский', 'Russian', 'ru-RU', TextDirection.ltr),
  zh('zh', '中文', 'Chinese', 'zh-CN', TextDirection.ltr),
  ja('ja', '日本語', 'Japanese', 'ja-JP', TextDirection.ltr);

  final String code;
  final String nativeName;
  final String englishName;
  final String formattingLocale;
  final TextDirection direction;

  const ExtendedLocale(this.code, this.nativeName, this.englishName,
      this.formattingLocale, this.direction);

  static ExtendedLocale fromCode(String code) => ExtendedLocale.values.firstWhere(
        (locale) => locale.code == code.toLowerCase(),
        orElse: () => ExtendedLocale.de,
      );

  static bool isSupported(String code) =>
      ExtendedLocale.values.any((l) => l.code == code.toLowerCase());

  static List<String> get codes =>
      ExtendedLocale.values.map((l) => l.code).toList();

  static List<Locale> get flutterLocales =>
      ExtendedLocale.values.map((l) => Locale(l.code)).toList();
}

/// Combined locale list used by the expanded language picker.
class CombinedLocales {
  const CombinedLocales._();

  static const List<String> allCodes = [
    'en', 'ar', 'fr', 'es', 'tr', 'ur', 'de', 'it', 'pt', 'ru', 'zh', 'ja',
  ];

  static const List<String> rtlCodes = ['ar', 'ur'];

  static const List<String> ltrCodes = [
    'en', 'fr', 'es', 'tr', 'de', 'it', 'pt', 'ru', 'zh', 'ja',
  ];

  static bool isRtl(String code) => rtlCodes.contains(code);

  static String formattingLocale(String code) {
    switch (code) {
      case 'ar':
        return 'ar-EG';
      case 'ur':
        return 'ur-PK';
      case 'zh':
        return 'zh-CN';
      case 'ja':
        return 'ja-JP';
      case 'pt':
        return 'pt-PT';
      default:
        return '$code-${code.toUpperCase()}';
    }
  }

  static String nativeName(String code) {
    const names = {
      'en': 'English', 'ar': 'العربية', 'fr': 'Français', 'es': 'Español',
      'tr': 'Türkçe', 'ur': 'اردو', 'de': 'Deutsch', 'it': 'Italiano',
      'pt': 'Português', 'ru': 'Русский', 'zh': '中文', 'ja': '日本語',
    };
    return names[code] ?? code.toUpperCase();
  }

  static List<String> search(String query) {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) return allCodes;
    return allCodes.where((code) {
      return nativeName(code).toLowerCase().contains(needle) ||
          code.contains(needle);
    }).toList();
  }
}
