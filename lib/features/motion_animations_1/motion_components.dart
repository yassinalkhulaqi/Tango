import 'package:flutter/material.dart';

class AnimatedPageIndicator extends StatefulWidget {
  final int currentPage;
  final int totalPages;
  final Duration duration;
  final double activeSize;
  final double inactiveSize;
  final Color activeColor;
  final Color inactiveColor;

  const AnimatedPageIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.duration = const Duration(milliseconds: 300),
    this.activeSize = 32.0,
    this.inactiveSize = 8.0,
    this.activeColor = const Color(0xFF38BDF8),
    this.inactiveColor = const Color(0xFF1E293B),
  });

  @override
  State<AnimatedPageIndicator> createState() => _AnimatedPageIndicatorState();
}

class _AnimatedPageIndicatorState extends State<AnimatedPageIndicator> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.totalPages, (index) {
        final isActive = index == widget.currentPage;
        return AnimatedContainer(
          duration: widget.duration,
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? widget.activeSize : widget.inactiveSize,
          height: widget.inactiveSize,
          decoration: BoxDecoration(
            color: isActive ? widget.activeColor : widget.inactiveColor,
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }),
    );
  }
}

class AnimatedStepIndicator extends StatefulWidget {
  final int currentStep;
  final int totalSteps;
  final Duration duration;

  const AnimatedStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedStepIndicator> createState() => _AnimatedStepIndicatorState();
}

class _AnimatedStepIndicatorState extends State<AnimatedStepIndicator> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.totalSteps, (index) {
        final isActive = index <= widget.currentStep;
        final isCurrent = index == widget.currentStep;
        return AnimatedContainer(
          duration: widget.duration,
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: isCurrent ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF38BDF8) : const Color(0xFF1E293B).withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }),
    );
  }
}

class AnimatedHeader extends StatefulWidget {
  final Widget child;
  final double scrollOffset;
  final Duration duration;

  const AnimatedHeader({
    super.key,
    required this.child,
    required this.scrollOffset,
    this.duration = const Duration(milliseconds: 250),
  });

  @override
  State<AnimatedHeader> createState() => _AnimatedHeaderState();
}

class _AnimatedHeaderState extends State<AnimatedHeader> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      curve: Curves.easeInOut,
      transform: Matrix4.translationValues(0, -widget.scrollOffset.clamp(0, 100), 0),
      child: widget.child,
    );
  }
}

class AnimatedFabMenu extends StatefulWidget {
  final Widget fab;
  final List<Widget> actions;
  final bool isOpen;
  final Duration duration;

  const AnimatedFabMenu({
    super.key,
    required this.fab,
    required this.actions,
    required this.isOpen,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedFabMenu> createState() => _AnimatedFabMenuState();
}

class _AnimatedFabMenuState extends State<AnimatedFabMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.isOpen) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void didUpdateWidget(AnimatedFabMenu oldWidget) {
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ...List.generate(widget.actions.length, (index) {
          return Transform.translate(
            offset: Offset(0, -70 * (index + 1) * _controller.value),
            child: Opacity(
              opacity: _controller.value,
              child: widget.actions[index],
            ),
          );
        }),
        Transform.rotate(
          angle: _controller.value * 0.785398,
          child: widget.fab,
        ),
      ],
    );
  }
}

class AnimatedFilterChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;
  final Duration duration;

  const AnimatedFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.duration = const Duration(milliseconds: 200),
  });

  @override
  State<AnimatedFilterChip> createState() => _AnimatedFilterChipState();
}

class _AnimatedFilterChipState extends State<AnimatedFilterChip> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onSelected,
      child: AnimatedContainer(
        duration: widget.duration,
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: widget.isSelected ? const Color(0xFF38BDF8) : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: widget.isSelected ? const Color(0xFF38BDF8) : const Color(0xFF334155),
            width: 1,
          ),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            color: widget.isSelected ? Colors.white : Colors.grey,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class AnimatedSearchField extends StatefulWidget {
  final Widget child;
  final bool isFocused;
  final Duration duration;

  const AnimatedSearchField({
    super.key,
    required this.child,
    required this.isFocused,
    this.duration = const Duration(milliseconds: 250),
  });

  @override
  State<AnimatedSearchField> createState() => _AnimatedSearchFieldState();
}

class _AnimatedSearchFieldState extends State<AnimatedSearchField> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      curve: Curves.easeInOut,
      width: widget.isFocused ? 300 : 200,
      child: widget.child,
    );
  }
}

class AnimatedTabIndicator extends StatefulWidget {
  final int selectedIndex;
  final int totalTabs;
  final double tabWidth;
  final Duration duration;

  const AnimatedTabIndicator({
    super.key,
    required this.selectedIndex,
    required this.totalTabs,
    required this.tabWidth,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedTabIndicator> createState() => _AnimatedTabIndicatorState();
}

class _AnimatedTabIndicatorState extends State<AnimatedTabIndicator> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: widget.duration,
      curve: Curves.easeInOut,
      left: widget.selectedIndex * widget.tabWidth,
      width: widget.tabWidth,
      height: 4,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF38BDF8), Color(0xFF818CF8)],
          ),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class AnimatedDrawerHeader extends StatefulWidget {
  final Widget child;
  final bool isOpen;
  final Duration duration;

  const AnimatedDrawerHeader({
    super.key,
    required this.child,
    required this.isOpen,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedDrawerHeader> createState() => _AnimatedDrawerHeaderState();
}

class _AnimatedDrawerHeaderState extends State<AnimatedDrawerHeader> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      curve: Curves.easeInOut,
      height: widget.isOpen ? 200 : 100,
      child: widget.child,
    );
  }
}

class AnimatedListTile extends StatefulWidget {
  final Widget child;
  final bool isSelected;
  final Duration duration;

  const AnimatedListTile({
    super.key,
    required this.child,
    required this.isSelected,
    this.duration = const Duration(milliseconds: 200),
  });

  @override
  State<AnimatedListTile> createState() => _AnimatedListTileState();
}

class _AnimatedListTileState extends State<AnimatedListTile> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: widget.isSelected ? const Color(0xFF38BDF8).withValues(alpha: 0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: widget.child,
    );
  }
}

class AnimatedBadge extends StatefulWidget {
  final Widget child;
  final int count;
  final Duration duration;

  const AnimatedBadge({
    super.key,
    required this.child,
    required this.count,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedBadge> createState() => _AnimatedBadgeState();
}

class _AnimatedBadgeState extends State<AnimatedBadge> {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    if (widget.count > 0) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.count != widget.count) {
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
    return Stack(
      children: [
        widget.child,
        if (widget.count > 0)
          Positioned(
            right: 0,
            top: 0,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _animation.value,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${widget.count}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
          ),
      ],
    );
  }
}

class AnimatedNotificationBell extends StatefulWidget {
  final bool hasNotification;
  final VoidCallback? onPressed;
  final Duration duration;

  const AnimatedNotificationBell({
    super.key,
    required this.hasNotification,
    this.onPressed,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedNotificationBell> createState() => _AnimatedNotificationBellState();
}

class _AnimatedNotificationBellState extends State<AnimatedNotificationBell>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    if (widget.hasNotification) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedNotificationBell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hasNotification != widget.hasNotification && widget.hasNotification) {
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
    return IconButton(
      onPressed: widget.onPressed,
      icon: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _animation.value * 0.5,
            child: Icon(
              Icons.notifications_rounded,
              color: widget.hasNotification ? const Color(0xFF38BDF8) : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedThemeSwitch extends StatefulWidget {
  final bool isDark;
  final ValueChanged<bool> onChanged;
  final Duration duration;

  const AnimatedThemeSwitch({
    super.key,
    required this.isDark,
    required this.onChanged,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedThemeSwitch> createState() => _AnimatedThemeSwitchState();
}

class _AnimatedThemeSwitchState extends State<AnimatedThemeSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.isDark) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void didUpdateWidget(AnimatedThemeSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDark != widget.isDark) {
      if (widget.isDark) {
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
    return GestureDetector(
      onTap: () => widget.onChanged(!widget.isDark),
      child: AnimatedContainer(
        duration: widget.duration,
        curve: Curves.easeInOut,
        width: 56,
        height: 32,
        decoration: BoxDecoration(
          color: widget.isDark ? const Color(0xFF38BDF8) : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: widget.duration,
              curve: Curves.easeInOut,
              left: widget.isDark ? 28 : 4,
              top: 4,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.isDark ? Icons.wb_sunny_rounded : Icons.brightness_2_rounded,
                  color: widget.isDark ? Colors.orange : Colors.grey,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedLanguageSwitch extends StatefulWidget {
  final String currentLanguage;
  final ValueChanged<String> onChanged;
  final Duration duration;

  const AnimatedLanguageSwitch({
    super.key,
    required this.currentLanguage,
    required this.onChanged,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedLanguageSwitch> createState() => _AnimatedLanguageSwitchState();
}

class _AnimatedLanguageSwitchState extends State<AnimatedLanguageSwitch> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF334155), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.language_rounded, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            widget.currentLanguage,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: Colors.grey),
        ],
      ),
    );
  }
}

class AnimatedRefreshIndicator extends StatefulWidget {
  final Widget child;
  final bool isRefreshing;
  final Duration duration;

  const AnimatedRefreshIndicator({
    super.key,
    required this.child,
    required this.isRefreshing,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedRefreshIndicator> createState() => _AnimatedRefreshIndicatorState();
}

class _AnimatedRefreshIndicatorState extends State<AnimatedRefreshIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    if (widget.isRefreshing) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(AnimatedRefreshIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isRefreshing != widget.isRefreshing) {
      if (widget.isRefreshing) {
        _controller.repeat();
      } else {
        _controller.stop();
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
    return Stack(
      children: [
        widget.child,
        if (widget.isRefreshing)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _controller.value * 6.28318,
                  child: const SizedBox(
                    height: 3,
                    child: LinearProgressIndicator(),
                  ),
                ),
              ),
            ),
      ],
    );
  }
}

class AnimatedScaffold extends StatefulWidget {
  final Widget child;
  final bool showFab;
  final Duration duration;

  const AnimatedScaffold({
    super.key,
    required this.child,
    required this.showFab,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedScaffold> createState() => _AnimatedScaffoldState();
}

class _AnimatedScaffoldState extends State<AnimatedScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      floatingActionButton: AnimatedOpacity(
        duration: widget.duration,
        opacity: widget.showFab ? 1.0 : 0.0,
        child: widget.showFab ? const FloatingActionButton() : const SizedBox.shrink(),
      ),
    );
  }
}

class AnimatedRouteTransition extends PageRouteBuilder {
  final Widget page;
  final Duration duration;
  final Curve curve;

  AnimatedRouteTransition({
    required this.page,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOut,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(parent: animation, curve: curve),
              child: child,
            );
          },
          transitionDuration: duration,
        );
}

class AnimatedSlideUp extends StatefulWidget {
  final Widget child;
  final bool isVisible;
  final Duration duration;

  const AnimatedSlideUp({
    super.key,
    required this.child,
    required this.isVisible,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedSlideUp> createState() => _AnimatedSlideUpState();
}

class _AnimatedSlideUpState extends State<AnimatedSlideUp>
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
  void didUpdateWidget(AnimatedSlideUp oldWidget) {
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

class AnimatedSlideDown extends StatefulWidget {
  final Widget child;
  final bool isVisible;
  final Duration duration;

  const AnimatedSlideDown({
    super.key,
    required this.child,
    required this.isVisible,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedSlideDown> createState() => _AnimatedSlideDownState();
}

class _AnimatedSlideDownState extends State<AnimatedSlideDown>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    if (widget.isVisible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void didUpdateWidget(AnimatedSlideDown oldWidget) {
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

class AnimatedSlideLeft extends StatefulWidget {
  final Widget child;
  final bool isVisible;
  final Duration duration;

  const AnimatedSlideLeft({
    super.key,
    required this.child,
    required this.isVisible,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedSlideLeft> createState() => _AnimatedSlideLeftState();
}

class _AnimatedSlideLeftState extends State<AnimatedSlideLeft>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    if (widget.isVisible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void didUpdateWidget(AnimatedSlideLeft oldWidget) {
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

class AnimatedSlideRight extends StatefulWidget {
  final Widget child;
  final bool isVisible;
  final Duration duration;

  const AnimatedSlideRight({
    super.key,
    required this.child,
    required this.isVisible,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedSlideRight> createState() => _AnimatedSlideRightState();
}

class _AnimatedSlideRightState extends State<AnimatedSlideRight>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    if (widget.isVisible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void didUpdateWidget(AnimatedSlideRight oldWidget) {
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

class AnimatedZoomIn extends StatefulWidget {
  final Widget child;
  final bool isVisible;
  final Duration duration;

  const AnimatedZoomIn({
    super.key,
    required this.child,
    required this.isVisible,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedZoomIn> createState() => _AnimatedZoomInState();
}

class _AnimatedZoomInState extends State<AnimatedZoomIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    if (widget.isVisible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void didUpdateWidget(AnimatedZoomIn oldWidget) {
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
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}

class AnimatedZoomOut extends StatefulWidget {
  final Widget child;
  final bool isVisible;
  final Duration duration;

  const AnimatedZoomOut({
    super.key,
    required this.child,
    required this.isVisible,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedZoomOut> createState() => _AnimatedZoomOutState();
}

class _AnimatedZoomOutState extends State<AnimatedZoomOut>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    if (!widget.isVisible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedZoomOut oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isVisible != widget.isVisible) {
      if (widget.isVisible) {
        _controller.reverse();
      } else {
        _controller.forward();
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
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}

class AnimatedFadeThrough extends StatefulWidget {
  final Widget child;
  final bool showFirst;
  final Duration duration;

  const AnimatedFadeThrough({
    super.key,
    required this.child,
    required this.showFirst,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedFadeThrough> createState() => _AnimatedFadeThroughState();
}

class _AnimatedFadeThroughState extends State<AnimatedFadeThrough> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: widget.duration,
      transitionBuilder: (child, animation) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: const AlwaysStoppedAnimation(0.0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class AnimatedSharedElement extends StatelessWidget {
  final String tag;
  final Widget child;

  const AnimatedSharedElement({
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

class AnimatedFlightShuttleBuilder extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;
  final HeroFlightDirection flightDirection;
  final BuildContext fromHeroContext;
  final BuildContext toHeroContext;

  const AnimatedFlightShuttleBuilder({
    super.key,
    required this.child,
    required this.animation,
    required this.flightDirection,
    required this.fromHeroContext,
    required this.toHeroContext,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
