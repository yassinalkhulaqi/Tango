import 'package:flutter/material.dart';

/// RTL-aware layout primitives.
///
/// Every widget here resolves physical directions from [TextDirection], so
/// Arabic and Urdu screens mirror without per-screen conditionals.
class MirroredPadding extends StatelessWidget {
  final Widget child;
  final double start;
  final double end;
  final double vertical;

  const MirroredPadding({
    super.key,
    required this.child,
    this.start = 0,
    this.end = 0,
    this.vertical = 0,
  });

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return Padding(
      padding: EdgeInsets.only(
        left: rtl ? end : start,
        right: rtl ? start : end,
        top: vertical,
        bottom: vertical,
      ),
      child: child,
    );
  }
}

/// A row that reverses its children order in RTL while keeping logical meaning.
class MirroredRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;

  const MirroredRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.spacing = 0,
  });

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final ordered = rtl ? children.reversed.toList() : children;
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: spacing > 0
          ? List.generate(ordered.length * 2 - 1, (i) {
              if (i.isOdd) return SizedBox(width: spacing);
              return ordered[i ~/ 2];
            })
          : ordered,
    );
  }
}

/// An icon that flips horizontally for directional glyphs in RTL.
class MirroredIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? color;
  final bool flipInRtl;

  const MirroredIcon(
    this.icon, {
    super.key,
    this.size = 24,
    this.color,
    this.flipInRtl = true,
  });

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final child = Icon(icon, size: size, color: color);
    if (rtl && flipInRtl) return Transform.scale(scaleX: -1, child: child);
    return child;
  }
}

/// A card whose accent edge follows the reading direction.
class MirroredAccentCard extends StatelessWidget {
  final Widget child;
  final Color accent;
  final double accentWidth;

  const MirroredAccentCard({
    super.key,
    required this.child,
    required this.accent,
    this.accentWidth = 3,
  });

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: rtl
              ? BorderSide.none
              : BorderSide(color: accent, width: accentWidth),
          right: rtl
              ? BorderSide(color: accent, width: accentWidth)
              : BorderSide.none,
        ),
      ),
      child: child,
    );
  }
}
