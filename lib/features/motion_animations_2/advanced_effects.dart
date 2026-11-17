import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui' as ui;

class MeshGradient extends StatefulWidget {
  final List<List<Color>> colors;
  final Duration duration;

  const MeshGradient({
    super.key,
    required this.colors,
    this.duration = const Duration(seconds: 5),
  });

  @override
  State<MeshGradient> createState() => _MeshGradientState();
}

class _MeshGradientState extends State<MeshGradient>
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
          painter: MeshGradientPainter(widget.colors, _controller.value),
        );
      },
    );
  }
}

class MeshGradientPainter extends CustomPainter {
  final List<List<Color>> colors;
  final double animationValue;

  MeshGradientPainter(this.colors, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final rows = colors.length;
    final cols = colors[0].length;
    final cellWidth = size.width / (cols - 1);
    final cellHeight = size.height / (rows - 1);

    for (int r = 0; r < rows - 1; r++) {
      for (int c = 0; c < cols - 1; c++) {
        final tl = Offset(c * cellWidth, r * cellHeight);
        final tr = Offset((c + 1) * cellWidth, r * cellHeight);
        final bl = Offset(c * cellWidth, (r + 1) * cellHeight);
        final br = Offset((c + 1) * cellWidth, (r + 1) * cellHeight);

        final path = Path();
        path.moveTo(tl.dx + sin(animationValue * 6.28318 + c + r) * 5, tl.dy + cos(animationValue * 6.28318 + c + r) * 5);
        path.lineTo(tr.dx + sin(animationValue * 6.28318 + c + 1 + r) * 5, tr.dy + cos(animationValue * 6.28318 + c + 1 + r) * 5);
        path.lineTo(br.dx + sin(animationValue * 6.28318 + c + 1 + r + 1) * 5, br.dy + cos(animationValue * 6.28318 + c + 1 + r + 1) * 5);
        path.lineTo(bl.dx + sin(animationValue * 6.28318 + c + r + 1) * 5, bl.dy + cos(animationValue * 6.28318 + c + r + 1) * 5);
        path.close();

        final colors4 = [
          colors[r][c].withValues(alpha: 0.3 + 0.2 * sin(animationValue + c + r)),
          colors[r][c + 1].withValues(alpha: 0.3 + 0.2 * sin(animationValue + c + 1 + r)),
          colors[r + 1][c + 1].withValues(alpha: 0.3 + 0.2 * sin(animationValue + c + 1 + r + 1)),
          colors[r + 1][c].withValues(alpha: 0.3 + 0.2 * sin(animationValue + c + r + 1)),
        ];

        paint.shader = ui.Gradient.linear(
          tl,
          br,
          colors4,
          [0.0, 0.33, 0.66, 1.0],
        );
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant MeshGradientPainter old) => true;
}

class GradientMesh extends StatelessWidget {
  final List<List<Color>> colors;
  final int resolution;

  const GradientMesh({
    super.key,
    required this.colors,
    this.resolution = 50,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: GradientMeshPainter(colors, resolution),
    );
  }
}

class GradientMeshPainter extends CustomPainter {
  final List<List<Color>> colors;
  final int resolution;

  GradientMeshPainter(this.colors, this.resolution);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final rows = colors.length;
    final cols = colors[0].length;
    final cellWidth = size.width / (cols - 1);
    final cellHeight = size.height / (rows - 1);

    for (int r = 0; r < rows - 1; r++) {
      for (int c = 0; c < cols - 1; c++) {
        final tl = Offset(c * cellWidth, r * cellHeight);
        final tr = Offset((c + 1) * cellWidth, r * cellHeight);
        final bl = Offset(c * cellWidth, (r + 1) * cellHeight);
        final br = Offset((c + 1) * cellWidth, (r + 1) * cellHeight);

        final path = Path();
        path.moveTo(tl.dx, tl.dy);
        path.lineTo(tr.dx, tr.dy);
        path.lineTo(br.dx, br.dy);
        path.lineTo(bl.dx, bl.dy);
        path.close();

        paint.shader = ui.Gradient.linear(
          tl,
          br,
          [colors[r][c], colors[r][c + 1], colors[r + 1][c + 1], colors[r + 1][c]],
          [0.0, 0.33, 0.66, 1.0],
        );
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant GradientMeshPainter old) => true;
}

class FluidSimulation extends StatefulWidget {
  final int particleCount;
  final Duration duration;

  const FluidSimulation({
    super.key,
    this.particleCount = 200,
    this.duration = const Duration(seconds: 10),
  });

  @override
  State<FluidSimulation> createState() => _FluidSimulationState();
}

class _FluidSimulationState extends State<FluidSimulation>
    with TickerProviderStateMixin {
  late List<FluidParticle> _particles;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _particles = List.generate(widget.particleCount, (_) => _randomParticle());
    _controller.repeat();
  }

  FluidParticle _randomParticle() {
    return FluidParticle(
      position: Offset(
        Random().nextDouble() * 400,
        Random().nextDouble() * 400,
      ),
      velocity: Offset(
        (Random().nextDouble() - 0.5) * 2,
        (Random().nextDouble() - 0.5) * 2,
      ),
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
          painter: FluidPainter(_particles, _controller.value),
        );
      },
    );
  }
}

class FluidParticle {
  final Offset position;
  final Offset velocity;
  final Color color;

  FluidParticle({
    required this.position,
    required this.velocity,
    required this.color,
  });
}

class FluidPainter extends CustomPainter {
  final List<FluidParticle> particles;
  final double animationValue;

  FluidPainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final particle in particles) {
      final x = (particle.position.dx + particle.velocity.dx * animationValue * 50) % size.width;
      final y = (particle.position.dy + particle.velocity.dy * animationValue * 50) % size.height;
      paint.color = particle.color.withValues(alpha: 0.6);
      canvas.drawCircle(Offset(x, y), 3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant FluidPainter old) => true;
}

class FlowField extends StatefulWidget {
  final int resolution;
  final Duration duration;

  const FlowField({
    super.key,
    this.resolution = 20,
    this.duration = const Duration(seconds: 10),
  });

  @override
  State<FlowField> createState() => _FlowFieldState();
}

class _FlowFieldState extends State<FlowField>
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
          painter: FlowFieldPainter(widget.resolution, _controller.value),
        );
      },
    );
  }
}

class FlowFieldPainter extends CustomPainter {
  final int resolution;
  final double animationValue;

  FlowFieldPainter(this.resolution, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: 0.2)
      ..strokeWidth = 1;

    final cellSize = size.width / resolution;
    for (double y = 0; y < size.height; y += cellSize) {
      for (double x = 0; x < size.width; x += cellSize) {
        final angle = sin(x * 0.01 + animationValue * 6.28318) + cos(y * 0.01 + animationValue * 6.28318);
        final dx = cos(angle) * cellSize * 0.3;
        final dy = sin(angle) * cellSize * 0.3;
        canvas.drawLine(Offset(x, y), Offset(x + dx, y + dy), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant FlowFieldPainter old) => true;
}

class PerlinNoise extends StatefulWidget {
  final int octaves;
  final Duration duration;

  const PerlinNoise({
    super.key,
    this.octaves = 4,
    this.duration = const Duration(seconds: 10),
  });

  @override
  State<PerlinNoise> createState() => _PerlinNoiseState();
}

class _PerlinNoiseState extends State<PerlinNoise>
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
          painter: PerlinPainter(widget.octaves, _controller.value),
        );
      },
    );
  }
}

class PerlinPainter extends CustomPainter {
  final int octaves;
  final double animationValue;

  PerlinPainter(this.octaves, this.animationValue);

  double _noise(double x, double y) {
    return sin(x * 0.1 + animationValue) * cos(y * 0.1 - animationValue);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (double y = 0; y < size.height; y += 5) {
      for (double x = 0; x < size.width; x += 5) {
        final n = _noise(x, y);
        paint.color = const Color(0xFF38BDF8).withValues(alpha: (n + 1) / 4);
        canvas.drawRect(Rect.fromLTWH(x, y, 5, 5), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant PerlinPainter old) => true;
}

class VoronoiPattern extends StatefulWidget {
  final int pointCount;
  final Duration duration;

  const VoronoiPattern({
    super.key,
    this.pointCount = 30,
    this.duration = const Duration(seconds: 5),
  });

  @override
  State<VoronoiPattern> createState() => _VoronoiPatternState();
}

class _VoronoiPatternState extends State<VoronoiPattern>
    with TickerProviderStateMixin {
  late List<Offset> _points;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _points = List.generate(widget.pointCount, (_) => Offset(
      Random().nextDouble() * 400,
      Random().nextDouble() * 400,
    ));
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
          painter: VoronoiPainter(_points, _controller.value),
        );
      },
    );
  }
}

class VoronoiPainter extends CustomPainter {
  final List<Offset> points;
  final double animationValue;

  VoronoiPainter(this.points, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (double y = 0; y < size.height; y += 2) {
      for (double x = 0; x < size.width; x += 2) {
        double minDist = double.infinity;
        int nearest = 0;
        for (int i = 0; i < points.length; i++) {
          final d = sqrt(pow(x - points[i].dx, 2) + pow(y - points[i].dy, 2));
          if (d < minDist) {
            minDist = d;
            nearest = i;
          }
        }
        paint.color = [
          const Color(0xFF38BDF8),
          const Color(0xFFA855F7),
          const Color(0xFF4ADE80),
          const Color(0xFFFACC15),
        ][nearest % 4].withValues(alpha: 0.3);
        canvas.drawRect(Rect.fromLTWH(x, y, 2, 2), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant VoronoiPainter old) => true;
}

class DelaunayTriangulation extends StatefulWidget {
  final int pointCount;
  final Duration duration;

  const DelaunayTriangulation({
    super.key,
    this.pointCount = 20,
    this.duration = const Duration(seconds: 5),
  });

  @override
  State<DelaunayTriangulation> createState() => _DelaunayTriangulationState();
}

class _DelaunayTriangulationState extends State<DelaunayTriangulation>
    with TickerProviderStateMixin {
  late List<Offset> _points;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _points = List.generate(widget.pointCount, (_) => Offset(
      Random().nextDouble() * 400,
      Random().nextDouble() * 400,
    ));
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
          painter: DelaunayPainter(_points, _controller.value),
        );
      },
    );
  }
}

class DelaunayPainter extends CustomPainter {
  final List<Offset> points;
  final double animationValue;

  DelaunayPainter(this.points, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: 0.3)
      ..strokeWidth = 1;

    for (int i = 0; i < points.length; i++) {
      for (int j = i + 1; j < points.length; j++) {
        final d = sqrt(pow(points[i].dx - points[j].dx, 2) + pow(points[i].dy - points[j].dy, 2));
        if (d < 150) {
          canvas.drawLine(points[i], points[j], paint);
        }
      }
    }
    for (final p in points) {
      paint.color = const Color(0xFFFACC15);
      canvas.drawCircle(p, 3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant DelaunayPainter old) => true;
}

class Spirograph extends StatefulWidget {
  final int petals;
  final Duration duration;

  const Spirograph({
    super.key,
    this.petals = 5,
    this.duration = const Duration(seconds: 10),
  });

  @override
  State<Spirograph> createState() => _SpirographState();
}

class _SpirographState extends State<Spirograph>
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
          painter: SpirographPainter(widget.petals, _controller.value),
        );
      },
    );
  }
}

class SpirographPainter extends CustomPainter {
  final int petals;
  final double animationValue;

  SpirographPainter(this.petals, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: 0.5)
      ..strokeWidth = 2;

    final path = Path();
    for (double t = 0; t < 6.28318 * 4; t += 0.01) {
      final r = 50 + 30 * sin(widget.petals * t + animationValue * 6.28318);
      final x = center.dx + r * cos(t);
      final y = center.dy + r * sin(t);
      if (t == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SpirographPainter old) => true;
}

class HypnoticSpiral extends StatefulWidget {
  final int turns;
  final Duration duration;

  const HypnoticSpiral({
    super.key,
    this.turns = 10,
    this.duration = const Duration(seconds: 8),
  });

  @override
  State<HypnoticSpiral> createState() => _HypnoticSpiralState();
}

class _HypnoticSpiralState extends State<HypnoticSpiral>
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
          painter: HypnoticSpiralPainter(widget.turns, _controller.value),
        );
      },
    );
  }
}

class HypnoticSpiralPainter extends CustomPainter {
  final int turns;
  final double animationValue;

  HypnoticSpiralPainter(this.turns, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = const Color(0xFFA855F7).withValues(alpha: 0.6)
      ..strokeWidth = 2;

    final path = Path();
    for (double t = 0; t < 6.28318 * widget.turns; t += 0.01) {
      final r = 5 * t + 20 * sin(animationValue * 6.28318);
      final x = center.dx + r * cos(t + animationValue);
      final y = center.dy + r * sin(t + animationValue);
      if (t == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant HypnoticSpiralPainter old) => true;
}

class LissajousCurve extends StatefulWidget {
  final int a;
  final int b;
  final double delta;
  final Duration duration;

  const LissajousCurve({
    super.key,
    this.a = 3,
    this.b = 2,
    this.delta = 3.14159 / 2,
    this.duration = const Duration(seconds: 8),
  });

  @override
  State<LissajousCurve> createState() => _LissajousCurveState();
}

class _LissajousCurveState extends State<LissajousCurve>
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
          painter: LissajousPainter(widget.a, widget.b, widget.delta, _controller.value),
        );
      },
    );
  }
}

class LissajousPainter extends CustomPainter {
  final int a;
  final int b;
  final double delta;
  final double animationValue;

  LissajousPainter(this.a, this.b, this.delta, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = const Color(0xFF4ADE80).withValues(alpha: 0.6)
      ..strokeWidth = 2;

    final path = Path();
    for (double t = 0; t < 6.28318 * 4; t += 0.01) {
      final x = center.dx + 100 * sin(widget.a * t + widget.delta + animationValue * 6.28318);
      final y = center.dy + 100 * sin(widget.b * t + animationValue * 6.28318);
      if (t == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant LissajousPainter old) => true;
}

class CellularAutomaton extends StatefulWidget {
  final int width;
  final int height;
  final Duration duration;

  const CellularAutomaton({
    super.key,
    this.width = 50,
    this.height = 50,
    this.duration = const Duration(milliseconds: 100),
  });

  @override
  State<CellularAutomaton> createState() => _CellularAutomatonState();
}

class _CellularAutomatonState extends State<CellularAutomaton>
    with TickerProviderStateMixin {
  late List<List<bool>> _grid;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _grid = List.generate(widget.height, (_) => List.generate(widget.width, (_) => Random().nextBool()));
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
        _grid = _nextGeneration(_grid);
        return CustomPaint(
          size: Size.infinite,
          painter: CellularPainter(_grid),
        );
      },
    );
  }

  List<List<bool>> _nextGeneration(List<List<bool>> grid) {
    final h = grid.length;
    final w = grid[0].length;
    final next = List.generate(h, (_) => List.generate(w, (_) => false));
    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        int neighbors = 0;
        for (int dy = -1; dy <= 1; dy++) {
          for (int dx = -1; dx <= 1; dx++) {
            if (dx == 0 && dy == 0) continue;
            final ny = (y + dy + h) % h;
            final nx = (x + dx + w) % w;
            if (grid[ny][nx]) neighbors++;
          }
        }
        if (grid[y][x]) {
          next[y][x] = neighbors == 2 || neighbors == 3;
        } else {
          next[y][x] = neighbors == 3;
        }
      }
    }
    return next;
  }

  @override
  void didUpdateWidget(covariant CellularAutomaton oldWidget) {
    super.didUpdateWidget(oldWidget);
  }
}

class CellularPainter extends CustomPainter {
  final List<List<bool>> grid;

  CellularPainter(this.grid);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: 0.6);

    final cellW = size.width / grid[0].length;
    final cellH = size.height / grid.length;
    for (int y = 0; y < grid.length; y++) {
      for (int x = 0; x < grid[0].length; x++) {
        if (grid[y][x]) {
          canvas.drawRect(Rect.fromLTWH(x * cellW, y * cellH, cellW, cellH), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CellularPainter old) => true;
}

class ConwayGame extends StatefulWidget {
  final int size;
  final Duration duration;

  const ConwayGame({
    super.key,
    this.size = 30,
    this.duration = const Duration(milliseconds: 150),
  });

  @override
  State<ConwayGame> createState() => _ConwayGameState();
}

class _ConwayGameState extends State<ConwayGame>
    with TickerProviderStateMixin {
  late List<List<bool>> _grid;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _grid = List.generate(widget.size, (_) => List.generate(widget.size, (_) => Random().nextBool()));
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
        _grid = _nextGen(_grid);
        return CustomPaint(
          size: Size.infinite,
          painter: ConwayPainter(_grid),
        );
      },
    );
  }

  List<List<bool>> _nextGen(List<List<bool>> g) {
    final n = g.length;
    final next = List.generate(n, (_) => List.generate(n, (_) => false));
    for (int y = 0; y < n; y++) {
      for (int x = 0; x < n; x++) {
        int alive = 0;
        for (int dy = -1; dy <= 1; dy++) {
          for (int dx = -1; dx <= 1; dx++) {
            if (dx == 0 && dy == 0) continue;
            if (g[(y + dy + n) % n][(x + dx + n) % n]) alive++;
          }
        }
        next[y][x] = g[y][x] ? (alive == 2 || alive == 3) : (alive == 3);
      }
    }
    return next;
  }

  @override
  void didUpdateWidget(covariant ConwayGame oldWidget) {
    super.didUpdateWidget(oldWidget);
  }
}

class ConwayPainter extends CustomPainter {
  final List<List<bool>> grid;

  ConwayPainter(this.grid);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFACC15).withValues(alpha: 0.6);

    final cell = size.width / grid.length;
    for (int y = 0; y < grid.length; y++) {
      for (int x = 0; x < grid[0].length; x++) {
        if (grid[y][x]) {
          canvas.drawRect(Rect.fromLTWH(x * cell, y * cell, cell, cell), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant ConwayPainter old) => true;
}

class ParticleAttractor extends StatefulWidget {
  final int particleCount;
  final Duration duration;

  const ParticleAttractor({
    super.key,
    this.particleCount = 100,
    this.duration = const Duration(seconds: 10),
  });

  @override
  State<ParticleAttractor> createState() => _ParticleAttractorState();
}

class _ParticleAttractorState extends State<ParticleAttractor>
    with TickerProviderStateMixin {
  late List<AttractorParticle> _particles;
  late AnimationController _controller;
  Offset _mousePosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _particles = List.generate(widget.particleCount, (_) => _randomParticle());
    _controller.repeat();
  }

  AttractorParticle _randomParticle() {
    return AttractorParticle(
      position: Offset(
        Random().nextDouble() * 400,
        Random().nextDouble() * 400,
      ),
      velocity: Offset.zero,
      color: const Color(0xFF38BDF8).withValues(alpha: 0.6),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _mousePosition = details.localPosition;
        });
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: Size.infinite,
            painter: AttractorPainter(_particles, _controller.value, _mousePosition),
          );
        },
      ),
    );
  }
}

class AttractorParticle {
  final Offset position;
  Offset velocity;
  final Color color;

  AttractorParticle({
    required this.position,
    required this.velocity,
    required this.color,
  });
}

class AttractorPainter extends CustomPainter {
  final List<AttractorParticle> particles;
  final double animationValue;
  final Offset mousePosition;

  AttractorPainter(this.particles, this.animationValue, this.mousePosition);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final p in particles) {
      final dx = mousePosition.dx - p.position.dx;
      final dy = mousePosition.dy - p.position.dy;
      final dist = sqrt(dx * dx + dy * dy);
      final force = 100 / (dist + 1);
      p.velocity = Offset(
        p.velocity.dx + dx * force * 0.001,
        p.velocity.dy + dy * force * 0.001,
      );
      p.velocity = Offset(
        p.velocity.dx * 0.95,
        p.velocity.dy * 0.95,
      );
      p.position = Offset(
        p.position.dx + p.velocity.dx,
        p.position.dy + p.velocity.dy,
      );
      paint.color = p.color;
      canvas.drawCircle(p.position, 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant AttractorPainter old) => true;
}

class OrbitalParticles extends StatefulWidget {
  final int particleCount;
  final Duration duration;

  const OrbitalParticles({
    super.key,
    this.particleCount = 20,
    this.duration = const Duration(seconds: 10),
  });

  @override
  State<OrbitalParticles> createState() => _OrbitalParticlesState();
}

class _OrbitalParticlesState extends State<OrbitalParticles>
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
          painter: OrbitalPainter(widget.particleCount, _controller.value),
        );
      },
    );
  }
}

class OrbitalPainter extends CustomPainter {
  final int particleCount;
  final double animationValue;

  OrbitalPainter(this.particleCount, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint();

    for (int i = 0; i < particleCount; i++) {
      final angle = (i / particleCount) * 6.28318 + animationValue * 2;
      final radius = 50 + 30 * sin(i * 0.5 + animationValue);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      paint.color = const Color(0xFFFACC15).withValues(alpha: 0.6);
      canvas.drawCircle(Offset(x, y), 3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant OrbitalPainter old) => true;
}

class GravityWell extends StatefulWidget {
  final int particleCount;
  final Duration duration;

  const GravityWell({
    super.key,
    this.particleCount = 50,
    this.duration = const Duration(seconds: 10),
  });

  @override
  State<GravityWell> createState() => _GravityWellState();
}

class _GravityWellState extends State<GravityWell>
    with TickerProviderStateMixin {
  late List<GravityParticle> _particles;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _particles = List.generate(widget.particleCount, (_) => _randomParticle());
    _controller.repeat();
  }

  GravityParticle _randomParticle() {
    return GravityParticle(
      position: Offset(
        Random().nextDouble() * 400,
        Random().nextDouble() * 400,
      ),
      velocity: Offset(
        (Random().nextDouble() - 0.5) * 3,
        (Random().nextDouble() - 0.5) * 3,
      ),
      color: const Color(0xFF4ADE80).withValues(alpha: 0.6),
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
          painter: GravityPainter(_particles, _controller.value),
        );
      },
    );
  }
}

class GravityParticle {
  final Offset position;
  Offset velocity;
  final Color color;

  GravityParticle({
    required this.position,
    required this.velocity,
    required this.color,
  });
}

class GravityPainter extends CustomPainter {
  final List<GravityParticle> particles;
  final double animationValue;

  GravityPainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint();
    for (final p in particles) {
      final dx = center.dx - p.position.dx;
      final dy = center.dy - p.position.dy;
      final dist = sqrt(dx * dx + dy * dy) + 1;
      final force = 5000 / (dist * dist);
      p.velocity = Offset(
        p.velocity.dx + dx * force * 0.0001,
        p.velocity.dy + dy * force * 0.0001,
      );
      p.position = Offset(
        p.position.dx + p.velocity.dx,
        p.position.dy + p.velocity.dy,
      );
      paint.color = p.color;
      canvas.drawCircle(p.position, 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant GravityPainter old) => true;
}

class SpringNetwork extends StatefulWidget {
  final int nodeCount;
  final Duration duration;

  const SpringNetwork({
    super.key,
    this.nodeCount = 15,
    this.duration = const Duration(seconds: 10),
  });

  @override
  State<SpringNetwork> createState() => _SpringNetworkState();
}

class _SpringNetworkState extends State<SpringNetwork>
    with TickerProviderStateMixin {
  late List<SpringNode> _nodes;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _nodes = List.generate(widget.nodeCount, (_) => _randomNode());
    _controller.repeat();
  }

  SpringNode _randomNode() {
    return SpringNode(
      position: Offset(
        Random().nextDouble() * 400,
        Random().nextDouble() * 400,
      ),
      velocity: Offset.zero,
      color: const Color(0xFF38BDF8).withValues(alpha: 0.6),
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
          painter: SpringPainter(_nodes, _controller.value),
        );
      },
    );
  }
}

class SpringNode {
  final Offset position;
  Offset velocity;
  final Color color;

  SpringNode({
    required this.position,
    required this.velocity,
    required this.color,
  });
}

class SpringPainter extends CustomPainter {
  final List<SpringNode> nodes;
  final double animationValue;

  SpringPainter(this.nodes, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: 0.3)
      ..strokeWidth = 1;
    final nodePaint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        final d = sqrt(pow(nodes[i].position.dx - nodes[j].position.dx, 2) + pow(nodes[i].position.dy - nodes[j].position.dy, 2));
        if (d < 100) {
          canvas.drawLine(nodes[i].position, nodes[j].position, linePaint);
        }
      }
    }

    for (final node in nodes) {
      canvas.drawCircle(node.position, 4, nodePaint);
    }
  }

  @override
  bool shouldRepaint(covariant SpringPainter old) => true;
}

class AnimatedGradientMesh extends StatefulWidget {
  final List<List<Color>> colors;
  final Duration duration;

  const AnimatedGradientMesh({
    super.key,
    required this.colors,
    this.duration = const Duration(seconds: 8),
  });

  @override
  State<AnimatedGradientMesh> createState() => _AnimatedGradientMeshState();
}

class _AnimatedGradientMeshState extends State<AnimatedGradientMesh>
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
          painter: AnimatedMeshPainter(widget.colors, _controller.value),
        );
      },
    );
  }
}

class AnimatedMeshPainter extends CustomPainter {
  final List<List<Color>> colors;
  final double animationValue;

  AnimatedMeshPainter(this.colors, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final rows = colors.length;
    final cols = colors[0].length;
    final cellWidth = size.width / (cols - 1);
    final cellHeight = size.height / (rows - 1);

    for (int r = 0; r < rows - 1; r++) {
      for (int c = 0; c < cols - 1; c++) {
        final tl = Offset(c * cellWidth + sin(animationValue * 6.28318 + c) * 10, r * cellHeight + cos(animationValue * 6.28318 + r) * 10);
        final tr = Offset((c + 1) * cellWidth + sin(animationValue * 6.28318 + c + 1) * 10, r * cellHeight + cos(animationValue * 6.28318 + r) * 10);
        final bl = Offset(c * cellWidth + sin(animationValue * 6.28318 + c) * 10, (r + 1) * cellHeight + cos(animationValue * 6.28318 + r + 1) * 10);
        final br = Offset((c + 1) * cellWidth + sin(animationValue * 6.28318 + c + 1) * 10, (r + 1) * cellHeight + cos(animationValue * 6.28318 + r + 1) * 10);

        final path = Path();
        path.moveTo(tl.dx, tl.dy);
        path.lineTo(tr.dx, tr.dy);
        path.lineTo(br.dx, br.dy);
        path.lineTo(bl.dx, bl.dy);
        path.close();

        paint.shader = ui.Gradient.linear(
          tl,
          br,
          [
            colors[r][c].withValues(alpha: 0.3),
            colors[r][c + 1].withValues(alpha: 0.3),
            colors[r + 1][c + 1].withValues(alpha: 0.3),
            colors[r + 1][c].withValues(alpha: 0.3),
          ],
          [0.0, 0.33, 0.66, 1.0],
        );
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant AnimatedMeshPainter old) => true;
}

class ColorWave extends StatefulWidget {
  final int waveCount;
  final Duration duration;

  const ColorWave({
    super.key,
    this.waveCount = 5,
    this.duration = const Duration(seconds: 5),
  });

  @override
  State<ColorWave> createState() => _ColorWaveState();
}

class _ColorWaveState extends State<ColorWave>
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
          painter: ColorWavePainter(widget.waveCount, _controller.value),
        );
      },
    );
  }
}

class ColorWavePainter extends CustomPainter {
  final int waveCount;
  final double animationValue;

  ColorWavePainter(this.waveCount, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (int i = 0; i < waveCount; i++) {
      final color = [
        const Color(0xFF38BDF8),
        const Color(0xFFA855F7),
        const Color(0xFF4ADE80),
        const Color(0xFFFACC15),
        const Color(0xFFFB923C),
      ][i % 5];
      paint.color = color.withValues(alpha: 0.6);
      final path = Path();
      for (double x = 0; x <= size.width; x += 5) {
        final y = size.height / 2 + 40 * sin(x * 0.02 + i * 1.0 + animationValue * 6.28318);
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
  bool shouldRepaint(covariant ColorWavePainter old) => true;
}

class PlasmaEffect extends StatefulWidget {
  final Duration duration;

  const PlasmaEffect({
    super.key,
    this.duration = const Duration(seconds: 8),
  });

  @override
  State<PlasmaEffect> createState() => _PlasmaEffectState();
}

class _PlasmaEffectState extends State<PlasmaEffect>
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
          painter: PlasmaPainter(_controller.value),
        );
      },
    );
  }
}

class PlasmaPainter extends CustomPainter {
  final double animationValue;

  PlasmaPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (double y = 0; y < size.height; y += 4) {
      for (double x = 0; x < size.width; x += 4) {
        final v = sin(x * 0.05 + animationValue) +
            cos(y * 0.05 + animationValue) +
            sin((x + y) * 0.03 + animationValue) +
            cos(sqrt(x * x + y * y) * 0.03 + animationValue);
        final hue = (v + 4) / 8;
        paint.color = HSLColor.fromAHSL(0.5, hue % 1.0, 0.6, 0.6).toColor();
        canvas.drawRect(Rect.fromLTWH(x, y, 4, 4), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant PlasmaPainter old) => true;
}

class ColorCycle extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const ColorCycle({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 5),
  });

  @override
  State<ColorCycle> createState() => _ColorCycleState();
}

class _ColorCycleState extends State<ColorCycle>
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
            HSLColor.fromAHSL(0.5, _controller.value, 0.6, 0.6).toColor().withValues(alpha: 0.3),
            BlendMode.color,
          ),
          child: child,
        );
      },
    );
  }
}

class RainbowBorder extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double width;

  const RainbowBorder({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 3),
    this.width = 3.0,
  });

  @override
  State<RainbowBorder> createState() => _RainbowBorderState();
}

class _RainbowBorderState extends State<RainbowBorder>
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
