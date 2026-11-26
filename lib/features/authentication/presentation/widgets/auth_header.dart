import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.terminal_rounded,
              color: AppColors.primaryBlue,
              size: 28,
            ),
            const SizedBox(width: 10),
            Text(
              'CodeBro',
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
                fontSize: 26,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Text(
          title,
          style: AppTextStyles.displayMedium.copyWith(fontSize: 26),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            subtitle,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
