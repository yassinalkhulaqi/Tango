import 'package:flutter/material.dart';

/// Supported application locales with the metadata the shell needs.
///
/// Language-only tags are used in routes and storage; a region-qualified tag
/// is used for number and date formatting so Arabic screens render
/// Arabic-Indic digits instead of Western ones.
enum AppLocale {
  en('en', 'English', 'English', 'en-US', TextDirection.ltr),
  ar('ar', 'العربية', 'Arabic', 'ar-EG', TextDirection.rtl),
  fr('fr', 'Français', 'French', 'fr-FR', TextDirection.ltr),
  es('es', 'Español', 'Spanish', 'es-ES', TextDirection.ltr),
  tr('tr', 'Türkçe', 'Turkish', 'tr-TR', TextDirection.ltr),
  ur('ur', 'اردو', 'Urdu', 'ur-PK', TextDirection.rtl);

  final String code;
  final String nativeName;
  final String englishName;
  final String formattingLocale;
  final TextDirection direction;

  const AppLocale(
    this.code,
    this.nativeName,
    this.englishName,
    this.formattingLocale,
    this.direction,
  );

  bool get isRtl => direction == TextDirection.rtl;

  static AppLocale fromCode(String? code) {
    if (code == null) return AppLocale.en;
    return AppLocale.values.firstWhere(
      (locale) => locale.code == code.toLowerCase(),
      orElse: () => AppLocale.en,
    );
  }

  static List<Locale> get flutterLocales =>
      AppLocale.values.map((locale) => Locale(locale.code)).toList();

  static List<Locale> get supportedLocales => flutterLocales;

  String get accessibleName =>
      nativeName == englishName ? nativeName : '$nativeName ($englishName)';

  @override
  String toString() => code;
}

/// Helpers for working with [AppLocale] values.
class AppLocaleHelper {
  const AppLocaleHelper._();

  static AppLocale matchLanguage(String? languageCode) {
    if (languageCode == null) return AppLocale.en;
    final normalized = languageCode.split('-').first.toLowerCase();
    return AppLocale.fromCode(normalized);
  }

  static List<AppLocale> byDirection(TextDirection direction) =>
      AppLocale.values.where((locale) => locale.direction == direction).toList();

  static List<AppLocale> get rtlLocales => byDirection(TextDirection.rtl);

  static List<AppLocale> get ltrLocales => byDirection(TextDirection.ltr);

  static String toLanguageTag(AppLocale locale) => locale.formattingLocale;

  static AppLocale parseLanguageTag(String tag) => AppLocale.fromCode(
        tag.split('-').first,
      );

  static bool isSupported(String code) =>
      AppLocale.values.any((locale) => locale.code == code.toLowerCase());

  static List<String> get codes =>
      AppLocale.values.map((locale) => locale.code).toList();

  static Map<String, AppLocale> get byCodeMap => {
        for (final locale in AppLocale.values) locale.code: locale,
      };
}
