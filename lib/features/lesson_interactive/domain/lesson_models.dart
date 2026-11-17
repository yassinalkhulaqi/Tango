import 'package:flutter/material.dart';

class Lesson {
  final String id;
  final String title;
  final String description;
  final String category;
  final int level;
  final int xpReward;
  final int estimatedMinutes;
  final List<LessonSection> sections;
  final List<LessonQuizQuestion> quizQuestions;
  final bool isLocked;
  final bool isCompleted;
  final DateTime? completedAt;
  final Map<String, dynamic> metadata;

  const Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.level,
    required this.xpReward,
    required this.estimatedMinutes,
    required this.sections,
    required this.quizQuestions,
    this.isLocked = false,
    this.isCompleted = false,
    this.completedAt,
    this.metadata = const {},
  });

  double get completionPercent {
    if (sections.isEmpty) return 0.0;
    final completed = sections.where((s) => s.isCompleted).length;
    return completed / sections.length;
  }

  int get totalSections => sections.length;

  int get completedSections => sections.where((s) => s.isCompleted).length;

  Lesson copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    int? level,
    int? xpReward,
    int? estimatedMinutes,
    List<LessonSection>? sections,
    List<LessonQuizQuestion>? quizQuestions,
    bool? isLocked,
    bool? isCompleted,
    DateTime? completedAt,
    Map<String, dynamic>? metadata,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      level: level ?? this.level,
      xpReward: xpReward ?? this.xpReward,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      sections: sections ?? this.sections,
      quizQuestions: quizQuestions ?? this.quizQuestions,
      isLocked: isLocked ?? this.isLocked,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      metadata: metadata ?? this.metadata,
    );
  }
}

class LessonSection {
  final String id;
  final String title;
  final String content;
  final String codeExample;
  final String explanation;
  final SectionType type;
  final bool isCompleted;
  final bool isLocked;
  final int order;
  final Map<String, dynamic> metadata;

  const LessonSection({
    required this.id,
    required this.title,
    required this.content,
    required this.codeExample,
    required this.explanation,
    required this.type,
    this.isCompleted = false,
    this.isLocked = false,
    required this.order,
    this.metadata = const {},
  });

  LessonSection copyWith({
    String? id,
    String? title,
    String? content,
    String? codeExample,
    String? explanation,
    SectionType? type,
    bool? isCompleted,
    bool? isLocked,
    int? order,
    Map<String, dynamic>? metadata,
  }) {
    return LessonSection(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      codeExample: codeExample ?? this.codeExample,
      explanation: explanation ?? this.explanation,
      type: type ?? this.type,
      isCompleted: isCompleted ?? this.isCompleted,
      isLocked: isLocked ?? this.isLocked,
      order: order ?? this.order,
      metadata: metadata ?? this.metadata,
    );
  }
}

enum SectionType {
  theory,
  code,
  interactive,
  quiz,
  challenge,
  summary,
}

class LessonQuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final int points;
  final bool isAnswered;
  final int? selectedAnswer;
  final bool isCorrect;

  const LessonQuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.points,
    this.isAnswered = false,
    this.selectedAnswer,
    this.isCorrect = false,
  });

  LessonQuizQuestion copyWith({
    String? id,
    String? question,
    List<String>? options,
    int? correctIndex,
    String? explanation,
    int? points,
    bool? isAnswered,
    int? selectedAnswer,
    bool? isCorrect,
  }) {
    return LessonQuizQuestion(
      id: id ?? this.id,
      question: question ?? this.question,
      options: options ?? this.options,
      correctIndex: correctIndex ?? this.correctIndex,
      explanation: explanation ?? this.explanation,
      points: points ?? this.points,
      isAnswered: isAnswered ?? this.isAnswered,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }
}

class LessonProgress {
  final String lessonId;
  final int currentSectionIndex;
  final Map<String, bool> sectionCompletion;
  final Map<String, LessonQuizQuestion> quizAnswers;
  final int xpEarned;
  final bool isCompleted;
  final DateTime? startedAt;
  final DateTime? completedAt;

  const LessonProgress({
    required this.lessonId,
    required this.currentSectionIndex,
    this.sectionCompletion = const {},
    this.quizAnswers = const {},
    this.xpEarned = 0,
    this.isCompleted = false,
    this.startedAt,
    this.completedAt,
  });

  double get completionPercent {
    if (sectionCompletion.isEmpty) return 0.0;
    final completed = sectionCompletion.values.where((v) => v).length;
    return completed / sectionCompletion.length;
  }

  LessonProgress copyWith({
    String? lessonId,
    int? currentSectionIndex,
    Map<String, bool>? sectionCompletion,
    Map<String, LessonQuizQuestion>? quizAnswers,
    int? xpEarned,
    bool? isCompleted,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return LessonProgress(
      lessonId: lessonId ?? this.lessonId,
      currentSectionIndex: currentSectionIndex ?? this.currentSectionIndex,
      sectionCompletion: sectionCompletion ?? this.sectionCompletion,
      quizAnswers: quizAnswers ?? this.quizAnswers,
      xpEarned: xpEarned ?? this.xpEarned,
      isCompleted: isCompleted ?? this.isCompleted,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

class CodeDiff {
  final String originalCode;
  final String modifiedCode;
  final List<DiffChange> changes;
  final bool hasDifferences;

  const CodeDiff({
    required this.originalCode,
    required this.modifiedCode,
    required this.changes,
    required this.hasDifferences,
  });

  factory CodeDiff.empty() {
    return const CodeDiff(
      originalCode: '',
      modifiedCode: '',
      changes: [],
      hasDifferences: false,
    );
  }
}

class DiffChange {
  final int lineNumber;
  final String originalLine;
  final String modifiedLine;
  final DiffType type;

  const DiffChange({
    required this.lineNumber,
    required this.originalLine,
    required this.modifiedLine,
    required this.type,
  });
}

enum DiffType {
  added,
  removed,
  changed,
  unchanged,
}

class LessonSession {
  final String id;
  final String lessonId;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int timeSpentSeconds;
  final int attempts;
  final int hintsUsed;
  final bool isCompleted;
  final Map<String, dynamic> metadata;

  const LessonSession({
    required this.id,
    required this.lessonId,
    required this.startedAt,
    this.completedAt,
    this.timeSpentSeconds = 0,
    this.attempts = 0,
    this.hintsUsed = 0,
    this.isCompleted = false,
    this.metadata = const {},
  });

  double get completionRate {
    return isCompleted ? 1.0 : 0.0;
  }
}
