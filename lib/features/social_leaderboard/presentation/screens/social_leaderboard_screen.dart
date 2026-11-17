import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_gradients.dart';
import '../domain/social_models.dart';
import '../domain/social_controller.dart';
import '../presentation/widgets/leaderboard_row_widget.dart';
import '../presentation/widgets/friend_card_widget.dart';
import '../presentation/widgets/achievement_badge_widget.dart';
import '../presentation/widgets/social_stats_widget.dart';
import '../presentation/widgets/friend_request_widget.dart';
import '../presentation/widgets/share_widget.dart';
import '../presentation/widgets/filter_chips_widget.dart';

class SocialLeaderboardScreen extends StatefulWidget {
  const SocialLeaderboardScreen({super.key});

  @override
  State<SocialLeaderboardScreen> createState() => _SocialLeaderboardScreenState();
}

class _SocialLeaderboardScreenState extends State<SocialLeaderboardScreen>
    with TickerProviderStateMixin {
  late LeaderboardController _controller;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = LeaderboardController();
    _fadeController = AnimationController(
      vsync: this,
      duration: AppMotion.smooth,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();

    _controller.loadLeaderboard();
    _controller.loadFriends();
    _controller.loadSocialPosts();
    _controller.loadAchievementProgress();
    _controller.loadCurrentUserProfile();
    _controller.loadFriendRequests();
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Consumer<LeaderboardController>(
        builder: (context, controller, child) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Stack(
              children: [
                const GradientBackground(),
                SafeArea(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        _buildHeader(controller),
                        _buildTabBar(),
                        Expanded(
                          child: _buildTabContent(controller),
                        ),
                      ],
                    ),
                  ),
                ),
                if (controller.isLoading)
                  const LoadingOverlay(),
                if (controller.errorMessage != null)
                  ErrorBanner(
                    message: controller.errorMessage!,
                    onDismiss: () => controller.setError(null),
                  ),
              ],
            ),
            floatingActionButton: _tabIndex == 0
                ? FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ShareScreen(),
                        ),
                      );
                    },
                    backgroundColor: AppColors.primaryBlue,
                    icon: const Icon(Icons.share_rounded, color: Colors.white),
                    label: const Text(
                      'Share Progress',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }

  Widget _buildHeader(LeaderboardController controller) {
    final user = controller.currentUser;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: AppGradients.primary,
                  borderRadius: AppRadius.circular(AppRadius.md),
                  boxShadow: [
                    AppGradients.glow(AppColors.primaryBlue, blurRadius: 12),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.leaderboard_rounded, color: Colors.white, size: 24),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.circular(AppRadius.xxl),
                  border: Border.all(color: AppColors.cardBorder, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_fire_department_rounded, color: AppColors.primaryOrange, size: 16),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '${user.streak} Day Streak',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primaryOrange,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
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
                    user.avatar,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
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
                      user.name,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
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
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'Lv.${user.level}',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.primaryYellow,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.cardBorder, width: 1),
                ),
                child: Column(
                  children: [
                    Text(
                      '${user.xp}',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.primaryYellow,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'XP',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          LinearProgressIndicator(
            value: user.levelProgress,
            minHeight: 8,
            backgroundColor: AppColors.cardBorder,
            valueColor: const AlwaysStoppedAnimation(AppColors.primaryBlue),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    final tabs = ['Leaderboard', 'Friends', 'Activity', 'Badges'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          TabBar(
            controller: TabController(length: tabs.length, vsync: this),
            isScrollable: true,
            indicatorColor: AppColors.primaryBlue,
            labelColor: AppColors.primaryBlue,
            unselectedLabelColor: AppColors.textMuted,
            tabs: tabs.map((t) => Tab(text: t)).toList(),
            onTap: (index) => setState(() => _tabIndex = index),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(LeaderboardController controller) {
    switch (_tabIndex) {
      case 0:
        return _buildLeaderboardTab(controller);
      case 1:
        return _buildFriendsTab(controller);
      case 2:
        return _buildActivityTab(controller);
      case 3:
        return _buildBadgesTab(controller);
      default:
        return _buildLeaderboardTab(controller);
    }
  }

  Widget _buildLeaderboardTab(LeaderboardController controller) {
    return Column(
      children: [
        _buildFilterBar(controller),
        Expanded(
          child: controller.isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primaryBlue))
              : RefreshIndicator(
                  onRefresh: () async => controller.loadLeaderboard(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: controller.filteredEntries.length,
                    itemBuilder: (context, index) {
                      return LeaderboardRowWidget(
                        entry: controller.filteredEntries[index],
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildFilterBar(LeaderboardController controller) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          FilterChipsWidget(
            periods: LeaderboardFilter.periods,
            scopes: LeaderboardFilter.scopes,
            sortBy: LeaderboardFilter.sortBy,
            currentPeriod: controller.filter.period,
            currentScope: controller.filter.scope,
            currentSortBy: controller.filter.sortBy,
            onPeriodChanged: controller.setPeriod,
            onScopeChanged: controller.setScope,
            onSortByChanged: controller.setSortBy,
          ),
          const SizedBox(height: AppSpacing.md),
          if (controller.currentUserEntry != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.1),
                borderRadius: AppRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.3), width: 1),
              ),
              child: Row(
                children: [
                  const Icon(Icons.person_rounded, color: AppColors.primaryBlue, size: 20),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Position',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rank #${controller.currentUserEntry!.rank}',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: AppRadius.circular(AppRadius.xxl),
                    ),
                    child: Text(
                      '#${controller.currentUserEntry!.rank}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFriendsTab(LeaderboardController controller) {
    return Column(
      children: [
        _buildFriendStats(controller),
        Expanded(
          child: controller.isLoadingFriends
              ? const Center(child: CircularProgressIndicator(color: AppColors.primaryBlue))
              : RefreshIndicator(
                  onRefresh: () async => controller.loadFriends(),
                  child: Column(
                    children: [
                      _buildFriendRequestsSection(controller),
                      const SizedBox(height: AppSpacing.lg),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          itemCount: controller.friends.length,
                          itemBuilder: (context, index) {
                            return FriendCardWidget(
                              friend: controller.friends[index],
                              onRemove: () => controller.removeFriend(controller.friends[index].id),
                              onMessage: () {},
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildFriendStats(LeaderboardController controller) {
    final stats = controller.socialStats;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(bottom: BorderSide(color: AppColors.cardBorder, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: Icons.people_rounded,
              label: 'Total Friends',
              value: '${stats?.totalFriends ?? 0}',
              color: AppColors.primaryBlue,
            ),
          ),
          Expanded(
            child: _buildStatItem(
              icon: Icons.circle_rounded,
              label: 'Online Now',
              value: '${stats?.onlineFriends ?? 0}',
              color: AppColors.primaryGreen,
            ),
          ),
          Expanded(
            child: _buildStatItem(
              icon: Icons.pending_actions_rounded,
              label: 'Pending Requests',
              value: '${stats?.pendingRequests ?? 0}',
              color: AppColors.primaryYellow,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Center(child: Icon(icon, color: color, size: 16)),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildFriendRequestsSection(LeaderboardController controller) {
    if (controller.friendRequests.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Friend Requests',
                style: AppTextStyles.titleMedium.copyWith(fontSize: 17),
              ),
              Text(
                '${controller.pendingFriendRequests} new',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...controller.friendRequests.take(3).map((request) {
            return FriendRequestWidget(
              request: request,
              onAccept: () => controller.acceptFriendRequest(request.id),
              onReject: () => controller.rejectFriendRequest(request.id),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildActivityTab(LeaderboardController controller) {
    return RefreshIndicator(
      onRefresh: () async => controller.loadSocialPosts(),
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: controller.socialPosts.length,
        itemBuilder: (context, index) {
          return SocialPostWidget(
            post: controller.socialPosts[index],
            onLike: () => controller.toggleLikePost(controller.socialPosts[index].id),
            onComment: () {},
          );
        },
      ),
    );
  }

  Widget _buildBadgesTab(LeaderboardController controller) {
    return Column(
      children: [
        _buildBadgesProgressHeader(controller),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.9,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
            ),
            itemCount: controller.achievementProgress.length,
            itemBuilder: (context, index) {
              return AchievementBadgeWidget(
                progress: controller.achievementProgress[index],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBadgesProgressHeader(LeaderboardController controller) {
    final earned = controller.achievementProgress.where((a) => a.isUnlocked).length;
    final total = controller.achievementProgress.length;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(bottom: BorderSide(color: AppColors.cardBorder, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Achievements',
                style: AppTextStyles.titleMedium.copyWith(fontSize: 18),
              ),
              Text(
                '$earned / $total',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          LinearProgressIndicator(
            value: earned / total.clamp(1, total),
            minHeight: 8,
            backgroundColor: AppColors.cardBorder,
            valueColor: const AlwaysStoppedAnimation(AppColors.primaryYellow),
          ),
        ],
      ),
    );
  }
}

class SocialPostWidget extends StatelessWidget {
  final SocialPost post;
  final VoidCallback onLike;
  final VoidCallback onComment;

  const SocialPostWidget({
    super.key,
    required this.post,
    required this.onLike,
    required this.onComment,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: AppGradients.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    post.userAvatar,
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
                      post.userName,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      _formatTime(post.createdAt),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            post.content,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          if (post.imageUrl != null) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.cardBorder.withValues(alpha: 0.5),
                borderRadius: AppRadius.circular(AppRadius.lg),
              ),
              child: const Center(
                child: Icon(Icons.image_rounded, color: AppColors.textMuted, size: 40),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              GestureDetector(
                onTap: onLike,
                child: Row(
                  children: [
                    Icon(
                      post.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: post.isLiked ? AppColors.pink : AppColors.textMuted,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '${post.likes}',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              GestureDetector(
                onTap: onComment,
                child: Row(
                  children: [
                    const Icon(Icons.comment_rounded, color: AppColors.textMuted, size: 20),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '${post.comments}',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Share',
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF070A0F), Color(0xFF0C111A), Color(0xFF080D14)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryBlue,
          strokeWidth: 3,
        ),
      ),
    );
  }
}

class ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onDismiss;

  const ErrorBanner({
    super.key,
    required this.message,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 60,
      left: AppSpacing.lg,
      right: AppSpacing.lg,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.pink.withValues(alpha: 0.15),
          borderRadius: AppRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.pink.withValues(alpha: 0.3), width: 1),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: AppColors.pink, size: 20),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.pink,
                  fontSize: 13,
                ),
              ),
            ),
            GestureDetector(
              onTap: onDismiss,
              child: const Icon(Icons.close_rounded, color: AppColors.pink, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class ShareScreen extends StatelessWidget {
  const ShareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Share Progress'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: false,
      ),
      body: Center(
        child: Column(
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
              child: const Center(
                child: Icon(Icons.share_rounded, color: Colors.white, size: 56),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'Share Your Progress',
              style: AppTextStyles.displayMedium.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Show off your achievements to friends and challenge them to catch up!',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),
            ...SocialDataService.shareMessages.map((message) {
              return Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.circular(AppRadius.lg),
                  border: Border.all(color: AppColors.cardBorder, width: 1),
                ),
                child: Row(
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
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.content_copy_rounded, color: AppColors.textMuted),
                    ),
                  ],
                ),
              );
            }).toList(),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: PremiumShareButton(
                text: 'Share to Social Media',
                onPressed: () {},
                gradient: AppGradients.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
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
