import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../states/onboarding_content_data.dart';
import './premium_components.dart';

class OnboardingPageContent extends StatelessWidget {
  final OnboardingContent content;

  const OnboardingPageContent({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          SizedBox(height: height * 0.05),
          // Interactive mockups with neon glows
          SizedBox(
            height: height * 0.38,
            child: _buildPremiumIllustration(context),
          ),
          SizedBox(height: height * 0.04),
          // Content text with clear visual hierarchy
          Text(
            content.title,
            style: AppTextStyles.displayMedium.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 30,
              letterSpacing: -0.8,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              content.description,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumIllustration(BuildContext context) {
    switch (content.pageIndex) {
      case 0:
        return const NeonGlowContainer(
          glowColor: AppColors.primaryBlue,
          child: CodeEditorPreview(),
        );
      case 1:
        return const NeonGlowContainer(
          glowColor: AppColors.green,
          child: RoadmapVisual(),
        );
      case 2:
        return const NeonGlowContainer(
          glowColor: AppColors.primaryYellow,
          child: GamifiedStatsDashboard(),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
