import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_gradients.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildHeader(),
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            sliver: SliverToBoxAdapter(child: _buildStatsGrid()),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            sliver: SliverToBoxAdapter(child: _buildXPSection()),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            sliver: SliverToBoxAdapter(child: _buildAchievementsSection()),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            sliver: SliverToBoxAdapter(child: _buildSettingsSection()),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: AppSpacing.huge)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _ProfileHeaderDelegate(),
    );
  }

  Widget _buildStatsGrid() {
    final stats = [
      {'icon': Icons.check_circle_rounded, 'value': '48', 'label': 'Lessons', 'color': AppColors.primaryGreen},
      {'icon': Icons.local_fire_department_rounded, 'value': '12', 'label': 'Streak', 'color': AppColors.primaryOrange},
      {'icon': Icons.bolt_rounded, 'value': '12,450', 'label': 'Total XP', 'color': AppColors.primaryYellow},
      {'icon': Icons.emoji_events_rounded, 'value': '6', 'label': 'Badges', 'color': AppColors.primaryPurple},
      {'icon': Icons.quiz_rounded, 'value': '24', 'label': 'Quizzes', 'color': AppColors.primaryCyan},
      {'icon': Icons.code_rounded, 'value': '12', 'label': 'Challenges', 'color': AppColors.primaryGreen},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stats.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.4,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemBuilder: (context, index) {
        final s = stats[index];
        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.circular(AppRadius.xl),
            border: Border.all(color: AppColors.cardBorder, width: 1),
            boxShadow: [AppGradients.cardShadow()],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: s['color'].withValues(alpha: 0.15),
                  borderRadius: AppRadius.circular(AppRadius.md),
                ),
                child: Center(
                  child: Icon(s['icon'] as IconData, color: s['color'], size: 18),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                s['value'] as String,
                style: AppTextStyles.titleLarge.copyWith(fontSize: 20),
              ),
              Text(
                s['label'] as String,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, fontSize: 11),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildXPSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Level 7 • Senior Developer',
              style: AppTextStyles.titleMedium.copyWith(fontSize: 17),
            ),
            Text(
              '8,900 / 12,000 XP',
              style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ClipRRect(
          borderRadius: AppRadius.circular(AppRadius.md),
          child: LinearProgressIndicator(
            value: 0.74,
            minHeight: 10,
            backgroundColor: AppColors.cardBorder,
            valueColor: const AlwaysStoppedAnimation(AppColors.primaryBlue),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Next level: Architect — 3,100 XP to go',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _buildAchievementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Achievements',
              style: AppTextStyles.titleMedium.copyWith(fontSize: 17),
            ),
            Text(
              'View All',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            itemBuilder: (context, index) {
              final achievements = [
                {'name': 'First Commit', 'icon': '🚀', 'color': AppColors.primaryBlue, 'unlocked': true},
                {'name': 'Bug Squasher', 'icon': '🐛', 'color': AppColors.primaryGreen, 'unlocked': false},
                {'name': 'Week Warrior', 'icon': '🔥', 'color': AppColors.primaryOrange, 'unlocked': false},
                {'name': 'Polyglot', 'icon': '🌐', 'color': AppColors.primaryPurple, 'unlocked': false},
                {'name': 'Speed Runner', 'icon': '⚡', 'color': AppColors.primaryYellow, 'unlocked': false},
                {'name': 'Monthly Master', 'icon': '🏆', 'color': AppColors.primaryCyan, 'unlocked': false},
              ];
              final a = achievements[index];
              return Container(
                width: 100,
                margin: const EdgeInsets.only(right: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.circular(AppRadius.xl),
                  border: Border.all(
                    color: a['unlocked'] ? a['color'] : AppColors.cardBorder,
                    width: a['unlocked'] ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: a['unlocked'] ? a['color'].withValues(alpha: 0.2) : AppColors.cardBorder.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: a['unlocked'] ? a['color'] : AppColors.textMuted,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(a['icon'] as String, style: const TextStyle(fontSize: 24)),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      a['name'] as String,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: a['unlocked'] ? AppColors.textPrimary : AppColors.textMuted,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    final settings = [
      {'icon': Icons.notifications_rounded, 'title': 'Notifications', 'subtitle': 'Get streak reminders', 'switch': true},
      {'icon': Icons.dark_mode_rounded, 'title': 'Dark Mode', 'subtitle': 'CodeBro is dark-only', 'switch': false},
      {'icon': Icons.language_rounded, 'title': 'Language', 'subtitle': 'English', 'switch': false},
      {'icon': Icons.help_outline_rounded, 'title': 'Help & Support', 'subtitle': 'Contact the CodeBro team', 'switch': false},
      {'icon': Icons.logout_rounded, 'title': 'Sign Out', 'subtitle': 'Log out of your account', 'switch': false},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: AppTextStyles.titleMedium.copyWith(fontSize: 17),
        ),
        const SizedBox(height: AppSpacing.md),
        ...settings.map((s) => _SettingRow(setting: s)),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.pink,
              side: const BorderSide(color: AppColors.pink, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.circular(AppRadius.xl),
              ),
            ),
            child: const Text(
              'Sign out',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}

class _SettingRow extends StatelessWidget {
  final Map<String, dynamic> setting;
  const _SettingRow({required this.setting});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        leading: Icon(setting['icon'], color: AppColors.textSecondary, size: 22),
        title: Text(
          setting['title'],
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        subtitle: Text(
          setting['subtitle'],
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted, fontSize: 12),
        ),
        trailing: setting['switch']
            ? Switch(value: true, onChanged: (_) {}, activeColor: AppColors.primaryBlue)
            : const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
      ),
    );
  }
}

class _ProfileHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xxl),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF070A0F), Color(0xFF0C111A)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              gradient: AppGradients.primary,
              shape: BoxShape.circle,
              boxShadow: [AppGradients.glow(AppColors.primaryBlue, blurRadius: 40)],
            ),
            child: const Center(
              child: Text(
                'YU',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 32,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Alex Rivera',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Level 7 • Senior Developer',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.15),
                  borderRadius: AppRadius.circular(AppRadius.xxl),
                  border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.3), width: 1),
                ),
                child: const Text(
                  'Rank #42',
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 260;
  @override
  double get minExtent => 200;
  @override
  bool shouldRebuild(covariant _ProfileHeaderDelegate old) => false;
}
