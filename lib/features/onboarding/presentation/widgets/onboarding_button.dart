import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

enum OnboardingButtonType { primary, secondary }

class OnboardingButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final OnboardingButtonType type;

  const OnboardingButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = OnboardingButtonType.primary,
  });

  @override
  State<OnboardingButton> createState() => _OnboardingButtonState();
}

class _OnboardingButtonState extends State<OnboardingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPrimary = widget.type == OnboardingButtonType.primary;
    final width = MediaQuery.sizeOf(context).width;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onPressed();
        },
        onTapCancel: () => _controller.reverse(),
        child: Container(
          width: width * 0.85,
          height: 56,
          decoration: BoxDecoration(
            gradient: isPrimary ? AppColors.primaryGradient : null,
            color: isPrimary ? null : AppColors.surface.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isPrimary ? Colors.transparent : const Color(0x1F94A3B8),
              width: 1.5,
            ),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: AppColors.primaryBlue.withValues(alpha: 0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              widget.text,
              style: AppTextStyles.labelLarge.copyWith(
                color: isPrimary ? Colors.white : AppColors.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
