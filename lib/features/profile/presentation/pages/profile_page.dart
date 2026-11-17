import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_shadows.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _stats = [
    _Stat(Icons.check_circle_rounded, '48', 'Lessons', AppColors.primaryGreen),
    _Stat(Icons.local_fire_department_rounded, '12', 'Streak', AppColors.primaryOrange),
    _Stat(Icons.bolt_rounded, '12,450', 'Total XP', AppColors.primaryYellow),
    _Stat(Icons.emoji_events_rounded, '6', 'Badges', AppColors.primaryPurple),
  ];

  final _settings = [
    _SettingItem(Icons.notifications_rounded, 'Notifications', 'Get streak reminders', true),
    _SettingItem(Icons.dark_mode_rounded, 'Dark Mode', 'CodeBro is dark-only', false),
    _SettingItem(Icons.language_rounded, 'Language', 'English', false),
    _SettingItem(Icons.help_outline_rounded, 'Help & Support', 'Contact the CodeBro team', false),
  ];

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
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _stats.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemBuilder: (context, index) {
        final s = _stats[index];
        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.circular(AppRadius.xl),
            border: Border.all(color: AppColors.cardBorder, width: 1),
            boxShadow: [AppShadows.soft],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: s.color.withValues(alpha: 0.15),
                  borderRadius: AppRadius.circular(AppRadius.md),
                ),
                child: Center(
                  child: Icon(s.icon, color: s.color, size: 22),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.value,
                    style: AppTextStyles.titleLarge.copyWith(fontSize: 20),
                  ),
                  Text(
                    s.label,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ],
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
              'Level 7 • Senior',
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
            value: 8900 / 12000,
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

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: AppTextStyles.titleMedium.copyWith(fontSize: 17),
        ),
        const SizedBox(height: AppSpacing.md),
        ..._settings.map((s) => _SettingRow(setting: s)),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/auth');
            },
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

class _Stat {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  _Stat(this.icon, this.value, this.label, this.color);
}

class _SettingItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool enabled;
  _SettingItem(this.icon, this.title, this.subtitle, this.enabled);
}

class _SettingRow extends StatelessWidget {
  final _SettingItem setting;
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
        leading: Icon(setting.icon, color: AppColors.textSecondary, size: 22),
        title: Text(
          setting.title,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          setting.subtitle,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted, fontSize: 12),
        ),
        trailing: setting.enabled
            ? Switch(
                value: true,
                onChanged: (_) {},
                activeThumbColor: AppColors.primaryBlue,
              )
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
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [AppShadows.glow(AppColors.primaryBlue, blurRadius: 40)],
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
                  border: Border.all(color: AppColors.primaryBlue, width: 1),
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
