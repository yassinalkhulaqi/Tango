class OnboardingContent {
  final String title;
  final String description;
  final int pageIndex;

  const OnboardingContent({
    required this.title,
    required this.description,
    required this.pageIndex,
  });

  static const List<OnboardingContent> pages = [
    OnboardingContent(
      title: 'Welcome to CodeBro',
      description:
          'Learn programming, build skills, and become a better developer through interactive learning.',
      pageIndex: 0,
    ),
    OnboardingContent(
      title: 'Learn By Building',
      description:
          'Master programming through structured courses, practical challenges, quizzes, and real projects.',
      pageIndex: 1,
    ),
    OnboardingContent(
      title: 'Level Up Your Skills',
      description:
          'Earn XP, unlock achievements, compete on the leaderboard, and track your progress.',
      pageIndex: 2,
    ),
  ];
}
