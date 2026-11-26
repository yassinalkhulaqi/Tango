import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_gradients.dart';

class CodeEditorWidget extends StatefulWidget {
  final String initialCode;
  final ValueChanged<String> onCodeChanged;
  final VoidCallback onRunPressed;
  final bool isRunning;
  final String output;

  const CodeEditorWidget({
    super.key,
    required this.initialCode,
    required this.onCodeChanged,
    required this.onRunPressed,
    required this.isRunning,
    required this.output,
  });

  @override
  State<CodeEditorWidget> createState() => _CodeEditorWidgetState();
}

class _CodeEditorWidgetState extends State<CodeEditorWidget> {
  late TextEditingController _controller;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialCode);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF0F141C),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.primaryRed,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.primaryYellow,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  shape: BoxShape.circle,
                ),
              ),
              const Spacer(),
              Text(
                'main.dart',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              IconButton(
                onPressed: widget.isRunning ? null : widget.onRunPressed,
                icon: widget.isRunning
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(
                            AppColors.primaryGreen,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.play_arrow_rounded,
                        color: AppColors.primaryGreen,
                        size: 20,
                      ),
                tooltip: 'Run Code',
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF070A0F),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
              border: Border.all(color: AppColors.cardBorder, width: 1),
            ),
            child: TextField(
              controller: _controller,
              maxLines: null,
              expands: true,
              style: const TextStyle(
                fontFamily: 'FiraCode',
                fontSize: 14,
                color: AppColors.textPrimary,
                height: 1.6,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(AppSpacing.md),
              ),
              onChanged: widget.onCodeChanged,
              onTap: () => setState(() => _isFocused = true),
              onTapOutside: (_) => setState(() => _isFocused = false),
            ),
          ),
        ),
        if (widget.output.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF05070A),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
              border: Border.all(color: AppColors.cardBorder, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F141C),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.terminal_rounded,
                        color: AppColors.primaryCyan,
                        size: 16,
                      ),
                      const SizedBox(width: AppSpacing.xs),
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
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Text(
                    widget.output,
                    style: const TextStyle(
                      fontFamily: 'FiraCode',
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class LineNumberGutter extends StatelessWidget {
  final int lineCount;

  const LineNumberGutter({super.key, required this.lineCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      color: const Color(0xFF0F141C),
      child: Column(
        children: List.generate(lineCount, (index) {
          return Container(
            height: 24,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              '${index + 1}',
              style: AppTextStyles.codeFont.copyWith(
                color: AppColors.textMuted,
                fontSize: 12,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class SyntaxHighlighter extends StatelessWidget {
  final String code;

  const SyntaxHighlighter({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return Text(
      code,
      style: const TextStyle(
        fontFamily: 'FiraCode',
        fontSize: 14,
        color: AppColors.textPrimary,
        height: 1.6,
      ),
    );
  }
}
