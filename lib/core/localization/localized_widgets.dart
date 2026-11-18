import 'package:flutter/material.dart';
import 'app_locale.dart';
import 'app_localizations.dart';
import 'locale_controller.dart';

/// Text widget that reads from the active locale with English fallback.
class LocalizedText extends StatelessWidget {
  final String Function(AppLocalizations l10n) selector;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  LocalizedText(
    this.selector, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Text(
      selector(strings),
      style: style,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
    );
  }
}

/// A compact chip showing a locale's native name.
class LocaleChip extends StatelessWidget {
  final AppLocale locale;
  final bool selected;
  final ValueChanged<AppLocale>? onSelected;

  LocaleChip({
    super.key,
    required this.locale,
    this.selected = false,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(locale.nativeName, textDirection: locale.direction),
      selected: selected,
      onSelected: onSelected == null ? null : (_) => onSelected!(locale),
      avatar: Icon(locale.isRtl ? Icons.language_rounded : Icons.language_outlined, size: 16),
    );
  }
}

/// Lists all supported locales grouped by writing direction.
class LocalePicker extends StatelessWidget {
  final AppLocale current;
  final ValueChanged<AppLocale> onChanged;

  const LocalePicker({
    super.key,
    required this.current,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(strings.selectLanguage, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Text(strings.rtlLanguages, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            for (final locale in AppLocaleHelper.rtlLocales)
              LocaleChip(locale: locale, selected: locale == current, onSelected: onChanged),
          ],
        ),
        const SizedBox(height: 16),
        Text(strings.ltrLanguages, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            for (final locale in AppLocaleHelper.ltrLocales)
              LocaleChip(locale: locale, selected: locale == current, onSelected: onChanged),
          ],
        ),
      ],
    );
  }
}

/// Scopes localized text and direction to a controller.
class LocalizationScope extends StatelessWidget {
  final LocaleController controller;
  final Widget child;

  const LocalizationScope({
    super.key,
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LocaleScope(
      controller: controller,
      child: Directionality(
        textDirection: controller.direction,
        child: child,
      ),
    );
  }
}
