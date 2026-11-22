import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class StateViewV3 extends StatelessWidget {
  final StateKindV3 kind;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const StateViewV3({super.key, required this.kind, required this.title, this.message, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    final icon = switch (kind) {
      StateKindV3.loading => Icons.hourglass_empty_rounded,
      StateKindV3.empty => Icons.inbox_rounded,
      StateKindV3.error => Icons.error_outline_rounded,
    };
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (kind == StateKindV3.loading)
              const CircularProgressIndicator()
            else
              Icon(icon, size: 56, color: kind == StateKindV3.error ? AppColors.pink : AppColors.textMuted),
            const SizedBox(height: AppSpacing.lg),
            Text(title, style: AppTextStyles.titleLarge, textAlign: TextAlign.center),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(message!, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

enum StateKindV3 { loading, empty, error }

class AsyncBoundaryV3<T> extends StatelessWidget {
  final bool loading;
  final String? error;
  final T? data;
  final Widget Function(T data) builder;
  final String loadingLabel;
  final String errorTitle;
  final String retryLabel;
  final VoidCallback? onRetry;

  const AsyncBoundaryV3({
    super.key,
    required this.loading,
    this.error,
    this.data,
    required this.builder,
    required this.loadingLabel,
    required this.errorTitle,
    required this.retryLabel,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) return StateViewV3(kind: StateKindV3.loading, title: loadingLabel);
    if (error != null) return StateViewV3(kind: StateKindV3.error, title: errorTitle, message: error, actionLabel: retryLabel, onAction: onRetry);
    if (data == null) return StateViewV3(kind: StateKindV3.empty, title: errorTitle);
    return builder(data as T);
  }
}
