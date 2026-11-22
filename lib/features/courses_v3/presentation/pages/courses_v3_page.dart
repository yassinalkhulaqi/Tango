import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../widgets/course_card_v3.dart';

class CoursesV3Page extends StatelessWidget {
  final List<CourseV3> courses;
  const CoursesV3Page({super.key, this.courses = const [
    CourseV3(title: 'Flutter', category: 'Flutter', lessons: 24, progress: 0.5, icon: Icons.phone_android_rounded, color: AppColors.primaryBlue),
    CourseV3(title: 'Python 101', category: 'Python', lessons: 18, progress: 0.3, icon: Icons.code_rounded, color: AppColors.primaryYellow),
    CourseV3(title: 'Web Dev', category: 'Web', lessons: 30, progress: 0.0, icon: Icons.language_rounded, color: AppColors.primaryPurple),
    CourseV3(title: 'AI/ML', category: 'AI', lessons: 9, progress: 0.0, icon: Icons.psychology_rounded, color: AppColors.primaryCyan, locked: true),
  ]});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Courses')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: courses.map((c) => CourseCardV3(course: c, onTap: () {})).toList(),
          ),
        ),
      ),
    );
  }
}
