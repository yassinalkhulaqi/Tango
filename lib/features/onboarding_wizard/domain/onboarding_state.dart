import 'package:flutter/material.dart';

class OnboardingStepState {
  final String stepId;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLocked;
  final DateTime? completedAt;
  final Map<String, dynamic> data;

  const OnboardingStepState({
    required this.stepId,
    this.isCompleted = false,
    this.isCurrent = false,
    this.isLocked = false,
    this.completedAt,
    this.data = const {},
  });

  OnboardingStepState copyWith({
    String? stepId,
    bool? isCompleted,
    bool? isCurrent,
    bool? isLocked,
    DateTime? completedAt,
    Map<String, dynamic>? data,
  }) {
    return OnboardingStepState(
      stepId: stepId ?? this.stepId,
      isCompleted: isCompleted ?? this.isCompleted,
      isCurrent: isCurrent ?? this.isCurrent,
      isLocked: isLocked ?? this.isLocked,
      completedAt: completedAt ?? this.completedAt,
      data: data ?? this.data,
    );
  }
}

class OnboardingWizardState {
  final List<OnboardingStepState> steps;
  final int currentStepIndex;
  final bool isCompleted;
  final OnboardingProfile? profile;

  const OnboardingWizardState({
    required this.steps,
    required this.currentStepIndex,
    this.isCompleted = false,
    this.profile,
  });

  factory OnboardingWizardState.initial() {
    return OnboardingWizardState(
      steps: [
        const OnboardingStepState(stepId: 'welcome', isCurrent: true, isLocked: false),
        const OnboardingStepState(stepId: 'personal_info', isLocked: true),
        const OnboardingStepState(stepId: 'skill_selection', isLocked: true),
        const OnboardingStepState(stepId: 'goal_selection', isLocked: true),
        const OnboardingStepState(stepId: 'notifications', isLocked: true),
        const OnboardingStepState(stepId: 'terms', isLocked: true),
        const OnboardingStepState(stepId: 'completion', isLocked: true),
      ],
      currentStepIndex: 0,
    );
  }

  OnboardingWizardState copyWith({
    List<OnboardingStepState>? steps,
    int? currentStepIndex,
    bool? isCompleted,
    OnboardingProfile? profile,
  }) {
    return OnboardingWizardState(
      steps: steps ?? this.steps,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      isCompleted: isCompleted ?? this.isCompleted,
      profile: profile ?? this.profile,
    );
  }

  OnboardingStepState? get currentStep {
    if (currentStepIndex >= 0 && currentStepIndex < steps.length) {
      return steps[currentStepIndex];
    }
    return null;
  }

  double get completionPercent {
    if (steps.isEmpty) return 0.0;
    final completed = steps.where((s) => s.isCompleted).length;
    return completed / steps.length;
  }

  bool get canProceedToNext {
    final current = currentStep;
    if (current == null) return false;
    return current.isCompleted || currentStepIndex == 0;
  }
}

class OnboardingStepConfig {
  final String id;
  final String title;
  final String subtitle;
  final String icon;
  final Color color;
  final String routeName;
  final bool isOptional;
  final String? validationMessage;

  const OnboardingStepConfig({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.routeName,
    this.isOptional = false,
    this.validationMessage,
  });

  static List<OnboardingStepConfig> get allSteps => [
    OnboardingStepConfig(
      id: 'welcome',
      title: 'Welcome',
      subtitle: 'Introduction to CodeBro',
      icon: '🚀',
      color: AppColors.primaryBlue,
      routeName: '/onboarding/welcome',
    ),
    OnboardingStepConfig(
      id: 'personal_info',
      title: 'Personal Info',
      subtitle: 'Set up your profile',
      icon: '👤',
      color: AppColors.primaryPurple,
      routeName: '/onboarding/personal-info',
      validationMessage: 'Name and email are required',
    ),
    OnboardingStepConfig(
      id: 'skill_selection',
      title: 'Select Skills',
      subtitle: 'Choose what to learn',
      icon: '📚',
      color: AppColors.primaryGreen,
      routeName: '/onboarding/skills',
    ),
    OnboardingStepConfig(
      id: 'goal_selection',
      title: 'Set Goal',
      subtitle: 'Daily learning time',
      icon: '🎯',
      color: AppColors.primaryOrange,
      routeName: '/onboarding/goal',
    ),
    OnboardingStepConfig(
      id: 'notifications',
      title: 'Notifications',
      subtitle: 'Stay on track',
      icon: '🔔',
      color: AppColors.primaryCyan,
      routeName: '/onboarding/notifications',
      isOptional: true,
    ),
    OnboardingStepConfig(
      id: 'terms',
      title: 'Terms',
      subtitle: 'Accept terms of service',
      icon: '📄',
      color: AppColors.primaryYellow,
      routeName: '/onboarding/terms',
    ),
    OnboardingStepConfig(
      id: 'completion',
      title: 'Complete',
      subtitle: 'Ready to start',
      icon: '🎉',
      color: AppColors.primaryGreen,
      routeName: '/onboarding/complete',
    ),
  ];

  static OnboardingStepConfig? findById(String id) {
    try {
      return allSteps.firstWhere((step) => step.id == id);
    } catch (_) {
      return null;
    }
  }

  static int getIndexById(String id) {
    return allSteps.indexWhere((step) => step.id == id);
  }
}

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_gradients.dart';

class SkillSelectionSummary extends StatelessWidget {
  final Map<String, List<String>> selections;

  const SkillSelectionSummary({super.key, required this.selections});

  @override
  Widget build(BuildContext context) {
    final totalSkills = selections.values.expand((s) => s).length;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Selected Skills',
                style: AppTextStyles.titleMedium.copyWith(fontSize: 17),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.15),
                  borderRadius: AppRadius.circular(AppRadius.xxl),
                ),
                child: Text(
                  '$totalSkills skills',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: selections.entries.expand((entry) {
                return entry.value.map((skill) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: AppColors.cardBorder.withValues(alpha: 0.5),
                      borderRadius: AppRadius.circular(AppRadius.xxl),
                    ),
                    child: Text(
                      skill,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  );
                });
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Color activeColor;
  final Color inactiveColor;

  const OnboardingPageIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.activeColor = AppColors.primaryBlue,
    this.inactiveColor = AppColors.cardBorder,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        final isActive = index == currentPage;
        return AnimatedContainer(
          duration: AppMotion.normal,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          width: isActive ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            borderRadius: AppRadius.circular(AppRadius.xxl),
          ),
        );
      }),
    );
  }
}

class OnboardingHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showSkip;
  final VoidCallback? onSkip;

  const OnboardingHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showSkip = true,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.displayMedium.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              if (showSkip)
                TextButton(
                  onPressed: onSkip,
                  child: Text(
                    'Skip',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class OnboardingFooter extends StatelessWidget {
  final String primaryText;
  final String? secondaryText;
  final VoidCallback onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final bool isLoading;
  final bool isPrimaryEnabled;

  const OnboardingFooter({
    super.key,
    required this.primaryText,
    this.secondaryText,
    required this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.isLoading = false,
    this.isPrimaryEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (secondaryText != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (onSecondaryPressed != null)
                  TextButton(
                    onPressed: onSecondaryPressed,
                    child: Text(
                      secondaryText!,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          SizedBox(
            width: double.infinity,
            height: 52,
            child: PremiumOnboardingButton(
              text: primaryText,
              onPressed: isPrimaryEnabled ? onPrimaryPressed : null,
              isDisabled: !isPrimaryEnabled,
              gradient: AppGradients.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedStepTransition extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;

  const AnimatedStepTransition({
    super.key,
    required this.child,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.3, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: child,
      ),
    );
  }
}

class SkillChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const SkillChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppMotion.fast,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : AppColors.surfaceLight,
          borderRadius: AppRadius.circular(AppRadius.xxl),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.cardBorder,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class GoalChip extends StatelessWidget {
  final String label;
  final String subtitle;
  final int minutes;
  final bool isSelected;
  final VoidCallback onTap;

  const GoalChip({
    super.key,
    required this.label,
    required this.subtitle,
    required this.minutes,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppMotion.fast,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue.withValues(alpha: 0.2) : AppColors.surface,
          borderRadius: AppRadius.circular(AppRadius.xl),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.cardBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isSelected ? AppColors.primaryBlue : AppColors.textPrimary,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle_rounded, color: AppColors.primaryGreen, size: 20),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                const Icon(Icons.access_time_rounded, color: AppColors.textMuted, size: 14),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '$minutes min/day',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const OnboardingCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.circular(AppRadius.xxl),
        border: Border.all(color: AppColors.cardBorder, width: 1),
        boxShadow: [AppGradients.cardShadow()],
      ),
      child: child,
    );
  }
}
