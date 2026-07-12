import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A premium glassmorphism card container with gradient borders and blur.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final BoxBorder? border;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 24.0,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
        child: Container(
          padding: padding ?? const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: AppColors.glassBackground,
            borderRadius: BorderRadius.circular(borderRadius),
            border: border ?? Border.all(
              color: const Color(0x1E94A3B8),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

/// A neon/glow effects container designed to make widgets stand out.
class NeonGlowContainer extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final double maxBlurRadius;

  const NeonGlowContainer({
    super.key,
    required this.child,
    this.glowColor = AppColors.primaryBlue,
    this.maxBlurRadius = 15.0,
  });

  @override
  State<NeonGlowContainer> createState() => _NeonGlowContainerState();
}

class _NeonGlowContainerState extends State<NeonGlowContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 2.0, end: widget.maxBlurRadius).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withValues(alpha: 0.15),
                blurRadius: _glowAnimation.value,
                spreadRadius: _glowAnimation.value * 0.2,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// Simulated beautiful code editor terminal for onboarding Screen 1
class CodeEditorPreview extends StatelessWidget {
  const CodeEditorPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 16.0,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Tab Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0x1F000000),
              border: Border(
                bottom: BorderSide(color: Color(0x1E94A3B8), width: 1),
              ),
            ),
            child: Row(
              children: [
                // Mac OS-like traffic dots
                Row(
                  children: [
                    _buildDot(Colors.redAccent),
                    const SizedBox(width: 6),
                    _buildDot(Colors.amber),
                    const SizedBox(width: 6),
                    _buildDot(Colors.green),
                  ],
                ),
                const SizedBox(width: 20),
                // File Tab Name
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0x1E94A3B8), width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.code_rounded, size: 14, color: AppColors.primaryBlue),
                      const SizedBox(width: 6),
                      Text(
                        'main.py',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Code space
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCodeLine('1', 'import', ' codebro', keyword: true),
                const SizedBox(height: 4),
                _buildCodeLine('2', 'def', ' learn_programming():', keyword: true),
                const SizedBox(height: 4),
                _buildCodeLine('3', '    app = codebro.App()', '', secondary: true),
                const SizedBox(height: 4),
                _buildCodeLine('4', '    app.start_journey()', '', secondary: true),
                const SizedBox(height: 4),
                _buildCodeLine('5', 'learn_programming()', '', highlight: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.8),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildCodeLine(String num, String accentText, String normalText,
      {bool keyword = false, bool secondary = false, bool highlight = false}) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          child: Text(
            num,
            style: AppTextStyles.codeFont.copyWith(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
          ),
        ),
        RichText(
          text: TextSpan(
            style: AppTextStyles.codeFont.copyWith(fontSize: 13),
            children: [
              if (keyword)
                TextSpan(
                  text: accentText,
                  style: const TextStyle(color: AppColors.pink, fontWeight: FontWeight.bold),
                )
              else if (secondary)
                TextSpan(
                  text: accentText,
                  style: const TextStyle(color: AppColors.primaryBlue),
                )
              else
                TextSpan(
                  text: accentText,
                  style: TextStyle(color: highlight ? AppColors.primaryYellow : AppColors.textPrimary),
                ),
              TextSpan(
                text: normalText,
                style: TextStyle(
                  color: secondary
                      ? AppColors.primaryYellow
                      : (keyword ? AppColors.cyan : AppColors.textPrimary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Animated learning journey visualization for Screen 2
class RoadmapVisual extends StatelessWidget {
  const RoadmapVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 20.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.alt_route_rounded, color: AppColors.primaryBlue),
                  const SizedBox(width: 8),
                  Text(
                    'Python Mastery Path',
                    style: AppTextStyles.titleMedium.copyWith(fontSize: 16),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.green.withValues(alpha: 0.3)),
                ),
                child: Text(
                  '65% Active',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.green,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildJourneyStep(
            '1',
            'Variables & Data Types',
            'Completed • Basic quiz cleared',
            AppColors.green,
            true,
          ),
          _buildRoadmapLine(AppColors.green),
          _buildJourneyStep(
            '2',
            'Control Flows & Functions',
            'In Progress • 4 Challenges left',
            AppColors.primaryBlue,
            true,
            isActive: true,
          ),
          _buildRoadmapLine(AppColors.textMuted.withValues(alpha: 0.3)),
          _buildJourneyStep(
            '3',
            'Object Oriented Dev',
            'Locked • Reach Level 5',
            AppColors.textMuted,
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildRoadmapLine(Color color) {
    return Container(
      width: 2,
      height: 18,
      margin: const EdgeInsets.only(left: 17),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  Widget _buildJourneyStep(
    String step,
    String title,
    String desc,
    Color color,
    bool done, {
    bool isActive = false,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: done ? color.withValues(alpha: 0.15) : AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? AppColors.primaryYellow : color,
              width: isActive ? 2.5 : 1.5,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primaryYellow.withValues(alpha: 0.3),
                      blurRadius: 10,
                    )
                  ]
                : null,
          ),
          child: Center(
            child: done
                ? Icon(Icons.check_rounded, color: color, size: 18)
                : Text(
                    step,
                    style: AppTextStyles.codeFont.copyWith(color: color, fontSize: 13),
                  ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.labelLarge.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 11,
                  color: isActive ? AppColors.primaryYellow : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Profile Stats and Leaderboard mockup for Screen 3
class GamifiedStatsDashboard extends StatelessWidget {
  const GamifiedStatsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 20.0,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Profile Info
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                ),
                child: const Center(
                  child: Icon(Icons.person_rounded, color: Colors.white, size: 24),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DevCodeBro #42',
                      style: AppTextStyles.labelLarge.copyWith(fontSize: 15),
                    ),
                    Text(
                      'Rank: Gold League',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 11,
                        color: AppColors.primaryYellow,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: AppColors.yellowGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bolt, color: Colors.white, size: 14),
                    const SizedBox(width: 2),
                    Text(
                      'Lv. 4',
                      style: AppTextStyles.labelLarge.copyWith(
                        fontSize: 11,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // XP progress meter
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Level Progress', style: AppTextStyles.labelMedium.copyWith(fontSize: 11)),
                  Text('750 / 1000 XP', style: AppTextStyles.labelMedium.copyWith(fontSize: 11)),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  height: 8,
                  child: LinearProgressIndicator(
                    value: 0.75,
                    backgroundColor: AppColors.surfaceLight,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0x1F94A3B8), height: 1),
          const SizedBox(height: 16),
          // Achievements list
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricCard(Icons.emoji_events_rounded, 'Streak', '12 Days', AppColors.orange),
              _buildMetricCard(Icons.military_tech_rounded, 'Badges', '8 Earned', AppColors.purple),
              _buildMetricCard(Icons.insights_rounded, 'Accuracy', '94 %', AppColors.cyan),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(fontSize: 10, color: AppColors.textMuted),
        ),
        Text(
          value,
          style: AppTextStyles.labelLarge.copyWith(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
