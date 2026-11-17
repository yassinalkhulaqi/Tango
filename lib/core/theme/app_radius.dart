import 'package:flutter/material.dart';

abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 14;
  static const double xl = 16;
  static const double xxl = 20;
  static const double xxxl = 24;

  static BorderRadius all(double radius) => BorderRadius.all(Radius.circular(radius));
  static BorderRadius circular(double radius) => BorderRadius.circular(radius);
}
