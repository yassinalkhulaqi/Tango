import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/localized_widgets.dart';
import '../../../../core/localization/app_locale.dart';

/// Localized lesson player with stepper, code block and action bar.
class LocalizedLessonPage extends StatefulWidget {
  final AppLocale locale;
  final String title;

  const LocalizedLessonPage({
    super.key,
    required this.locale,
    this.title = 'Flutter Basics',
  });

  @override
  State<LocalizedLessonPage> createState() => _LocalizedLessonPageState();
}

class _LocalizedLessonPageState extends State<LocalizedLessonPage> {
  int _section = 0;
  final int _total = 5;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: LocalizedText((l) => l.lessons),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border_rounded),
            onPressed: () {},
            tooltip: l10n.save,
          ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(value: (_section + 1) / _total),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  Text(l10n.codeExample, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const SelectableText(
                      'void main() {\n  print("Hello, CodeBro!");\n}',
                      style: TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: LocalizedText((l) => l.runCode),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _section > 0 ? () => setState(() => _section--) : null,
                    child: LocalizedText((l) => l.previousSection),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _section < _total - 1 ? () => setState(() => _section++) : null,
                    child: LocalizedText((l) => l.nextSection),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
