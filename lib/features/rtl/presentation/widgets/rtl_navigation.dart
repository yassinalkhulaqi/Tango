import 'package:flutter/material.dart';

class MirroredTabBar extends StatelessWidget {
  const MirroredTabBar({
    super.key,
    required this.tabs,
    required this.controller,
  });

  final List<Widget> tabs;
  final TabController controller;

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return TabBar(
      controller: controller,
      tabs: rtl ? tabs.reversed.toList() : tabs,
    );
  }
}

class MirroredNavRow extends StatelessWidget {
  const MirroredNavRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
  });

  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return Row(
      textDirection: Directionality.of(context),
      mainAxisAlignment: mainAxisAlignment,
      children: rtl ? children.reversed.toList() : children,
    );
  }
}

class MirroredBottomSheet extends StatelessWidget {
  const MirroredBottomSheet({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: rtl ? padding.right : padding.left,
          right: rtl ? padding.left : padding.right,
          top: padding.top,
          bottom: padding.bottom,
        ),
        child: child,
      ),
    );
  }
}
