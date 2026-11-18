import 'package:flutter/material.dart';

class MotionConfig {
  static const Duration instant = Duration(milliseconds: 50);
  static const Duration immediate = Duration(milliseconds: 80);
  static const Duration fast = Duration(milliseconds: 120);
  static const Duration snappy = Duration(milliseconds: 160);
  static const Duration normal = Duration(milliseconds: 200);
  static const Duration smooth = Duration(milliseconds: 250);
  static const Duration gentle = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 350);
  static const Duration leisurely = Duration(milliseconds: 400);
  static const Duration relaxed = Duration(milliseconds: 500);
  static const Duration celebration = Duration(milliseconds: 800);
  static const Duration levelUp = Duration(milliseconds: 1200);
  static const Duration pageTransition = Duration(milliseconds: 350);
  static const Duration maxDuration = Duration(milliseconds: 800);

  static const double maxAnimationTime = 800.0;
}

class MotionCurves {
  static const Curve linear = Curves.linear;
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeInOutSine = Curves.easeInOutSine;
  static const Curve easeInOutCubic = Curves.easeInOutCubic;
  static const Curve easeInOutQuartic = Curves.easeInOutQuartic;
  static const Curve easeInOutQuintic = Curves.easeInOutQuintic;
  static const Curve easeInOutExpo = Curves.easeInOutExpo;
  static const Curve easeInOutCirc = Curves.easeInOutCirc;
  static const Curve easeInOutBack = Curves.easeInOutBack;
  static const Curve easeOutBack = Curves.easeOutBack;
  static const Curve easeInBack = Curves.easeInBack;
  static const Curve easeOutCirc = Curves.easeOutCirc;
  static const Curve easeOutCubic = Curves.easeOutCubic;
  static const Curve easeOutExpo = Curves.easeOutExpo;
  static const Curve easeOutQuad = Curves.easeOutQuad;
  static const Curve easeOutQuartic = Curves.easeOutQuartic;
  static const Curve easeOutQuintic = Curves.easeOutQuintic;
  static const Curve easeOutSine = Curves.easeOutSine;
  static const Curve elastic = Curves.elasticOut;
  static const Curve bounce = Curves.bounceOut;
  static const Curve bounceIn = Curves.bounceIn;
  static const Curve bounceInOut = Curves.bounceInOut;
  static const Curve decelerate = Curves.decelerate;
  static const Curve accelerate = Curves.accelerate;
  static const Curve fastLinearToSlowEaseIn = Curves.fastLinearToSlowEaseIn;
  static const Curve slowMiddle = Curves.slowMiddle;

  static const Cubic confident = Cubic(0.4, 0.0, 0.2, 1.0);
  static const Cubic playful = Cubic(0.68, -0.55, 0.265, 1.55);
  static const Cubic smooth = Cubic(0.23, 1, 0.32, 1);
  static const Cubic spring = Cubic(0.34, 1.56, 0.64, 1);
  static const Cubic gentleCubic = Cubic(0.25, 0.25, 0.75, 0.75);
  static const Cubic easingCubic = Cubic(0.16, 1, 0.3, 1);
  static const Cubic materialEase = Cubic(0.4, 0.0, 0.2, 1.0);
  static const Cubic materialEaseOut = Cubic(0.0, 0.0, 0.2, 1.0);
  static const Cubic materialEaseInOut = Cubic(0.4, 0.0, 0.6, 1.0);
}

class MotionShadows {
  static const BoxShadow soft = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 8,
    offset: Offset(0, 2),
  );

  static const BoxShadow medium = BoxShadow(
    color: Color(0x26000000),
    blurRadius: 16,
    offset: Offset(0, 4),
  );

  static const BoxShadow strong = BoxShadow(
    color: Color(0x33000000),
    blurRadius: 24,
    offset: Offset(0, 8),
  );

  static BoxShadow glow(Color color,
      {double blurRadius = 20, double spreadRadius = 2, Offset offset = Offset.zero}) {
    return BoxShadow(
      color: color.withValues(alpha: 0.35),
      blurRadius: blurRadius,
      spreadRadius: spreadRadius,
      offset: offset,
    );
  }

  static BoxShadow cardShadow({double blurRadius = 16, Offset offset = Offset.zero}) {
    return BoxShadow(
      color: Colors.black.withValues(alpha: 0.25),
      blurRadius: blurRadius,
      offset: offset,
    );
  }

  static BoxShadow softShadow({Offset offset = Offset(0, 2), double blurRadius = 8}) {
    return BoxShadow(
      color: Colors.black.withValues(alpha: 0.15),
      blurRadius: blurRadius,
      offset: offset,
    );
  }

  static BoxShadow glowPulse(Color color, {double blurRadius = 30}) {
    return BoxShadow(
      color: color.withValues(alpha: 0.4),
      blurRadius: blurRadius,
      spreadRadius: 4,
      offset: Offset.zero,
    );
  }
}

class MotionGradients {
  static const LinearGradient primary = LinearGradient(
    colors: [Color(0xFF38BDF8), Color(0xFF818CF8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient reward = LinearGradient(
    colors: [Color(0xFFFACC15), Color(0xFFF97316)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient neonPurple = LinearGradient(
    colors: [Color(0xFFA855F7), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient neonGreen = LinearGradient(
    colors: [Color(0xFF4ADE80), Color(0xFF22C55E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient deepSpace = LinearGradient(
    colors: [Color(0xFF070A0F), Color(0xFF0C111A), Color(0xFF080D14)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient glassBorder = LinearGradient(
    colors: [Color(0x3338BDF8), Color(0x11818CF8), Color(0x05FACC15)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceSubtle = LinearGradient(
    colors: [Color(0x0A19212C), Color(0x050F141C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient streak = LinearGradient(
    colors: [Color(0xFFFB923C), Color(0xFFFACC15)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static LinearGradient radialGlow(Color color,
      {Alignment begin = Alignment.center, Alignment end = Alignment.center}) {
    return RadialGradient(
      colors: [color.withValues(alpha: 0.4), color.withValues(alpha: 0.0)],
      begin: begin,
      end: end,
    );
  }
}

extension AnimatedExtensions on Widget {
  Widget fadeIn({
    Duration duration = MotionConfig.smooth,
    Curve curve = MotionCurves.easeOut,
    double begin = 0.0,
    double end = 1.0,
  }) {
    return AnimatedOpacity(
      opacity: end,
      duration: duration,
      curve: curve,
      child: this,
    );
  }

  Widget slideIn({
    Duration duration = MotionConfig.smooth,
    Curve curve = MotionCurves.easeOut,
    Offset begin = const Offset(0, 0.3),
    Offset end = Offset.zero,
  }) {
    return SlideTransition(
      position: Tween<Offset>(begin: begin, end: end).animate(
        CurvedAnimation(
          parent: AlwaysStoppedAnimation(1.0) as Animation<double>,
          curve: curve,
        ) as Animation<Offset>,
      ),
      child: this,
    );
  }

  Widget scaleIn({
    Duration duration = MotionConfig.fast,
    Curve curve = MotionCurves.easeOut,
    double begin = 0.8,
    double end = 1.0,
  }) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      child: this,
    );
  }

  Widget pulse({
    Duration duration = MotionConfig.celebration,
    Curve curve = MotionCurves.easeInOut,
  }) {
    return this;
  }

  Widget shake({
    Duration duration = MotionConfig.fast,
    int shakes = 3,
  }) {
    return this;
  }
}

class PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;

  const PulseAnimation({
    super.key,
    required this.child,
    this.duration = MotionConfig.celebration,
    this.minScale = 0.95,
    this.maxScale = 1.05,
  });

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: widget.minScale, end: widget.maxScale).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
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
        return Transform.scale(scale: _animation.value, child: widget.child);
      },
    );
  }
}

class FloatAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double offset;

  const FloatAnimation({
    super.key,
    required this.child,
    this.duration = MotionConfig.leisurely,
    this.offset = 10.0,
  });

  @override
  State<FloatAnimation> createState() => _FloatAnimationState();
}

class _FloatAnimationState extends State<FloatAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0.0, end: widget.offset).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
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
        return Transform.translate(offset: Offset(0, -_animation.value), child: widget.child);
      },
    );
  }
}

class ShakeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final int shakes;
  final double intensity;

  const ShakeAnimation({
    super.key,
    required this.child,
    this.duration = MotionConfig.fast,
    this.shakes = 3,
    this.intensity = 10.0,
  });

  @override
  State<ShakeAnimation> createState() => _ShakeAnimationState();
}

class _ShakeAnimationState extends State<ShakeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: -widget.intensity, end: widget.intensity).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  void trigger() {
    _controller.forward().then((_) => _controller.reverse());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: trigger,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(offset: Offset(_animation.value, 0), child: widget.child);
        },
      ),
    );
  }
}

class ScaleTapAnimation extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double minScale;
  final double maxScale;
  final Duration duration;

  const ScaleTapAnimation({
    super.key,
    required this.child,
    this.onTap,
    this.minScale = 0.95,
    this.maxScale = 1.0,
    this.duration = MotionConfig.fast,
  });

  @override
  State<ScaleTapAnimation> createState() => _ScaleTapAnimationState();
}

class _ScaleTapAnimationState extends State<ScaleTapAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: widget.maxScale, end: widget.minScale).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(scale: _animation.value, child: widget.child);
        },
      ),
    );
  }
}

class SlideInAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Offset begin;
  final Offset end;
  final Curve curve;

  const SlideInAnimation({
    super.key,
    required this.child,
    this.duration = MotionConfig.smooth,
    this.begin = const Offset(0, 0.3),
    this.end = Offset.zero,
    this.curves = Curves.easeOut,
  });

  @override
  State<SlideInAnimation> createState() => _SlideInAnimationState();
}

class _SlideInAnimationState extends State<SlideInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<Offset>(begin: widget.begin, end: widget.end).animate(
      CurvedAnimation(parent: _controller, curve: widget.curves),
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
    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }
}

class FadeInAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double begin;
  final double end;
  final Curve curve;

  const FadeInAnimation({
    super.key,
    required this.child,
    this.duration = MotionConfig.smooth,
    this.begin = 0.0,
    this.end = 1.0,
    this.curves = Curves.easeOut,
  });

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: widget.begin, end: widget.end).animate(
      CurvedAnimation(parent: _controller, curve: widget.curves),
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
      child: widget.child,
    );
  }
}

class StaggeredFadeIn extends StatefulWidget {
  final Widget child;
  final int index;
  final int total;
  final Duration duration;
  final Duration delay;

  const StaggeredFadeIn({
    super.key,
    required this.child,
    required this.index,
    required this.total,
    this.duration = MotionConfig.smooth,
    this.duration = const Duration(milliseconds: 80),
  });

  @override
  State<StaggeredFadeIn> createState() => _StaggeredFadeInState();
}

class _StaggeredFadeInState extends State<StaggeredFadeIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    final delay = Duration(milliseconds: widget.index * 80);
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration + delay,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          delay.inMilliseconds / (widget.duration + delay).inMilliseconds,
          1.0,
          curve: Curves.easeOut,
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
      child: widget.child,
    );
  }
}

class XPFloatAnimation extends StatefulWidget {
  final String text;
  final Duration duration;
  final double floatDistance;
  final Color color;

  const XPFloatAnimation({
    super.key,
    required this.text,
    this.duration = MotionConfig.celebration,
    this.floatDistance = 40.0,
    this.color = AppColors.primaryYellow,
  });

  @override
  State<XPFloatAnimation> createState() => _XPFloatAnimationState();
}

class _XPFloatAnimationState extends State<XPFloatAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _floatAnimation = Tween<double>(begin: 0.0, end: widget.floatDistance).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -_floatAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Text(
              widget.text,
              style: TextStyle(
                color: widget.color,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }
}

class CelebrationBurst extends StatefulWidget {
  final int particleCount;
  final Duration duration;
  final Color color;

  const CelebrationBurst({
    super.key,
    this.particleCount = 20,
    this.duration = MotionConfig.celebration,
    this.color = AppColors.primaryYellow,
  });

  @override
  State<CelebrationBurst> createState() => _CelebrationBurstState();
}

class _CelebrationBurstState extends State<CelebrationBurst>
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
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: List.generate(widget.particleCount, (index) {
            final angle = (index / widget.particleCount) * 3.14159 * 2;
            final distance = 50 * _animation.value;
            final opacity = 1.0 - _animation.value;
            return Positioned(
              left: 50 + distance * 0.5 * cos(angle),
              top: 50 + distance * 0.5 * sin(angle),
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

import 'dart:math';

class LevelUpAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool showOverlay;

  const LevelUpAnimation({
    super.key,
    required this.child,
    this.duration = MotionConfig.levelUp,
    this.showOverlay = true,
  });

  @override
  State<LevelUpAnimation> createState() => _LevelUpAnimationState();
}

class _LevelUpAnimationState extends State<LevelUpAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
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
    return Stack(
      children: [
        if (widget.showOverlay)
          Container(
            color: Colors.black.withValues(alpha: 0.5 * _fadeAnimation.value),
          ),
        Center(
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(scale: _scaleAnimation.value, child: widget.child);
            },
          ),
        ),
      ],
    );
  }
}

class StreakPulseAnimation extends StatefulWidget {
  final Widget child;
  final bool active;
  final Duration duration;

  const StreakPulseAnimation({
    super.key,
    required this.child,
    this.active = true,
    this.duration = MotionConfig.normal,
  });

  @override
  State<StreakPulseAnimation> createState() => _StreakPulseAnimationState();
}

class _StreakPulseAnimationState extends State<StreakPulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.active) {
      _controller.repeat(reverse: true);
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
        return Transform.scale(scale: _animation.value, child: widget.child);
      },
    );
  }
}

class AnimatedCounter extends StatefulWidget {
  final int endValue;
  final int startValue;
  final Duration duration;
  final TextStyle style;

  const AnimatedCounter({
    super.key,
    required this.endValue,
    this.startValue = 0,
    this.duration = MotionConfig.smooth,
    this.style = const TextStyle(),
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = IntTween(begin: widget.startValue, end: widget.endValue).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
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

class PageTransitionRoute extends PageRouteBuilder {
  final Widget page;
  final Duration duration;
  final Offset begin;

  PageTransitionRoute({
    required this.page,
    this.duration = MotionConfig.pageTransition,
    this.begin = const Offset(1.0, 0.0),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(begin: begin, end: Offset.zero).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
              child: child,
            );
          },
          transitionDuration: duration,
        );
}

class SharedAxisTransition extends StatelessWidget {
  final Widget child;
  final Axis axis;
  final Duration duration;

  const SharedAxisTransition({
    super.key,
    required this.child,
    this.axis = Axis.horizontal,
    this.duration = MotionConfig.pageTransition,
  });

  @override
  Widget build(BuildContext context) {
    return this;
  }
}

class CustomCurve extends Curve {
  final List<double> points;

  const CustomCurve(this.points);

  @override
  double transformInternal(double t) {
    return t;
  }
}

class SpringAnimation extends StatefulWidget {
  final Widget child;
  final double value;
  final Duration duration;
  final Curve curve;

  const SpringAnimation({
    super.key,
    required this.child,
    required this.value,
    this.duration = MotionConfig.normal,
    this.curve = Curves.easeOutBack,
  });

  @override
  State<SpringAnimation> createState() => _SpringAnimationState();
}

class _SpringAnimationState extends State<SpringAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0.0, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(scale: 1.0 + _animation.value * 0.1, child: widget.child);
      },
    );
  }
}

class ElasticAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double begin;
  final double end;

  const ElasticAnimation({
    super.key,
    required this.child,
    this.duration = MotionConfig.normal,
    this.begin = 0.0,
    this.end = 1.0,
  });

  @override
  State<ElasticAnimation> createState() => _ElasticAnimationState();
}

class _ElasticAnimationState extends State<ElasticAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: widget.begin, end: widget.end).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(scale: _animation.value, child: widget.child);
      },
    );
  }
}

class RotationAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double turns;
  final bool repeat;

  const RotationAnimation({
    super.key,
    required this.child,
    this.duration = MotionConfig.slow,
    this.turns = 1.0,
    this.repeat = true,
  });

  @override
  State<RotationAnimation> createState() => _RotationAnimationState();
}

class _RotationAnimationState extends State<RotationAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.repeat) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween<double>(begin: 0.0, end: widget.turns).animate(_controller),
      child: widget.child,
    );
  }
}

class CardFlipAnimation extends StatefulWidget {
  final Widget frontChild;
  final Widget backChild;
  final bool isFlipped;
  final Duration duration;

  const CardFlipAnimation({
    super.key,
    required this.frontChild,
    required this.backChild,
    required this.isFlipped,
    this.duration = MotionConfig.normal,
  });

  @override
  State<CardFlipAnimation> createState() => _CardFlipAnimationState();
}

class _CardFlipAnimationState extends State<CardFlipAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.isFlipped) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(CardFlipAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFlipped != widget.isFlipped) {
      if (widget.isFlipped) {
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
      animation: _controller,
      builder: (context, child) {
        final isUnder = _controller.value > 0.5;
        final front = Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(_controller.value * 3.14159),
          child: _controller.value <= 0.5 ? widget.frontChild : const SizedBox.shrink(),
        );
        final back = Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(_controller.value * 3.14159),
          child: _controller.value > 0.5 ? widget.backChild : const SizedBox.shrink(),
        );
        return Stack(
          children: [front, back],
        );
      },
    );
  }
}

class MotionPageRoute<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;
  final Duration duration;
  final Curve curve;
  final Offset begin;
  final Offset end;

  MotionPageRoute({
    required this.builder,
    this.duration = MotionConfig.pageTransition,
    this.curve = Curves.easeInOut,
    this.begin = const Offset(1.0, 0.0),
    this.end = Offset.zero,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(begin: begin, end: end).animate(
                CurvedAnimation(parent: animation, curve: curve),
              ),
              child: child,
            );
          },
          transitionDuration: duration,
        );
}

class FadePageRoute<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;
  final Duration duration;

  FadePageRoute({
    required this.builder,
    this.duration = MotionConfig.pageTransition,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              child: child,
            );
          },
          transitionDuration: duration,
        );
}

class ScalePageRoute<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;
  final Duration duration;

  ScalePageRoute({
    required this.builder,
    this.duration = MotionConfig.pageTransition,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
              scale: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              child: child,
            );
          },
          transitionDuration: duration,
        );
}

class AnimationShowcaseWidget extends StatefulWidget {
  const AnimationShowcaseWidget({super.key});

  @override
  State<AnimationShowcaseWidget> createState() => _AnimationShowcaseWidgetState();
}

class _AnimationShowcaseWidgetState extends State<AnimationShowcaseWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PulseAnimation(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: MotionGradients.primary,
              shape: BoxShape.circle,
            ),
            child: const Center(child: Icon(Icons.favorite_rounded, color: Colors.white, size: 40)),
          ),
        ),
        const SizedBox(height: 20),
        FloatAnimation(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: MotionGradients.reward,
              shape: BoxShape.circle,
            ),
            child: const Center(child: Icon(Icons.star_rounded, color: Colors.white, size: 40)),
          ),
        ),
        const SizedBox(height: 20),
        ScaleTapAnimation(
          onTap: () {},
          child: Container(
            width: 100,
            height: 40,
            decoration: BoxDecoration(
              gradient: MotionGradients.neonGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(child: Text('Tap Me', style: TextStyle(color: Colors.white))),
          ),
        ),
      ],
    );
  }
}
