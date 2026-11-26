import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';

extension WidgetExtensions on Widget {
  Widget paddingAll(double size) =>
      Padding(padding: AppSpacing.all(size), child: this);
  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) =>
      Padding(
        padding: AppSpacing.symmetric(
          horizontal: horizontal,
          vertical: vertical,
        ),
        child: this,
      );
  Widget paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => Padding(
    padding: AppSpacing.only(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    ),
    child: this,
  );
  Widget expand({int flex = 1}) => Expanded(flex: flex, child: this);
  Widget flexed(int flex) => Flexible(flex: flex, child: this);
}
