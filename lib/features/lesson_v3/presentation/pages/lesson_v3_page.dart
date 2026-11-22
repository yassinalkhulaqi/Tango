import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../widgets/lesson_v3_widgets.dart';

class LessonV3Page extends StatefulWidget {
  final String title;
  const LessonV3Page({super.key, this.title = 'Flutter Basics'});

  @override
  State<LessonV3Page> createState() => _LessonV3PageState();
}

class _LessonV3PageState extends State<LessonV3Page> {
  int _section = 0;
  final int _total = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: LessonStepperV3(total: _total, current: _section),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: CodeBlockV3(
                  code: 'void main() {\n  print("Hello, CodeBro!");\n}',
                  label: 'Code Example',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(child: OutlinedButton(onPressed: _section > 0 ? () => setState(() => _section--) : null, child: const Text('Previous'))),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: ElevatedButton(onPressed: _section < _total - 1 ? () => setState(() => _section++) : null, child: const Text('Next'))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
