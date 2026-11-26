import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final VoidCallback? onToggle;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final TextCapitalization textCapitalization;
  final int maxLines;
  final bool enabled;

  const CustomTextField({
    super.key,
    this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.onToggle,
    this.validator,
    this.onChanged,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Stack(
          alignment: Alignment.centerRight,
          children: [
            TextFormField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              validator: validator,
              onChanged: onChanged,
              textCapitalization: textCapitalization,
              maxLines: maxLines,
              enabled: enabled,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 14,
                ),
                prefixIcon: prefixIcon != null
                    ? Icon(prefixIcon, color: AppColors.textMuted, size: 20)
                    : null,
                suffixIcon: onToggle != null
                    ? GestureDetector(
                        onTap: onToggle,
                        child: Icon(
                          obscureText
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          color: AppColors.textMuted,
                          size: 20,
                        ),
                      )
                    : null,
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
                border: OutlineInputBorder(
                  borderRadius: AppRadius.circular(AppRadius.lg),
                  borderSide:
                      const BorderSide(color: AppColors.cardBorder, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppRadius.circular(AppRadius.lg),
                  borderSide: BorderSide(
                    color: enabled
                        ? AppColors.cardBorder
                        : AppColors.cardBorder.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppRadius.circular(AppRadius.lg),
                  borderSide:
                      const BorderSide(color: AppColors.primaryBlue, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: AppRadius.circular(AppRadius.lg),
                  borderSide: const BorderSide(color: AppColors.pink, width: 1.5),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: AppRadius.circular(AppRadius.lg),
                  borderSide: const BorderSide(color: AppColors.pink, width: 2),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
