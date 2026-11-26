import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_colors.dart';

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryBlue,
      secondary: AppColors.primaryYellow,
      surface: AppColors.surface,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textPrimary,
      error: Color(0xFFF87171),
    ),
    dividerColor: AppColors.divider,
  );
  return base.copyWith(
    textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    ),
    primaryTextTheme: GoogleFonts.interTextTheme(base.primaryTextTheme),
  );
}

TextStyle codeStyle({double size = 14, FontWeight? weight, Color? color}) =>
    GoogleFonts.firaCode(
      fontSize: size,
      fontWeight: weight,
      color: color ?? AppColors.textPrimary,
    );
