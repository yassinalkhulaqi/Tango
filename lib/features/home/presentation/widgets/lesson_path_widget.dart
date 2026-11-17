import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class LessonPathWidget extends StatelessWidget {
  const LessonPathWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final nodes = [
      _PathNodeData('Variables', Icons.code_rounded, AppColors.primaryGreen, true),
      _PathNodeData('Functions', Icons.functions_rounded, AppColors.primaryBlue, true),
      _PathNodeData('Classes', Icons.widgets_rounded, AppColors.primaryPurple, true),
      _PathNodeData('Async', Icons.swap_horiz_rounded, AppColors.primaryOrange, false),
      _PathNodeData('Streams', Icons.waves_rounded, AppColors.primaryCyan, false),
    ];

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 4, right: 4),
        itemCount: nodes.length,
        separatorBuilder: (_, _) => const SizedBox(width: 0),
        itemBuilder: (context, index) {
          final node = nodes[index];
          final isLast = index == nodes.length - 1;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: node.completed || node.active
                            ? LinearGradient(
                                colors: [node.color, node.color.withValues(alpha: 0.7)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: node.completed || node.active ? null : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: node.active
                              ? node.color
                              : (node.completed ? node.color.withValues(alpha: 0.5) : AppColors.cardBorder),
                          width: node.active ? 2.5 : 1.5,
                        ),
                        boxShadow: node.active
                            ? [
                                BoxShadow(
                                  color: node.color.withValues(alpha: 0.25),
                                  blurRadius: 10,
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: node.completed
                            ? const Icon(Icons.check_rounded, color: Colors.white, size: 24)
                            : Icon(node.icon, color: node.active ? node.color : AppColors.textMuted, size: 22),
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 28,
                        height: 3,
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: node.completed
                              ? node.color.withValues(alpha: 0.5)
                              : AppColors.cardBorder,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  node.label,
                  style: AppTextStyles.labelSmall.copyWith(
                    fontSize: 10,
                    color: node.active ? AppColors.textPrimary : AppColors.textMuted,
                    fontWeight: node.active ? FontWeight.w700 : FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PathNodeData {
  final String label;
  final IconData icon;
  final Color color;
  final bool completed;

  bool get active => false;

  _PathNodeData(this.label, this.icon, this.color, this.completed);
}
