import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/providers.dart';
import '../domain/app_notification.dart';

class NotificationsRepository {
  NotificationsRepository(this._api);

  final ApiClient _api;

  Future<List<AppNotification>> fetchNotifications() async {
    try {
      final body = await _api.get('/notifications');
      final raw = body['data'];
      if (raw is! List) return const <AppNotification>[];
      return raw
          .whereType<Map>()
          .map(
            (row) => AppNotification.fromJson(Map<String, dynamic>.from(row)),
          )
          .toList();
    } on Object {
      return const <AppNotification>[];
    }
  }

  Future<bool> markRead(String id) async {
    try {
      await _api.post('/notifications/$id/read');
      return true;
    } on Object {
      return false;
    }
  }
}

final notificationsRepositoryProvider = Provider<NotificationsRepository>((
  ref,
) {
  return NotificationsRepository(ref.watch(apiClientProvider));
});

final notificationsProvider = FutureProvider<List<AppNotification>>((
  ref,
) async {
  return ref.watch(notificationsRepositoryProvider).fetchNotifications();
});

final unreadCountProvider = FutureProvider<int>((ref) async {
  final notifications = await ref.watch(notificationsProvider.future);
  return notifications.where((item) => !item.read).length;
});
