import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

extension GlassCardExtension on Widget {
  Widget glassCard({
    double borderWidth = 1.0,
    Color borderColor = AppColors.cardBorder,
    double blurRadius = 16,
    Offset shadowOffset = Offset.zero,
    Color shadowColor = Colors.black54,
    BorderRadiusGeometry? borderRadius,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        borderRadius: borderRadius ?? AppRadius.circular(AppRadius.xl),
        border: Border.all(
          color: borderColor.withValues(alpha: 0.2),
          width: borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.25),
            blurRadius: blurRadius,
            offset: shadowOffset,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? AppRadius.circular(AppRadius.xl),
        child: this,
      ),
    );
  }
}
