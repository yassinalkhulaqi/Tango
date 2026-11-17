import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class DailyQuestsCard extends StatelessWidget {
  const DailyQuestsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.event_note_rounded, color: AppColors.primaryPurple, size: 20),
              const SizedBox(width: 8),
              Text(
                'Daily Quests',
                style: AppTextStyles.titleSmall.copyWith(fontSize: 15),
              ),
              const Spacer(),
              Text(
                '2 of 3 done',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primaryGreen,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _QuestRow(
            icon: Icons.menu_book_rounded,
            text: 'Complete 1 lesson',
            done: true,
            xp: 30,
            color: AppColors.primaryGreen,
          ),
          const SizedBox(height: 10),
          _QuestRow(
            icon: Icons.code_rounded,
            text: 'Write 5 lines of code',
            done: true,
            xp: 20,
            color: AppColors.primaryGreen,
          ),
          const SizedBox(height: 10),
          _QuestRow(
            icon: Icons.local_fire_department_rounded,
            text: '3-day streak maintained',
            done: false,
            xp: 50,
            color: AppColors.primaryOrange,
          ),
        ],
      ),
    );
  }
}

class _QuestRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool done;
  final int xp;
  final Color color;

  const _QuestRow({
    required this.icon,
    required this.text,
    required this.done,
    required this.xp,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: done ? color.withValues(alpha: 0.15) : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: done
              ? const Icon(Icons.check_rounded, color: AppColors.primaryGreen, size: 18)
              : Icon(icon, color: AppColors.textMuted, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: done ? AppColors.textMuted : AppColors.textSecondary,
              fontSize: 13,
              decoration: done ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bolt_rounded, color: AppColors.primaryYellow, size: 14),
            const SizedBox(width: 2),
            Text(
              '+$xp',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.primaryYellow,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
