import 'package:flutter/material.dart';

abstract final class AppColors {
  // Ultra Premium Dark Backgrounds
  static const Color background = Color(0xFF070A0F); // Deep space dark
  static const Color surface = Color(0xFF0F141C);    // High-end card/surface
  static const Color surfaceLight = Color(0xFF19202B); // Accent surface
  static const Color glassBackground = Color(0x0F19212C); // Glassmorphism backdrop

  // Python-inspired accents & Premium neon colors
  static const Color primaryBlue = Color(0xFF38BDF8); // Electric sky blue
  static const Color primaryBlueDark = Color(0xFF0284C7);
  static const Color primaryYellow = Color(0xFFFACC15); // Neon yellow
  static const Color primaryYellowDark = Color(0xFFCA8A04);

  // Gradient definitions for premium look
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF38BDF8), Color(0xFF818CF8)], // Sky blue to indigo
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient yellowGradient = LinearGradient(
    colors: [Color(0xFFFACC15), Color(0xFFF97316)], // Gold to orange
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient neonPurpleGradient = LinearGradient(
    colors: [Color(0xFFA855F7), Color(0xFFEC4899)], // Neon purple to pink
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassBorderGradient = LinearGradient(
    colors: [
      Color(0x3338BDF8), // 20% Sky blue
      Color(0x11818CF8), // 7% Indigo
      Color(0x05FACC15), // 2% Gold
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [
      Color(0xFF070A0F),
      Color(0xFF0C111A),
      Color(0xFF080D14),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Text colors
  static const Color textPrimary = Color(0xFFF8FAFC); // Clean crisp white
  static const Color textSecondary = Color(0xFF94A3B8); // Muted slate
  static const Color textMuted = Color(0xFF64748B); // Low priority Slate

  // Semantics
  static const Color green = Color(0xFF4ADE80); // Neon green
  static const Color purple = Color(0xFFA855F7); // Purple
  static const Color orange = Color(0xFFFB923C); // Orange
  static const Color cyan = Color(0xFF22D3EE); // Cyan
  static const Color pink = Color(0xFFF472B6); // Pink

  // Primary-prefixed aliases used across feature widgets
  static const Color primaryGreen = green;
  static const Color primaryOrange = orange;
  static const Color primaryPurple = purple;
  static const Color primaryCyan = cyan;

  // Convenience gradients
  static const LinearGradient blueGradient = LinearGradient(
    colors: [Color(0xFF38BDF8), Color(0xFF818CF8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF4ADE80), Color(0xFF22C55E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Borders
  static const Color divider = Color(0xFF1E293B);
  static const Color cardBorder = Color(0xFF1E293B);
}
