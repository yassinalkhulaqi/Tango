import 'package:flutter/material.dart';
import './lesson_models.dart';

class LessonController extends ChangeNotifier {
  Lesson _lesson;
  LessonProgress _progress;
  String _currentCode = '';
  int _currentSectionIndex = 0;
  int _currentQuizQuestionIndex = 0;
  int? _selectedQuizAnswer;
  bool _showQuizResult = false;
  bool _isRunningCode = false;
  String _codeOutput = '';
  bool _isSubmittingQuiz = false;
  bool _isMarkingComplete = false;
  final List<String> _hintHistory = [];
  int _attempts = 0;

  LessonController({required Lesson lesson, required LessonProgress progress})
    : _lesson = lesson,
      _progress = progress {
    _currentCode = _lesson.sections.isNotEmpty
        ? _lesson.sections.first.codeExample
        : '';
    _currentSectionIndex = 0;
  }

  Lesson get lesson => _lesson;
  LessonProgress get progress => _progress;
  String get currentCode => _currentCode;
  int get currentSectionIndex => _currentSectionIndex;
  int get currentQuizQuestionIndex => _currentQuizQuestionIndex;
  int? get selectedQuizAnswer => _selectedQuizAnswer;
  bool get showQuizResult => _showQuizResult;
  bool get isRunningCode => _isRunningCode;
  String get codeOutput => _codeOutput;
  bool get isSubmittingQuiz => _isSubmittingQuiz;
  bool get isMarkingComplete => _isMarkingComplete;
  List<String> get hintHistory => List.unmodifiable(_hintHistory);
  int get attempts => _attempts;

  LessonSection get currentSection {
    if (_currentSectionIndex >= 0 &&
        _currentSectionIndex < _lesson.sections.length) {
      return _lesson.sections[_currentSectionIndex];
    }
    return _lesson.sections.first;
  }

  LessonQuizQuestion? get currentQuizQuestion {
    if (_currentQuizQuestionIndex >= 0 &&
        _currentQuizQuestionIndex < _lesson.quizQuestions.length) {
      return _lesson.quizQuestions[_currentQuizQuestionIndex];
    }
    return null;
  }

  bool get isLastSection => _currentSectionIndex >= _lesson.sections.length - 1;

  bool get isLastQuizQuestion =>
      _currentQuizQuestionIndex >= _lesson.quizQuestions.length - 1;

  double get sectionProgress {
    if (_lesson.sections.isEmpty) return 0.0;
    return (_currentSectionIndex + 1) / _lesson.sections.length;
  }

  double get quizProgress {
    if (_lesson.quizQuestions.isEmpty) return 0.0;
    return (_currentQuizQuestionIndex + 1) / _lesson.quizQuestions.length;
  }

  bool get sectionCompleted {
    return _progress.sectionCompletion[currentSection.id] ?? false;
  }

  bool get canProceedToNextSection {
    return sectionCompleted || currentSection.type != SectionType.quiz;
  }

  void setCode(String code) {
    _currentCode = code;
    notifyListeners();
  }

  void setSection(int index) {
    if (index >= 0 && index < _lesson.sections.length) {
      _currentSectionIndex = index;
      _currentCode = _lesson.sections[index].codeExample;
      _selectedQuizAnswer = null;
      _showQuizResult = false;
      _codeOutput = '';
      notifyListeners();
    }
  }

  void nextSection() {
    if (!isLastSection) {
      setSection(_currentSectionIndex + 1);
    }
  }

  void previousSection() {
    if (_currentSectionIndex > 0) {
      setSection(_currentSectionIndex - 1);
    }
  }

  void markSectionCompleted() {
    _progress = _progress.copyWith(
      sectionCompletion: {
        ..._progress.sectionCompletion,
        currentSection.id: true,
      },
      currentSectionIndex: _currentSectionIndex < _lesson.sections.length - 1
          ? _currentSectionIndex + 1
          : _currentSectionIndex,
    );
    _attempts++;
    notifyListeners();
  }

  void selectQuizAnswer(int answerIndex) {
    _selectedQuizAnswer = answerIndex;
    _showQuizResult = true;
    _attempts++;
    notifyListeners();
  }

  bool get isQuizAnswerCorrect {
    if (_selectedQuizAnswer == null) return false;
    return _selectedQuizAnswer == currentQuizQuestion?.correctIndex;
  }

  void nextQuizQuestion() {
    if (!isLastQuizQuestion) {
      _currentQuizQuestionIndex++;
      _selectedQuizAnswer = null;
      _showQuizResult = false;
      notifyListeners();
    }
  }

  void previousQuizQuestion() {
    if (_currentQuizQuestionIndex > 0) {
      _currentQuizQuestionIndex--;
      _selectedQuizAnswer = null;
      _showQuizResult = false;
      notifyListeners();
    }
  }

  void submitQuiz() {
    _isSubmittingQuiz = true;
    notifyListeners();
  }

  void finishQuizSubmission() {
    _isSubmittingQuiz = false;
    notifyListeners();
  }

  void runCode() {
    _isRunningCode = true;
    _codeOutput = 'Running code...\n';
    notifyListeners();

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      _codeOutput += _executeCode(_currentCode);
      _codeOutput += '\nExecution completed in 240ms.';
      _isRunningCode = false;
      notifyListeners();
    });
  }

  String _executeCode(String code) {
    if (code.contains('print(')) {
      return 'Hello, CodeBro!\nCode executed successfully.';
    }
    return 'No output generated.';
  }

  void clearOutput() {
    _codeOutput = '';
    notifyListeners();
  }

  void useHint(String hint) {
    _hintHistory.add(hint);
    notifyListeners();
  }

  void clearHints() {
    _hintHistory.clear();
    notifyListeners();
  }

  void markLessonComplete() {
    _isMarkingComplete = true;
    notifyListeners();

    Future.delayed(const Duration(seconds: 1), () {
      _progress = _progress.copyWith(
        isCompleted: true,
        completedAt: DateTime.now(),
        xpEarned: _lesson.xpReward,
      );
      _isMarkingComplete = false;
      notifyListeners();
    });
  }

  CodeDiff getCodeDiff(String originalCode) {
    final originalLines = originalCode.split('\n');
    final modifiedLines = _currentCode.split('\n');
    final changes = <DiffChange>[];
    final maxLength = originalLines.length > modifiedLines.length
        ? originalLines.length
        : modifiedLines.length;

    for (int i = 0; i < maxLength; i++) {
      final original = i < originalLines.length ? originalLines[i] : '';
      final modified = i < modifiedLines.length ? modifiedLines[i] : '';
      if (original == modified) {
        changes.add(
          DiffChange(
            lineNumber: i + 1,
            originalLine: original,
            modifiedLine: modified,
            type: DiffType.unchanged,
          ),
        );
      } else if (original.isEmpty) {
        changes.add(
          DiffChange(
            lineNumber: i + 1,
            originalLine: '',
            modifiedLine: modified,
            type: DiffType.added,
          ),
        );
      } else if (modified.isEmpty) {
        changes.add(
          DiffChange(
            lineNumber: i + 1,
            originalLine: original,
            modifiedLine: '',
            type: DiffType.removed,
          ),
        );
      } else {
        changes.add(
          DiffChange(
            lineNumber: i + 1,
            originalLine: original,
            modifiedLine: modified,
            type: DiffType.changed,
          ),
        );
      }
    }

    return CodeDiff(
      originalCode: originalCode,
      modifiedCode: _currentCode,
      changes: changes,
      hasDifferences: _currentCode != originalCode,
    );
  }

  void resetProgress() {
    _progress = LessonProgress(
      lessonId: _lesson.id,
      currentSectionIndex: 0,
      sectionCompletion: {},
      quizAnswers: {},
      xpEarned: 0,
      isCompleted: false,
    );
    _currentSectionIndex = 0;
    _currentCode = _lesson.sections.isNotEmpty
        ? _lesson.sections.first.codeExample
        : '';
    _selectedQuizAnswer = null;
    _showQuizResult = false;
    _codeOutput = '';
    _hintHistory.clear();
    _attempts = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class LessonDataService {
  static List<Lesson> get sampleLessons => [
    Lesson(
      id: 'flutter-basics-1',
      title: 'Flutter Basics',
      description: 'Learn the fundamentals of Flutter development',
      category: 'Flutter',
      level: 1,
      xpReward: 50,
      estimatedMinutes: 15,
      sections: [
        LessonSection(
          id: 'intro',
          title: 'Introduction to Flutter',
          content:
              'Flutter is Google\'s UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.',
          codeExample: 'void main() {\n  runApp(const MyApp());\n}',
          explanation:
              'The main function is the entry point of every Dart application.',
          type: SectionType.theory,
          order: 1,
        ),
        LessonSection(
          id: 'widgets',
          title: 'Understanding Widgets',
          content:
              'Everything in Flutter is a widget. Widgets are the building blocks of your app\'s user interface.',
          codeExample:
              'class MyApp extends StatelessWidget {\n  @override\n  Widget build(BuildContext context) {\n    return MaterialApp(\n      home: Scaffold(\n        body: Center(child: Text(\'Hello Flutter!\')),\n      ),\n    );\n  }\n}',
          explanation:
              'StatelessWidget is immutable and rebuilds when its configuration changes.',
          type: SectionType.code,
          order: 2,
        ),
        LessonSection(
          id: 'interactive',
          title: 'Interactive Counter',
          content:
              'Learn how to manage state with StatefulWidget and create interactive UIs.',
          codeExample:
              'class CounterWidget extends StatefulWidget {\n  @override\n  _CounterWidgetState createState() => _CounterWidgetState();\n}\n\nclass _CounterWidgetState extends State<CounterWidget> {\n  int _count = 0;\n  void _increment() => setState(() => _count++);\n}',
          explanation:
              'StatefulWidget allows you to modify the UI based on user interactions.',
          type: SectionType.interactive,
          order: 3,
        ),
        LessonSection(
          id: 'quiz',
          title: 'Knowledge Check',
          content: 'Test your understanding of Flutter basics.',
          codeExample: '',
          explanation: 'Answer the questions to proceed.',
          type: SectionType.quiz,
          order: 4,
        ),
        LessonSection(
          id: 'summary',
          title: 'Summary',
          content:
              'You\'ve learned the basics of Flutter! Continue to the next lesson.',
          codeExample: '',
          explanation: 'Great job completing this lesson.',
          type: SectionType.summary,
          order: 5,
        ),
      ],
      quizQuestions: [
        LessonQuizQuestion(
          id: 'q1',
          question: 'What is the entry point of a Dart application?',
          options: ['start()', 'main()', 'init()', 'run()'],
          correctIndex: 1,
          explanation: 'The main() function is where execution begins.',
          points: 10,
        ),
        LessonQuizQuestion(
          id: 'q2',
          question: 'Which widget is immutable in Flutter?',
          options: ['StatefulWidget', 'StatelessWidget', 'Both', 'Neither'],
          correctIndex: 1,
          explanation:
              'StatelessWidget cannot change its state after being built.',
          points: 10,
        ),
        LessonQuizQuestion(
          id: 'q3',
          question: 'What method rebuilds a widget\'s UI?',
          options: ['build()', 'render()', 'display()', 'show()'],
          correctIndex: 0,
          explanation:
              'The build() method describes how to display the widget.',
          points: 10,
        ),
      ],
      isLocked: false,
      isCompleted: false,
    ),
    Lesson(
      id: 'flutter-basics-2',
      title: 'Layouts & Navigation',
      description: 'Master Flutter layouts and screen navigation',
      category: 'Flutter',
      level: 2,
      xpReward: 75,
      estimatedMinutes: 20,
      sections: [
        LessonSection(
          id: 'columns-rows',
          title: 'Column and Row',
          content:
              'Use Column and Row to arrange widgets vertically and horizontally.',
          codeExample:
              'Column(\n  children: [\n    Text(\'First\'),\n    Text(\'Second\'),\n  ],\n)',
          explanation:
              'Column arranges children vertically, Row arranges horizontally.',
          type: SectionType.theory,
          order: 1,
        ),
        LessonSection(
          id: 'containers',
          title: 'Container Widget',
          content:
              'Container is a convenience widget that combines common painting, positioning, and sizing widgets.',
          codeExample:
              'Container(\n  padding: EdgeInsets.all(16),\n  decoration: BoxDecoration(\n    color: Colors.blue,\n    borderRadius: BorderRadius.circular(8),\n  ),\n  child: Text(\'Box\'),\n)',
          explanation: 'Container is one of the most used widgets in Flutter.',
          type: SectionType.code,
          order: 2,
        ),
        LessonSection(
          id: 'navigation',
          title: 'Screen Navigation',
          content:
              'Navigate between screens using Navigator.push and Navigator.pop.',
          codeExample:
              'Navigator.push(\n  context,\n  MaterialPageRoute(builder: (context) => SecondScreen()),\n)',
          explanation:
              'Navigator manages a stack of routes for screen transitions.',
          type: SectionType.interactive,
          order: 3,
        ),
      ],
      quizQuestions: [
        LessonQuizQuestion(
          id: 'q1',
          question: 'Which widget arranges children vertically?',
          options: ['Row', 'Column', 'Stack', 'Container'],
          correctIndex: 1,
          explanation: 'Column arranges its children in a vertical array.',
          points: 10,
        ),
      ],
      isLocked: true,
      isCompleted: false,
    ),
    Lesson(
      id: 'python-basics-1',
      title: 'Python Basics',
      description: 'Introduction to Python programming',
      category: 'Python',
      level: 1,
      xpReward: 50,
      estimatedMinutes: 15,
      sections: [
        LessonSection(
          id: 'hello-world',
          title: 'Hello World',
          content: 'Your first Python program prints text to the console.',
          codeExample: 'print("Hello, World!")',
          explanation: 'The print() function outputs text to the console.',
          type: SectionType.theory,
          order: 1,
        ),
        LessonSection(
          id: 'variables',
          title: 'Variables',
          content: 'Store data in variables for later use.',
          codeExample: 'name = "CodeBro"\nage = 25\nprint(name, age)',
          explanation: 'Python variables are dynamically typed.',
          type: SectionType.code,
          order: 2,
        ),
      ],
      quizQuestions: [
        LessonQuizQuestion(
          id: 'q1',
          question: 'What does print() do in Python?',
          options: [
            'Displays text',
            'Calculates math',
            'Creates variables',
            'Deletes files',
          ],
          correctIndex: 0,
          explanation: 'print() outputs text to the console.',
          points: 10,
        ),
      ],
      isLocked: false,
      isCompleted: false,
    ),
  ];

  static Lesson getLessonById(String id) {
    try {
      return sampleLessons.firstWhere((l) => l.id == id);
    } catch (_) {
      return sampleLessons.first;
    }
  }

  static List<Lesson> getLessonsByCategory(String category) {
    return sampleLessons.where((l) => l.category == category).toList();
  }

  static List<String> get categories =>
      sampleLessons.map((l) => l.category).toSet().toList();
}
