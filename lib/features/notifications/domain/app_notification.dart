enum NotificationType { achievement, streak, leaderboard, social, system }

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.read = false,
  });

  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime createdAt;
  final bool read;

  AppNotification copyWith({bool? read}) => AppNotification(
    id: id,
    title: title,
    body: body,
    type: type,
    createdAt: createdAt,
    read: read ?? this.read,
  );

  IconData get icon {
    switch (type) {
      case NotificationType.achievement:
        return Icons.emoji_events_outlined;
      case NotificationType.streak:
        return Icons.local_fire_department_outlined;
      case NotificationType.leaderboard:
        return Icons.leaderboard_outlined;
      case NotificationType.social:
        return Icons.people_outline;
      case NotificationType.system:
        return Icons.info_outline;
    }
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final rawType = '${json['type'] ?? 'system'}';
    final type = NotificationType.values.firstWhere(
      (value) => value.name == rawType,
      orElse: () => NotificationType.system,
    );
    return AppNotification(
      id: '${json['id'] ?? ''}',
      title: '${json['title'] ?? 'Notification'}',
      body: '${json['body'] ?? json['message'] ?? ''}',
      type: type,
      createdAt: DateTime.tryParse('${json['createdAt']}') ?? DateTime.now(),
      read: json['read'] == true || json['isRead'] == true,
    );
  }
}
