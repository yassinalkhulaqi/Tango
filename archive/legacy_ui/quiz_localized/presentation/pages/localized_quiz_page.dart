import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/localized_widgets.dart';
import '../../../../core/localization/app_locale.dart';
import '../../../../core/localization/locale_format.dart';

class QuizData {
  final String question;
  final List<String> options;
  final int correct;

  const QuizData({required this.question, required this.options, required this.correct});
}

/// Localized quiz screen with per-question feedback and localized result.
class LocalizedQuizPage extends StatefulWidget {
  final AppLocale locale;
  final List<QuizData> questions;

  const LocalizedQuizPage({
    super.key,
    required this.locale,
    this.questions = const [
      QuizData(question: 'What is Flutter?', options: ['Framework', 'Language', 'Database', 'OS'], correct: 0),
      QuizData(question: 'Which keyword defines a class?', options: ['func', 'class', 'def', 'type'], correct: 1),
    ],
  });

  @override
  State<LocalizedQuizPage> createState() => _LocalizedQuizPageState();
}

class _LocalizedQuizPageState extends State<LocalizedQuizPage> {
  int _index = 0;
  int? _selected;
  int _score = 0;
  bool _finished = false;

  void _select(int option) {
    if (_selected != null) return;
    setState(() {
      _selected = option;
      if (option == widget.questions[_index].correct) _score++;
    });
  }

  void _next() {
    if (_index == widget.questions.length - 1) {
      setState(() => _finished = true);
    } else {
      setState(() {
        _index++;
        _selected = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_finished) return _Result(score: _score, total: widget.questions.length, locale: widget.locale);

    final question = widget.questions[_index];
    return Scaffold(
      appBar: AppBar(
        title: LocalizedText((l) => l.quizzes),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(value: (_index + 1) / widget.questions.length),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${l10n.question} ${_index + 1}/${widget.questions.length}',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              Text(question.question, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 24),
              ...List.generate(question.options.length, (i) {
                final selected = _selected == i;
                final correct = i == question.correct;
                final revealed = _selected != null;
                Color? color;
                if (revealed && correct) color = Colors.green;
                if (revealed && selected && !correct) color = Colors.red;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    title: Text(question.options[i]),
                    selected: selected,
                    selectedTileColor: color?.withAlpha(40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: color ?? Theme.of(context).dividerColor),
                    ),
                    onTap: () => _select(i),
                  ),
                );
              }),
              const Spacer(),
              if (_selected != null)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _next,
                    child: LocalizedText((l) => l.continueLabel),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Result extends StatelessWidget {
  final int score;
  final int total;
  final AppLocale locale;
  const _Result({required this.score, required this.total, required this.locale});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: LocalizedText((l) => l.quizComplete)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events_rounded, size: 72, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 24),
            Text('${LocaleFormat.number(score, locale)} / ${LocaleFormat.number(total, locale)}',
                style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 8),
            Text(l10n.score),
          ],
        ),
      ),
    );
  }
}
