import 'package:flutter/material.dart';

abstract final class AppShadows {
  static const BoxShadow soft = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 8,
    offset: Offset(0, 2),
  );

  static const BoxShadow medium = BoxShadow(
    color: Color(0x26000000),
    blurRadius: 16,
    offset: Offset(0, 4),
  );

  static const BoxShadow strong = BoxShadow(
    color: Color(0x33000000),
    blurRadius: 24,
    offset: Offset(0, 8),
  );

  static BoxShadow glow(
    Color color, {
    double blurRadius = 20,
    double spreadRadius = 2,
  }) {
    return BoxShadow(
      color: color.withValues(alpha: 0.35),
      blurRadius: blurRadius,
      spreadRadius: spreadRadius,
      offset: Offset.zero,
    );
  }
}
