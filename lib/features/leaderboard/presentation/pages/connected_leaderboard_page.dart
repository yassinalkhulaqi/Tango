import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/ui/app_states.dart';
import '../data/leaderboard_dto.dart';
import '../data/leaderboard_repository.dart';
import '../domain/leaderboard_model.dart';
import '../widgets/leaderboard_row.dart';

class ConnectedLeaderboardPage extends ConsumerStatefulWidget {
  const ConnectedLeaderboardPage({super.key});

  @override
  ConsumerState<ConnectedLeaderboardPage> createState() =>
      _ConnectedLeaderboardPageState();
}

class _ConnectedLeaderboardPageState
    extends ConsumerState<ConnectedLeaderboardPage> {
  LeaderboardPeriod _period = LeaderboardPeriod.weekly;

  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(leaderboardProvider(_period));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                'Leaderboard',
                style: AppTextStyles.displayMedium.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppSpacing.sm),
                itemCount: LeaderboardPeriod.values.length,
                itemBuilder: (context, index) {
                  final period = LeaderboardPeriod.values[index];
                  return ChoiceChip(
                    label: Text(period.label),
                    selected: period == _period,
                    onSelected: (_) => setState(() => _period = period),
                    selectedColor: AppColors.primaryBlue,
                    backgroundColor: AppColors.surface,
                  );
                },
              ),
            ),
            Expanded(
              child: entriesAsync.when(
                loading: () =>
                    const AppLoadingView(message: 'Loading ranks...'),
                error: (_, __) => AppErrorView(
                  message: 'Could not load the leaderboard.',
                  onRetry: () => ref.invalidate(leaderboardProvider(_period)),
                ),
                data: (entries) => entries.isEmpty
                    ? const AppEmptyView(
                        title: 'No ranks yet',
                        message: 'Complete a lesson to enter the leaderboard.',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        itemCount: entries.length,
                        itemBuilder: (context, index) =>
                            LeaderboardRow(entry: entries[index]),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
