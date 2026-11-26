import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tango/features/achievements/data/achievement_dto.dart';
import 'package:tango/features/achievements/domain/achievement_model.dart';

void main() {
  test('parses badges with color palette and unlock state', () {
    final badges = AchievementDto.parse({
      'data': [
        {
          'id': 'first-lesson',
          'name': 'First Commit',
          'description': 'Finish your first lesson',
          'icon': '★',
          'color': 'gold',
          'xpReward': 50,
          'unlockedAt': '2026-01-01T00:00:00.000Z',
        },
      ],
    });

    expect(badges, hasLength(1));
    expect(badges.first.unlocked, isTrue);
    expect(badges.first.color, const Color(0xFFFACC15));
    expect(badges.first.xpReward, 50);
  });

  test('unknown colors fall back to blue', () {
    final badge = AchievementDto.fromJson({
      'id': 'b',
      'name': 'Badge',
      'color': 'mystery',
    });

    expect(badge.color, const Color(0xFF38BDF8));
    expect(badge.unlocked, isFalse);
  });

  test('achievement model keeps required fields', () {
    const achievement = Achievement(
      id: 'a',
      name: 'Achievement',
      description: 'Desc',
      icon: '★',
      color: Colors.blue,
      xpReward: 25,
    );

    expect(achievement.id, 'a');
    expect(achievement.unlocked, isFalse);
  });
}
