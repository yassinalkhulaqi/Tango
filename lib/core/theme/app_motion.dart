import 'package:flutter/material.dart';
import './app_colors.dart';

abstract final class AppMotion {
  static const Duration instant = Duration(milliseconds: 80);
  static const Duration fast = Duration(milliseconds: 120);
  static const Duration snappy = Duration(milliseconds: 160);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration smooth = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration celebration = Duration(milliseconds: 800);
  static const Duration levelUp = Duration(milliseconds: 1200);
  static const Duration pageTransition = Duration(milliseconds: 350);

  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeOutBack = Curves.easeOutBack;
  static const Curve easeOutCubic = Curves.easeOutCubic;
  static const Curve bounce = Curves.bounceOut;
  static const Curve elastic = Curves.elasticOut;

  static const double maxAnimationTime = 800.0;
}

abstract final class AppEasing {
  static const Cubic confident = Cubic(0.4, 0.0, 0.2, 1.0);
  static const Cubic playful = Cubic(0.68, -0.55, 0.265, 1.55);
  static const Cubic smooth = Cubic(0.23, 1, 0.32, 1);
  static const Cubic spring = Cubic(0.34, 1.56, 0.64, 1);
}
