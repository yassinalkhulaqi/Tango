import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controllers/onboarding_controller.dart';
import '../states/onboarding_content_data.dart';
import '../widgets/onboarding_button.dart';
import '../widgets/onboarding_indicator.dart';
import '../widgets/onboarding_page_content.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  late final OnboardingController _controller;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = OnboardingController();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    _controller.onPageChanged(index);
    _fadeController.reset();
    _fadeController.forward();
  }

  void _onActionPressed() {
    if (_controller.isLastPage) {
      _controller.onComplete(context);
    } else {
      _controller.nextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Premium space background with subtle color glows
          _buildPremiumBackground(),
          
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  _buildTopBar(),
                  Expanded(
                    child: _buildPageView(),
                  ),
                  _buildBottomSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: Stack(
        children: [
          // Neon glow point top-right
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withValues(alpha: 0.12),
                    blurRadius: 120,
                    spreadRadius: 60,
                  ),
                ],
              ),
            ),
          ),
          // Neon glow point bottom-left
          Positioned(
            bottom: -50,
            left: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.purple.withValues(alpha: 0.08),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),
          // Subtle grid pattern simulation using lines
          Opacity(
            opacity: 0.03,
            child: GridPaper(
              color: Colors.white,
              interval: 40,
              subdivisions: 1,
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // CodeBro logo label
              Row(
                children: [
                  const Icon(Icons.terminal_rounded, color: AppColors.primaryBlue, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'CodeBro',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              if (!_controller.isLastPage)
                TextButton(
                  onPressed: _controller.skipToEnd,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Skip',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      controller: _controller.pageController,
      onPageChanged: _onPageChanged,
      itemCount: OnboardingContent.pages.length,
      itemBuilder: (context, index) {
        return OnboardingPageContent(
          content: OnboardingContent.pages[index],
        );
      },
    );
  }

  Widget _buildBottomSection() {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OnboardingIndicator(
                currentPage: _controller.currentPage,
                totalPages: _controller.totalPages,
              ),
              const SizedBox(height: 32),
              OnboardingButton(
                text: _controller.isLastPage ? 'Start Learning' : 'Next Journey',
                onPressed: _onActionPressed,
              ),
            ],
          ),
        );
      },
    );
  }
}
