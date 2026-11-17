import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_gradients.dart';
import '../../ui_components/widgets/ui_component_library.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  String _tab = 'Weekly';

  @override
  Widget build(BuildContext context) {
    final entries = _tab == 'Weekly' ? _weeklyEntries : _allTimeEntries;
    final currentUser = entries.firstWhere((e) => e['isCurrentUser'] ?? false);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        children: [
          _buildTabs(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                return LeaderboardRow(entry: entries[index]);
              },
            ),
          ),
          _buildCurrentUserBar(currentUser),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    final tabs = ['Weekly', 'All-time', 'Friends'];
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isActive = _tab == tabs[i];
          return GestureDetector(
            onTap: () => setState(() => _tab = tabs[i]),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              margin: const EdgeInsets.only(right: AppSpacing.xxl),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: isActive ? AppColors.primaryBlue : Colors.transparent, width: 2)),
              ),
              child: Text(tabs[i], style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w700, color: isActive ? AppColors.primaryBlue : AppColors.textSecondary)),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentUserBar(Map<String, dynamic> user) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      color: AppColors.surface,
      child: Row(
        children: [
          _buildAvatar(user['avatar']),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(user['name'], style: AppTextStyles.titleMedium.copyWith(fontSize: 16)),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withValues(alpha: 0.15),
                        borderRadius: AppRadius.circular(AppRadius.xxl),
                        border: Border.all(color: AppColors.primaryBlue, width: 1),
                      ),
                      child: const Text('YOU', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w800, fontSize: 10)),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text('Rank #${user['rank']}  •  Level ${user['level']}  •  ${user['xp']} XP', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text('#${user['rank']}', style: AppTextStyles.titleLarge.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _buildAvatar(String avatar) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: AppGradients.primary,
        shape: BoxShape.circle,
      ),
      child: Center(child: Text(avatar, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16))),
    );
  }

  static List<Map<String, dynamic>> get _weeklyEntries => [
    {'name': 'Alex Rivera', 'avatar': 'AR', 'level': 12, 'xp': 18400, 'rank': 1, 'isCurrentUser': false},
    {'name': 'Sam Chen', 'avatar': 'SC', 'level': 11, 'xp': 16200, 'rank': 2, 'isCurrentUser': false},
    {'name': 'Jordan Lee', 'avatar': 'JL', 'level': 10, 'xp': 14800, 'rank': 3, 'isCurrentUser': false},
    {'name': 'Taylor Kim', 'avatar': 'TK', 'level': 9, 'xp': 12400, 'rank': 4, 'isCurrentUser': false},
    {'name': 'Morgan Davis', 'avatar': 'MD', 'level': 8, 'xp': 11100, 'rank': 5, 'isCurrentUser': false},
    {'name': 'You', 'avatar': 'YU', 'level': 7, 'xp': 8900, 'rank': 42, 'isCurrentUser': true},
    {'name': 'Casey Wu', 'avatar': 'CW', 'level': 6, 'xp': 7200, 'rank': 7, 'isCurrentUser': false},
    {'name': 'Riley Ortiz', 'avatar': 'RO', 'level': 6, 'xp': 6900, 'rank': 8, 'isCurrentUser': false},
  ];

  static List<Map<String, dynamic>> get _allTimeEntries => [
    {'name': 'Alex Rivera', 'avatar': 'AR', 'level': 18, 'xp': 45000, 'rank': 1, 'isCurrentUser': false},
    {'name': 'Sam Chen', 'avatar': 'SC', 'level': 17, 'xp': 41200, 'rank': 2, 'isCurrentUser': false},
    {'name': 'Jordan Lee', 'avatar': 'JL', 'level': 16, 'xp': 38900, 'rank': 3, 'isCurrentUser': false},
    {'name': 'You', 'avatar': 'YU', 'level': 14, 'xp': 31500, 'rank': 4, 'isCurrentUser': true},
    {'name': 'Taylor Kim', 'avatar': 'TK', 'level': 13, 'xp': 29800, 'rank': 5, 'isCurrentUser': false},
  ];
}

class LeaderboardRow extends StatelessWidget {
  final Map<String, dynamic> entry;

  const LeaderboardRow({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final isCurrent = entry['isCurrentUser'] ?? false;
    final rank = entry['rank'] as int;
    final Color rankColor = rank == 1 ? AppColors.primaryYellow : rank == 2 ? const Color(0xFFCBD5E1) : rank == 3 ? const Color(0xFFE2E8F0) : AppColors.textMuted;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isCurrent ? AppColors.primaryBlue.withValues(alpha: 0.10) : AppColors.surface,
        borderRadius: AppRadius.circular(AppRadius.xl),
        border: Border.all(color: isCurrent ? AppColors.primaryBlue : AppColors.cardBorder, width: isCurrent ? 2 : 1),
        boxShadow: [AppGradients.cardShadow()],
      ),
      child: Row(
        children: [
          _buildRank(rank, rankColor),
          const SizedBox(width: AppSpacing.md),
          _buildAvatar(entry['avatar']),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(entry['name'], style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600, color: isCurrent ? AppColors.primaryBlue : AppColors.textPrimary)),
                    ),
                    Text('Lv.${entry['level']}', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryYellow, fontWeight: FontWeight.w700, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    const Icon(Icons.bolt_rounded, color: AppColors.primaryYellow, size: 16),
                    const SizedBox(width: AppSpacing.xs),
                    Text('${entry['xp']} XP', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
          if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              decoration: BoxDecoration(color: AppColors.primaryBlue, borderRadius: AppRadius.circular(AppRadius.xxl)),
              child: const Text('YOU', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 10, letterSpacing: 0.5)),
            )
          else
            const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildRank(int rank, Color color) {
    if (rank <= 3) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.05)]),
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
        ),
        child: Center(child: Text('$rank', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14))),
      );
    }
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      child: Text('#$rank', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted, fontWeight: FontWeight.w700)),
    );
  }

  Widget _buildAvatar(String avatar) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: AppGradients.primary,
        shape: BoxShape.circle,
      ),
      child: Center(child: Text(avatar, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16))),
    );
  }
}
