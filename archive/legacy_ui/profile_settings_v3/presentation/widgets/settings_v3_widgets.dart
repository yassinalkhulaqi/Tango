import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

class SettingsGroupV3 extends StatelessWidget {
  final String title;
  final List<Widget> items;
  const SettingsGroupV3({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Text(title, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.textMuted)),
        ),
        const SizedBox(height: AppSpacing.sm),
        Card(
          shape: RoundedRectangleBorder(borderRadius: AppRadius.circular(AppRadius.lg)),
          child: Column(children: items),
        ),
      ],
    );
  }
}

class SettingsTileV3 extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsTileV3({super.key, required this.icon, required this.title, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryBlue),
      title: Text(title),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
