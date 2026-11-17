import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_colors.dart';
import 'features/onboarding/presentation/pages/onboarding_page.dart';
import 'features/authentication/presentation/pages/login_page.dart';
import 'features/authentication/presentation/pages/register_page.dart';
import 'features/authentication/presentation/pages/forgot_password_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/courses/presentation/pages/courses_list_page.dart';
import 'features/courses/presentation/pages/course_detail_page.dart';
import 'features/quiz/presentation/pages/quiz_page.dart';
import 'features/quiz/domain/quiz_model.dart';
import 'features/leaderboard/presentation/pages/leaderboard_page.dart';
import 'features/achievements/presentation/pages/achievements_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/playground/presentation/pages/playground_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const CodeBroApp());
}

class CodeBroApp extends StatelessWidget {
  const CodeBroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CodeBro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryBlue,
          secondary: AppColors.primaryYellow,
          surface: AppColors.surface,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: AppColors.textPrimary,
        ),
      ),
      home: const OnboardingPage(),
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingPage(),
        '/auth': (context) => const _AuthPlaceholder(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/home': (context) => const HomePage(),
        '/courses': (context) => const CoursesListPage(),
        '/quiz': (context) => QuizPage(
              questions: const [
                QuizQuestion(
                  id: 'q1',
                  question: 'What does "void" mean in a Dart function?',
                  options: ['Returns no value', 'Returns null', 'Returns 0', 'Returns String'],
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
              ],
            ),
        '/playground': (context) => const PlaygroundPage(),
        '/leaderboard': (context) => const LeaderboardPage(),
        '/achievements': (context) => const AchievementsPage(),
        '/profile': (context) => const ProfilePage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/course-detail') {
          final course = settings.arguments;
          if (course != null) {
            return MaterialPageRoute(
              builder: (_) => CourseDetailPage(course: course),
            );
          }
        }
        return null;
      },
    );
  }
}

class _AuthPlaceholder extends StatelessWidget {
  const _AuthPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Text(
          'Authentication Screen\nComing Soon',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
