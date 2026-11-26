import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/ui/app_states.dart';
import '../data/achievements_repository.dart';
import '../widgets/achievement_card.dart';

class ConnectedAchievementsPage extends ConsumerWidget {
  const ConnectedAchievementsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badgesAsync = ref.watch(badgesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Achievements',
                      style: AppTextStyles.displayMedium.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Check for new badges',
                    onPressed: () async {
                      await ref.read(achievementsRepositoryProvider).evaluate();
                      ref.invalidate(badgesProvider);
                    },
                    icon: const Icon(
                      Icons.refresh_rounded,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: badgesAsync.when(
                loading: () =>
                    const AppLoadingView(message: 'Loading badges...'),
                error: (_, __) => AppErrorView(
                  message: 'Could not load achievements.',
                  onRetry: () => ref.invalidate(badgesProvider),
                ),
                data: (badges) {
                  if (badges.isEmpty) {
                    return const AppEmptyView(
                      title: 'No badges yet',
                      message: 'Keep learning to unlock your first badge.',
                    );
                  }
                  final unlocked = badges.where((b) => b.unlocked).length;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        child: Row(
                          children: [
                            Text(
                              '$unlocked of ${badges.length} unlocked',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1,
                                crossAxisSpacing: AppSpacing.md,
                                mainAxisSpacing: AppSpacing.md,
                              ),
                          itemCount: badges.length,
                          itemBuilder: (context, index) =>
                              AchievementCard(achievement: badges[index]),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
