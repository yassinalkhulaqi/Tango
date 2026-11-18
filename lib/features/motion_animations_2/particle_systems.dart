import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui' as ui;

class ParticleSystem extends StatefulWidget {
  final int particleCount;
  final Duration duration;
  final Color color;
  final bool emitOnTap;

  const ParticleSystem({
    super.key,
    this.particleCount = 50,
    this.duration = const Duration(seconds: 2),
    this.color = const Color(0xFF38BDF8),
    this.emitOnTap = true,
  });

  @override
  State<ParticleSystem> createState() => _ParticleSystemState();
}

class _ParticleSystemState extends State<ParticleSystem>
    with TickerProviderStateMixin {
  late List<Particle> _particles;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _particles = List.generate(widget.particleCount, (_) => _randomParticle());
    _controller.repeat();
  }

  Particle _randomParticle() {
    return Particle(
      position: Offset(
        Random().nextDouble() * 300,
        Random().nextDouble() * 300,
      ),
      velocity: Offset(
        (Random().nextDouble() - 0.5) * 2,
        (Random().nextDouble() - 0.5) * 2,
      ),
      size: Random().nextDouble() * 4 + 2,
      color: widget.color.withValues(alpha: Random().nextDouble() * 0.5 + 0.2),
      life: Random().nextDouble(),
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
          painter: ParticlePainter(_particles, _controller.value),
        );
      },
    );
  }
}

class Particle {
  final Offset position;
  final Offset velocity;
  final double size;
  final Color color;
  final double life;

  Particle({
    required this.position,
    required this.velocity,
    required this.size,
    required this.color,
    required this.life,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final particle in particles) {
      final x = (particle.position.dx + particle.velocity.dx * animationValue * 100) % size.width;
      final y = (particle.position.dy + particle.velocity.dy * animationValue * 100) % size.height;
      paint.color = particle.color.withValues(alpha: particle.color.alpha * (1 - animationValue * 0.5));
      canvas.drawCircle(Offset(x, y), particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter old) => true;
}

class ConfettiSystem extends StatefulWidget {
  final int particleCount;
  final Duration duration;
  final List<Color> colors;

  const ConfettiSystem({
    super.key,
    this.particleCount = 100,
    this.duration = const Duration(seconds: 3),
    this.colors = const [
      Color(0xFF38BDF8),
      Color(0xFFFACC15),
      Color(0xFF4ADE80),
      Color(0xFFA855F7),
      Color(0xFFFB923C),
      Color(0xFF22D3EE),
    ],
  });

  @override
  State<ConfettiSystem> createState() => _ConfettiSystemState();
}

class _ConfettiSystemState extends State<ConfettiSystem>
    with TickerProviderStateMixin {
  late List<ConfettiParticle> _particles;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _particles = List.generate(widget.particleCount, (_) => _randomParticle());
    _controller.forward();
  }

  ConfettiParticle _randomParticle() {
    return ConfettiParticle(
      position: Offset.zero,
      velocity: Offset(
        (Random().nextDouble() - 0.5) * 10,
        (Random().nextDouble() - 0.5) * 10,
      ),
      angle: Random().nextDouble() * 6.28318,
      angularVelocity: (Random().nextDouble() - 0.5) * 4,
      color: widget.colors[Random().nextInt(widget.colors.length)],
      size: Size(
        Random().nextDouble() * 6 + 4,
        Random().nextDouble() * 6 + 4,
      ),
      gravity: Random().nextDouble() * 0.5 + 0.3,
      life: Random().nextDouble() + 0.5,
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
          painter: ConfettiPainter(_particles, _controller.value),
        );
      },
    );
  }
}

class ConfettiParticle {
  final Offset position;
  final Offset velocity;
  final double angle;
  final double angularVelocity;
  final Color color;
  final Size size;
  final double gravity;
  final double life;

  ConfettiParticle({
    required this.position,
    required this.velocity,
    required this.angle,
    required this.angularVelocity,
    required this.color,
    required this.size,
    required this.gravity,
    required this.life,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double animationValue;

  ConfettiPainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final particle in particles) {
      final t = animationValue / particle.life;
      if (t > 1.0) continue;
      final x = particle.position.dx + particle.velocity.dx * animationValue * 100;
      final y = particle.position.dy + particle.velocity.dy * animationValue * 100 + 0.5 * particle.gravity * (animationValue * 100) * (animationValue * 100);
      paint.color = particle.color.withValues(alpha: particle.color.alpha * (1 - t));
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(particle.angle + particle.angularVelocity * animationValue * 100);
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: particle.size.width, height: particle.size.height),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant ConfettiPainter old) => true;
}

class FireworkSystem extends StatefulWidget {
  final int fireworkCount;
  final Duration duration;

  const FireworkSystem({
    super.key,
    this.fireworkCount = 10,
    this.duration = const Duration(seconds: 4),
  });

  @override
  State<FireworkSystem> createState() => _FireworkSystemState();
}

class _FireworkSystemState extends State<FireworkSystem>
    with TickerProviderStateMixin {
  late List<Firework> _fireworks;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _fireworks = List.generate(widget.fireworkCount, (_) => _randomFirework());
    _controller.repeat();
  }

  Firework _randomFirework() {
    return Firework(
      position: Offset(
        Random().nextDouble() * 400,
        Random().nextDouble() * 400,
      ),
      explosionTime: Random().nextDouble(),
      color: [
        const Color(0xFF38BDF8),
        const Color(0xFFFACC15),
        const Color(0xFF4ADE80),
        const Color(0xFFA855F7),
        const Color(0xFFFB923C),
      ][Random().nextInt(5)],
      particleCount: Random().nextInt(30) + 20,
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
          painter: FireworkPainter(_fireworks, _controller.value),
        );
      },
    );
  }
}

class Firework {
  final Offset position;
  final double explosionTime;
  final Color color;
  final int particleCount;

  Firework({
    required this.position,
    required this.explosionTime,
    required this.color,
    required this.particleCount,
  });
}

class FireworkPainter extends CustomPainter {
  final List<Firework> fireworks;
  final double animationValue;

  FireworkPainter(this.fireworks, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final firework in fireworks) {
      final t = (animationValue - firework.explosionTime).clamp(0.0, 1.0);
      if (t < 0.0 || t > 1.0) continue;
      paint.color = firework.color.withValues(alpha: firework.color.alpha * (1 - t));
      for (int i = 0; i < firework.particleCount; i++) {
        final angle = (i / firework.particleCount) * 6.28318;
        final distance = 50 * t;
        final x = firework.position.dx + distance * cos(angle);
        final y = firework.position.dy + distance * sin(angle);
        canvas.drawCircle(Offset(x, y), 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant FireworkPainter old) => true;
}

class MatrixRain extends StatefulWidget {
  final int columnCount;
  final Duration duration;

  const MatrixRain({
    super.key,
    this.columnCount = 20,
    this.duration = const Duration(seconds: 5),
  });

  @override
  State<MatrixRain> createState() => _MatrixRainState();
}

class _MatrixRainState extends State<MatrixRain>
    with TickerProviderStateMixin {
  late List<MatrixColumn> _columns;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _columns = List.generate(widget.columnCount, (_) => _randomColumn());
    _controller.repeat();
  }

  MatrixColumn _randomColumn() {
    return MatrixColumn(
      x: Random().nextDouble() * 400,
      y: Random().nextDouble() * -200,
      speed: Random().nextDouble() * 2 + 1,
      characters: List.generate(10, (_) => String.fromCharCode(Random().nextInt(94) + 33)),
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
          painter: MatrixPainter(_columns, _controller.value),
        );
      },
    );
  }
}

class MatrixColumn {
  final double x;
  double y;
  final double speed;
  final List<String> characters;

  MatrixColumn({
    required this.x,
    required this.y,
    required this.speed,
    required this.characters,
  });
}

class MatrixPainter extends CustomPainter {
  final List<MatrixColumn> columns;
  final double animationValue;

  MatrixPainter(this.columns, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    for (final column in columns) {
      final y = (column.y + column.speed * animationValue * 200) % (size.height + 200) - 100;
      for (int i = 0; i < column.characters.length; i++) {
        final charY = y - i * 20;
        if (charY > size.height || charY < -20) continue;
        textPainter.text = TextSpan(
          text: column.characters[i],
          style: const TextStyle(
            color: Color(0xFF00FF00),
            fontSize: 16,
            fontFamily: 'monospace',
          ),
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(column.x, charY));
      }
    }
  }

  @override
  bool shouldRepaint(covariant MatrixPainter old) => true;
}

class StarField extends StatefulWidget {
  final int starCount;
  final Duration duration;

  const StarField({
    super.key,
    this.starCount = 100,
    this.duration = const Duration(seconds: 10),
  });

  @override
  State<StarField> createState() => _StarFieldState();
}

class _StarFieldState extends State<StarField>
    with TickerProviderStateMixin {
  late List<Star> _stars;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _stars = List.generate(widget.starCount, (_) => _randomStar());
    _controller.repeat();
  }

  Star _randomStar() {
    return Star(
      position: Offset(
        Random().nextDouble() * 400,
        Random().nextDouble() * 400,
      ),
      size: Random().nextDouble() * 2 + 1,
      twinkleSpeed: Random().nextDouble() * 2 + 0.5,
      twinkleOffset: Random().nextDouble() * 6.28318,
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
          painter: StarPainter(_stars, _controller.value),
        );
      },
    );
  }
}

class Star {
  final Offset position;
  final double size;
  final double twinkleSpeed;
  final double twinkleOffset;

  Star({
    required this.position,
    required this.size,
    required this.twinkleSpeed,
    required this.twinkleOffset,
  });
}

class StarPainter extends CustomPainter {
  final List<Star> stars;
  final double animationValue;

  StarPainter(this.stars, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final star in stars) {
      final alpha = 0.3 + 0.7 * sin(animationValue * star.twinkleSpeed + star.twinkleOffset);
      paint.color = const Color(0xFFFFFFFF).withValues(alpha: alpha.clamp(0.0, 1.0));
      canvas.drawCircle(star.position, star.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant StarPainter old) => true;
}

class NebulaBackground extends StatefulWidget {
  final int nebulaCount;
  final Duration duration;

  const NebulaBackground({
    super.key,
    this.nebulaCount = 5,
    this.duration = const Duration(seconds: 8),
  });

  @override
  State<NebulaBackground> createState() => _NebulaBackgroundState();
}

class _NebulaBackgroundState extends State<NebulaBackground>
    with TickerProviderStateMixin {
  late List<Nebula> _nebulae;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _nebulae = List.generate(widget.nebulaCount, (_) => _randomNebula());
    _controller.repeat(reverse: true);
  }

  Nebula _randomNebula() {
    return Nebula(
      position: Offset(
        Random().nextDouble() * 400,
        Random().nextDouble() * 400,
      ),
      size: Random().nextDouble() * 200 + 100,
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
          painter: NebulaPainter(_nebulae, _controller.value),
        );
      },
    );
  }
}

class Nebula {
  final Offset position;
  final double size;
  final Color color;

  Nebula({
    required this.position,
    required this.size,
    required this.color,
  });
}

class NebulaPainter extends CustomPainter {
  final List<Nebula> nebulae;
  final double animationValue;

  NebulaPainter(this.nebulae, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (final nebula in nebulae) {
      final paint = Paint()
        ..shader = ui.Gradient.radial(
          nebula.position,
          nebula.size * (0.8 + 0.2 * sin(animationValue * 3.14159)),
          [
            nebula.color.withValues(alpha: 0.1),
            nebula.color.withValues(alpha: 0.0),
          ],
        );
      canvas.drawCircle(nebula.position, nebula.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant NebulaPainter old) => true;
}

class GridBackground extends StatefulWidget {
  final int gridSize;
  final Duration duration;

  const GridBackground({
    super.key,
    this.gridSize = 40,
    this.duration = const Duration(seconds: 10),
  });

  @override
  State<GridBackground> createState() => _GridBackgroundState();
}

class _GridBackgroundState extends State<GridBackground>
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
        return CustomPaint(
          size: Size.infinite,
          painter: GridPainter(widget.gridSize, _controller.value),
        );
      },
    );
  }
}

class GridPainter extends CustomPainter {
  final int gridSize;
  final double animationValue;

  GridPainter(this.gridSize, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E293B).withValues(alpha: 0.3)
      ..strokeWidth = 1;

    final offsetX = animationValue * gridSize;
    final offsetY = animationValue * gridSize;

    for (double x = -gridSize + offsetX; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = -gridSize + offsetY; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter old) => true;
}

class HologramEffect extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const HologramEffect({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<HologramEffect> createState() => _HologramEffectState();
}

class _HologramEffectState extends State<HologramEffect>
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
        return ColorFiltered(
          colorFilter: ColorFilter.mode(
            const Color(0xFF00FF00).withValues(alpha: 0.3 + 0.2 * sin(_controller.value * 6.28318)),
            BlendMode.color,
          ),
          child: Opacity(
            opacity: 0.8 + 0.2 * sin(_controller.value * 6.28318),
            child: child,
          ),
        );
      },
    );
  }
}

class ScanlineEffect extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const ScanlineEffect({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<ScanlineEffect> createState() => _ScanlineEffectState();
}

class _ScanlineEffectState extends State<ScanlineEffect>
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
        return CustomPaint(
          size: Size.infinite,
          painter: ScanlinePainter(_controller.value),
        );
      },
    );
  }
}

class ScanlinePainter extends CustomPainter {
  final double animationValue;

  ScanlinePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00FF00).withValues(alpha: 0.1)
      ..strokeWidth = 2;

    final lineY = (animationValue * size.height) % (size.height + 20) - 10;
    canvas.drawLine(Offset(0, lineY), Offset(size.width, lineY), paint);
  }

  @override
  bool shouldRepaint(covariant ScanlinePainter old) => true;
}

class GlitchEffect extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double intensity;

  const GlitchEffect({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 1),
    this.intensity = 10.0,
  });

  @override
  State<GlitchEffect> createState() => _GlitchEffectState();
}

class _GlitchEffectState extends State<GlitchEffect>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _offsetAnimation = Tween<double>(begin: 0.0, end: widget.intensity).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward().then((_) => _controller.reverse());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(_offsetAnimation.value, 0),
      child: child,
    );
  }
}

class ChromaticAberration extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double offset;

  const ChromaticAberration({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 1),
    this.offset = 5.0,
  });

  @override
  State<ChromaticAberration> createState() => _ChromaticAberrationState();
}

class _ChromaticAberrationState extends State<ChromaticAberration>
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
        return Stack(
          children: [
            child,
            Positioned.fill(
              child: ClipRect(
                child: OverflowBox(
                  alignment: Alignment.center,
                  child: Transform.translate(
                    offset: Offset(widget.offset * sin(_controller.value * 6.28318), 0),
                    child: child,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class RippleEffect extends StatefulWidget {
  final Widget child;
  final int rippleCount;
  final Duration duration;

  const RippleEffect({
    super.key,
    required this.child,
    this.rippleCount = 5,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<RippleEffect> createState() => _RippleEffectState();
}

class _RippleEffectState extends State<RippleEffect>
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
        return CustomPaint(
          size: Size.infinite,
          painter: RipplePainter(widget.rippleCount, _controller.value),
          child: child,
        );
      },
    );
  }
}

class RipplePainter extends CustomPainter {
  final int rippleCount;
  final double animationValue;

  RipplePainter(this.rippleCount, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < rippleCount; i++) {
      final t = (animationValue - i / rippleCount).clamp(0.0, 1.0);
      if (t < 0.0) continue;
      paint.color = const Color(0xFF38BDF8).withValues(alpha: 0.5 * (1 - t));
      canvas.drawCircle(center, 100 * t, paint);
    }
  }

  @override
  bool shouldRepaint(covariant RipplePainter old) => true;
}

class PulseRing extends StatefulWidget {
  final int ringCount;
  final Duration duration;
  final Color color;

  const PulseRing({
    super.key,
    this.ringCount = 3,
    this.duration = const Duration(seconds: 2),
    this.color = const Color(0xFF38BDF8),
  });

  @override
  State<PulseRing> createState() => _PulseRingState();
}

class _PulseRingState extends State<PulseRing>
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
        return CustomPaint(
          size: Size.infinite,
          painter: PulseRingPainter(widget.ringCount, _controller.value, widget.color),
        );
      },
    );
  }
}

class PulseRingPainter extends CustomPainter {
  final int ringCount;
  final double animationValue;
  final Color color;

  PulseRingPainter(this.ringCount, this.animationValue, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < ringCount; i++) {
      final t = (animationValue - i / ringCount).clamp(0.0, 1.0);
      if (t < 0.0) continue;
      paint.color = color.withValues(alpha: color.alpha * (1 - t));
      canvas.drawCircle(center, 50 * t, paint);
    }
  }

  @override
  bool shouldRepaint(covariant PulseRingPainter old) => true;
}

class WaveBackground extends StatefulWidget {
  final int waveCount;
  final Duration duration;

  const WaveBackground({
    super.key,
    this.waveCount = 3,
    this.duration = const Duration(seconds: 5),
  });

  @override
  State<WaveBackground> createState() => _WaveBackgroundState();
}

class _WaveBackgroundState extends State<WaveBackground>
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
        return CustomPaint(
          size: Size.infinite,
          painter: WavePainter(widget.waveCount, _controller.value),
        );
      },
    );
  }
}

class WavePainter extends CustomPainter {
  final int waveCount;
  final double animationValue;

  WavePainter(this.waveCount, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < waveCount; i++) {
      final color = [
        const Color(0xFF38BDF8),
        const Color(0xFFA855F7),
        const Color(0xFF4ADE80),
      ][i % 3];
      paint.color = color.withValues(alpha: 0.2);
      final path = Path();
      for (double x = 0; x <= size.width; x += 10) {
        final y = size.height / 2 + 50 * sin(x * 0.02 + animationValue * 6.28318 + i * 2);
        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant WavePainter old) => true;
}

class AudioVisualizer extends StatefulWidget {
  final int barCount;
  final Duration duration;

  const AudioVisualizer({
    super.key,
    this.barCount = 20,
    this.duration = const Duration(seconds: 1),
  });

  @override
  State<AudioVisualizer> createState() => _AudioVisualizerState();
}

class _AudioVisualizerState extends State<AudioVisualizer>
    with TickerProviderStateMixin {
  late List<double> _barHeights;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _barHeights = List.generate(widget.barCount, (_) => Random().nextDouble());
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
        return CustomPaint(
          size: Size.infinite,
          painter: AudioVisualizerPainter(_barHeights, _controller.value),
        );
      },
    );
  }
}

class AudioVisualizerPainter extends CustomPainter {
  final List<double> barHeights;
  final double animationValue;

  AudioVisualizerPainter(this.barHeights, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final barWidth = size.width / barHeights.length;
    for (int i = 0; i < barHeights.length; i++) {
      final height = barHeights[i] * (0.5 + 0.5 * sin(animationValue * 6.28318 + i * 0.5));
      final x = i * barWidth + barWidth / 2;
      final y = size.height / 2;
      canvas.drawLine(
        Offset(x, y - height * 50),
        Offset(x, y + height * 50),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant AudioVisualizerPainter old) => true;
}

class LiquidFill extends StatefulWidget {
  final Widget child;
  final double fillLevel;
  final Duration duration;

  const LiquidFill({
    super.key,
    required this.child,
    required this.fillLevel,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<LiquidFill> createState() => _LiquidFillState();
}

class _LiquidFillState extends State<LiquidFill>
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
        return CustomPaint(
          size: Size.infinite,
          painter: LiquidFillPainter(widget.fillLevel, _controller.value),
          child: child,
        );
      },
    );
  }
}

class LiquidFillPainter extends CustomPainter {
  final double fillLevel;
  final double animationValue;

  LiquidFillPainter(this.fillLevel, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: 0.3);

    final waveY = size.height * (1 - fillLevel) + 20 * sin(animationValue * 6.28318);
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, waveY);
    for (double x = 0; x <= size.width; x += 10) {
      path.lineTo(x, waveY + 10 * sin(x * 0.05 + animationValue * 6.28318));
    }
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant LiquidFillPainter old) => true;
}

class MorphingShape extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const MorphingShape({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<MorphingShape> createState() => _MorphingShapeState();
}

class _MorphingShapeState extends State<MorphingShape>
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
        return CustomPaint(
          size: Size.infinite,
          painter: MorphingShapePainter(_controller.value),
          child: child,
        );
      },
    );
  }
}

class MorphingShapePainter extends CustomPainter {
  final double animationValue;

  MorphingShapePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(center.dx, center.dy - 50);
    path.cubicTo(
      center.dx + 100 * cos(animationValue * 6.28318),
      center.dy - 50 + 100 * sin(animationValue * 6.28318),
      center.dx + 100 * cos(animationValue * 6.28318 + 2),
      center.dy + 50 + 100 * sin(animationValue * 6.28318 + 2),
      center.dx,
      center.dy + 50,
    );
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant MorphingShapePainter old) => true;
}

class BreathingAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;

  const BreathingAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 3),
    this.minScale = 0.95,
    this.maxScale = 1.05,
  });

  @override
  State<BreathingAnimation> createState() => _BreathingAnimationState();
}

class _BreathingAnimationState extends State<BreathingAnimation>
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

class FloatingAction extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double offset;

  const FloatingAction({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.offset = 10.0,
  });

  @override
  State<FloatingAction> createState() => _FloatingActionState();
}

class _FloatingActionState extends State<FloatingAction>
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

class WobbleAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double intensity;

  const WobbleAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 1),
    this.intensity = 0.1,
  });

  @override
  State<WobbleAnimation> createState() => _WobbleAnimationState();
}

class _WobbleAnimationState extends State<WobbleAnimation>
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
        return Transform.rotate(angle: _animation.value, child: widget.child);
      },
    );
  }
}

class JelloAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double intensity;

  const JelloAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 1),
    this.intensity = 0.15,
  });

  @override
  State<JelloAnimation> createState() => _JelloAnimationState();
}

class _JelloAnimationState extends State<JelloAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleX;
  late Animation<double> _scaleY;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _scaleX = Tween<double>(begin: 1.0, end: 1.0 + widget.intensity).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _scaleY = Tween<double>(begin: 1.0, end: 1.0 - widget.intensity).animate(
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
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scaleX: _scaleX.value,
          scaleY: _scaleY.value,
          child: widget.child,
        );
      },
    );
  }
}

class SwipeAnimation extends StatefulWidget {
  final Widget child;
  final Offset offset;
  final Duration duration;

  const SwipeAnimation({
    super.key,
    required this.child,
    required this.offset,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<SwipeAnimation> createState() => _SwipeAnimationState();
}

class _SwipeAnimationState extends State<SwipeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<Offset>(begin: Offset.zero, end: widget.offset).animate(
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
    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }
}

class PinchAnimation extends StatefulWidget {
  final Widget child;
  final double scale;
  final Duration duration;

  const PinchAnimation({
    super.key,
    required this.child,
    required this.scale,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<PinchAnimation> createState() => _PinchAnimationState();
}

class _PinchAnimationState extends State<PinchAnimation>
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
    _controller.forward();
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

class TwistAnimation extends StatefulWidget {
  final Widget child;
  final double turns;
  final Duration duration;

  const TwistAnimation({
    super.key,
    required this.child,
    required this.turns,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<TwistAnimation> createState() => _TwistAnimationState();
}

class _TwistAnimationState extends State<TwistAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0.0, end: widget.turns).animate(
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
    return RotationTransition(
      turns: _animation,
      child: widget.child,
    );
  }
}

class FlipXAnimation extends StatefulWidget {
  final Widget child;
  final bool flipped;
  final Duration duration;

  const FlipXAnimation({
    super.key,
    required this.child,
    required this.flipped,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<FlipXAnimation> createState() => _FlipXAnimationState();
}

class _FlipXAnimationState extends State<FlipXAnimation>
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
    if (widget.flipped) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(FlipXAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.flipped != widget.flipped) {
      if (widget.flipped) {
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
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(_animation.value * 3.14159),
      child: _animation.value <= 0.5 ? widget.child : const SizedBox.shrink(),
    );
  }
}

class FlipYAnimation extends StatefulWidget {
  final Widget child;
  final bool flipped;
  final Duration duration;

  const FlipYAnimation({
    super.key,
    required this.child,
    required this.flipped,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<FlipYAnimation> createState() => _FlipYAnimationState();
}

class _FlipYAnimationState extends State<FlipYAnimation>
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
    if (widget.flipped) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(FlipYAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.flipped != widget.flipped) {
      if (widget.flipped) {
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
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationX(_animation.value * 3.14159),
      child: _animation.value <= 0.5 ? widget.child : const SizedBox.shrink(),
    );
  }
}

class FoldAnimation extends StatefulWidget {
  final Widget child;
  final double fold;
  final Duration duration;

  const FoldAnimation({
    super.key,
    required this.child,
    required this.fold,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<FoldAnimation> createState() => _FoldAnimationState();
}

class _FoldAnimationState extends State<FoldAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0.0, end: widget.fold).animate(
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
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateX(_animation.value),
      child: widget.child,
    );
  }
}

class UnfoldAnimation extends StatefulWidget {
  final Widget child;
  final double unfold;
  final Duration duration;

  const UnfoldAnimation({
    super.key,
    required this.child,
    required this.unfold,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<UnfoldAnimation> createState() => _UnfoldAnimationState();
}

class _UnfoldAnimationState extends State<UnfoldAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: widget.unfold, end: 0.0).animate(
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
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateX(_animation.value),
      child: widget.child,
    );
  }
}

class ExplodeAnimation extends StatefulWidget {
  final Widget child;
  final int fragmentCount;
  final Duration duration;

  const ExplodeAnimation({
    super.key,
    required this.child,
    this.fragmentCount = 20,
    this.duration = const Duration(seconds: 1),
  });

  @override
  State<ExplodeAnimation> createState() => _ExplodeAnimationState();
}

class _ExplodeAnimationState extends State<ExplodeAnimation>
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
        return Opacity(
          opacity: 1 - _animation.value,
          child: Transform.scale(
            scale: 1 + _animation.value * 2,
            child: widget.child,
          ),
        );
      },
    );
  }
}

class ImplodeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const ImplodeAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 1),
  });

  @override
  State<ImplodeAnimation> createState() => _ImplodeAnimationState();
}

class _ImplodeAnimationState extends State<ImplodeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(
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
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}

class ShatterAnimation extends StatefulWidget {
  final Widget child;
  final int shardCount;
  final Duration duration;

  const ShatterAnimation({
    super.key,
    required this.child,
    this.shardCount = 30,
    this.duration = const Duration(seconds: 1),
  });

  @override
  State<ShatterAnimation> createState() => _ShatterAnimationState();
}

class _ShatterAnimationState extends State<ShatterAnimation>
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
        return Opacity(
          opacity: 1 - _animation.value,
          child: Transform.translate(
            offset: Offset(_animation.value * 100, _animation.value * 100),
            child: widget.child,
          ),
        );
      },
    );
  }
}
