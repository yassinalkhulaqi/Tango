import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../widgets/dashboard_tiles.dart';

/// Dashboard shell composing greeting, quick stats and section placeholders.
class DashboardV3Page extends StatelessWidget {
  final String greeting;
  final String name;
  final String level;
  final String avatar;
  final int lessons;
  final int streak;
  final int xp;
  final int badges;

  const DashboardV3Page({
    super.key,
    required this.greeting,
    required this.name,
    required this.level,
    required this.avatar,
    this.lessons = 48,
    this.streak = 12,
    this.xp = 2450,
    this.badges = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashboardGreeting(greeting: greeting, name: name, level: level, avatar: avatar),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  QuickStatTile(icon: Icons.check_circle_rounded, value: '$lessons', label: 'Lessons', color: AppColors.primaryGreen),
                  const SizedBox(width: AppSpacing.sm),
                  QuickStatTile(icon: Icons.local_fire_department_rounded, value: '$streak', label: 'Streak', color: AppColors.primaryOrange),
                  const SizedBox(width: AppSpacing.sm),
                  QuickStatTile(icon: Icons.bolt_rounded, value: '$xp', label: 'Total XP', color: AppColors.primaryYellow),
                  const SizedBox(width: AppSpacing.sm),
                  QuickStatTile(icon: Icons.emoji_events_rounded, value: '$badges', label: 'Badges', color: AppColors.primaryPurple),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
