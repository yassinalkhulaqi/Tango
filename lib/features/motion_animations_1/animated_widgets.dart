import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Duration duration;
  final double scale;

  const AnimatedButton({
    super.key,
    required this.child,
    this.onPressed,
    this.duration = const Duration(milliseconds: 120),
    this.scale = 0.95,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 1.0, end: widget.scale).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(scale: _animation.value, child: widget.child);
        },
      ),
    );
  }
}

class AnimatedCard extends StatefulWidget {
  final Widget child;
  final bool isHovered;
  final Duration duration;

  const AnimatedCard({
    super.key,
    required this.child,
    this.isHovered = false,
    this.duration = const Duration(milliseconds: 200),
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      curve: Curves.easeInOut,
      transform: Matrix4.translationValues(
        widget.isHovered ? -5 : 0,
        widget.isHovered ? -5 : 0,
        0,
      ),
      child: widget.child,
    );
  }
}

class AnimatedListItem extends StatefulWidget {
  final Widget child;
  final int index;
  final bool isVisible;
  final Duration duration;

  const AnimatedListItem({
    super.key,
    required this.child,
    required this.index,
    this.isVisible = true,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          widget.index * 0.1,
          1.0,
          curve: Curves.easeOut,
        ),
      ),
    );
    if (widget.isVisible) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOut),
        ),
        child: widget.child,
      ),
    );
  }
}

class AnimatedGridItem extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration duration;

  const AnimatedGridItem({
    super.key,
    required this.child,
    required this.index,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedGridItem> createState() => _AnimatedGridItemState();
}

class _AnimatedGridItemState extends State<AnimatedGridItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          widget.index * 0.08,
          1.0,
          curve: Curves.easeOutCubic,
        ),
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
        ),
        child: widget.child,
      ),
    );
  }
}

class StaggeredContainer extends StatelessWidget {
  final List<Widget> children;
  final Duration duration;
  final Duration staggerDelay;

  const StaggeredContainer({
    super.key,
    required this.children,
    this.duration = const Duration(milliseconds: 300),
    this.staggerDelay = const Duration(milliseconds: 80),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(children.length, (index) {
        return AnimatedListItem(
          child: children[index],
          index: index,
          duration: duration,
        );
      }),
    );
  }
}

class StaggeredGrid extends StatelessWidget {
  final List<Widget> children;
  final int crossAxisCount;
  final Duration duration;

  const StaggeredGrid({
    super.key,
    required this.children,
    this.crossAxisCount = 2,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: children.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        return AnimatedGridItem(
          child: children[index],
          index: index,
          duration: duration,
        );
      },
    );
  }
}

class AnimatedVisibility extends StatefulWidget {
  final Widget child;
  final bool visible;
  final Duration duration;
  final Curve curve;

  const AnimatedVisibility({
    super.key,
    required this.child,
    required this.visible,
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.easeInOut,
  });

  @override
  State<AnimatedVisibility> createState() => _AnimatedVisibilityState();
}

class _AnimatedVisibilityState extends State<AnimatedVisibility>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
    if (widget.visible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void didUpdateWidget(AnimatedVisibility oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.visible != widget.visible) {
      if (widget.visible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: ScaleTransition(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}

class AnimatedSwitcherCustom extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const AnimatedSwitcherCustom({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  @override
  State<AnimatedSwitcherCustom> createState() => _AnimatedSwitcherCustomState();
}

class _AnimatedSwitcherCustomState extends State<AnimatedSwitcherCustom> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: widget.duration,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
              CurvedAnimation(parent: animation, curve: widget.curve),
            ),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

class HeroAnimationWidget extends StatelessWidget {
  final String tag;
  final Widget child;

  const HeroAnimationWidget({
    super.key,
    required this.tag,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: child,
    );
  }
}

class SharedAxisPageTransition extends PageRouteBuilder {
  final Widget page;
  final Axis axis;
  final Duration duration;

  SharedAxisPageTransition({
    required this.page,
    this.axis = Axis.horizontal,
    this.duration = const Duration(milliseconds: 350),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionSet: _getTransitionSet(),
              child: child,
            );
          },
          transitionDuration: duration,
        );

  SharedAxisTransitionSet _getTransitionSet() {
    switch (axis) {
      case Axis.horizontal:
        return SharedAxisTransitionSet.horizontal;
      case Axis.vertical:
        return SharedAxisTransitionSet.vertical;
    }
  }
}

class FadePageTransition extends PageRouteBuilder {
  final Widget page;
  final Duration duration;

  FadePageTransition({
    required this.page,
    this.duration = const Duration(milliseconds: 350),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
              child: child,
            );
          },
          transitionDuration: duration,
        );
}

class ScalePageTransition extends PageRouteBuilder {
  final Widget page;
  final Duration duration;

  ScalePageTransition({
    required this.page,
    this.duration = const Duration(milliseconds: 350),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
              scale: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
              child: child,
            );
          },
          transitionDuration: duration,
        );
}

class RotationPageTransition extends PageRouteBuilder {
  final Widget page;
  final Duration duration;

  RotationPageTransition({
    required this.page,
    this.duration = const Duration(milliseconds: 350),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return RotationTransition(
              turns: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
              child: child,
            );
          },
          transitionDuration: duration,
        );
}

class AnimatedBottomSheet extends StatefulWidget {
  final Widget child;
  final bool isOpen;
  final Duration duration;

  const AnimatedBottomSheet({
    super.key,
    required this.child,
    required this.isOpen,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedBottomSheet> createState() => _AnimatedBottomSheetState();
}

class _AnimatedBottomSheetState extends State<AnimatedBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.isOpen) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void didUpdateWidget(AnimatedBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isOpen != widget.isOpen) {
      if (widget.isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: widget.child,
    );
  }
}

class AnimatedDialog extends StatefulWidget {
  final Widget child;
  final bool isOpen;
  final Duration duration;

  const AnimatedDialog({
    super.key,
    required this.child,
    required this.isOpen,
    this.duration = const Duration(milliseconds: 250),
  });

  @override
  State<AnimatedDialog> createState() => _AnimatedDialogState();
}

class _AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    if (widget.isOpen) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void didUpdateWidget(AnimatedDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isOpen != widget.isOpen) {
      if (widget.isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: ScaleTransition(
        scale: _animation,
        child: widget.child,
      ),
    );
  }
}

class AnimatedSnackBar extends StatefulWidget {
  final Widget child;
  final bool isVisible;
  final Duration duration;

  const AnimatedSnackBar({
    super.key,
    required this.child,
    required this.isVisible,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedSnackBar> createState() => _AnimatedSnackBarState();
}

class _AnimatedSnackBarState extends State<AnimatedSnackBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    if (widget.isVisible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void didUpdateWidget(AnimatedSnackBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isVisible != widget.isVisible) {
      if (widget.isVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }
}

class PageViewAnimation extends StatefulWidget {
  final List<Widget> pages;
  final Duration duration;
  final Curve curve;

  const PageViewAnimation({
    super.key,
    required this.pages,
    this.duration = const Duration(milliseconds: 350),
    this.curve = Curves.easeInOut,
  });

  @override
  State<PageViewAnimation> createState() => _PageViewAnimationState();
}

class _PageViewAnimationState extends State<PageViewAnimation> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      onPageChanged: (index) => setState(() => _currentPage = index),
      children: List.generate(widget.pages.length, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double value = 1.0;
            if (_controller.position.haveDimensions) {
              value = _controller.page! - index;
              value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
            }
            return Center(
              child: SizedBox(
                height: Curves.easeInOut.transform(value) * 300,
                width: Curves.easeInOut.transform(value) * 300,
                child: widget.pages[index],
              ),
            );
          },
        );
      }),
    );
  }
}

class AnimatedTabBar extends StatefulWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;
  final Duration duration;

  const AnimatedTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabChanged,
    this.duration = const Duration(milliseconds: 200),
  });

  @override
  State<AnimatedTabBar> createState() => _AnimatedTabBarState();
}

class _AnimatedTabBarState extends State<AnimatedTabBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.tabs.length,
        itemBuilder: (context, index) {
          final isSelected = index == widget.selectedIndex;
          return AnimatedContainer(
            duration: widget.duration,
            curve: Curves.easeInOut,
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF38BDF8).withValues(alpha: 0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? const Color(0xFF38BDF8) : Colors.transparent,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                widget.tabs[index],
                style: TextStyle(
                  color: isSelected ? const Color(0xFF38BDF8) : Colors.grey,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AnimatedProgressIndicator extends StatefulWidget {
  final double progress;
  final Duration duration;
  final Color color;
  final double height;

  const AnimatedProgressIndicator({
    super.key,
    required this.progress,
    this.duration = const Duration(milliseconds: 500),
    this.color = const Color(0xFF38BDF8),
    this.height = 8.0,
  });

  @override
  State<AnimatedProgressIndicator> createState() => _AnimatedProgressIndicatorState();
}

class _AnimatedProgressIndicatorState extends State<AnimatedProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      curve: Curves.easeInOut,
      height: widget.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.height / 2),
        child: LinearProgressIndicator(
          value: widget.progress,
          backgroundColor: const Color(0xFF1E293B),
          valueColor: AlwaysStoppedAnimation(widget.color),
        ),
      ),
    );
  }
}

class AnimatedCounterWidget extends StatefulWidget {
  final int value;
  final Duration duration;
  final TextStyle style;

  const AnimatedCounterWidget({
    super.key,
    required this.value,
    this.duration = const Duration(milliseconds: 800),
    this.style = const TextStyle(),
  });

  @override
  State<AnimatedCounterWidget> createState() => _AnimatedCounterWidgetState();
}

class _AnimatedCounterWidgetState extends State<AnimatedCounterWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = IntTween(begin: 0, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCounterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          '${_animation.value}',
          style: widget.style,
        );
      },
    );
  }
}

class AnimatedListView extends StatefulWidget {
  final List<Widget> children;
  final Duration duration;

  const AnimatedListView({
    super.key,
    required this.children,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedListView> createState() => _AnimatedListViewState();
}

class _AnimatedListViewState extends State<AnimatedListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.children.length,
      itemBuilder: (context, index) {
        return AnimatedListItem(
          child: widget.children[index],
          index: index,
          duration: widget.duration,
        );
      },
    );
  }
}

class AnimatedWrap extends StatelessWidget {
  final List<Widget> children;
  final Duration duration;

  const AnimatedWrap({
    super.key,
    required this.children,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(children.length, (index) {
        return AnimatedGridItem(
          child: children[index],
          index: index,
          duration: duration,
        );
      }),
    );
  }
}

class AnimatedColumn extends StatelessWidget {
  final List<Widget> children;
  final Duration duration;

  const AnimatedColumn({
    super.key,
    required this.children,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(children.length, (index) {
        return AnimatedListItem(
          child: children[index],
          index: index,
          duration: duration,
        );
      }),
    );
  }
}

class AnimatedRow extends StatelessWidget {
  final List<Widget> children;
  final Duration duration;

  const AnimatedRow({
    super.key,
    required this.children,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(children.length, (index) {
        return AnimatedListItem(
          child: children[index],
          index: index,
          duration: duration,
        );
      }),
    );
  }
}

class AnimatedOpacityWidget extends StatefulWidget {
  final Widget child;
  final double opacity;
  final Duration duration;

  const AnimatedOpacityWidget({
    super.key,
    required this.child,
    required this.opacity,
    this.duration = const Duration(milliseconds: 250),
  });

  @override
  State<AnimatedOpacityWidget> createState() => _AnimatedOpacityWidgetState();
}

class _AnimatedOpacityWidgetState extends State<AnimatedOpacityWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.opacity,
      duration: widget.duration,
      curve: Curves.easeInOut,
      child: widget.child,
    );
  }
}

class AnimatedContainerWidget extends StatefulWidget {
  final Widget child;
  final double width;
  final double height;
  final Color color;
  final BorderRadius borderRadius;
  final Duration duration;

  const AnimatedContainerWidget({
    super.key,
    required this.child,
    required this.width,
    required this.height,
    required this.color,
    this.borderRadius = BorderRadius.zero,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedContainerWidget> createState() => _AnimatedContainerWidgetState();
}

class _AnimatedContainerWidgetState extends State<AnimatedContainerWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      curve: Curves.easeInOut,
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: widget.borderRadius,
      ),
      child: widget.child,
    );
  }
}

class AnimatedPositionedWidget extends StatefulWidget {
  final Widget child;
  final double top;
  final double left;
  final Duration duration;

  const AnimatedPositionedWidget({
    super.key,
    required this.child,
    required this.top,
    required this.left,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedPositionedWidget> createState() => _AnimatedPositionedWidgetState();
}

class _AnimatedPositionedWidgetState extends State<AnimatedPositionedWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: widget.duration,
      curve: Curves.easeInOut,
      top: widget.top,
      left: widget.left,
      child: widget.child,
    );
  }
}

class AnimatedRotationWidget extends StatefulWidget {
  final Widget child;
  final double turns;
  final Duration duration;

  const AnimatedRotationWidget({
    super.key,
    required this.child,
    required this.turns,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedRotationWidget> createState() => _AnimatedRotationWidgetState();
}

class _AnimatedRotationWidgetState extends State<AnimatedRotationWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: widget.turns,
      duration: widget.duration,
      curve: Curves.easeInOut,
      child: widget.child,
    );
  }
}

class AnimatedScaleWidget extends StatefulWidget {
  final Widget child;
  final double scale;
  final Duration duration;

  const AnimatedScaleWidget({
    super.key,
    required this.child,
    required this.scale,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedScaleWidget> createState() => _AnimatedScaleWidgetState();
}

class _AnimatedScaleWidgetState extends State<AnimatedScaleWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: widget.scale,
      duration: widget.duration,
      curve: Curves.easeInOut,
      child: widget.child,
    );
  }
}

class AnimatedAlignWidget extends StatefulWidget {
  final Widget child;
  final Alignment alignment;
  final Duration duration;

  const AnimatedAlignWidget({
    super.key,
    required this.child,
    required this.alignment,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedAlignWidget> createState() => _AnimatedAlignWidgetState();
}

class _AnimatedAlignWidgetState extends State<AnimatedAlignWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
      duration: widget.duration,
      curve: Curves.easeInOut,
      alignment: widget.alignment,
      child: widget.child,
    );
  }
}

class AnimatedPaddingWidget extends StatefulWidget {
  final Widget child;
  final EdgeInsets padding;
  final Duration duration;

  const AnimatedPaddingWidget({
    super.key,
    required this.child,
    required this.padding,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedPaddingWidget> createState() => _AnimatedPaddingWidgetState();
}

class _AnimatedPaddingWidgetState extends State<AnimatedPaddingWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: widget.duration,
      curve: Curves.easeInOut,
      padding: widget.padding,
      child: widget.child,
    );
  }
}

class AnimatedPhysicalModel extends StatefulWidget {
  final Widget child;
  final Color color;
  final double elevation;
  final Duration duration;

  const AnimatedPhysicalModel({
    super.key,
    required this.child,
    required this.color,
    required this.elevation,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedPhysicalModel> createState() => _AnimatedPhysicalModelState();
}

class _AnimatedPhysicalModelState extends State<AnimatedPhysicalModel> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPhysicalModel(
      duration: widget.duration,
      curve: Curves.easeInOut,
      color: widget.color,
      elevation: widget.elevation,
      shadowColor: Colors.black,
      child: widget.child,
    );
  }
}

class AnimatedDefaultTextStyle extends StatefulWidget {
  final Widget child;
  final TextStyle style;
  final Duration duration;

  const AnimatedDefaultTextStyle({
    super.key,
    required this.child,
    required this.style,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedDefaultTextStyle> createState() => _AnimatedDefaultTextStyleState();
}

class _AnimatedDefaultTextStyleState extends State<AnimatedDefaultTextStyle> {
  @override
  Widget build(BuildContext context) {
    return AnimatedDefaultTextStyle(
      duration: widget.duration,
      curve: Curves.easeInOut,
      style: widget.style,
      child: widget.child,
    );
  }
}

class AnimatedCrossFade extends StatefulWidget {
  final Widget firstChild;
  final Widget secondChild;
  final bool showFirst;
  final Duration duration;

  const AnimatedCrossFade({
    super.key,
    required this.firstChild,
    required this.secondChild,
    required this.showFirst,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedCrossFade> createState() => _AnimatedCrossFadeState();
}

class _AnimatedCrossFadeState extends State<AnimatedCrossFade> {
  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: widget.duration,
      firstChild: widget.firstChild,
      secondChild: widget.secondChild,
      crossFadeState: widget.showFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }
}
