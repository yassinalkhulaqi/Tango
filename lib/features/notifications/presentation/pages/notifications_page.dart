import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/ui/app_states.dart';
import '../data/notifications_repository.dart';
import '../domain/app_notification.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Notifications', style: AppTextStyles.titleLarge),
      ),
      body: notificationsAsync.when(
        loading: () => const AppLoadingView(),
        error: (_, __) => AppErrorView(
          message: 'Could not load notifications.',
          onRetry: () => ref.invalidate(notificationsProvider),
        ),
        data: (notifications) => notifications.isEmpty
            ? const AppEmptyView(
                title: 'All caught up',
                message: 'New achievements and friend activity appear here.',
              )
            : ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: notifications.length,
                itemBuilder: (context, index) =>
                    _NotificationTile(notification: notifications[index]),
              ),
      ),
    );
  }
}

class _NotificationTile extends ConsumerWidget {
  const _NotificationTile({required this.notification});

  final AppNotification notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: notification.read ? AppColors.surface : AppColors.surfaceLight,
        borderRadius: AppRadius.circular(AppRadius.lg),
        border: Border.all(
          color: notification.read
              ? AppColors.cardBorder
              : AppColors.primaryBlue.withValues(alpha: 0.4),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(notification.icon, color: AppColors.primaryBlue),
        title: Text(notification.title, style: AppTextStyles.labelLarge),
        subtitle: Text(
          notification.body,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: notification.read
            ? null
            : TextButton(
                onPressed: () async {
                  await ref
                      .read(notificationsRepositoryProvider)
                      .markRead(notification.id);
                  ref.invalidate(notificationsProvider);
                },
                child: const Text('Mark read'),
              ),
      ),
    );
  }
}
