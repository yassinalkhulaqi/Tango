import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  double get width => mediaQuery.size.width;
  double get height => mediaQuery.size.height;
  double get textScaleFactor => mediaQuery.textScaleFactor.clamp(1.0, 1.3);
  bool get isSmallScreen => width < 360;
  bool get isTablet => width >= 600;
  bool get isLargeTablet => width >= 840;
}
