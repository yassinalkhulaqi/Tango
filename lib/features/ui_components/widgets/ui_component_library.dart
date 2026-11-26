import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_gradients.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderWidth;
  final Color borderColor;
  final double blurRadius;
  final Offset shadowOffset;
  final BorderRadiusGeometry? borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.borderWidth = 1.0,
    this.borderColor = AppColors.cardBorder,
    this.blurRadius = 16,
    this.shadowOffset = Offset.zero,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        borderRadius: borderRadius ?? AppRadius.circular(AppRadius.xl),
        border: Border.all(
          color: borderColor.withValues(alpha: 0.2),
          width: borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: blurRadius,
            offset: shadowOffset,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? AppRadius.circular(AppRadius.xl),
        child: child,
      ),
    );
  }
}

class XPProgressBar extends StatelessWidget {
  final double value;
  final double height;
  final Color trackColor;
  final LinearGradient gradient;
  final bool showGlow;

  const XPProgressBar({
    super.key,
    required this.value,
    this.height = 8,
    this.trackColor = AppColors.cardBorder,
    this.gradient = AppGradients.primary,
    this.showGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.circular(AppRadius.md),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        minHeight: height,
        backgroundColor: trackColor,
        valueColor: AlwaysStoppedAnimation(AppColors.primaryBlue),
      ),
    );
  }
}

class StreakIndicator extends StatelessWidget {
  final int streak;
  final Color flameColor;
  final bool animated;

  const StreakIndicator({
    super.key,
    required this.streak,
    this.flameColor = AppColors.primaryOrange,
    this.animated = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        gradient: AppGradients.streak,
        borderRadius: AppRadius.circular(AppRadius.xxl),
        boxShadow: [AppGradients.glow(flameColor, blurRadius: 16)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: AppMotion.snappy,
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '$streak Day Streak',
            style: AppTextStyles.labelLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class AchievementCard extends StatelessWidget {
  final String name;
  final String description;
  final String icon;
  final Color color;
  final bool unlocked;
  final int xpReward;
  final DateTime? unlockedAt;

  const AchievementCard({
    super.key,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.unlocked,
    this.xpReward = 200,
    this.unlockedAt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.circular(AppRadius.xl),
        border: Border.all(
          color: unlocked ? color : AppColors.cardBorder,
          width: unlocked ? 2 : 1,
        ),
        boxShadow: [AppGradients.cardShadow()],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: unlocked
                  ? color.withValues(alpha: 0.2)
                  : AppColors.cardBorder.withValues(alpha: 0.4),
              shape: BoxShape.circle,
              border: Border.all(
                color: unlocked ? color : AppColors.textMuted,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            name,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: unlocked ? AppColors.textPrimary : AppColors.textMuted,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: unlocked ? AppColors.textSecondary : AppColors.textMuted,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (unlocked) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: AppColors.primaryYellow,
                  size: 16,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '+$xpReward XP',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primaryYellow,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String title;
  final String category;
  final int lessonCount;
  final double progress;
  final bool isLocked;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const CourseCard({
    super.key,
    required this.title,
    required this.category,
    required this.lessonCount,
    required this.progress,
    this.isLocked = false,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Container(
        width: 170,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.circular(AppRadius.xl),
          border: Border.all(
            color: isLocked ? AppColors.cardBorder : AppColors.divider,
            width: 1,
          ),
          boxShadow: [AppGradients.cardShadow()],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: AppRadius.circular(AppRadius.xl),
                      gradient: isLocked
                          ? const LinearGradient(
                              colors: [Color(0xFF1E293B), Color(0xFF0F141C)],
                            )
                          : LinearGradient(
                              colors: [
                                color.withValues(alpha: 0.15),
                                AppColors.surface,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                    ),
                    child: Center(
                      child: Icon(
                        icon,
                        size: 40,
                        color: isLocked ? AppColors.textMuted : color,
                      ),
                    ),
                  ),
                  if (isLocked)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        borderRadius: AppRadius.circular(AppRadius.xl),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.lock_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryYellow,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(14),
                          topLeft: Radius.circular(14),
                        ),
                      ),
                      child: Text(
                        '${(progress * 100).round()}%',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.background,
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isLocked
                          ? AppColors.textMuted
                          : AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '$lessonCount lessons',
                    style: AppTextStyles.labelMedium.copyWith(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}

class LessonItem extends StatelessWidget {
  final String title;
  final String description;
  final int index;
  final bool isCompleted;
  final bool isLocked;
  final VoidCallback onTap;

  const LessonItem({
    super.key,
    required this.title,
    required this.description,
    required this.index,
    this.isCompleted = false,
    this.isLocked = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: isLocked ? AppColors.surface : AppColors.surfaceLight,
        borderRadius: AppRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isLocked ? AppColors.cardBorder : AppColors.divider,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppRadius.circular(AppRadius.lg),
          onTap: isLocked ? null : onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.primaryGreen
                        : isLocked
                        ? AppColors.cardBorder
                        : AppColors.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ),
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
                          color: isLocked
                              ? AppColors.textMuted
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        description,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (isCompleted)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.primaryGreen,
                    size: 20,
                  )
                else if (isLocked)
                  const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.textMuted,
                    size: 20,
                  )
                else
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.primaryBlue,
                    size: 16,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StatsCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const StatsCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.cardBorder, width: 1),
        boxShadow: [AppGradients.softShadow()],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: AppRadius.circular(AppRadius.md),
            ),
            child: Center(child: Icon(icon, color: color, size: 22)),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: AppTextStyles.titleLarge.copyWith(fontSize: 20),
              ),
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final int lessonCount;
  final bool isLocked;

  const CategoryCard({
    super.key,
    required this.name,
    required this.icon,
    required this.color,
    required this.lessonCount,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 36,
                  color: isLocked ? AppColors.textMuted : color,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              children: [
                Text(
                  name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '$lessonCount lessons',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChallengeCard extends StatelessWidget {
  final String title;
  final String description;
  final int xpReward;
  final Color color;

  const ChallengeCard({
    super.key,
    required this.title,
    required this.description,
    required this.xpReward,
    this.color = AppColors.primaryYellow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.2), AppColors.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.circular(AppRadius.xxl),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        boxShadow: [AppGradients.glow(color, blurRadius: 16)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flag_rounded, color: color, size: 20),
              const SizedBox(width: AppSpacing.sm),
              const Spacer(),
              Text(
                '+$xpReward XP',
                style: AppTextStyles.labelLarge.copyWith(
                  color: color,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(title, style: AppTextStyles.titleMedium.copyWith(fontSize: 18)),
          const SizedBox(height: AppSpacing.sm),
          Text(
            description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class DailyQuestsCard extends StatelessWidget {
  final List<Map<String, dynamic>> quests;

  const DailyQuestsCard({super.key, required this.quests});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(quests.length, (index) {
          final q = quests[index];
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: AppRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.cardBorder, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.15),
                    borderRadius: AppRadius.circular(AppRadius.md),
                  ),
                  child: Center(
                    child: Icon(
                      q['icon'],
                      color: AppColors.primaryBlue,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        q['title'],
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '+${q['xp']} XP',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Checkbox(
                  value: q['completed'] ?? false,
                  onChanged: null,
                  activeColor: AppColors.primaryGreen,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class LessonPathWidget extends StatelessWidget {
  final List<Map<String, dynamic>> path;

  const LessonPathWidget({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: path.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final step = path[index];
          final isCompleted = step['completed'] ?? false;
          final isCurrent = step['current'] ?? false;
          return Container(
            width: 90,
            decoration: BoxDecoration(
              color: isCurrent
                  ? AppColors.primaryBlue.withValues(alpha: 0.2)
                  : AppColors.surface,
              borderRadius: AppRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.cardBorder, width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.primaryGreen
                        : isCurrent
                        ? AppColors.primaryBlue
                        : AppColors.cardBorder,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  step['title'],
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class UserHeader extends StatelessWidget {
  final String name;
  final String level;
  final String avatar;

  const UserHeader({
    super.key,
    required this.name,
    required this.level,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: AppGradients.primary,
            shape: BoxShape.circle,
            boxShadow: [
              AppGradients.glow(AppColors.primaryBlue, blurRadius: 20),
            ],
          ),
          child: Center(
            child: Text(
              avatar,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: AppTextStyles.titleMedium.copyWith(fontSize: 17)),
            Text(
              level,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadiusGeometry borderRadius;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: borderRadius,
      ),
      child: const ShimmerEffect(),
    );
  }
}

class ShimmerEffect extends StatefulWidget {
  const ShimmerEffect({super.key});

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: LinearGradient(
            colors: [
              AppColors.surfaceLight,
              AppColors.surface.withValues(alpha: 0.5),
              AppColors.surfaceLight,
            ],
            stops: [0.1, 0.3, 0.5],
            begin: Alignment(-1.0 + _controller.value * 2, 0),
            end: Alignment(1.0 + _controller.value * 2, 0),
          ).createShader(const Rect.fromLTWH(0, 0, 200, 100)),
        );
      },
    );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String ctaText;
  final VoidCallback onCtaPressed;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.ctaText,
    required this.onCtaPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.cardBorder.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(icon, color: AppColors.textMuted, size: 40),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(title, style: AppTextStyles.titleMedium.copyWith(fontSize: 20)),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxl),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: PremiumButton(text: ctaText, onPressed: onCtaPressed),
          ),
        ],
      ),
    );
  }
}

class ErrorState extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onRetry;

  const ErrorState({
    super.key,
    required this.title,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.pink,
            size: 48,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(title, style: AppTextStyles.titleMedium.copyWith(fontSize: 20)),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxl),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: PremiumButton(text: 'Try Again', onPressed: onRetry),
          ),
        ],
      ),
    );
  }
}
