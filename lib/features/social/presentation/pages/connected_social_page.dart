import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/ui/app_states.dart';
import '../data/social_repository.dart';
import '../data/social_dto.dart';

class ConnectedSocialPage extends ConsumerWidget {
  const ConnectedSocialPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(socialPostsProvider);
    final friendsAsync = ref.watch(socialFriendsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  'Community',
                  style: AppTextStyles.displayMedium.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const TabBar(
                tabs: [
                  Tab(text: 'Activity'),
                  Tab(text: 'Friends'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    postsAsync.when(
                      loading: () => const AppLoadingView(),
                      error: (_, __) => AppErrorView(
                        message: 'Could not load activity.',
                        onRetry: () => ref.invalidate(socialPostsProvider),
                      ),
                      data: (posts) => posts.isEmpty
                          ? const AppEmptyView(
                              title: 'No activity yet',
                              message: 'Share your first achievement!',
                            )
                          : ListView.builder(
                              itemCount: posts.length,
                              itemBuilder: (context, index) =>
                                  _PostTile(post: posts[index]),
                            ),
                    ),
                    friendsAsync.when(
                      loading: () => const AppLoadingView(),
                      error: (_, __) => AppErrorView(
                        message: 'Could not load friends.',
                        onRetry: () => ref.invalidate(socialFriendsProvider),
                      ),
                      data: (friends) => friends.isEmpty
                          ? const AppEmptyView(
                              title: 'No friends yet',
                              message: 'Invite a friend to compete together.',
                            )
                          : ListView.builder(
                              itemCount: friends.length,
                              itemBuilder: (context, index) =>
                                  _FriendTile(friend: friends[index]),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PostTile extends ConsumerWidget {
  const _PostTile({required this.post});

  final SocialPost post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        0,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.author.name,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(post.body, style: AppTextStyles.bodyMedium),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  post.likedByMe ? Icons.favorite : Icons.favorite_border,
                  color: post.likedByMe ? Colors.pink : AppColors.textMuted,
                  size: 20,
                ),
                onPressed: () => ref
                    .read(socialRepositoryProvider)
                    .toggleLike(post.id, post.likedByMe),
              ),
              Text('${post.likes}', style: AppTextStyles.labelSmall),
              const SizedBox(width: AppSpacing.md),
              Icon(
                Icons.comment_outlined,
                size: 18,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 4),
              Text('${post.comments}', style: AppTextStyles.labelSmall),
            ],
          ),
        ],
      ),
    );
  }
}

class _FriendTile extends StatelessWidget {
  const _FriendTile({required this.friend});

  final Friend friend;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.surfaceLight,
        child: Text(
          friend.user.initials,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.primaryBlue,
          ),
        ),
      ),
      title: Text(friend.user.name, style: AppTextStyles.labelLarge),
      subtitle: Text(
        'Level ${friend.user.level} · ${friend.user.xp} XP',
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: Icon(
        friend.online ? Icons.circle : Icons.circle_outlined,
        color: friend.online ? AppColors.primaryGreen : AppColors.textMuted,
        size: 12,
      ),
    );
  }
}
