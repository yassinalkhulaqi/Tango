import 'package:flutter/material.dart';

class AppMotionPreferences {
  const AppMotionPreferences._();

  static bool reduced(BuildContext context) =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  static Duration duration(BuildContext context, Duration duration) =>
      reduced(context) ? Duration.zero : duration;

  static Curve curve(BuildContext context, Curve curve) =>
      reduced(context) ? Curves.linear : curve;

  static bool animate(BuildContext context) => !reduced(context);
}

class SemanticLabels {
  const SemanticLabels._();

  static String counter(String label, int value) => '$label: $value';

  static String action(String action, String target) => '$action $target';

  static String progress(String label, int current, int total) =>
      '$label: $current of $total';
}
