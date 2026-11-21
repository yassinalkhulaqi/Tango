import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/auth_validators.dart';

/// A password field with visibility toggle and inline validation message.
class PolishedPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String? error;
  final bool rtl;

  const PolishedPasswordField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.error,
    this.rtl = false,
  });

  @override
  State<PolishedPasswordField> createState() => _PolishedPasswordFieldState();
}

class _PolishedPasswordFieldState extends State<PolishedPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppTextStyles.titleMedium.copyWith(fontSize: 13)),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: widget.controller,
          obscureText: _obscure,
          textDirection: widget.rtl ? TextDirection.rtl : TextDirection.ltr,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
            suffixIcon: IconButton(
              icon: Icon(_obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded, size: 20),
              onPressed: () => setState(() => _obscure = !_obscure),
              tooltip: _obscure ? 'Show password' : 'Hide password',
            ),
            errorText: widget.error,
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: AppRadius.circular(AppRadius.lg),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.circular(AppRadius.lg),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.circular(AppRadius.lg),
              borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

/// An email field with inline validation and direction support.
class PolishedEmailField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String? error;
  final bool rtl;

  const PolishedEmailField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.error,
    this.rtl = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.titleMedium.copyWith(fontSize: 13)),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: const Icon(Icons.email_outlined, size: 20),
            errorText: error,
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: AppRadius.circular(AppRadius.lg),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.circular(AppRadius.lg),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.circular(AppRadius.lg),
              borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
