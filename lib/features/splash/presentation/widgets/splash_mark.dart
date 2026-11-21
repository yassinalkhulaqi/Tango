import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Animated splash mark with a terminal glyph and a breathing halo.
///
/// The animation is driven by a single controller and respects reduced motion
/// by skipping the repeat. The glyph itself is never animated in scale, so the
/// logo stays legible; only the glow behind it breathes.
class SplashMark extends StatefulWidget {
  final double size;
  final bool reducedMotion;

  const SplashMark({super.key, this.size = 120, this.reducedMotion = false});

  @override
  State<SplashMark> createState() => _SplashMarkState();
}

class _SplashMarkState extends State<SplashMark>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _glow = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (!widget.reducedMotion) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant SplashMark oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.reducedMotion != oldWidget.reducedMotion) {
      if (widget.reducedMotion) {
        _controller.stop();
      } else {
        _controller.repeat(reverse: true);
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
      animation: _glow,
      builder: (context, _) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withValues(alpha: 0.25 * _glow.value),
                    blurRadius: 40 * _glow.value,
                    spreadRadius: 12 * _glow.value,
                  ),
                ],
              ),
            ),
            Container(
              width: widget.size * 0.78,
              height: widget.size * 0.78,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface,
                border: Border.all(
                  color: AppColors.primaryBlue.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.terminal_rounded,
                color: AppColors.primaryBlue,
                size: 52,
              ),
            ),
          ],
        );
      },
    );
  }
}
