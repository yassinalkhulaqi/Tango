import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../ui_components/widgets/ui_component_library.dart';

class PlaygroundScreen extends StatefulWidget {
  const PlaygroundScreen({super.key});

  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen> {
  final _codeController = TextEditingController();
  final _outputController = TextEditingController();
  String _language = 'Dart';
  double _divider = 0.6;
  bool _isRunning = false;

  static const _languages = ['Dart', 'Python', 'JavaScript', 'Flutter'];

  @override
  void initState() {
    super.initState();
    _codeController.text = '''void main() {
  print('Hello, CodeBro Playground!');
  var message = 'Learning to code is fun';
  print(message);
}''';
  }

  @override
  void dispose() {
    _codeController.dispose();
    _outputController.dispose();
    super.dispose();
  }

  void _runCode() {
    setState(() => _isRunning = true);
    _outputController.text = 'Running $_language code...\n\n';
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _outputController.text +=
            'Hello, CodeBro Playground!\nLearning to code is fun\n\nExecution completed in 840ms.';
        _isRunning = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Code Playground'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.reset_outlined),
            onPressed: _isRunning
                ? null
                : () {
                    setState(() {
                      _outputController.clear();
                      _codeController.text = '''void main() {
  print('Hello, CodeBro Playground!');
}''';
                    });
                  },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildToolbar(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final editorHeight = (constraints.maxHeight * _divider).clamp(
                  60.0,
                  constraints.maxHeight - 60,
                );
                return Column(
                  children: [
                    Expanded(child: _buildEditorPane(editorHeight)),
                    _buildDivider(),
                    Expanded(child: _buildOutputPane()),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: AppRadius.circular(AppRadius.xxl),
              border: Border.all(color: AppColors.cardBorder, width: 1),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _language,
                dropdownColor: AppColors.surfaceLight,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
                items: _languages
                    .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                    .toList(),
                onChanged: (v) => setState(() => _language = v!),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: SizedBox(
              height: 44,
              child: PremiumButton(
                text: _isRunning ? 'Running...' : 'Run',
                onPressed: _isRunning ? null : _runCode,
                icon: _isRunning ? null : Icons.play_arrow_rounded,
                gradient: AppGradients.neonGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditorPane(double height) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF070A0F),
        borderRadius: AppRadius.circular(AppRadius.lg),
      ),
      margin: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 30,
            color: const Color(0xFF0F141C),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                const Icon(
                  Icons.code_rounded,
                  color: AppColors.primaryYellow,
                  size: 16,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '$_language',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TextField(
              controller: _codeController,
              maxLines: null,
              expands: true,
              style: const TextStyle(
                fontFamily: 'FiraCode',
                fontSize: 14,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(AppSpacing.md),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(
          () =>
              _divider = (_divider + details.delta.dx / 400).clamp(0.25, 0.85),
        );
      },
      child: Container(
        height: 8,
        color: Colors.transparent,
        child: Center(
          child: Container(
            width: 20,
            height: 2,
            color: AppColors.textMuted.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildOutputPane() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF05070A),
        borderRadius: AppRadius.circular(AppRadius.lg),
      ),
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 30,
            color: const Color(0xFF0F141C),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                const Icon(
                  Icons.terminal_rounded,
                  color: AppColors.primaryCyan,
                  size: 16,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Output',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                _outputController.text.isEmpty
                    ? 'Run your code to see output here.'
                    : _outputController.text,
                style: const TextStyle(
                  fontFamily: 'FiraCode',
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
