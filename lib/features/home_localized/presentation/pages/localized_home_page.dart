import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/localized_widgets.dart';
import '../../../../core/localization/locale_format.dart';
import '../../../../core/localization/locale_controller.dart';
import '../../design_v2/presentation/widgets/premium_widgets.dart';

/// A localized home dashboard that reads all copy from [AppLocalizations]
/// and formats numbers through the active locale.
class LocalizedHomePage extends StatelessWidget {
  final LocaleController localeController;
  final String userName;
  final int streak;
  final int xp;
  final int level;
  final double progress;

  const LocalizedHomePage({
    super.key,
    required this.localeController,
    this.userName = 'Alex',
    this.streak = 12,
    this.xp = 2450,
    this.level = 7,
    this.progress = 0.6,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: LocalizedText((l) => l.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.language_rounded),
            onPressed: () => Navigator.of(context).pushNamed('/language'),
            tooltip: l10n.language,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Greeting(name: userName, l10n: l10n),
              const SizedBox(height: 20),
              _StreakCard(streak: streak, l10n: l10n, locale: localeController.locale),
              const SizedBox(height: 16),
              _XpCard(xp: xp, level: level, progress: progress, l10n: l10n, locale: localeController.locale),
              const SizedBox(height: 24),
              SectionHeader(title: l10n.continueLearning, actionLabel: l10n.seeAll, onAction: () {}),
              const SizedBox(height: 12),
              PremiumCard(
                title: l10n.courses,
                subtitle: l10n.lessons,
                icon: Icons.play_circle_rounded,
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {},
              ),
              const SizedBox(height: 24),
              SectionHeader(title: l10n.dailyQuests),
              const SizedBox(height: 12),
              PremiumCard(title: l10n.dailyChallenge, icon: Icons.flag_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  final String name;
  final AppLocalizations l10n;
  const _Greeting({required this.name, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.welcomeBack, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 4),
        Text('$name 👋', style: Theme.of(context).textTheme.headlineMedium),
      ],
    );
  }
}

class _StreakCard extends StatelessWidget {
  final int streak;
  final AppLocalizations l10n;
  final AppLocale locale;
  const _StreakCard({required this.streak, required this.l10n, required this.locale});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.tertiaryContainer,
            Theme.of(context).colorScheme.surfaceContainerHighest,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department_rounded, size: 32),
          const SizedBox(width: 12),
          Text(
            '${LocaleFormat.number(streak, locale)} ${l10n.dayStreak}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

class _XpCard extends StatelessWidget {
  final int xp;
  final int level;
  final double progress;
  final AppLocalizations l10n;
  final AppLocale locale;
  const _XpCard({
    required this.xp,
    required this.level,
    required this.progress,
    required this.l10n,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${l10n.level} ${LocaleFormat.number(level, locale)}',
                    style: Theme.of(context).textTheme.titleMedium),
                Text('${LocaleFormat.number(xp, locale)} ${l10n.totalXp}'),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: progress),
          ],
        ),
      ),
    );
  }
}
