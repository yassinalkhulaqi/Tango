import 'package:flutter/material.dart';

/// Helpers for building accessible, screen-reader-friendly UI.
abstract final class A11y {
  /// A label for an icon-only button, combining action and subject.
  static String iconButtonLabel(String action, String subject) => '$action $subject';

  /// Semantic hint for a progress value.
  static String progressHint(int current, int total) => '$current of $total';

  /// Whether a widget should be excluded from the accessibility tree.
  static bool isDecorative({required bool hasSemanticValue}) => !hasSemanticValue;

  /// Tooltip + semantics for a navigation action.
  static String navLabel(String destination) => 'Go to $destination';
}

/// An icon-only button with a required semantic label.
class AccessibleIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? color;

  const AccessibleIconButton({super.key, required this.icon, required this.label, required this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      child: IconButton(icon: Icon(icon, color: color), tooltip: label, onPressed: onPressed),
    );
  }
}

/// A labeled progress indicator that announces its value.
class AccessibleProgress extends StatelessWidget {
  final double value;
  final String label;
  const AccessibleProgress({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      value: '${(value * 100).round()}%',
      progressBar: true,
      child: LinearProgressIndicator(value: value),
    );
  }
}
