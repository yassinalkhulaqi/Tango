import 'package:flutter/material.dart';
import './app_colors.dart';

abstract final class AppGradients {
  static const LinearGradient primary = LinearGradient(
    colors: [Color(0xFF38BDF8), Color(0xFF818CF8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient reward = LinearGradient(
    colors: [Color(0xFFFACC15), Color(0xFFF97316)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient neonPurple = LinearGradient(
    colors: [Color(0xFFA855F7), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient neonGreen = LinearGradient(
    colors: [Color(0xFF4ADE80), Color(0xFF22C55E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient deepSpace = LinearGradient(
    colors: [Color(0xFF070A0F), Color(0xFF0C111A), Color(0xFF080D14)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient glassBorder = LinearGradient(
    colors: [Color(0x3338BDF8), Color(0x11818CF8), Color(0x05FACC15)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceSubtle = LinearGradient(
    colors: [Color(0x0A19212C), Color(0x050F141C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient streak = LinearGradient(
    colors: [Color(0xFFFB923C), Color(0xFFFACC15)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static BoxShadow glow(
    Color color, {
    double blurRadius = 20,
    double spreadRadius = 2,
    Offset offset = Offset.zero,
  }) {
    return BoxShadow(
      color: color.withValues(alpha: 0.35),
      blurRadius: blurRadius,
      spreadRadius: spreadRadius,
      offset: offset,
    );
  }

  static BoxShadow cardShadow({
    double blurRadius = 16,
    Offset offset = Offset.zero,
  }) {
    return BoxShadow(
      color: Colors.black.withValues(alpha: 0.25),
      blurRadius: blurRadius,
      offset: offset,
    );
  }

  static BoxShadow softShadow({Offset? offset, double blurRadius = 8}) {
    return BoxShadow(
      color: Colors.black.withValues(alpha: 0.15),
      blurRadius: blurRadius,
      offset: offset ?? const Offset(0, 2),
    );
  }
}
