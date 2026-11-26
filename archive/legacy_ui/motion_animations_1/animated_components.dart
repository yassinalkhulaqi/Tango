import 'package:flutter/material.dart';

class CurvedAnimationWidget extends StatelessWidget {
  final Widget child;
  final Curve curve;
  final Duration duration;
  final double begin;
  final double end;

  const CurvedAnimationWidget({
    super.key,
    required this.child,
    this.curve = Curves.easeInOut,
    this.duration = const Duration(milliseconds: 500),
    this.begin = 0.0,
    this.end = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return this;
  }
}

class TweenAnimationBuilderWidget extends StatelessWidget {
  final Widget child;
  final double tween;
  final Duration duration;

  const TweenAnimationBuilderWidget({
    super.key,
    required this.child,
    required this.tween,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: tween),
      duration: duration,
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: child,
    );
  }
}

class HeroPageRoute extends PageRouteBuilder {
  final Widget page;
  final String tag;
  final Duration duration;

  HeroPageRoute({
    required this.page,
    required this.tag,
    this.duration = const Duration(milliseconds: 500),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: duration,
        );
}

class AnimatedListBuilder extends StatefulWidget {
  final List<Widget> items;
  final Duration itemDuration;
  final Duration totalDuration;

  const AnimatedListBuilder({
    super.key,
    required this.items,
    this.itemDuration = const Duration(milliseconds: 100),
    this.totalDuration = const Duration(milliseconds: 1000),
  });

  @override
  State<AnimatedListBuilder> createState() => _AnimatedListBuilderState();
}

class _AnimatedListBuilderState extends State<AnimatedListBuilder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.totalDuration);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
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
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final delay = (index * 100).clamp(0, widget.totalDuration.inMilliseconds);
        return FutureBuilder<double>(
          future: Future.delayed(Duration(milliseconds: delay)).then((_) => 1.0),
          builder: (context, snapshot) {
            final value = snapshot.data ?? 0.0;
            return Opacity(
              opacity: value,
              child: SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
                  CurvedAnimation(
                    parent: AlwaysStoppedAnimation(1.0) as Animation<double>,
                    curve: Curves.easeOut,
                  ) as Animation<Offset>,
                ),
                child: widget.items[index],
              ),
            );
          },
        );
      },
    );
  }
}

class AnimatedTabView extends StatefulWidget {
  final List<Widget> pages;
  final int currentIndex;
  final Duration duration;

  const AnimatedTabView({
    super.key,
    required this.pages,
    required this.currentIndex,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedTabView> createState() => _AnimatedTabViewState();
}

class _AnimatedTabViewState extends State<AnimatedTabView> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: widget.duration,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            ),
            child: child,
          ),
        );
      },
      child: widget.pages[widget.currentIndex],
    );
  }
}

class AnimatedBottomNav extends StatefulWidget {
  final List<BottomNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final Duration duration;

  const AnimatedBottomNav({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
    this.duration = const Duration(milliseconds: 250),
  });

  @override
  State<AnimatedBottomNav> createState() => _AnimatedBottomNavState();
}

class BottomNavItem {
  final IconData icon;
  final String label;
  final Color color;

  BottomNavItem({
    required this.icon,
    required this.label,
    required this.color,
  });
}

class _AnimatedBottomNavState extends State<AnimatedBottomNav> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF0F141C),
        border: const Border(top: BorderSide(color: Color(0xFF1E293B), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(widget.items.length, (index) {
              final item = widget.items[index];
              final isSelected = index == widget.selectedIndex;
              return GestureDetector(
                onTap: () => widget.onItemSelected(index),
                child: AnimatedContainer(
                  duration: widget.duration,
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? item.color.withValues(alpha: 0.15) : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: widget.duration,
                        curve: Curves.easeInOut,
                        child: Icon(
                          item.icon,
                          color: isSelected ? item.color : Colors.grey,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedDefaultTextStyle(
                        duration: widget.duration,
                        curve: Curves.easeInOut,
                        child: Text(
                          item.label,
                          style: TextStyle(
                            color: isSelected ? item.color : Colors.grey,
                            fontSize: 10,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class AnimatedAppBar extends StatefulWidget {
  final Widget child;
  final bool isScrolled;
  final Duration duration;

  const AnimatedAppBar({
    super.key,
    required this.child,
    required this.isScrolled,
    this.duration = const Duration(milliseconds: 250),
  });

  @override
  State<AnimatedAppBar> createState() => _AnimatedAppBarState();
}

class _AnimatedAppBarState extends State<AnimatedAppBar> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      curve: Curves.easeInOut,
      height: widget.isScrolled ? 56 : 80,
      child: widget.child,
    );
  }
}

class AnimatedFab extends StatefulWidget {
  final Widget child;
  final bool isVisible;
  final Duration duration;

  const AnimatedFab({
    super.key,
    required this.child,
    required this.isVisible,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedFab> createState() => _AnimatedFabState();
}

class _AnimatedFabState extends State<AnimatedFab>
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
    if (widget.isVisible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void didUpdateWidget(AnimatedFab oldWidget) {
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _animation.value) * 100),
          child: Opacity(
            opacity: _animation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}

class AnimatedDrawer extends StatefulWidget {
  final Widget child;
  final bool isOpen;
  final Duration duration;

  const AnimatedDrawer({
    super.key,
    required this.child,
    required this.isOpen,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedDrawer> createState() => _AnimatedDrawerState();
}

class _AnimatedDrawerState extends State<AnimatedDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.isOpen) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void didUpdateWidget(AnimatedDrawer oldWidget) {
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
      position: _animation,
      child: widget.child,
    );
  }
}

class AnimatedModalBottomSheet extends StatefulWidget {
  final Widget child;
  final bool isVisible;
  final Duration duration;

  const AnimatedModalBottomSheet({
    super.key,
    required this.child,
    required this.isVisible,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedModalBottomSheet> createState() => _AnimatedModalBottomSheetState();
}

class _AnimatedModalBottomSheetState extends State<AnimatedModalBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    if (widget.isVisible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void didUpdateWidget(AnimatedModalBottomSheet oldWidget) {
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _animation.value) * 200),
          child: Opacity(
            opacity: _animation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}

class AnimatedConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const AnimatedConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: onCancel,
                    child: Text(cancelText),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    child: Text(confirmText),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedErrorAnimation extends StatefulWidget {
  final Widget child;
  final bool showError;
  final Duration duration;

  const AnimatedErrorAnimation({
    super.key,
    required this.child,
    required this.showError,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedErrorAnimation> createState() => _AnimatedErrorAnimationState();
}

class _AnimatedErrorAnimationState extends State<AnimatedErrorAnimation>
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
    if (widget.showError) {
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            (widget.showError ? _animation.value : 0) * 10,
            0,
          ),
          child: widget.child,
        );
      },
    );
  }
}

class AnimatedSuccessAnimation extends StatefulWidget {
  final Widget child;
  final bool showSuccess;
  final Duration duration;

  const AnimatedSuccessAnimation({
    super.key,
    required this.child,
    required this.showSuccess,
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  State<AnimatedSuccessAnimation> createState() => _AnimatedSuccessAnimationState();
}

class _AnimatedSuccessAnimationState extends State<AnimatedSuccessAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    if (widget.showSuccess) {
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.5 + (_animation.value * 0.5),
          child: widget.child,
        );
      },
    );
  }
}

class AnimatedLoadingWidget extends StatefulWidget {
  final Widget child;
  final bool isLoading;
  final Duration duration;

  const AnimatedLoadingWidget({
    super.key,
    required this.child,
    required this.isLoading,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedLoadingWidget> createState() => _AnimatedLoadingWidgetState();
}

class _AnimatedLoadingWidgetState extends State<AnimatedLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
    if (widget.isLoading) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(AnimatedLoadingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoading != widget.isLoading) {
      if (widget.isLoading) {
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
        if (widget.isLoading)
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _animation.value * 6.28318,
                child: const CircularProgressIndicator(),
              );
            },
          ),
      ],
    );
  }
}

class AnimatedEmptyState extends StatefulWidget {
  final Widget child;
  final bool isEmpty;
  final Duration duration;

  const AnimatedEmptyState({
    super.key,
    required this.child,
    required this.isEmpty,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedEmptyState> createState() => _AnimatedEmptyStateState();
}

class _AnimatedEmptyStateState extends State<AnimatedEmptyState>
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
    if (widget.isEmpty) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedEmptyState oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isEmpty != widget.isEmpty) {
      if (widget.isEmpty) {
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: widget.isEmpty ? _animation.value : 0.0,
          child: widget.child,
        );
      },
    );
  }
}

class AnimatedSearchBar extends StatefulWidget {
  final Widget child;
  final bool isExpanded;
  final Duration duration;

  const AnimatedSearchBar({
    super.key,
    required this.child,
    required this.isExpanded,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedSearchBar> createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      curve: Curves.easeInOut,
      width: widget.isExpanded ? 300 : 56,
      child: widget.child,
    );
  }
}

class AnimatedMenu extends StatefulWidget {
  final List<Widget> items;
  final bool isOpen;
  final Duration duration;

  const AnimatedMenu({
    super.key,
    required this.items,
    required this.isOpen,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedMenu> createState() => _AnimatedMenuState();
}

class _AnimatedMenuState extends State<AnimatedMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    if (widget.isOpen) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void didUpdateWidget(AnimatedMenu oldWidget) {
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Column(
          children: List.generate(widget.items.length, (index) {
            return Opacity(
              opacity: _animation.value,
              child: Transform.translate(
                offset: Offset(0, (1 - _animation.value) * 50),
                child: widget.items[index],
              ),
            );
          }),
        );
      },
    );
  }
}

class AnimatedTooltip extends StatefulWidget {
  final Widget child;
  final Widget message;
  final bool show;
  final Duration duration;

  const AnimatedTooltip({
    super.key,
    required this.child,
    required this.message,
    required this.show,
    this.duration = const Duration(milliseconds: 250),
  });

  @override
  State<AnimatedTooltip> createState() => _AnimatedTooltipState();
}

class _AnimatedTooltipState extends State<AnimatedTooltip>
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
    if (widget.show) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void didUpdateWidget(AnimatedTooltip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.show != widget.show) {
      if (widget.show) {
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.child,
            if (widget.show)
              Transform.translate(
                offset: Offset(0, -20 * (1 - _animation.value)),
                child: Opacity(
                  opacity: _animation.value,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: widget.message,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class AnimatedImage extends StatefulWidget {
  final Widget child;
  final bool isLoaded;
  final Duration duration;

  const AnimatedImage({
    super.key,
    required this.child,
    required this.isLoaded,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedImage> createState() => _AnimatedImageState();
}

class _AnimatedImageState extends State<AnimatedImage>
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
    if (widget.isLoaded) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoaded != widget.isLoaded && widget.isLoaded) {
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
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}

class AnimatedText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration duration;

  const AnimatedText({
    super.key,
    required this.text,
    required this.style,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedText> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText> {
  String _currentText = '';

  @override
  void initState() {
    super.initState();
    _currentText = widget.text;
  }

  @override
  void didUpdateWidget(AnimatedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      setState(() {
        _currentText = widget.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: widget.duration,
      firstChild: const SizedBox.shrink(),
      secondChild: Text(
        _currentText,
        style: widget.style,
      ),
      crossFadeState: _currentText.isNotEmpty
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
    );
  }
}

class AnimatedIconButton extends StatefulWidget {
  final IconData icon;
  final IconData activeIcon;
  final bool isActive;
  final VoidCallback? onPressed;
  final Duration duration;

  const AnimatedIconButton({
    super.key,
    required this.icon,
    required this.activeIcon,
    required this.isActive,
    this.onPressed,
    this.duration = const Duration(milliseconds: 250),
  });

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
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
    if (widget.isActive) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void didUpdateWidget(AnimatedIconButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive) {
      if (widget.isActive) {
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return IconButton(
          onPressed: widget.onPressed,
          icon: AnimatedSwitcher(
            duration: widget.duration,
            child: widget.isActive
                ? Icon(
                    widget.activeIcon,
                    key: const ValueKey('active'),
                  )
                : Icon(
                    widget.icon,
                    key: const ValueKey('inactive'),
                  ),
          ),
        );
      },
    );
  }
}
