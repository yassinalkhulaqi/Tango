import 'package:flutter/material.dart';

class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final Color color;
  final int xpReward;
  final bool unlocked;
  final DateTime? unlockedAt;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.xpReward,
    this.unlocked = false,
    this.unlockedAt,
  });
}
