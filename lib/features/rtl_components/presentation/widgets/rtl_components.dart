import 'package:flutter/material.dart';

/// RTL-aware navigation row that reverses chevron direction and child order.
class RtlNavRow extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool rtl;
  final IconData? icon;

  const RtlNavRow({super.key, required this.label, required this.onTap, this.rtl = false, this.icon});

  @override
  Widget build(BuildContext context) {
    final chevron = rtl ? Icons.chevron_left_rounded : Icons.chevron_right_rounded;
    return ListTile(
      leading: icon != null ? Icon(icon) : null,
      title: Text(label, textDirection: rtl ? TextDirection.rtl : TextDirection.ltr),
      trailing: Icon(chevron),
      onTap: onTap,
    );
  }
}

/// An RTL-aware tab bar that mirrors the order of tabs.
class RtlTabBar extends StatelessWidget {
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;
  final bool rtl;

  const RtlTabBar({super.key, required this.labels, required this.selected, required this.onChanged, this.rtl = false});

  @override
  Widget build(BuildContext context) {
    final indices = rtl ? List.generate(labels.length, (i) => labels.length - 1 - i) : List.generate(labels.length, (i) => i);
    return Row(
      children: indices.map((i) => Expanded(
        child: GestureDetector(
          onTap: () => onChanged(i),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: selected == i ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1) : Colors.transparent,
              border: Border(bottom: BorderSide(color: selected == i ? Theme.of(context).colorScheme.primary : Colors.transparent, width: 2)),
            ),
            child: Text(labels[i], textAlign: TextAlign.center, style: TextStyle(color: selected == i ? Theme.of(context).colorScheme.primary : null)),
          ),
        ),
      )).toList(),
    );
  }
}
