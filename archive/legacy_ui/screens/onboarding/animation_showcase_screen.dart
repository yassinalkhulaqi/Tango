import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../ui_components/widgets/ui_component_library.dart';

class AnimationShowcaseScreen extends StatefulWidget {
  const AnimationShowcaseScreen({super.key});

  @override
  State<AnimationShowcaseScreen> createState() =>
      _AnimationShowcaseScreenState();
}

class _AnimationShowcaseScreenState extends State<AnimationShowcaseScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );
    _pulseController.repeat(reverse: true);
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _floatAnimation = Tween(begin: 0.0, end: -10.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
    _floatController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Animation Showcase'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Micro-Interactions',
                style: AppTextStyles.displayMedium.copyWith(fontSize: 24),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'All animations follow the CodeBro motion language — fast, snappy, purposeful.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              _buildAnimationCard(
                title: 'Button Press',
                subtitle: 'Scale 1.0→0.97 in 120ms',
                icon: Icons.touch_app_rounded,
                color: AppColors.primaryBlue,
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 + (0.05 * _pulseAnimation.value),
                      child: PremiumButton(
                        text: 'Press Me',
                        onPressed: () {},
                        gradient: AppGradients.primary,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              _buildAnimationCard(
                title: 'Floating Element',
                subtitle: 'Drifts up 10px, loops 2s',
                icon: Icons.airplay_rounded,
                color: AppColors.primaryYellow,
                child: AnimatedBuilder(
                  animation: _floatAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _floatAnimation.value),
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: AppGradients.reward,
                          borderRadius: AppRadius.circular(AppRadius.xxl),
                          boxShadow: [
                            AppGradients.glow(
                              AppColors.primaryYellow,
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.star_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              _buildAnimationCard(
                title: 'XP Float',
                subtitle: 'Drifts up 40dp, fades over 800ms',
                icon: Icons.bolt_rounded,
                color: AppColors.primaryGreen,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppRadius.circular(AppRadius.lg),
                    border: Border.all(color: AppColors.cardBorder, width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.bolt_rounded,
                        color: AppColors.primaryGreen,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        '+50 XP earned',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, -40 * _pulseAnimation.value),
                            child: Opacity(
                              opacity: 1.0 - _pulseAnimation.value,
                              child: const Text(
                                '+50 XP',
                                style: TextStyle(
                                  color: AppColors.primaryYellow,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              _buildAnimationCard(
                title: 'Celebration Burst',
                subtitle: 'Particle burst on achievement unlock',
                icon: Icons.celebration_rounded,
                color: AppColors.primaryPurple,
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1.0 + (0.1 * _pulseAnimation.value),
                          child: AchievementCard(
                            achievement: {
                              'name': 'First Commit',
                              'description': 'Complete your very first lesson',
                              'icon': '🚀',
                              'color': AppColors.primaryBlue,
                              'unlocked': true,
                              'xp': 100,
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    PremiumButton(
                      text: 'Unlock Achievement',
                      onPressed: () {},
                      gradient: AppGradients.neonPurple,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              _buildAnimationCard(
                title: 'Streak Pulse',
                subtitle: 'Flame icon pulses + count animates',
                icon: Icons.local_fire_department_rounded,
                color: AppColors.primaryOrange,
                child: StreakIndicator(
                  streak: 12,
                  flameColor: AppColors.primaryOrange,
                  animated: true,
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimationCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: AppRadius.circular(AppRadius.md),
                ),
                child: Center(child: Icon(icon, color: color, size: 20)),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  int _page = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Welcome to CodeBro',
      'subtitle': 'Learn to code by building real projects',
      'icon': '🚀',
    },
    {
      'title': 'Learn By Building',
      'subtitle': 'Courses, challenges, and interactive lessons',
      'icon': '💻',
    },
    {
      'title': 'Level Up Your Skills',
      'subtitle': 'Earn XP, badges, and climb the leaderboard',
      'icon': '🏆',
    },
  ];

  @override
  void initState() {
    super.initState();
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
    _fadeController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_page == _pages.length - 1) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    } else {
      setState(() => _page++);
      _fadeController.reset();
      _fadeController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = _pages[_page];
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(gradient: AppGradients.deepSpace),
            child: Stack(
              children: [
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
                          color: AppColors.primaryPurple.withValues(
                            alpha: 0.08,
                          ),
                          blurRadius: 100,
                          spreadRadius: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  _buildTopBar(),
                  Expanded(
                    child: PageView.builder(
                      itemCount: _pages.length,
                      itemBuilder: (context, index) {
                        return _buildPage(_pages[index]);
                      },
                    ),
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

  Widget _buildTopBar() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.terminal_rounded,
                color: AppColors.primaryBlue,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                'CodeBro',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          if (_page < _pages.length - 1)
            TextButton(
              onPressed: () => setState(() => _page = _pages.length - 1),
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
  }

  Widget _buildPage(Map<String, String> page) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
          child: Center(
            child: Text(
              page['icon'] ?? '🚀',
              style: const TextStyle(fontSize: 50),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text(
          page['title'],
          style: AppTextStyles.displayMedium.copyWith(fontSize: 26),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          page['subtitle'],
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pages.length, (index) {
              final isActive = index == _page;
              return AnimatedContainer(
                duration: AppMotion.normal,
                width: isActive ? 24 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primaryBlue
                      : AppColors.cardBorder,
                  borderRadius: AppRadius.circular(AppRadius.xxl),
                ),
              );
            }),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: PremiumButton(
              text: _page == _pages.length - 1
                  ? 'Start Learning'
                  : 'Next Journey',
              onPressed: _nextPage,
              gradient: AppGradients.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.deepSpace),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 40),
                const AuthHeader(
                  title: 'Welcome Back',
                  subtitle: 'Continue your programming journey',
                ),
                const SizedBox(height: 40),
                AuthTextField(
                  controller: TextEditingController(),
                  label: 'Email Address',
                  hint: 'dev@codebro.dev',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                PasswordField(
                  controller: TextEditingController(),
                  label: 'Password',
                  hint: '••••••••',
                  obscureText: true,
                  onToggle: () {},
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Remember me',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Forgot Password?',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                PremiumButton(
                  text: 'Login',
                  onPressed: () {},
                  gradient: AppGradients.primary,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.cardBorder)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'or continue with',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: AppColors.cardBorder)),
                  ],
                ),
                const SizedBox(height: 20),
                const SocialButton(
                  text: 'Continue with Google',
                  icon: Icons.g_mobiledata_rounded,
                ),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: () {},
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                      children: [
                        const TextSpan(text: "Don't have an account? "),
                        TextSpan(
                          text: 'Create Account',
                          style: const TextStyle(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
