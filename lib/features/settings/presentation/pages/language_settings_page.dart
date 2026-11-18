import 'package:flutter/material.dart';
import '../../../../core/localization/app_locale.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/localized_widgets.dart';
import '../../../../core/localization/locale_controller.dart';

/// Settings surface for choosing the interface language.
///
/// Arabic and Urdu are grouped as RTL so a reader can find their script
/// without scanning an English-only list. Changing the language updates the
/// controller, which mirrors the whole widget tree.
class LanguageSettingsPage extends StatelessWidget {
  final LocaleController controller;

  const LanguageSettingsPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: LocalizedText((l) => l.languageSettings)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.selectLanguage,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.digitsAccepted,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 24),
              LocalePicker(
                current: controller.locale,
                onChanged: (locale) => controller.setLocale(locale),
              ),
              const SizedBox(height: 32),
              _PreviewCard(locale: controller.locale),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  final AppLocale locale;
  const _PreviewCard({required this.locale});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locale.nativeName,
              textDirection: locale.direction,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              locale.englishName,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.language_rounded, size: 16),
                const SizedBox(width: 8),
                Text(locale.code.toUpperCase()),
                const Spacer(),
                if (locale.isRtl)
                  const Chip(label: Text('RTL')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
