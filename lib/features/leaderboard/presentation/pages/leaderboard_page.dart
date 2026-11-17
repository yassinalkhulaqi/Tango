import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_shadows.dart';
import '../domain/leaderboard_model.dart';
import 'leaderboard_row.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  String _tab = 'Weekly';

  static final List<LeaderboardEntry> _weekly = [
    LeaderboardEntry(id: '1', name: 'Alex Rivera', avatar: 'AR', level: 12, xp: 18400, rank: 1),
    LeaderboardEntry(id: '2', name: 'Sam Chen', avatar: 'SC', level: 11, xp: 16200, rank: 2),
    LeaderboardEntry(id: '3', name: 'Jordan Lee', avatar: 'JL', level: 10, xp: 14800, rank: 3),
    LeaderboardEntry(id: '4', name: 'Taylor Kim', avatar: 'TK', level: 9, xp: 12400, rank: 4),
    LeaderboardEntry(id: '5', name: 'Morgan Davis', avatar: 'MD', level: 8, xp: 11100, rank: 5),
    LeaderboardEntry(id: 'you', name: 'You', avatar: 'YU', level: 7, xp: 8900, rank: 42, isCurrentUser: true),
    LeaderboardEntry(id: '7', name: 'Casey Wu', avatar: 'CW', level: 6, xp: 7200, rank: 7),
    LeaderboardEntry(id: '8', name: 'Riley Ortiz', avatar: 'RO', level: 6, xp: 6900, rank: 8),
  ];

  static final List<LeaderboardEntry> _allTime = [
    LeaderboardEntry(id: '1', name: 'Alex Rivera', avatar: 'AR', level: 18, xp: 45000, rank: 1),
    LeaderboardEntry(id: '2', name: 'Sam Chen', avatar: 'SC', level: 17, xp: 41200, rank: 2),
    LeaderboardEntry(id: '3', name: 'Jordan Lee', avatar: 'JL', level: 16, xp: 38900, rank: 3),
    LeaderboardEntry(id: '4', name: 'You', avatar: 'YU', level: 14, xp: 31500, rank: 4, isCurrentUser: true),
    LeaderboardEntry(id: '5', name: 'Taylor Kim', avatar: 'TK', level: 13, xp: 29800, rank: 5),
  ];

  List<LeaderboardEntry> get _entries => _tab == 'Weekly' ? _weekly : _allTime;

  @override
  Widget build(BuildContext context) {
    final currentUser = _entries.firstWhere((e) => e.isCurrentUser)!;

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
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                return LeaderboardRow(entry: _entries[index]);
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
                border: Border(
                  bottom: BorderSide(
                    color: isActive ? AppColors.primaryBlue : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                tabs[i],
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isActive ? AppColors.primaryBlue : AppColors.textSecondary,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentUserBar(LeaderboardEntry user) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      color: AppColors.surface,
      child: Row(
        children: [
          _buildAvatar(user.avatar),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user.name,
                      style: AppTextStyles.titleMedium.copyWith(fontSize: 16),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withValues(alpha: 0.15),
                        borderRadius: AppRadius.circular(AppRadius.xxl),
                        border: Border.all(color: AppColors.primaryBlue, width: 1),
                      ),
                      child: const Text(
                        'YOU',
                        style: TextStyle(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Rank #${user.rank}  •  Level ${user.level}  •  ${user.xp.toStringAsFixed(0)} XP',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Text(
            '#${user.rank}',
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
