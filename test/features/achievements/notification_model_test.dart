import 'package:flutter_test/flutter_test.dart';
import 'package:tango/features/notifications/domain/app_notification.dart';

void main() {
  test('parses notification type and read state', () {
    final notification = AppNotification.fromJson({
      'id': 'n1',
      'title': 'Badge unlocked',
      'message': 'You earned Bug Squasher!',
      'type': 'achievement',
      'read': true,
      'createdAt': '2026-01-01T00:00:00.000Z',
    });

    expect(notification.type, NotificationType.achievement);
    expect(notification.read, isTrue);
    expect(notification.createdAt.year, 2026);
    expect(notification.icon, isNotNull);
  });

  test('unknown types fall back to system', () {
    final notification = AppNotification.fromJson({
      'id': 'n2',
      'title': 'Update',
      'type': 'mystery',
    });

    expect(notification.type, NotificationType.system);
    expect(notification.read, isFalse);
  });

  test('copyWith marks a notification as read', () {
    final notification = AppNotification(
      id: 'n3',
      title: 'Streak',
      body: 'Keep it going',
      type: NotificationType.streak,
      createdAt: DateTime(2026),
    );
    final read = notification.copyWith(read: true);

    expect(read.read, isTrue);
    expect(notification.read, isFalse);
  });
}
