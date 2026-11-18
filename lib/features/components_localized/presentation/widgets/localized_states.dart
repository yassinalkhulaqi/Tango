import 'package:flutter/material.dart';
import '../../../../core/localization/app_locale.dart';
import '../../../../core/localization/locale_format.dart';

/// Localized empty, error and loading states shared across all surfaces.
class LocalizedStateView extends StatelessWidget {
  final AppLocale locale;
  final StateKind kind;
  final String? title;
  final String? message;
  final VoidCallback? onRetry;

  const LocalizedStateView({
    super.key,
    required this.locale,
    required this.kind,
    this.title,
    this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final icon = switch (kind) {
      StateKind.loading => Icons.hourglass_empty_rounded,
      StateKind.empty => Icons.inbox_rounded,
      StateKind.error => Icons.error_outline_rounded,
    };
    final color = switch (kind) {
      StateKind.loading => Theme.of(context).colorScheme.primary,
      StateKind.empty => Theme.of(context).colorScheme.onSurfaceVariant,
      StateKind.error => Theme.of(context).colorScheme.error,
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (kind == StateKind.loading)
              CircularProgressIndicator(color: color)
            else
              Icon(icon, size: 56, color: color),
            const SizedBox(height: 20),
            if (title != null)
              Text(title!, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(message!, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

enum StateKind { loading, empty, error }

/// A localized status badge with icon and label.
class LocalizedStatusBadge extends StatelessWidget {
  final String label;
  final StatusTone tone;
  final IconData? icon;

  const LocalizedStatusBadge({
    super.key,
    required this.label,
    this.tone = StatusTone.neutral,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (tone) {
      StatusTone.success => (Colors.green.shade100, Colors.green.shade900),
      StatusTone.warning => (Colors.orange.shade100, Colors.orange.shade900),
      StatusTone.error => (Colors.red.shade100, Colors.red.shade900),
      StatusTone.neutral => (Colors.grey.shade200, Colors.grey.shade800),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 14, color: foreground), const SizedBox(width: 6)],
          Text(label, style: TextStyle(color: foreground, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

enum StatusTone { success, warning, error, neutral }

/// A localized money row for tables and summaries.
class LocalizedMoneyRow extends StatelessWidget {
  final String label;
  final String amount;
  final AppLocale locale;
  final String? currency;

  const LocalizedMoneyRow({
    super.key,
    required this.label,
    required this.amount,
    required this.locale,
    this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(
          LocaleFormat.money(amount, locale, currency: currency),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
