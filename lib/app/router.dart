import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/state/app_providers.dart';
import '../core/theme/app_colors.dart';
import '../features/achievements/presentation/pages/achievements_page.dart';
import '../features/authentication/presentation/pages/forgot_password_page.dart';
import '../features/authentication/presentation/pages/login_page.dart';
import '../features/authentication/presentation/pages/register_page.dart';
import '../features/courses/domain/course_model.dart';
import '../features/courses/presentation/pages/course_detail_page.dart';
import '../features/courses/presentation/pages/courses_list_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/leaderboard/presentation/pages/leaderboard_page.dart';
import '../features/lesson_interactive/presentation/screens/lesson_player_screen.dart';
import '../features/onboarding/presentation/pages/onboarding_page.dart';
import '../features/playground/presentation/pages/playground_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/quiz/domain/quiz_model.dart';
import '../features/quiz/presentation/pages/quiz_page.dart';
import '../features/settings/presentation/pages/language_settings_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final isAuthenticated = ref.watch(
    sessionProvider.select((s) => s.isAuthenticated),
  );

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final location = state.matchedLocation;
      final isAuthRoute =
          location == '/login' ||
          location == '/register' ||
          location == '/forgot-password';
      if (!isAuthenticated && location != '/' && !isAuthRoute) {
        return '/login';
      }
      if (isAuthenticated && (location == '/' || isAuthRoute)) {
        return '/home';
      }
      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Page not found',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 22),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => context.go('/home'),
              child: const Text('Back home'),
            ),
          ],
        ),
      ),
    ),
    routes: [
      GoRoute(path: '/', builder: (context, state) => const OnboardingPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/courses',
        builder: (context, state) => const CoursesListPage(),
      ),
      GoRoute(
        path: '/courses/:id',
        builder: (context, state) {
          final course = state.extra;
          if (course is Course) {
            return CourseDetailPage(course: course);
          }
          return const CoursesListPage();
        },
      ),
      GoRoute(
        path: '/lesson/:id',
        builder: (context, state) => LessonPlayerScreen(
          lessonId: state.pathParameters['id'] ?? 'flutter-basics',
        ),
      ),
      GoRoute(
        path: '/quiz',
        builder: (context, state) => QuizPage(questions: _starterQuestions),
      ),
      GoRoute(
        path: '/playground',
        builder: (context, state) => const PlaygroundPage(),
      ),
      GoRoute(
        path: '/leaderboard',
        builder: (context, state) => const LeaderboardPage(),
      ),
      GoRoute(
        path: '/achievements',
        builder: (context, state) => const AchievementsPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/language',
        builder: (context, state) => LanguageSettingsPage(
          controller: ref.read(localeControllerProvider),
        ),
      ),
    ],
  );
});

const List<QuizQuestion> _starterQuestions = [
  QuizQuestion(
    id: 'q1',
    question: 'What does "void" mean in a Dart function?',
    options: [
      'Returns no value',
      'Returns null',
      'Returns 0',
      'Returns String',
    ],
    correctIndex: 0,
  ),
  QuizQuestion(
    id: 'q2',
    question: 'Which keyword defines a class in Dart?',
    options: ['class', 'struct', 'interface', 'type'],
    correctIndex: 0,
  ),
  QuizQuestion(
    id: 'q3',
    question: 'What is the entry point function in Dart?',
    options: ['start()', 'run()', 'main()', 'init()'],
    correctIndex: 2,
  ),
];
