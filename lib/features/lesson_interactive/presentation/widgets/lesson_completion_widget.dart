import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_gradients.dart';

class LessonCompletionWidget extends StatelessWidget {
  final int xpEarned;
  final VoidCallback onClose;

  const LessonCompletionWidget({
    super.key,
    required this.xpEarned,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: AppGradients.neonGreen,
            shape: BoxShape.circle,
            boxShadow: [AppGradients.glow(AppColors.primaryGreen, blurRadius: 40)],
          ),
          child: const Center(
            child: Icon(Icons.check_circle_rounded, color: Colors.white, size: 56),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text(
          'Lesson Complete!',
          style: AppTextStyles.displayMedium.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'You\'ve mastered this lesson',
          style: AppTextStyles.bodyLarge.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xxl),
        Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.circular(AppRadius.xxl),
            border: Border.all(color: AppColors.cardBorder, width: 1),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'XP Earned',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '+$xpEarned XP',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.primaryYellow,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Status',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.15),
                      borderRadius: AppRadius.circular(AppRadius.xxl),
                    ),
                    child: const Text(
                      'Completed',
                      style: TextStyle(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: PremiumCompletionButton(
            text: 'Continue Learning',
            onPressed: onClose,
            gradient: AppGradients.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

class PremiumCompletionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final LinearGradient gradient;

  const PremiumCompletionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradient = AppGradients.primary,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppMotion.fast,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: AppRadius.circular(AppRadius.xl),
        boxShadow: [AppGradients.glow(AppColors.primaryBlue, blurRadius: 20)],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppRadius.circular(AppRadius.xl),
          onTap: onPressed,
          child: Center(
            child: Text(
              text,
              style: AppTextStyles.labelLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CelebrationParticle extends StatelessWidget {
  final Color color;
  final double size;
  final Offset position;

  const CelebrationParticle({
    super.key,
    required this.color,
    required this.size,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class ConfettiAnimation extends StatefulWidget {
  final int particleCount;

  const ConfettiAnimation({super.key, this.particleCount = 50});

  @override
  State<ConfettiAnimation> createState() => _ConfettiAnimationState();
}

class _ConfettiAnimationState extends State<ConfettiAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<Offset> _positions = [];
  final List<Color> _colors = [];
  final List<double> _sizes = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _colors = [
      AppColors.primaryBlue,
      AppColors.primaryYellow,
      AppColors.primaryGreen,
      AppColors.primaryPurple,
      AppColors.primaryOrange,
      AppColors.primaryCyan,
    ];
    for (int i = 0; i < widget.particleCount; i++) {
      _positions.add(Offset(
        (i / widget.particleCount) * 300,
        (i % 5) * 60,
      ));
      _colors.shuffle();
      _sizes.add(4 + (i % 6) * 2.0);
    }
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
            return CelebrationParticle(
              color: _colors[index % _colors.length],
              size: _sizes[index],
              position: Offset(
                _positions[index].dx,
                _positions[index].dy - (50 * _controller.value),
              ),
            );
          }),
        );
      },
    );
  }
}
