import 'package:flutter/material.dart';

import '../domain/achievement_model.dart';

class AchievementDto {
  AchievementDto._();

  static const Map<String, Color> _palette = {
    'gold': Color(0xFFFACC15),
    'blue': Color(0xFF38BDF8),
    'green': Color(0xFF4ADE80),
    'purple': Color(0xFFA855F7),
    'orange': Color(0xFFFB923C),
  };

  static Achievement fromJson(Map<String, dynamic> json) {
    final rawColor = '${json['color'] ?? 'blue'}'.toLowerCase();
    return Achievement(
      id: '${json['id'] ?? json['slug'] ?? ''}',
      name: '${json['name'] ?? json['title'] ?? 'Achievement'}',
      description: '${json['description'] ?? ''}',
      icon: '${json['icon'] ?? json['emoji'] ?? '★'}',
      color: _palette[rawColor] ?? _palette['blue']!,
      xpReward: (json['xpReward'] as num?)?.toInt() ?? 25,
      unlocked: json['unlocked'] == true || json['unlockedAt'] != null,
      unlockedAt: DateTime.tryParse('${json['unlockedAt']}'),
    );
  }

  static List<Achievement> parse(Object? body) {
    final map = body is Map<String, dynamic> ? body : <String, dynamic>{};
    final raw = map['data'] ?? map['badges'] ?? map['achievements'];
    if (raw is! List) return const <Achievement>[];
    return raw
        .whereType<Map>()
        .map((row) => fromJson(Map<String, dynamic>.from(row)))
        .toList();
  }
}
