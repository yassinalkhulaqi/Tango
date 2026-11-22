import '../../app_locale.dart';

/// Extended formatting helpers for dates, relative time and plural-aware counts.
abstract final class FormattingExtended {
  static const unavailable = '\u2014';

  static String relativeTime(Duration delta, AppLocale locale) {
    final seconds = delta.inSeconds.abs();
    final future = delta.inSeconds > 0;
    final (value, unit) = _pickUnit(seconds);
    final prefix = locale.isRtl ? '' : (future ? 'in ' : '');
    final suffix = locale.isRtl ? (future ? ' لاحقاً' : ' مضت') : (future ? '' : ' ago');
    return '$prefix$value $unit$suffix';
  }

  static (int, String) _pickUnit(int seconds) {
    if (seconds >= 31536000) return (seconds ~/ 31536000, 'year');
    if (seconds >= 2592000) return (seconds ~/ 2592000, 'month');
    if (seconds >= 604800) return (seconds ~/ 604800, 'week');
    if (seconds >= 86400) return (seconds ~/ 86400, 'day');
    if (seconds >= 3600) return (seconds ~/ 3600, 'hour');
    if (seconds >= 60) return (seconds ~/ 60, 'minute');
    return (seconds, 'second');
  }

  static String pluralCount(int count, AppLocale locale, String one, String other) {
    if (locale == AppLocale.ar) {
      if (count == 0) return 'لا $other';
      if (count == 1) return one;
      if (count == 2) return '$one (اثنان)';
      if (count >= 3 && count <= 10) return '$count $other';
      return '$count $other';
    }
    return count == 1 ? '1 $one' : '$count $other';
  }

  static String initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    return parts.map((p) => p.isNotEmpty ? p[0] : '').take(2).join().toUpperCase();
  }
}
