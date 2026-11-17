import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_gradients.dart';

class AvatarPicker extends StatelessWidget {
  final List<String> availableAvatars;
  final String selectedAvatar;
  final ValueChanged<String> onAvatarSelected;

  const AvatarPicker({
    super.key,
    required this.availableAvatars,
    required this.selectedAvatar,
    required this.onAvatarSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: availableAvatars.length,
        itemBuilder: (context, index) {
          final avatar = availableAvatars[index];
          final isSelected = avatar == selectedAvatar;
          return GestureDetector(
            onTap: () => onAvatarSelected(avatar),
            child: AnimatedContainer(
              duration: AppMotion.fast,
              margin: const EdgeInsets.only(right: AppSpacing.sm),
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isSelected
                    ? AppGradients.primary
                    : null,
                color: isSelected ? null : AppColors.surface,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryBlue
                      : AppColors.cardBorder,
                  width: isSelected ? 3 : 1,
                ),
                boxShadow: isSelected
                    ? [AppGradients.glow(AppColors.primaryBlue, blurRadius: 12)]
                    : [],
              ),
              child: Center(
                child: Text(
                  avatar,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AvatarGridPicker extends StatelessWidget {
  final List<String> availableAvatars;
  final String selectedAvatar;
  final ValueChanged<String> onAvatarSelected;
  final int columns;

  const AvatarGridPicker({
    super.key,
    required this.availableAvatars,
    required this.selectedAvatar,
    required this.onAvatarSelected,
    this.columns = 4,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 1,
      ),
      itemCount: availableAvatars.length,
      itemBuilder: (context, index) {
        final avatar = availableAvatars[index];
        final isSelected = avatar == selectedAvatar;
        return GestureDetector(
          onTap: () => onAvatarSelected(avatar),
          child: AnimatedContainer(
            duration: AppMotion.fast,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isSelected
                  ? AppGradients.primary
                  : null,
              color: isSelected ? null : AppColors.surface,
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryBlue
                    : AppColors.cardBorder,
                width: isSelected ? 3 : 1,
              ),
              boxShadow: isSelected
                  ? [AppGradients.glow(AppColors.primaryBlue, blurRadius: 12)]
                  : [],
            ),
            child: Center(
              child: Text(
                avatar,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
