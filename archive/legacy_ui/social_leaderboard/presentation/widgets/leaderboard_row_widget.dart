import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_gradients.dart';
import '../domain/social_models.dart';

class LeaderboardRowWidget extends StatelessWidget {
  final LeaderboardEntry entry;

  const LeaderboardRowWidget({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final isCurrent = entry.isCurrentUser;
    final isFriend = entry.isFriend;
    final rank = entry.rank;
    final Color rankColor = rank == 1
        ? AppColors.primaryYellow
        : rank == 2
            ? const Color(0xFFCBD5E1)
            : rank == 3
                ? const Color(0xFFE2E8F0)
                : AppColors.textMuted;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isCurrent
            ? AppColors.primaryBlue.withValues(alpha: 0.10)
            : AppColors.surface,
        borderRadius: AppRadius.circular(AppRadius.xl),
        border: Border.all(
          color: isCurrent ? AppColors.primaryBlue : AppColors.cardBorder,
          width: isCurrent ? 2 : 1,
        ),
        boxShadow: [AppGradients.cardShadow()],
      ),
      child: Row(
        children: [
          _buildRank(rank, rankColor),
          const SizedBox(width: AppSpacing.md),
          _buildAvatar(entry.avatar),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.name,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isCurrent ? AppColors.primaryBlue : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      'Lv.${entry.level}',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primaryYellow,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(
                      Icons.local_fire_department_rounded,
                      color: AppColors.primaryOrange,
                      size: 16,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '${entry.streak} day streak',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${entry.xp.toStringAsFixed(0)} XP',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.primaryYellow,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isFriend) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.15),
                borderRadius: AppRadius.circular(AppRadius.xxl),
                border: Border.all(color: AppColors.primaryGreen, width: 1),
              ),
              child: const Text(
                'Friend',
                style: TextStyle(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
            ),
          ] else if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: AppRadius.circular(AppRadius.xxl),
              ),
              child: const Text(
                'YOU',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
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
          gradient: LinearGradient(
            colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.05)],
          ),
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
        ),
        child: Center(
          child: Text(
            '$rank',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ),
      );
    }
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      child: Text(
        '#$rank',
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.textMuted,
          fontWeight: FontWeight.w700,
        ),
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
      child: Center(
        child: Text(
          avatar,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class FriendCardWidget extends StatelessWidget {
  final Friend friend;
  final VoidCallback onRemove;
  final VoidCallback onMessage;

  const FriendCardWidget({
    super.key,
    required this.friend,
    required this.onRemove,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.cardBorder, width: 1),
        boxShadow: [AppGradients.cardShadow()],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: AppGradients.primary,
              shape: BoxShape.circle,
              boxShadow: [
                if (friend.isOnline)
                  AppGradients.glow(AppColors.primaryBlue, blurRadius: 12),
              ],
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    friend.avatar,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                ),
                if (friend.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.surface,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        friend.name,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
                      decoration: BoxDecoration(
                        color: _statusColor(friend.status).withValues(alpha: 0.15),
                        borderRadius: AppRadius.circular(AppRadius.xxl),
                        border: Border.all(
                          color: _statusColor(friend.status),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _statusLabel(friend.status),
                        style: TextStyle(
                          color: _statusColor(friend.status),
                          fontWeight: FontWeight.w700,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(
                      Icons.bolt_rounded,
                      color: AppColors.primaryYellow,
                      size: 14,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '${friend.xp.toStringAsFixed(0)} XP',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Icon(
                      Icons.local_fire_department_rounded,
                      color: AppColors.primaryOrange,
                      size: 14,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '${friend.streak} day streak',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: onMessage,
                icon: const Icon(Icons.message_rounded, color: AppColors.textMuted, size: 20),
              ),
              IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.person_remove_rounded, color: AppColors.pink, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _statusColor(FriendStatus status) {
    switch (status) {
      case FriendStatus.active:
        return AppColors.primaryGreen;
      case FriendStatus.away:
        return AppColors.primaryYellow;
      case FriendStatus.offline:
        return AppColors.textMuted;
      case FriendStatus.pending:
        return AppColors.primaryBlue;
      case FriendStatus.blocked:
        return AppColors.pink;
    }
  }

  String _statusLabel(FriendStatus status) {
    switch (status) {
      case FriendStatus.active:
        return 'Online';
      case FriendStatus.away:
        return 'Away';
      case FriendStatus.offline:
        return 'Offline';
      case FriendStatus.pending:
        return 'Pending';
      case FriendStatus.blocked:
        return 'Blocked';
    }
  }
}

class AchievementBadgeWidget extends StatelessWidget {
  final AchievementProgress progress;

  const AchievementBadgeWidget({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final isUnlocked = progress.isUnlocked;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.circular(AppRadius.xl),
        border: Border.all(
          color: isUnlocked ? progress.color : AppColors.cardBorder,
          width: isUnlocked ? 2 : 1,
        ),
        boxShadow: [AppGradients.cardShadow()],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isUnlocked
                  ? progress.color.withValues(alpha: 0.2)
                  : AppColors.cardBorder.withValues(alpha: 0.4),
              shape: BoxShape.circle,
              border: Border.all(
                color: isUnlocked ? progress.color : AppColors.textMuted,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                progress.icon,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            progress.name,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: isUnlocked ? AppColors.textPrimary : AppColors.textMuted,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            progress.description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isUnlocked ? AppColors.textSecondary : AppColors.textMuted,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: AppRadius.circular(AppRadius.md),
            child: LinearProgressIndicator(
              value: progress.progressPercent,
              minHeight: 6,
              backgroundColor: AppColors.cardBorder,
              valueColor: AlwaysStoppedAnimation(progress.color),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${progress.currentProgress} / ${progress.targetProgress}',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textMuted,
              fontSize: 10,
            ),
          ),
          if (isUnlocked) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star_rounded, color: AppColors.primaryYellow, size: 14),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '+${progress.xpReward} XP',
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

class SocialStatsWidget extends StatelessWidget {
  final SocialStats stats;

  const SocialStatsWidget({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.circular(AppRadius.xxl),
        border: Border.all(color: AppColors.cardBorder, width: 1),
        boxShadow: [AppGradients.cardShadow()],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Social Stats',
            style: AppTextStyles.titleMedium.copyWith(fontSize: 18),
          ),
          const SizedBox(height: AppSpacing.lg),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.2,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return _buildStatItem(index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(int index) {
    final items = [
      {'icon': Icons.people_rounded, 'label': 'Friends', 'value': '${stats.totalFriends}', 'color': AppColors.primaryBlue},
      {'icon': Icons.circle_rounded, 'label': 'Online', 'value': '${stats.onlineFriends}', 'color': AppColors.primaryGreen},
      {'icon': Icons.pending_actions_rounded, 'label': 'Requests', 'value': '${stats.pendingRequests}', 'color': AppColors.primaryYellow},
      {'icon': Icons.emoji_events_rounded, 'label': 'Badges', 'value': '${stats.totalBadges}', 'color': AppColors.primaryPurple},
      {'icon': Icons.star_rounded, 'label': 'Rare Badges', 'value': '${stats.rareBadges}', 'color': AppColors.primaryYellow},
      {'icon': Icons.local_fire_department_rounded, 'label': 'Rank', 'value': '#${stats.rankAmongFriends}', 'color': AppColors.primaryOrange},
    ];
    final item = items[index];
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: item['color'].withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(child: Icon(item['icon'], color: item['color'], size: 16)),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item['value'],
                  style: AppTextStyles.titleLarge.copyWith(fontSize: 18),
                ),
                Text(
                  item['label'],
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
    );
  }
}

class FriendRequestWidget extends StatelessWidget {
  final FriendRequest request;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const FriendRequestWidget({
    super.key,
    required this.request,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
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
              gradient: AppGradients.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                request.fromUserAvatar,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
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
                  request.fromUserName,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'sent you a friend request',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 36,
                child: OutlinedButton(
                  onPressed: onAccept,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryGreen,
                    side: const BorderSide(color: AppColors.primaryGreen),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.circular(AppRadius.md),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: const Text(
                    'Accept',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              SizedBox(
                height: 36,
                child: OutlinedButton(
                  onPressed: onReject,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.pink,
                    side: const BorderSide(color: AppColors.pink),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.circular(AppRadius.md),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: const Text(
                    'Reject',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ShareWidget extends StatelessWidget {
  final String message;
  final VoidCallback onShare;
  final VoidCallback onCopy;

  const ShareWidget({
    super.key,
    required this.message,
    required this.onShare,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.share_rounded, color: AppColors.primaryBlue, size: 20),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton.icon(
                    onPressed: onShare,
                    icon: const Icon(Icons.share_rounded, size: 18),
                    label: const Text('Share'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryBlue,
                      side: const BorderSide(color: AppColors.primaryBlue),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.circular(AppRadius.md),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton.icon(
                    onPressed: onCopy,
                    icon: const Icon(Icons.content_copy_rounded, size: 18),
                    label: const Text('Copy Link'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.cardBorder),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.circular(AppRadius.md),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FilterChipsWidget extends StatelessWidget {
  final List<String> periods;
  final List<String> scopes;
  final List<String> sortBy;
  final String currentPeriod;
  final String currentScope;
  final String currentSortBy;
  final ValueChanged<String> onPeriodChanged;
  final ValueChanged<String> onScopeChanged;
  final ValueChanged<String> onSortByChanged;

  const FilterChipsWidget({
    super.key,
    required this.periods,
    required this.scopes,
    required this.sortBy,
    required this.currentPeriod,
    required this.currentScope,
    required this.currentSortBy,
    required this.onPeriodChanged,
    required this.onScopeChanged,
    required this.onSortByChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFilterRow(
          label: 'Period',
          items: periods,
          currentValue: currentPeriod,
          onChanged: onPeriodChanged,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildFilterRow(
          label: 'Scope',
          items: scopes,
          currentValue: currentScope,
          onChanged: onScopeChanged,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildFilterRow(
          label: 'Sort By',
          items: sortBy,
          currentValue: currentSortBy,
          onChanged: onSortByChanged,
        ),
      ],
    );
  }

  Widget _buildFilterRow({
    required String label,
    required List<String> items,
    required String currentValue,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        SizedBox(
          height: 32,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isSelected = item == currentValue;
              return GestureDetector(
                onTap: () => onChanged(item),
                child: AnimatedContainer(
                  duration: AppMotion.fast,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                  margin: const EdgeInsets.only(right: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryBlue : AppColors.surface,
                    borderRadius: AppRadius.circular(AppRadius.xxl),
                    border: Border.all(
                      color: isSelected ? AppColors.primaryBlue : AppColors.cardBorder,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      item,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}

class PremiumShareButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final LinearGradient gradient;

  const PremiumShareButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradient = AppGradients.primary,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppMotion.fast,
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.share_rounded, color: Colors.white, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  text,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
