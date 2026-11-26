import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

/// A shimmer block that sweeps a highlight across a placeholder.
///
/// The shimmer is decorative (`aria-hidden`), so screen readers hear the
/// surrounding status label once rather than a parade of empty boxes.
class ShimmerBlock extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadiusGeometry borderRadius;
  final bool enabled;

  const ShimmerBlock({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.enabled = true,
  });

  @override
  State<ShimmerBlock> createState() => _ShimmerBlockState();
}

class _ShimmerBlockState extends State<ShimmerBlock>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    if (widget.enabled) _controller.repeat();
  }

  @override
  void didUpdateWidget(covariant ShimmerBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled)
        _controller.repeat();
      else
        _controller.stop();
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
      builder: (context, _) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            color: AppColors.surfaceLight,
            gradient: widget.enabled
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.0, 0.5, 1.0],
                    colors: [
                      AppColors.surfaceLight,
                      AppColors.surfaceLight.withValues(alpha: 0.5),
                      AppColors.surfaceLight,
                    ],
                    transform: _SlidingGradientTransform(_controller.value),
                  )
                : null,
          ),
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double progress;
  const _SlidingGradientTransform(this.progress);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * (progress * 2 - 1), 0, 0);
  }
}

/// A table-shaped skeleton with a fixed header and rows.
class SkeletonTable extends StatelessWidget {
  final int rows;
  final String label;

  const SkeletonTable({super.key, this.rows = 5, required this.label});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Column(
          children: [
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: const Row(
                children: [
                  ShimmerBlock(width: 120, height: 14),
                  SizedBox(width: 24),
                  ShimmerBlock(width: 80, height: 14),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.cardBorder),
            ...List.generate(
              rows,
              (index) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    ShimmerBlock(width: 90, height: 16),
                    SizedBox(width: 24),
                    ShimmerBlock(width: 140, height: 16),
                    Spacer(),
                    ShimmerBlock(width: 50, height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
