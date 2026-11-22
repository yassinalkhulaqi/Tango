import 'package:flutter/material.dart';

/// Breakpoint definitions for adaptive layouts.
abstract final class Breakpoints {
  static const double phone = 600;
  static const double tablet = 840;
  static const double desktop = 1200;

  static bool isPhone(double width) => width < phone;
  static bool isTablet(double width) => width >= phone && width < tablet;
  static bool isDesktop(double width) => width >= tablet;
}

/// Rebuilds its child based on the current width breakpoint.
class ResponsiveLayout extends StatelessWidget {
  final Widget Function(BuildContext, double) phoneBuilder;
  final Widget Function(BuildContext, double)? tabletBuilder;
  final Widget Function(BuildContext, double)? desktopBuilder;

  const ResponsiveLayout({
    super.key,
    required this.phoneBuilder,
    this.tabletBuilder,
    this.desktopBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        if (Breakpoints.isDesktop(width)) {
          return (desktopBuilder ?? tabletBuilder ?? phoneBuilder)(context, width);
        }
        if (Breakpoints.isTablet(width)) {
          return (tabletBuilder ?? phoneBuilder)(context, width);
        }
        return phoneBuilder(context, width);
      },
    );
  }
}

/// A grid whose column count adapts to available width.
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  const ResponsiveGrid({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = Breakpoints.isDesktop(width) ? 4 : Breakpoints.isTablet(width) ? 3 : 2;
        return GridView.count(crossAxisCount: columns, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), children: children);
      },
    );
  }
}
