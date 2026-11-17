import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_gradients.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  int _page = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Welcome to CodeBro',
      'subtitle': 'Learn to code by building real projects',
      'icon': '🚀',
      'description': 'Gamified lessons, XP, streaks, and a community of developers.',
    },
    {
      'title': 'Learn By Building',
      'subtitle': 'Interactive courses, challenges, and quizzes',
      'icon': '💻',
      'description': 'Flutter, Python, Web Dev, Cybersecurity, and more.',
    },
    {
      'title': 'Level Up Your Skills',
      'subtitle': 'Earn badges and climb the leaderboard',
      'icon': '🏆',
      'description': 'Compete with friends and track your progress.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(vsync: this, duration: AppMotion.smooth);
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_page == _pages.length - 1) {
      Navigator.of(context).pushReplacementNamed('/auth');
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
                      boxShadow: [BoxShadow(color: AppColors.primaryBlue.withValues(alpha: 0.12), blurRadius: 120, spreadRadius: 60)],
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
                      boxShadow: [BoxShadow(color: AppColors.primaryPurple.withValues(alpha: 0.08), blurRadius: 100, spreadRadius: 50)],
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
              const Icon(Icons.terminal_rounded, color: AppColors.primaryBlue, size: 22),
              const SizedBox(width: 8),
              Text(
                'CodeBro',
                style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w900, fontSize: 18),
              ),
            ],
          ),
          if (_page < _pages.length - 1)
            TextButton(
              onPressed: () => setState(() => _page = _pages.length - 1),
              child: Text('Skip', style: AppTextStyles.labelMedium.copyWith(color: AppColors.textMuted, fontWeight: FontWeight.bold)),
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
            boxShadow: [AppGradients.glow(AppColors.primaryBlue, blurRadius: 30)],
          ),
          child: Center(child: Text(page['icon'] ?? '🚀', style: const TextStyle(fontSize: 50))),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text(page['title'], style: AppTextStyles.displayMedium.copyWith(fontSize: 26), textAlign: TextAlign.center),
        const SizedBox(height: AppSpacing.lg),
        Text(page['subtitle'], style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
        const SizedBox(height: AppSpacing.lg),
        Text(page['description'], style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, fontSize: 14), textAlign: TextAlign.center),
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
                  color: isActive ? AppColors.primaryBlue : AppColors.cardBorder,
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
              text: _page == _pages.length - 1 ? 'Start Learning' : 'Next Journey',
              onPressed: _nextPage,
              gradient: AppGradients.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class PremiumButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final LinearGradient gradient;

  const PremiumButton({super.key, required this.text, this.onPressed, this.gradient = AppGradients.primary});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppMotion.fast,
      height: 52,
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
              style: AppTextStyles.labelLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  bool _isLogin = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.deepSpace),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: AppGradients.primary,
                      shape: BoxShape.circle,
                      boxShadow: [AppGradients.glow(AppColors.primaryBlue, blurRadius: 24)],
                    ),
                    child: const Center(
                      child: Icon(Icons.terminal_rounded, color: Colors.white, size: 32),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    _isLogin ? 'Welcome Back' : 'Create Account',
                    style: AppTextStyles.displayMedium.copyWith(fontSize: 26),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _isLogin ? 'Continue your programming journey' : 'Join the CodeBro community',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  AuthTextField(
                    controller: _emailController,
                    label: 'Email Address',
                    hint: 'dev@codebro.dev',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  PasswordField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: '••••••••',
                    obscureText: _obscurePassword,
                    onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  if (!_isLogin) ...[
                    const SizedBox(height: 20),
                    AuthTextField(
                      controller: TextEditingController(),
                      label: 'Confirm Password',
                      hint: '••••••••',
                      prefixIcon: Icons.lock_outline_rounded,
                      obscureText: _obscurePassword,
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _rememberMe = !_rememberMe),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: _rememberMe ? AppColors.primaryBlue : Colors.transparent,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: _rememberMe ? AppColors.primaryBlue : AppColors.cardBorder,
                                  width: 1.5,
                                ),
                              ),
                              child: _rememberMe ? const Icon(Icons.check_rounded, color: Colors.white, size: 14) : null,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Remember me',
                              style: AppTextStyles.labelMedium.copyWith(color: AppColors.textMuted, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      if (_isLogin)
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Forgot Password?',
                            style: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: PremiumButton(
                      text: _isLogin ? 'Login' : 'Create Account',
                      onPressed: () {
                        setState(() => _isLoading = true);
                        Future.delayed(const Duration(seconds: 1), () {
                          if (!mounted) return;
                          setState(() => _isLoading = false);
                        });
                      },
                      isLoading: _isLoading,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Expanded(child: Divider(color: AppColors.cardBorder)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'or continue with',
                          style: AppTextStyles.labelMedium.copyWith(color: AppColors.textMuted, fontSize: 12),
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
                    onTap: () => setState(() => _isLogin = !_isLogin),
                    child: RichText(
                      text: TextSpan(
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, fontSize: 14),
                        children: [
                          TextSpan(
                            text: _isLogin ? "Don't have an account? " : 'Already have an account? ',
                          ),
                          TextSpan(
                            text: _isLogin ? 'Create Account' : 'Login',
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
      ),
    );
  }

  bool _rememberMe = false;
}

class AuthTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final VoidCallback? onToggle;

  const AuthTextField({super.key, this.controller, required this.label, this.hint, this.prefixIcon, this.keyboardType, this.obscureText = false, this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600, fontSize: 13),
        ),
        const SizedBox(height: AppSpacing.xs),
        Stack(
          alignment: Alignment.centerRight,
          children: [
            TextField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: AppTextStyles.bodyLarge.copyWith(color: AppColors.textMuted, fontSize: 14),
                prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: AppColors.textMuted, size: 20) : null,
                suffixIcon: onToggle != null ? GestureDetector(
                  onTap: onToggle,
                  child: Icon(obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: AppColors.textMuted, size: 20),
                ) : null,
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
                border: OutlineInputBorder(
                  borderRadius: AppRadius.circular(AppRadius.lg),
                  borderSide: const BorderSide(color: AppColors.cardBorder, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppRadius.circular(AppRadius.lg),
                  borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool obscureText;
  final VoidCallback onToggle;

  const PasswordField({super.key, required this.controller, required this.label, this.hint, required this.obscureText, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return AuthTextField(
      controller: controller,
      label: label,
      hint: hint,
      prefixIcon: Icons.lock_outline_rounded,
      obscureText: obscureText,
      onToggle: onToggle,
    );
  }
}

class SocialButton extends StatelessWidget {
  final String text;
  final IconData icon;

  const SocialButton({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(icon, color: AppColors.textSecondary, size: 20),
        label: Text(
          text,
          style: AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 15),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.cardBorder, width: 1),
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.circular(AppRadius.xl),
          ),
        ),
      ),
    );
  }
}
