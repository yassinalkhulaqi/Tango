import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/onboarding_models.dart';

class OnboardingRouteConfig {
  static const String welcome = '/onboarding/welcome';
  static const String personalInfo = '/onboarding/personal-info';
  static const String skillSelection = '/onboarding/skills';
  static const String goalSelection = '/onboarding/goal';
  static const String notifications = '/onboarding/notifications';
  static const String terms = '/onboarding/terms';
  static const String completion = '/onboarding/complete';

  static List<String> get allRoutes => [
    welcome,
    personalInfo,
    skillSelection,
    goalSelection,
    notifications,
    terms,
    completion,
  ];

  static String? getNextRoute(String currentRoute) {
    final index = allRoutes.indexOf(currentRoute);
    if (index != -1 && index < allRoutes.length - 1) {
      return allRoutes[index + 1];
    }
    return null;
  }

  static String? getPreviousRoute(String currentRoute) {
    final index = allRoutes.indexOf(currentRoute);
    if (index > 0) {
      return allRoutes[index - 1];
    }
    return null;
  }

  static bool isLastRoute(String route) {
    return route == completion;
  }

  static bool isFirstRoute(String route) {
    return route == welcome;
  }

  static int getRouteIndex(String route) {
    return allRoutes.indexOf(route);
  }

  static int get totalRoutes => allRoutes.length;
}

class OnboardingValidationResult {
  final bool isValid;
  final String? errorMessage;
  final String fieldName;

  const OnboardingValidationResult({
    required this.isValid,
    this.errorMessage,
    required this.fieldName,
  });

  factory OnboardingValidationResult.valid(String fieldName) {
    return OnboardingValidationResult(
      isValid: true,
      errorMessage: null,
      fieldName: fieldName,
    );
  }

  factory OnboardingValidationResult.invalid(String fieldName, String message) {
    return OnboardingValidationResult(
      isValid: false,
      errorMessage: message,
      fieldName: fieldName,
    );
  }
}

class OnboardingFieldValidator {
  static OnboardingValidationResult validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return OnboardingValidationResult.invalid('name', 'Please enter your name');
    }
    if (value.trim().length < 2) {
      return OnboardingValidationResult.invalid('name', 'Name must be at least 2 characters');
    }
    if (value.trim().length > 50) {
      return OnboardingValidationResult.invalid('name', 'Name must be less than 50 characters');
    }
    return OnboardingValidationResult.valid('name');
  }

  static OnboardingValidationResult validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return OnboardingValidationResult.invalid('email', 'Please enter your email');
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return OnboardingValidationResult.invalid('email', 'Please enter a valid email address');
    }
    return OnboardingValidationResult.valid('email');
  }

  static OnboardingValidationResult validateSkills(List<String>? skills) {
    if (skills == null || skills.isEmpty) {
      return OnboardingValidationResult.invalid('skills', 'Please select at least one skill');
    }
    return OnboardingValidationResult.valid('skills');
  }

  static OnboardingValidationResult validateGoal(String? goal) {
    if (goal == null || goal.isEmpty) {
      return OnboardingValidationResult.invalid('goal', 'Please select a learning goal');
    }
    return OnboardingValidationResult.valid('goal');
  }

  static OnboardingValidationResult validateTerms(bool? accepted) {
    if (accepted != true) {
      return OnboardingValidationResult.invalid('terms', 'You must accept the terms to continue');
    }
    return OnboardingValidationResult.valid('terms');
  }

  static List<OnboardingValidationResult> validateAll({
    String? name,
    String? email,
    List<String>? skills,
    String? goal,
    bool? termsAccepted,
  }) {
    return [
      validateName(name),
      validateEmail(email),
      validateSkills(skills),
      validateGoal(goal),
      validateTerms(termsAccepted),
    ];
  }

  static bool allValid(List<OnboardingValidationResult> results) {
    return results.every((r) => r.isValid);
  }

  static String? firstError(List<OnboardingValidationResult> results) {
    final error = results.firstWhere((r) => !r.isValid, orElse: () => const OnboardingValidationResult(isValid: true, errorMessage: null, fieldName: ''));
    return error.errorMessage;
  }
}

class OnboardingAnalyticsEvent {
  final String eventName;
  final Map<String, dynamic> properties;
  final DateTime timestamp;

  const OnboardingAnalyticsEvent({
    required this.eventName,
    required this.properties,
    required this.timestamp,
  });

  factory OnboardingAnalyticsEvent.stepCompleted(String stepId, int stepNumber) {
    return OnboardingAnalyticsEvent(
      eventName: 'onboarding_step_completed',
      properties: {
        'step_id': stepId,
        'step_number': stepNumber,
      },
      timestamp: DateTime.now(),
    );
  }

  factory OnboardingAnalyticsEvent.skillSelected(String skillId, String categoryId) {
    return OnboardingAnalyticsEvent(
      eventName: 'onboarding_skill_selected',
      properties: {
        'skill_id': skillId,
        'category_id': categoryId,
      },
      timestamp: DateTime.now(),
    );
  }

  factory OnboardingAnalyticsEvent.goalSelected(String goalId, int minutes) {
    return OnboardingAnalyticsEvent(
      eventName: 'onboarding_goal_selected',
      properties: {
        'goal_id': goalId,
        'daily_minutes': minutes,
      },
      timestamp: DateTime.now(),
    );
  }

  factory OnboardingAnalyticsEvent.completed(OnboardingProfile profile) {
    return OnboardingAnalyticsEvent(
      eventName: 'onboarding_completed',
      properties: {
        'skills_count': profile.selectedSkills.length,
        'goal': profile.goal,
        'daily_minutes': profile.dailyMinutes,
        'notifications_enabled': profile.notificationsEnabled,
      },
      timestamp: DateTime.now(),
    );
  }
}

class OnboardingAnalyticsService {
  final List<OnboardingAnalyticsEvent> _events = [];

  List<OnboardingAnalyticsEvent> get events => List.unmodifiable(_events);

  void track(OnboardingAnalyticsEvent event) {
    _events.add(event);
  }

  void clear() {
    _events.clear();
  }

  Map<String, int> get eventCountsByName {
    final counts = <String, int>{};
    for (final event in _events) {
      counts[event.eventName] = (counts[event.eventName] ?? 0) + 1;
    }
    return counts;
  }

  double get averageStepDuration {
    if (_events.isEmpty) return 0.0;
    return _events.length.toDouble();
  }
}

class OnboardingPersistenceService {
  static const String _keyProfile = 'onboarding_profile';
  static const String _keyCompleted = 'onboarding_completed';

  OnboardingProfile? loadProfile() {
    return null;
  }

  void saveProfile(OnboardingProfile profile) {}

  bool isOnboardingCompleted() {
    return false;
  }

  void markOnboardingCompleted() {}

  void resetOnboarding() {}
}

class OnboardingNotificationService {
  void scheduleStreakReminder(int streakDays) {}

  void scheduleDailyChallenge(String challengeTitle) {}

  void scheduleAchievementAlert(String achievementName) {}

  void cancelAllNotifications() {}

  Future<bool> requestPermissions() async {
    return true;
  }
}
