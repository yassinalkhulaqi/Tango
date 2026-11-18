import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/localized_widgets.dart';
import '../../../../core/localization/app_locale.dart';
import '../../../../core/localization/locale_format.dart';
import '../../../../core/localization/locale_controller.dart';
import '../../../design_v2/presentation/widgets/premium_widgets.dart';

/// Localized profile and settings page with language switching.
class LocalizedProfilePage extends StatelessWidget {
  final LocaleController localeController;
  final String name;
  final int level;
  final int xp;
  final int streak;

  const LocalizedProfilePage({
    super.key,
    required this.localeController,
    this.name = 'Alex Rivera',
    this.level = 7,
    this.xp = 2450,
    this.streak = 12,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = localeController.locale;
    return Scaffold(
      appBar: AppBar(title: LocalizedText((l) => l.profile)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CircleAvatar(
                radius: 48,
                child: Text(name.substring(0, 1), style: const TextStyle(fontSize: 32)),
              ),
              const SizedBox(height: 12),
              Text(name, style: Theme.of(context).textTheme.headlineSmall),
              Text('${l10n.level} ${LocaleFormat.number(level, locale)}',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),
              _StatsRow(xp: xp, streak: streak, locale: locale, l10n: l10n),
              const SizedBox(height: 24),
              SectionHeader(title: l10n.settings),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.language_rounded),
                title: LocalizedText((l) => l.language),
                subtitle: Text(locale.nativeName),
                onTap: () => Navigator.of(context).pushNamed('/language'),
              ),
              ListTile(
                leading: const Icon(Icons.notifications_rounded),
                title: LocalizedText((l) => l.notifications),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.logout_rounded),
                title: LocalizedText((l) => l.signOut),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final int xp;
  final int streak;
  final AppLocale locale;
  final AppLocalizations l10n;
  const _StatsRow({required this.xp, required this.streak, required this.locale, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _Stat(value: LocaleFormat.number(xp, locale), label: l10n.totalXp, icon: Icons.bolt_rounded)),
        const SizedBox(width: 12),
        Expanded(child: _Stat(value: LocaleFormat.number(streak, locale), label: l10n.streak, icon: Icons.local_fire_department_rounded)),
        const SizedBox(width: 12),
        Expanded(child: _Stat(value: '6', label: l10n.badges, icon: Icons.emoji_events_rounded)),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  const _Stat({required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.titleLarge),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
