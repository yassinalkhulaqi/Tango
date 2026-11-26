import 'package:flutter/material.dart';
import './app_locale.dart';

/// Logical-direction helpers so layouts mirror automatically for Arabic/Urdu.
///
/// Physical `left`/`right` values are never used: every padding, alignment and
/// border side is resolved through these helpers, which return logical values.
abstract final class DirectionalLayout {
  static EdgeInsets directionalPadding({
    double start = 0,
    double end = 0,
    double top = 0,
    double bottom = 0,
    required TextDirection direction,
  }) {
    final ltr = EdgeInsets.only(
      left: start,
      right: end,
      top: top,
      bottom: bottom,
    );
    final rtl = EdgeInsets.only(
      right: start,
      left: end,
      top: top,
      bottom: bottom,
    );
    return direction == TextDirection.rtl ? rtl : ltr;
  }

  static AlignmentDirectional alignment(String position) {
    switch (position) {
      case 'start':
        return AlignmentDirectional.centerStart;
      case 'end':
        return AlignmentDirectional.centerEnd;
      case 'topStart':
        return AlignmentDirectional.topStart;
      case 'bottomStart':
        return AlignmentDirectional.bottomStart;
      default:
        return AlignmentDirectional.center;
    }
  }

  static BorderRadius borderRadius(String corner, {double radius = 8}) {
    const ltr = BorderRadius.only(
      topLeft: Radius.circular(8),
      bottomLeft: Radius.circular(8),
    );
    const rtl = BorderRadius.only(
      topRight: Radius.circular(8),
      bottomRight: Radius.circular(8),
    );
    return corner == 'start' ? ltr : rtl;
  }

  static TextAlign textAlign(TextDirection direction, {bool centered = false}) {
    if (centered) return TextAlign.center;
    return direction == TextDirection.rtl ? TextAlign.right : TextAlign.left;
  }

  static bool flipIcon(IconData icon, TextDirection direction) =>
      direction == TextDirection.rtl &&
      {
        Icons.arrow_back,
        Icons.arrow_forward,
        Icons.chevron_left,
        Icons.chevron_right,
      }.contains(icon);

  static double sign(TextDirection direction) =>
      direction == TextDirection.rtl ? -1.0 : 1.0;

  static Offset offset(double x, TextDirection direction) =>
      Offset(x * sign(direction), 0);

  static EdgeInsets hintPadding(TextDirection direction) =>
      directionalPadding(start: 12, end: 12, direction: direction);

  static TextDirection directionFor(AppLocale locale) => locale.direction;
}
