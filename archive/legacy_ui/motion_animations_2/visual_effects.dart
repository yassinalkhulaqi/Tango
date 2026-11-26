import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui' as ui;

class NoiseTexture extends StatefulWidget {
  final Duration duration;
  final double intensity;

  const NoiseTexture({
    super.key,
    this.duration = const Duration(milliseconds: 100),
    this.intensity = 0.1,
  });

  @override
  State<NoiseTexture> createState() => _NoiseTextureState();
}

class _NoiseTextureState extends State<NoiseTexture>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<List<double>> _noise;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _noise = _generateNoise();
    _controller.repeat();
  }

  List<List<double>> _generateNoise() {
    return List.generate(50, (_) => List.generate(50, (_) => Random().nextDouble()));
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
        return CustomPaint(
          size: Size.infinite,
          painter: NoisePainter(_noise, widget.intensity),
        );
      },
    );
  }
}

class NoisePainter extends CustomPainter {
  final List<List<double>> noise;
  final double intensity;

  NoisePainter(this.noise, this.intensity);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final cellW = size.width / noise[0].length;
    final cellH = size.height / noise.length;
    for (int y = 0; y < noise.length; y++) {
      for (int x = 0; x < noise[0].length; x++) {
        final v = noise[y][x];
        paint.color = Color.fromRGBO(
          (v * 255).round(),
          (v * 255).round(),
          (v * 255).round(),
          intensity,
        );
        canvas.drawRect(Rect.fromLTWH(x * cellW, y * cellH, cellW, cellH), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant NoisePainter old) => true;
}

class GlowOrbs extends StatefulWidget {
  final int orbCount;
  final Duration duration;

  const GlowOrbs({
    super.key,
    this.orbCount = 10,
    this.duration = const Duration(seconds: 8),
  });

  @override
  State<GlowOrbs> createState() => _GlowOrbsState();
}

class _GlowOrbsState extends State<GlowOrbs>
    with TickerProviderStateMixin {
  late List<GlowOrb> _orbs;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _orbs = List.generate(widget.orbCount, (_) => _randomOrb());
    _controller.repeat();
  }

  GlowOrb _randomOrb() {
    return GlowOrb(
      position: Offset(
        Random().nextDouble() * 400,
        Random().nextDouble() * 400,
      ),
      velocity: Offset(
        (Random().nextDouble() - 0.5) * 1,
        (Random().nextDouble() - 0.5) * 1,
      ),
      size: Random().nextDouble() * 60 + 40,
      color: [
        const Color(0xFF38BDF8),
        const Color(0xFFA855F7),
        const Color(0xFF4ADE80),
        const Color(0xFFFACC15),
      ][Random().nextInt(4)],
    );
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
        return CustomPaint(
          size: Size.infinite,
          painter: GlowOrbsPainter(_orbs, _controller.value),
        );
      },
    );
  }
}

class GlowOrb {
  final Offset position;
  Offset velocity;
  final double size;
  final Color color;

  GlowOrb({
    required this.position,
    required this.velocity,
    required this.size,
    required this.color,
  });
}

class GlowOrbsPainter extends CustomPainter {
  final List<GlowOrb> orbs;
  final double animationValue;

  GlowOrbsPainter(this.orbs, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final orb in orbs) {
      final x = (orb.position.dx + orb.velocity.dx * animationValue * 20) % size.width;
      final y = (orb.position.dy + orb.velocity.dy * animationValue * 20) % size.height;
      paint.shader = ui.Gradient.radial(
        Offset(x, y),
        orb.size,
        [
          orb.color.withValues(alpha: 0.2),
          orb.color.withValues(alpha: 0.0),
        ],
      );
      canvas.drawCircle(Offset(x, y), orb.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant GlowOrbsPainter old) => true;
}

class BlurBackground extends StatefulWidget {
  final Widget child;
  final double sigma;
  final Duration duration;

  const BlurBackground({
    super.key,
    required this.child,
    this.sigma = 10.0,
    this.duration = const Duration(seconds: 5),
  });

  @override
  State<BlurBackground> createState() => _BlurBackgroundState();
}

class _BlurBackgroundState extends State<BlurBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
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
      animation: _controller,
      builder: (context, child) {
        return BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: widget.sigma * (0.5 + 0.5 * sin(_controller.value * 6.28318)),
            sigmaY: widget.sigma * (0.5 + 0.5 * sin(_controller.value * 6.28318)),
          ),
          child: child,
        );
      },
    );
  }
}

class ColorShift extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const ColorShift({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 5),
  });

  @override
  State<ColorShift> createState() => _ColorShiftState();
}

class _ColorShiftState extends State<ColorShift>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.repeat();
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
        return ColorFilter(
          colorFilter: ColorFilter.mode(
            HSLColor.fromAHSL(0.5, _controller.value, 0.6, 0.6).toColor().withValues(alpha: 0.2),
            BlendMode.hue,
          ),
          child: child,
        );
      },
    );
  }
}

class GlassMorphism extends StatefulWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final Duration duration;

  const GlassMorphism({
    super.key,
    required this.child,
    this.blur = 10.0,
    this.opacity = 0.1,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<GlassMorphism> createState() => _GlassMorphismState();
}

class _GlassMorphismState extends State<GlassMorphism>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
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
      animation: _controller,
      builder: (context, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: widget.blur * (0.5 + 0.5 * sin(_controller.value * 6.28318)),
              sigmaY: widget.blur * (0.5 + 0.5 * sin(_controller.value * 6.28318)),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: widget.opacity * (0.5 + 0.5 * sin(_controller.value * 6.28318))),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2 * (0.5 + 0.5 * sin(_controller.value * 6.28318))),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class NeonGlow extends StatefulWidget {
  final Widget child;
  final Color color;
  final double blur;
  final Duration duration;

  const NeonGlow({
    super.key,
    required this.child,
    required this.color,
    this.blur = 20.0,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<NeonGlow> createState() => _NeonGlowState();
}

class _NeonGlowState extends State<NeonGlow>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
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
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.5 + 0.3 * sin(_controller.value * 6.28318)),
                blurRadius: widget.blur * (0.5 + 0.5 * sin(_controller.value * 6.28318)),
                spreadRadius: 5 * (0.5 + 0.5 * sin(_controller.value * 6.28318)),
              ),
            ],
          ),
          child: child,
        );
      },
    );
  }
}

class InnerShadow extends StatefulWidget {
  final Widget child;
  final Color color;
  final double blur;
  final Duration duration;

  const InnerShadow({
    super.key,
    required this.child,
    this.color = Colors.black,
    this.blur = 10.0,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<InnerShadow> createState() => _InnerShadowState();
}

class _InnerShadowState extends State<InnerShadow>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
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
      animation: _controller,
      builder: (context, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: widget.blur * (0.5 + 0.5 * sin(_controller.value * 6.28318)),
              sigmaY: widget.blur * (0.5 + 0.5 * sin(_controller.value * 6.28318)),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.color.withValues(alpha: 0.1 * (0.5 + 0.5 * sin(_controller.value * 6.28318))),
                    widget.color.withValues(alpha: 0.05 * (0.5 + 0.5 * sin(_controller.value * 6.28318))),
                  ],
                ),
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class BevelEffect extends StatefulWidget {
  final Widget child;
  final double depth;
  final Duration duration;

  const BevelEffect({
    super.key,
    required this.child,
    this.depth = 4.0,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<BevelEffect> createState() => _BevelEffectState();
}

class _BevelEffectState extends State<BevelEffect>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
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
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0F141C),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.1 * (0.5 + 0.5 * sin(_controller.value * 6.28318))),
                offset: Offset(-widget.depth * (0.5 + 0.5 * sin(_controller.value * 6.28318)), -widget.depth * (0.5 + 0.5 * sin(_controller.value * 6.28318))),
                blurRadius: widget.depth * 2,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5 * (0.5 + 0.5 * sin(_controller.value * 6.28318))),
                offset: Offset(widget.depth * (0.5 + 0.5 * sin(_controller.value * 6.28318)), widget.depth * (0.5 + 0.5 * sin(_controller.value * 6.28318))),
                blurRadius: widget.depth * 2,
              ),
            ],
          ),
          child: child,
        );
      },
    );
  }
}

class EmbossEffect extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const EmbossEffect({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<EmbossEffect> createState() => _EmbossEffectState();
}

class _EmbossEffectState extends State<EmbossEffect>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
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
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0F141C),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.2 * (0.5 + 0.5 * sin(_controller.value * 6.28318))),
                offset: const Offset(-2, -2),
                blurRadius: 4,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5 * (0.5 + 0.5 * sin(_controller.value * 6.28318))),
                offset: const Offset(2, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: child,
        );
      },
    );
  }
}

class Claymorphism extends StatefulWidget {
  final Widget child;
  final double depth;
  final Color color;
  final Duration duration;

  const Claymorphism({
    super.key,
    required this.child,
    this.depth = 8.0,
    this.color = const Color(0xFF0F141C),
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<Claymorphism> createState() => _ClaymorphismState();
}

class _ClaymorphismState extends State<Claymorphism>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
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
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.1 * (0.5 + 0.5 * sin(_controller.value * 6.28318))),
                offset: Offset(-widget.depth * 0.5 * (0.5 + 0.5 * sin(_controller.value * 6.28318)), -widget.depth * 0.5 * (0.5 + 0.5 * sin(_controller.value * 6.28318))),
                blurRadius: widget.depth * (0.5 + 0.5 * sin(_controller.value * 6.28318)),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3 * (0.5 + 0.5 * sin(_controller.value * 6.28318))),
                offset: Offset(widget.depth * 0.5 * (0.5 + 0.5 * sin(_controller.value * 6.28318)), widget.depth * 0.5 * (0.5 + 0.5 * sin(_controller.value * 6.28318))),
                blurRadius: widget.depth * (0.5 + 0.5 * sin(_controller.value * 6.28318)),
              ),
            ],
          ),
          child: child,
        );
      },
    );
  }
}

class NeoMorphism extends StatefulWidget {
  final Widget child;
  final double light;
  final double dark;
  final Duration duration;

  const NeoMorphism({
    super.key,
    required this.child,
    this.light = 4.0,
    this.dark = 4.0,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<NeoMorphism> createState() => _NeoMorphismState();
}

class _NeoMorphismState extends State<NeoMorphism>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
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
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0F141C),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.1 * (0.5 + 0.5 * sin(_controller.value * 6.28318))),
                offset: Offset(-widget.light * (0.5 + 0.5 * sin(_controller.value * 6.28318)), -widget.light * (0.5 + 0.5 * sin(_controller.value * 6.28318))),
                blurRadius: widget.light * 2,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5 * (0.5 + 0.5 * sin(_controller.value * 6.28318))),
                offset: Offset(widget.dark * (0.5 + 0.5 * sin(_controller.value * 6.28318)), widget.dark * (0.5 + 0.5 * sin(_controller.value * 6.28318))),
                blurRadius: widget.dark * 2,
              ),
            ],
          ),
          child: child,
        );
      },
    );
  }
}

class LiquidGlass extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const LiquidGlass({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 4),
  });

  @override
  State<LiquidGlass> createState() => _LiquidGlassState();
}

class _LiquidGlassState extends State<LiquidGlass>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
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
      animation: _controller,
      builder: (context, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: 10 * (0.5 + 0.5 * sin(_controller.value * 6.28318)),
              sigmaY: 10 * (0.5 + 0.5 * sin(_controller.value * 6.28318)),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1 * (0.5 + 0.5 * sin(_controller.value * 6.28318))),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2 * (0.5 + 0.5 * sin(_controller.value * 6.28318))),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class AuroraBorealis extends StatefulWidget {
  final int curtainCount;
  final Duration duration;

  const AuroraBorealis({
    super.key,
    this.curtainCount = 5,
    this.duration = const Duration(seconds: 12),
  });

  @override
  State<AuroraBorealis> createState() => _AuroraBorealisState();
}

class _AuroraBorealisState extends State<AuroraBorealis>
    with TickerProviderStateMixin {
  late List<AuroraCurtain> _curtains;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _curtains = List.generate(widget.curtainCount, (_) => _randomCurtain());
    _controller.repeat();
  }

  AuroraCurtain _randomCurtain() {
    return AuroraCurtain(
      x: Random().nextDouble() * 400,
      width: Random().nextDouble() * 100 + 50,
      speed: Random().nextDouble() * 0.5 + 0.2,
      color: [
        const Color(0xFF4ADE80),
        const Color(0xFF38BDF8),
        const Color(0xFFA855F7),
      ][Random().nextInt(3)],
    );
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
        return CustomPaint(
          size: Size.infinite,
          painter: AuroraPainter(_curtains, _controller.value),
        );
      },
    );
  }
}

class AuroraCurtain {
  final double x;
  final double width;
  final double speed;
  final Color color;

  AuroraCurtain({
    required this.x,
    required this.width,
    required this.speed,
    required this.color,
  });
}

class AuroraPainter extends CustomPainter {
  final List<AuroraCurtain> curtains;
  final double animationValue;

  AuroraPainter(this.curtains, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 20);

    for (final curtain in curtains) {
      final x = (curtain.x + curtain.speed * animationValue * 100) % (size.width + 200) - 100;
      paint.shader = ui.Gradient.linear(
        Offset(x, 0),
        Offset(x + curtain.width, 0),
        [
          curtain.color.withValues(alpha: 0.0),
          curtain.color.withValues(alpha: 0.3),
          curtain.color.withValues(alpha: 0.0),
        ],
      );
      canvas.drawRect(Rect.fromLTWH(x, 0, curtain.width, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant AuroraPainter old) => true;
}

class LightStreaks extends StatefulWidget {
  final int streakCount;
  final Duration duration;

  const LightStreaks({
    super.key,
    this.streakCount = 8,
    this.duration = const Duration(seconds: 6),
  });

  @override
  State<LightStreaks> createState() => _LightStreaksState();
}

class _LightStreaksState extends State<LightStreaks>
    with TickerProviderStateMixin {
  late List<LightStreak> _streaks;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _streaks = List.generate(widget.streakCount, (_) => _randomStreak());
    _controller.repeat();
  }

  LightStreak _randomStreak() {
    return LightStreak(
      x: Random().nextDouble() * 400,
      y: Random().nextDouble() * 400,
      length: Random().nextDouble() * 100 + 50,
      angle: Random().nextDouble() * 6.28318,
      speed: Random().nextDouble() * 2 + 1,
      color: [
        const Color(0xFF38BDF8),
        const Color(0xFFFACC15),
        const Color(0xFF4ADE80),
      ][Random().nextInt(3)],
    );
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
        return CustomPaint(
          size: Size.infinite,
          painter: LightStreaksPainter(_streaks, _controller.value),
        );
      },
    );
  }
}

class LightStreak {
  final double x;
  final double y;
  final double length;
  final double angle;
  final double speed;
  final Color color;

  LightStreak({
    required this.x,
    required this.y,
    required this.length,
    required this.angle,
    required this.speed,
    required this.color,
  });
}

class LightStreaksPainter extends CustomPainter {
  final List<LightStreak> streaks;
  final double animationValue;

  LightStreaksPainter(this.streaks, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (final streak in streaks) {
      final t = (animationValue * streak.speed) % 1.0;
      final sx = streak.x + streak.length * cos(streak.angle) * t;
      final sy = streak.y + streak.length * sin(streak.angle) * t;
      final ex = streak.x + streak.length * cos(streak.angle);
      final ey = streak.y + streak.length * sin(streak.angle);
      paint.color = streak.color.withValues(alpha: streak.color.alpha * (1 - t));
      canvas.drawLine(Offset(sx, sy), Offset(ex, ey), paint);
    }
  }

  @override
  bool shouldRepaint(covariant LightStreaksPainter old) => true;
}

class MeteorShower extends StatefulWidget {
  final int meteorCount;
  final Duration duration;

  const MeteorShower({
    super.key,
    this.meteorCount = 5,
    this.duration = const Duration(seconds: 8),
  });

  @override
  State<MeteorShower> createState() => _MeteorShowerState();
}

class _MeteorShowerState extends State<MeteorShower>
    with TickerProviderStateMixin {
  late List<Meteor> _meteors;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _meteors = List.generate(widget.meteorCount, (_) => _randomMeteor());
    _controller.repeat();
  }

  Meteor _randomMeteor() {
    return Meteor(
      x: Random().nextDouble() * 400,
      y: Random().nextDouble() * -100,
      speed: Random().nextDouble() * 3 + 1,
      angle: Random().nextDouble() * 1.0 + 0.5,
      length: Random().nextDouble() * 50 + 20,
      color: const Color(0xFF4ADE80),
    );
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
        return CustomPaint(
          size: Size.infinite,
          painter: MeteorPainter(_meteors, _controller.value),
        );
      },
    );
  }
}

class Meteor {
  final double x;
  double y;
  final double speed;
  final double angle;
  final double length;
  final Color color;

  Meteor({
    required this.x,
    required this.y,
    required this.speed,
    required this.angle,
    required this.length,
    required this.color,
  });
}

class MeteorPainter extends CustomPainter {
  final List<Meteor> meteors;
  final double animationValue;

  MeteorPainter(this.meteors, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (final meteor in meteors) {
      final t = (animationValue * meteor.speed) % 1.0;
      final sx = meteor.x + meteor.length * cos(meteor.angle) * t;
      final sy = meteor.y + meteor.length * sin(meteor.angle) * t;
      final ex = meteor.x + meteor.length * cos(meteor.angle);
      final ey = meteor.y + meteor.length * sin(meteor.angle);
      paint.color = meteor.color.withValues(alpha: meteor.color.alpha * (1 - t));
      canvas.drawLine(Offset(sx, sy), Offset(ex, ey), paint);
    }
  }

  @override
  bool shouldRepaint(covariant MeteorPainter old) => true;
}

class CometTrail extends StatefulWidget {
  final int cometCount;
  final Duration duration;

  const CometTrail({
    super.key,
    this.cometCount = 3,
    this.duration = const Duration(seconds: 6),
  });

  @override
  State<CometTrail> createState() => _CometTrailState();
}

class _CometTrailState extends State<CometTrail>
    with TickerProviderStateMixin {
  late List<Comet> _comets;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _comets = List.generate(widget.cometCount, (_) => _randomComet());
    _controller.repeat();
  }

  Comet _randomComet() {
    return Comet(
      x: Random().nextDouble() * 400,
      y: Random().nextDouble() * 400,
      vx: (Random().nextDouble() - 0.5) * 2,
      vy: (Random().nextDouble() - 0.5) * 2,
      trail: List.generate(10, (_) => Offset.zero),
      color: const Color(0xFFFACC15),
    );
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
        return CustomPaint(
          size: Size.infinite,
          painter: CometPainter(_comets, _controller.value),
        );
      },
    );
  }
}

class Comet {
  double x;
  double y;
  final double vx;
  final double vy;
  List<Offset> trail;
  final Color color;

  Comet({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.trail,
    required this.color,
  });
}

class CometPainter extends CustomPainter {
  final List<Comet> comets;
  final double animationValue;

  CometPainter(this.comets, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (final comet in comets) {
      comet.x += comet.vx * animationValue * 5;
      comet.y += comet.vy * animationValue * 5;
      if (comet.x < 0 || comet.x > size.width) comet.vx = -comet.vx;
      if (comet.y < 0 || comet.y > size.height) comet.vy = -comet.vy;
      comet.trail.add(Offset(comet.x, comet.y));
      if (comet.trail.length > 10) comet.trail.removeAt(0);

      for (int i = 0; i < comet.trail.length; i++) {
        paint.color = comet.color.withValues(alpha: comet.color.alpha * (i / comet.trail.length));
        canvas.drawCircle(comet.trail[i], 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CometPainter old) => true;
}

class ColorShiftOverlay extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const ColorShiftOverlay({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 6),
  });

  @override
  State<ColorShiftOverlay> createState() => _ColorShiftOverlayState();
}

class _ColorShiftOverlayState extends State<ColorShiftOverlay>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.repeat();
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
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF38BDF8).withValues(alpha: _controller.value * 0.1),
                const Color(0xFFA855F7).withValues(alpha: _controller.value * 0.1),
                const Color(0xFF4ADE80).withValues(alpha: _controller.value * 0.1),
              ],
            ),
          ),
          child: child,
        );
      },
    );
  }
}

class AnimatedBorder extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double width;

  const AnimatedBorder({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 3),
    this.width = 3.0,
  });

  @override
  State<AnimatedBorder> createState() => _AnimatedBorderState();
}

class _AnimatedBorderState extends State<AnimatedBorder>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.repeat();
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
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: HSLColor.fromAHSL(0.5, _controller.value, 0.6, 0.6).toColor(),
              width: widget.width,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: child,
        );
      },
    );
  }
}

class AnimatedShadow extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double blur;
  final Color color;

  const AnimatedShadow({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 3),
    this.blur = 20.0,
    this.color = const Color(0xFF38BDF8),
  });

  @override
  State<AnimatedShadow> createState() => _AnimatedShadowState();
}

class _AnimatedShadowState extends State<AnimatedShadow>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
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
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.3 + 0.2 * sin(_controller.value * 6.28318)),
                blurRadius: widget.blur * (0.5 + 0.5 * sin(_controller.value * 6.28318)),
                spreadRadius: 5 * (0.5 + 0.5 * sin(_controller.value * 6.28318)),
              ),
            ],
          ),
          child: child,
        );
      },
    );
  }
}

class AnimatedGlow extends StatefulWidget {
  final Widget child;
  final Color color;
  final Duration duration;

  const AnimatedGlow({
    super.key,
    required this.child,
    required this.color,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<AnimatedGlow> createState() => _AnimatedGlowState();
}

class _AnimatedGlowState extends State<AnimatedGlow>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
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
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.4 + 0.3 * sin(_controller.value * 6.28318)),
                blurRadius: 30 * (0.5 + 0.5 * sin(_controller.value * 6.28318)),
                spreadRadius: 10 * (0.5 + 0.5 * sin(_controller.value * 6.28318)),
              ),
            ],
          ),
          child: child,
        );
      },
    );
  }
}

class ShimmerBorder extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double width;

  const ShimmerBorder({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.width = 2.0,
  });

  @override
  State<ShimmerBorder> createState() => _ShimmerBorderState();
}

class _ShimmerBorderState extends State<ShimmerBorder>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.repeat();
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
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                const Color(0xFF38BDF8).withValues(alpha: _controller.value),
                Colors.transparent,
              ],
              stops: [0.0, 0.5, 1.0],
            ),
            border: Border.all(
              color: const Color(0xFF38BDF8).withValues(alpha: 0.5),
              width: widget.width,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: child,
        );
      },
    );
  }
}

class PulseBorder extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Color color;

  const PulseBorder({
    super.key,
    required this.child,
    required this.color,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<PulseBorder> createState() => _PulseBorderState();
}

class _PulseBorderState extends State<PulseBorder>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
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
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.color.withValues(alpha: 0.3 + 0.4 * sin(_controller.value * 6.28318)),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: child,
        );
      },
    );
  }
}

class AnimatedVignette extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double intensity;

  const AnimatedVignette({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 5),
    this.intensity = 0.3,
  });

  @override
  State<AnimatedVignette> createState() => _AnimatedVignetteState();
}

class _AnimatedVignetteState extends State<AnimatedVignette>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
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
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 0.7 + 0.2 * sin(_controller.value * 6.28318),
              colors: [
                Colors.black.withValues(alpha: widget.intensity * (0.5 + 0.5 * sin(_controller.value * 6.28318))),
                Colors.transparent,
              ],
            ),
          ),
          child: child,
        );
      },
    );
  }
}

class AnimatedFocus extends StatefulWidget {
  final Widget child;
  final bool isFocused;
  final Duration duration;

  const AnimatedFocus({
    super.key,
    required this.child,
    required this.isFocused,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<AnimatedFocus> createState() => _AnimatedFocusState();
}

class _AnimatedFocusState extends State<AnimatedFocus>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.isFocused) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void didUpdateWidget(AnimatedFocus oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFocused != widget.isFocused) {
      if (widget.isFocused) {
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
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF38BDF8).withValues(alpha: 0.3 * _controller.value),
                blurRadius: 20 * _controller.value,
                spreadRadius: 5 * _controller.value,
              ),
            ],
          ),
          child: child,
        );
      },
    );
  }
}

class AnimatedSelection extends StatefulWidget {
  final Widget child;
  final bool isSelected;
  final Duration duration;

  const AnimatedSelection({
    super.key,
    required this.child,
    required this.isSelected,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<AnimatedSelection> createState() => _AnimatedSelectionState();
}

class _AnimatedSelectionState extends State<AnimatedSelection>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.isSelected) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void didUpdateWidget(AnimatedSelection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected) {
      if (widget.isSelected) {
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
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF38BDF8).withValues(alpha: 0.1 * _controller.value),
            border: Border.all(
              color: const Color(0xFF38BDF8).withValues(alpha: 0.5 * _controller.value),
              width: 2 * _controller.value,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: child,
        );
      },
    );
  }
}

class AnimatedHover extends StatefulWidget {
  final Widget child;
  final bool isHovered;
  final Duration duration;

  const AnimatedHover({
    super.key,
    required this.child,
    required this.isHovered,
    this.duration = const Duration(milliseconds: 200),
  });

  @override
  State<AnimatedHover> createState() => _AnimatedHoverState();
}

class _AnimatedHoverState extends State<AnimatedHover>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.isHovered) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void didUpdateWidget(AnimatedHover oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isHovered != widget.isHovered) {
      if (widget.isHovered) {
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
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF38BDF8).withValues(alpha: 0.1 * _controller.value),
            borderRadius: BorderRadius.circular(12),
          ),
          child: child,
        );
      },
    );
  }
}

class AnimatedPress extends StatefulWidget {
  final Widget child;
  final bool isPressed;
  final Duration duration;

  const AnimatedPress({
    super.key,
    required this.child,
    required this.isPressed,
    this.duration = const Duration(milliseconds: 100),
  });

  @override
  State<AnimatedPress> createState() => _AnimatedPressState();
}

class _AnimatedPressState extends State<AnimatedPress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.isPressed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void didUpdateWidget(AnimatedPress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPressed != widget.isPressed) {
      if (widget.isPressed) {
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
        return Transform.scale(
          scale: 1.0 - 0.05 * _controller.value,
          child: child,
        );
      },
    );
  }
}
