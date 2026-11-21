import 'package:flutter/material.dart';

/// A selectable skill tile used in onboarding step 1.
class SkillTile extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final ValueChanged<bool> onChanged;

  const SkillTile({
    super.key,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurfaceVariant;
    return FilterChip(
      avatar: Icon(icon, size: 20, color: color),
      label: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700)),
          Text(subtitle, style: TextStyle(color: color.withValues(alpha: 0.7), fontSize: 11)),
        ],
      ),
      selected: selected,
      onSelected: onChanged,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    );
  }
}

/// A daily-goal option used in onboarding step 2.
class GoalOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final int minutes;
  final bool selected;
  final VoidCallback onTap;

  const GoalOption({
    super.key,
    required this.title,
    required this.subtitle,
    required this.minutes,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: selected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(
          selected ? Icons.check_rounded : Icons.schedule_rounded,
          color: selected
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurfaceVariant,
          size: 18,
        ),
      ),
      title: Text(title),
      subtitle: Text('$subtitle · $minutes min'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
