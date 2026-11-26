import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_motion.dart';

class SkillOptionCard extends StatelessWidget {
  final String skill;
  final String categoryId;

  const SkillOptionCard({
    super.key,
    required this.skill,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingWizardController>(
      builder: (context, controller, child) {
        final selected = controller.isSkillSelected(categoryId, skill);
        return GestureDetector(
          onTap: () => controller.toggleSkill(categoryId, skill),
          child: AnimatedContainer(
            duration: AppMotion.fast,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primaryBlue.withValues(alpha: 0.2)
                  : AppColors.surfaceLight,
              borderRadius: AppRadius.circular(AppRadius.xxl),
              border: Border.all(
                color: selected
                    ? AppColors.primaryBlue
                    : AppColors.cardBorder,
                width: selected ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selected)
                  const Icon(
                    Icons.check_rounded,
                    color: AppColors.primaryBlue,
                    size: 16,
                  ),
                if (selected) const SizedBox(width: AppSpacing.xs),
                Text(
                  skill,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: selected
                        ? AppColors.primaryBlue
                        : AppColors.textSecondary,
                    fontWeight: selected
                        ? FontWeight.w700
                        : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_motion.dart';

class GoalOptionCard extends StatefulWidget {
  final Map<String, dynamic> goal;
  final bool isSelected;
  final VoidCallback onTap;

  const GoalOptionCard({
    super.key,
    required this.goal,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<GoalOptionCard> createState() => _GoalOptionCardState();
}

class _GoalOptionCardState extends State<GoalOptionCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: AppMotion.fast,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: widget.isSelected
              ? widget.goal['color'].withValues(alpha: 0.2)
              : AppColors.surfaceLight,
          borderRadius: AppRadius.circular(AppRadius.xl),
          border: Border.all(
            color: widget.isSelected
                ? widget.goal['color']
                : AppColors.cardBorder,
            width: widget.isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: widget.goal['color'].withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      widget.goal['icon'],
                      color: widget.goal['color'],
                      size: 18,
                    ),
                  ),
                ),
                const Spacer(),
                if (widget.isSelected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.primaryGreen,
                    size: 20,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              widget.goal['title'],
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              widget.goal['subtitle'],
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationToggle extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const NotificationToggle({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryBlue,
            activeTrackColor: AppColors.primaryBlue.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}

class TermsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;

  const TermsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (v) => onChanged(v ?? false),
          activeColor: AppColors.primaryBlue,
          checkColor: Colors.white,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(!value),
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
                children: [
                  TextSpan(text: label),
                  const TextSpan(
                    text: ' Terms of Service',
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const TextSpan(
                    text: ' and ',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: const TextStyle(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CompletionCelebration extends StatelessWidget {
  final OnboardingProfile profile;

  const CompletionCelebration({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: AppGradients.neonGreen,
            shape: BoxShape.circle,
            boxShadow: [
              AppGradients.glow(AppColors.primaryGreen, blurRadius: 40),
            ],
          ),
          child: const Center(
            child: Icon(Icons.celebration_rounded, color: Colors.white, size: 56),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Welcome, ${profile.name}!',
          style: AppTextStyles.titleLarge.copyWith(fontSize: 24),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'You selected ${profile.selectedSkills.length} skill${profile.selectedSkills.length != 1 ? 's' : ''}',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_gradients.dart';

class GradientBackground extends StatelessWidget {
  final Alignment begin;
  final Alignment end;

  const GradientBackground({
    super.key,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF070A0F), Color(0xFF0C111A), Color(0xFF080D14)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}

class PremiumOnboardingButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isDisabled;
  final LinearGradient gradient;

  const PremiumOnboardingButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isDisabled = false,
    this.gradient = AppGradients.primary,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isDisabled;
    return AnimatedContainer(
      duration: AppMotion.fast,
      height: 52,
      decoration: BoxDecoration(
        gradient: enabled ? gradient : null,
        color: enabled ? null : AppColors.cardBorder.withValues(alpha: 0.4),
        borderRadius: AppRadius.circular(AppRadius.xl),
        boxShadow:
            enabled ? [AppGradients.glow(AppColors.primaryBlue, blurRadius: 20)] : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppRadius.circular(AppRadius.xl),
          onTap: enabled ? onPressed : null,
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

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryBlue,
          strokeWidth: 3,
        ),
      ),
    );
  }
}
