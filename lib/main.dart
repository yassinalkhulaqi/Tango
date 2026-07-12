import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_colors.dart';
import 'features/onboarding/presentation/pages/onboarding_page.dart';

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
      onGenerateRoute: (settings) {
        if (settings.name == '/auth') {
          return MaterialPageRoute(
            builder: (_) => const _AuthPlaceholder(),
          );
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
