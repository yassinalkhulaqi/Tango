import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/splash_mark.dart';

/// Premium splash screen that fades the mark in and holds briefly before
/// handing control to the app. The mark is semantic-free decoration; the
/// localized brand text is supplied by the caller.
class PremiumSplashScreen extends StatefulWidget {
  final String brandName;
  final String? tagline;
  final VoidCallback? onReady;
  final Duration hold;

  const PremiumSplashScreen({
    super.key,
    required this.brandName,
    this.tagline,
    this.onReady,
    this.hold = const Duration(milliseconds: 1600),
  });

  @override
  State<PremiumSplashScreen> createState() => _PremiumSplashScreenState();
}

class _PremiumSplashScreenState extends State<PremiumSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<double>(
      begin: 16,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
    if (widget.onReady != null) {
      Future<void>.delayed(widget.hold, () {
        if (mounted) widget.onReady?.call();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.of(context).disableAnimations;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: Transform.translate(
              offset: Offset(0, reducedMotion ? 0 : _slide.value),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SplashMark(reducedMotion: reducedMotion),
                  const SizedBox(height: AppSpacing.xxl),
                  Text(
                    widget.brandName,
                    style: AppTextStyles.displayMedium.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  if (widget.tagline != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      widget.tagline!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
