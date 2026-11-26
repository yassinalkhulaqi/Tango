import 'package:flutter/material.dart';

class OnboardingStep {
  final String id;
  final String title;
  final String subtitle;
  final String icon;
  final Color color;
  final List<OnboardingOption> options;
  final bool isMultiSelect;
  final int minSelection;
  final int maxSelection;

  const OnboardingStep({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.options = const [],
    this.isMultiSelect = false,
    this.minSelection = 1,
    this.maxSelection = 1,
  });
}

class OnboardingOption {
  final String id;
  final String title;
  final String subtitle;
  final String icon;
  final Color color;
  final bool isSelected;
  final Map<String, dynamic> metadata;

  const OnboardingOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.isSelected = false,
    this.metadata = const {},
  });
}

class OnboardingProfile {
  final String name;
  final String email;
  final String avatar;
  final List<String> selectedSkills;
  final String goal;
  final int dailyMinutes;
  final bool notificationsEnabled;
  final bool termsAccepted;

  const OnboardingProfile({
    required this.name,
    required this.email,
    required this.avatar,
    required this.selectedSkills,
    required this.goal,
    required this.dailyMinutes,
    required this.notificationsEnabled,
    required this.termsAccepted,
  });

  OnboardingProfile copyWith({
    String? name,
    String? email,
    String? avatar,
    List<String>? selectedSkills,
    String? goal,
    int? dailyMinutes,
    bool? notificationsEnabled,
    bool? termsAccepted,
  }) {
    return OnboardingProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      selectedSkills: selectedSkills ?? this.selectedSkills,
      goal: goal ?? this.goal,
      dailyMinutes: dailyMinutes ?? this.dailyMinutes,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      termsAccepted: termsAccepted ?? this.termsAccepted,
    );
  }

  double get completionPercent {
    int completed = 0;
    int total = 8;
    if (name.isNotEmpty) completed++;
    if (email.isNotEmpty) completed++;
    if (avatar.isNotEmpty) completed++;
    if (selectedSkills.isNotEmpty) completed++;
    if (goal.isNotEmpty) completed++;
    if (dailyMinutes > 0) completed++;
    if (notificationsEnabled) completed++;
    if (termsAccepted) completed++;
    return completed / total;
  }
}
