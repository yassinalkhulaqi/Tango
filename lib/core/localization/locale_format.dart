import 'app_locale.dart';

/// Locale-aware number and date formatting for Flutter screens.
///
/// Region-qualified tags are used so Arabic screens render Arabic-Indic digits.
/// Unknown values degrade to an em dash rather than a misleading zero.
abstract final class LocaleFormat {
  static const String unavailable = '\u2014';

  static String number(num? value, AppLocale locale, {int fractionDigits = 0}) {
    if (value == null || value.isNaN) return unavailable;
    final digits = locale == AppLocale.ar
        ? '٠١٢٣٤٥٦٧٨٩'
        : locale == AppLocale.ur
            ? '۰۱۲۳۴۵۶۷۸۹'
            : null;
    final formatted = value.toStringAsFixed(fractionDigits);
    if (digits == null) return formatted;
    return formatted.split('').map((char) {
      final code = char.codeUnitAt(0);
      if (code >= 48 && code <= 57) return digits[code - 48];
      return char;
    }).join();
  }

  static String percent(num? value, AppLocale locale, {int fractionDigits = 0}) =>
      value == null ? unavailable : '${number(value * 100, locale, fractionDigits: fractionDigits)}%';

  static String date(DateTime? value, AppLocale locale) {
    if (value == null) return unavailable;
    final day = number(value.day, locale);
    final month = number(value.month, locale);
    final year = number(value.year, locale);
    return locale.isRtl ? '$day/$month/$year' : '$day/$month/$year';
  }

  static String money(String? canonical, AppLocale locale, {String? currency, int minorDigits = 2}) {
    if (canonical == null || canonical.isEmpty) return unavailable;
    final negative = canonical.startsWith('-');
    final unsigned = negative ? canonical.substring(1) : canonical;
    final parts = unsigned.split('.');
    final integer = parts[0];
    final fraction = parts.length > 1 ? parts[1] : '';
    final padded = fraction.padRight(minorDigits, '0');
    final grouped = _group(integer);
    final amount = '${negative ? '-' : ''}${numberAsDigits(grouped, locale)}.${numberAsDigits(padded, locale)}';
    return currency == null ? amount : '$amount $currency';
  }

  static String numberAsDigits(String value, AppLocale locale) {
    final digits = locale == AppLocale.ar
        ? '٠١٢٣٤٥٦٧٨٩'
        : locale == AppLocale.ur
            ? '۰۱۲۳۴۵۶۷۸۹'
            : null;
    if (digits == null) return value;
    return value.split('').map((char) {
      final code = char.codeUnitAt(0);
      if (code >= 48 && code <= 57) return digits[code - 48];
      return char;
    }).join();
  }

  static String _group(String digits) {
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      final remaining = digits.length - i;
      buffer.write(digits[i]);
      if (remaining > 1 && (remaining - 1) % 3 == 0) buffer.write(',');
    }
    return buffer.toString();
  }
}
