import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_gradients.dart';
import '../domain/onboarding_models.dart';
import '../presentation/controllers/onboarding_wizard_controller.dart';
import '../presentation/widgets/step_indicator.dart';
import '../presentation/widgets/custom_text_field.dart';
import '../presentation/widgets/avatar_picker.dart';
import '../presentation/widgets/skill_option_card.dart';
import '../presentation/widgets/goal_option_card.dart';
import '../presentation/widgets/notification_toggle.dart';
import '../presentation/widgets/terms_checkbox.dart';
import '../presentation/widgets/completion_celebration.dart';
import '../presentation/widgets/gradient_background.dart';

class OnboardingWizardScreen extends StatefulWidget {
  const OnboardingWizardScreen({super.key});

  @override
  State<OnboardingWizardScreen> createState() => _OnboardingWizardScreenState();
}

class _OnboardingWizardScreenState extends State<OnboardingWizardScreen>
    with TickerProviderStateMixin {
  late OnboardingWizardController _controller;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = OnboardingWizardController();
    _fadeController = AnimationController(
      vsync: this,
      duration: AppMotion.smooth,
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Consumer<OnboardingWizardController>(
        builder: (context, controller, child) {
          return Scaffold(
            body: Stack(
              children: [
                const GradientBackground(),
                SafeArea(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        _buildHeader(controller),
                        Expanded(
                          child: PageView(
                            controller: controller.pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            children: const [
                              WelcomeStepScreen(),
                              PersonalInfoStepScreen(),
                              SkillSelectionStepScreen(),
                              GoalSelectionStepScreen(),
                              NotificationStepScreen(),
                              TermsStepScreen(),
                              CompletionStepScreen(),
                            ],
                          ),
                        ),
                        _buildNavigation(controller),
                      ],
                    ),
                  ),
                ),
                if (controller.isLoading)
                  const LoadingOverlay(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(OnboardingWizardController controller) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: AppGradients.primary,
              borderRadius: AppRadius.circular(AppRadius.md),
              boxShadow: [
                AppGradients.glow(AppColors.primaryBlue, blurRadius: 12),
              ],
            ),
            child: const Center(
              child: Icon(Icons.terminal_rounded, color: Colors.white, size: 24),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'CodeBro',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Setup your learning journey',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          StepIndicator(
            currentStep: controller.currentStep,
            totalSteps: controller.totalSteps,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigation(OnboardingWizardController controller) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (controller.canGoPrevious)
                TextButton(
                  onPressed: controller.previousStep,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.circular(AppRadius.lg),
                    ),
                    backgroundColor: AppColors.surface,
                    foregroundColor: AppColors.textSecondary,
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                )
                else
                  const SizedBox(width: 80),
              Text(
                '${controller.currentStep + 1} / ${controller.totalSteps}',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              if (controller.currentStep == controller.totalSteps - 1)
                PremiumOnboardingButton(
                  text: 'Finish Setup',
                  onPressed: _handleFinish,
                  gradient: AppGradients.neonGreen,
                )
              else if (controller.canGoNext)
                PremiumOnboardingButton(
                  text: 'Next',
                  onPressed: controller.nextStep,
                  gradient: AppGradients.primary,
                )
              else
                PremiumOnboardingButton(
                  text: 'Next',
                  onPressed: null,
                  gradient: AppGradients.primary,
                  isDisabled: true,
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleFinish() {
    _controller.setLoading(true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      _controller.setLoading(false);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const OnboardingCompleteScreen(),
        ),
      );
    });
  }
}

class WelcomeStepScreen extends StatelessWidget {
  const WelcomeStepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: AppSpacing.xxl),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: AppGradients.primary,
              shape: BoxShape.circle,
              boxShadow: [
                AppGradients.glow(AppColors.primaryBlue, blurRadius: 30),
              ],
            ),
            child: const Center(
              child: Text('🚀', style: TextStyle(fontSize: 56)),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            'Welcome to CodeBro',
            style: AppTextStyles.displayMedium.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Learn to code by building real projects. Gamified lessons, XP, streaks, and a community of developers.',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
              height: 1.7,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxl),
          _buildFeatureItem(
            icon: Icons.code_rounded,
            title: 'Interactive Lessons',
            description: 'Learn Flutter, Python, Web, and more',
            color: AppColors.primaryBlue,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildFeatureItem(
            icon: Icons.local_fire_department_rounded,
            title: 'Streak System',
            description: 'Build daily coding habits',
            color: AppColors.primaryOrange,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildFeatureItem(
            icon: Icons.emoji_events_rounded,
            title: 'Achievements',
            description: 'Unlock badges and level up',
            color: AppColors.primaryPurple,
          ),
          const Spacer(),
          Text(
            'Tap Next to begin your journey',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textMuted,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: AppRadius.circular(AppRadius.md),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
          ),
          child: Center(child: Icon(icon, color: color, size: 22)),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PersonalInfoStepScreen extends StatefulWidget {
  const PersonalInfoStepScreen({super.key});

  @override
  State<PersonalInfoStepScreen> createState() => _PersonalInfoStepScreenState();
}

class _PersonalInfoStepScreenState extends State<PersonalInfoStepScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingWizardController>(
      builder: (context, controller, child) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Personal Information',
                  style: AppTextStyles.titleLarge.copyWith(fontSize: 24),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Tell us about yourself so we can personalize your experience',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                CustomTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  hint: 'Alex Rivera',
                  prefixIcon: Icons.person_rounded,
                  onChanged: controller.setName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                CustomTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  hint: 'dev@codebro.dev',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: controller.setEmail,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.xxl),
                Text(
                  'Choose your avatar',
                  style: AppTextStyles.titleMedium.copyWith(fontSize: 18),
                ),
                const SizedBox(height: AppSpacing.md),
                AvatarPicker(
                  availableAvatars: controller.availableAvatars,
                  selectedAvatar: controller.selectedAvatar,
                  onAvatarSelected: controller.selectAvatar,
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SkillSelectionStepScreen extends StatefulWidget {
  const SkillSelectionStepScreen({super.key});

  @override
  State<SkillSelectionStepScreen> createState() =>
      _SkillSelectionStepScreenState();
}

class _SkillSelectionStepScreenState extends State<SkillSelectionStepScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingWizardController>(
      builder: (context, controller, child) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
              Text(
                'What do you want to learn?',
                style: AppTextStyles.titleLarge.copyWith(fontSize: 24),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Select at least one category to get personalized recommendations',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                  ),
                  itemCount: controller.skillCategories.length,
                  itemBuilder: (context, index) {
                    final category = controller.skillCategories[index];
                    final isAnySelected =
                        controller.isSkillSelected(category['id'], '');
                    return SkillCategoryCard(
                      category: category,
                      isExpanded:
                          controller._skillSelections.containsKey(category['id']),
                      onTap: () {
                        // Toggle category expansion handled in widget
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SkillCategoryCard extends StatefulWidget {
  final Map<String, dynamic> category;
  final bool isExpanded;
  final VoidCallback onTap;

  const SkillCategoryCard({
    super.key,
    required this.category,
    this.isExpanded = false,
    required this.onTap,
  });

  @override
  State<SkillCategoryCard> createState() => _SkillCategoryCardState();
}

class _SkillCategoryCardState extends State<SkillCategoryCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() => _expanded = !_expanded);
            widget.onTap();
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.circular(AppRadius.xl),
              border: Border.all(
                color: widget.category['color'].withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: [AppGradients.softShadow()],
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
                        color: widget.category['color'].withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          widget.category['icon'],
                          color: widget.category['color'],
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.category['title'],
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            widget.category['subtitle'],
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: AppMotion.fast,
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textMuted,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (_expanded) ...[
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: (widget.category['options'] as List<String>).map((skill) {
              return SkillOptionCard(
                skill: skill,
                categoryId: widget.category['id'],
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

class SkillOptionCard extends StatefulWidget {
  final String skill;
  final String categoryId;

  const SkillOptionCard({
    super.key,
    required this.skill,
    required this.categoryId,
  });

  @override
  State<SkillOptionCard> createState() => _SkillOptionCardState();
}

class _SkillOptionCardState extends State<SkillOptionCard> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingWizardController>(
      builder: (context, controller, child) {
        _selected = controller.isSkillSelected(widget.categoryId, widget.skill);
        return GestureDetector(
          onTap: () => controller.toggleSkill(widget.categoryId, widget.skill),
          child: AnimatedContainer(
            duration: AppMotion.fast,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: _selected
                  ? AppColors.primaryBlue.withValues(alpha: 0.2)
                  : AppColors.surfaceLight,
              borderRadius: AppRadius.circular(AppRadius.xxl),
              border: Border.all(
                color: _selected
                    ? AppColors.primaryBlue
                    : AppColors.cardBorder,
                width: _selected ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_selected)
                  const Icon(
                    Icons.check_rounded,
                    color: AppColors.primaryBlue,
                    size: 16,
                  ),
                if (_selected) const SizedBox(width: AppSpacing.xs),
                Text(
                  widget.skill,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: _selected
                        ? AppColors.primaryBlue
                        : AppColors.textSecondary,
                    fontWeight: _selected
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

class GoalSelectionStepScreen extends StatefulWidget {
  const GoalSelectionStepScreen({super.key});

  @override
  State<GoalSelectionStepScreen> createState() =>
      _GoalSelectionStepScreenState();
}

class _GoalSelectionStepScreenState extends State<GoalSelectionStepScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingWizardController>(
      builder: (context, controller, child) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
              Text(
                'Set your learning goal',
                style: AppTextStyles.titleLarge.copyWith(fontSize: 24),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'How much time can you spend learning each day?',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.9,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                  ),
                  itemCount: controller.goalOptions.length,
                  itemBuilder: (context, index) {
                    final goal = controller.goalOptions[index];
                    return GoalOptionCard(
                      goal: goal,
                      isSelected: controller.selectedGoal == goal['id'],
                      onTap: () =>
                          controller.selectGoal(goal['id'], goal['minutes']),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class NotificationStepScreen extends StatelessWidget {
  const NotificationStepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingWizardController>(
      builder: (context, controller, child) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
              Text(
                'Stay on track',
                style: AppTextStyles.titleLarge.copyWith(fontSize: 24),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Enable notifications to get streak reminders and daily challenges',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              NotificationToggle(
                title: 'Daily Streak Reminders',
                subtitle: 'Get notified when your streak is at risk',
                value: controller.notificationsEnabled,
                onChanged: controller.toggleNotifications,
              ),
              const SizedBox(height: AppSpacing.lg),
              NotificationToggle(
                title: 'Daily Challenges',
                subtitle: 'Receive new coding challenges every day',
                value: controller.notificationsEnabled,
                onChanged: controller.toggleNotifications,
              ),
              const SizedBox(height: AppSpacing.lg),
              NotificationToggle(
                title: 'Achievement Alerts',
                subtitle: 'Celebrate when you unlock new badges',
                value: controller.notificationsEnabled,
                onChanged: controller.toggleNotifications,
              ),
              const Spacer(),
            ],
          ),
        );
      },
    );
  }
}

class TermsStepScreen extends StatelessWidget {
  const TermsStepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingWizardController>(
      builder: (context, controller, child) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
              Text(
                'Almost there',
                style: AppTextStyles.titleLarge.copyWith(fontSize: 24),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Please review and accept our terms to continue',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Terms of Service',
                      style: AppTextStyles.titleMedium.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'By creating an account, you agree to our Terms of Service and Privacy Policy. '
                      'Your data is encrypted and never sold to third parties.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TermsCheckbox(
                      value: controller.termsAccepted,
                      onChanged: controller.toggleTerms,
                      label: 'I accept the Terms of Service and Privacy Policy',
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        );
      },
    );
  }
}

class CompletionStepScreen extends StatelessWidget {
  const CompletionStepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingWizardController>(
      builder: (context, controller, child) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.xxl),
              CompletionCelebration(
                profile: controller.profile,
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'You\'re all set!',
                style: AppTextStyles.displayMedium.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Start your first lesson and begin your coding journey',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              PremiumOnboardingButton(
                text: 'Start Learning',
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const OnboardingCompleteScreen(),
                    ),
                  );
                },
                gradient: AppGradients.primary,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        );
      },
    );
  }
}

class OnboardingCompleteScreen extends StatelessWidget {
  const OnboardingCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: AppGradients.neonGreen,
                shape: BoxShape.circle,
                boxShadow: [
                  AppGradients.glow(AppColors.primaryGreen, blurRadius: 30),
                ],
              ),
              child: const Center(
                child: Icon(Icons.check_circle_rounded, color: Colors.white, size: 50),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'Setup Complete',
              style: AppTextStyles.displayMedium.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Welcome to CodeBro, Alex!',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: PremiumOnboardingButton(
                text: 'Go to Dashboard',
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/home',
                    (route) => false,
                  );
                },
                gradient: AppGradients.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
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
