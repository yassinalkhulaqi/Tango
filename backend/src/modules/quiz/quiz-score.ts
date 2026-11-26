export interface ScoringQuestion {
  id: string;
  options: Array<{ id: string; isCorrect: boolean }>;
}

export interface QuizAnswerInput {
  questionId: string;
  optionId: string;
}

export interface QuizScore {
  correctAnswers: number;
  totalQuestions: number;
  score: number;
}

export function scoreQuiz(
  questions: ScoringQuestion[],
  answers: QuizAnswerInput[],
): QuizScore {
  const correctOptionByQuestion = new Map(
    questions.map((question) => [
      question.id,
      question.options.find((option) => option.isCorrect)?.id,
    ]),
  );
  const seen = new Set<string>();
  let correctAnswers = 0;

  for (const answer of answers) {
    if (seen.has(answer.questionId)) continue;
    seen.add(answer.questionId);
    if (correctOptionByQuestion.get(answer.questionId) === answer.optionId) {
      correctAnswers += 1;
    }
  }

  const totalQuestions = questions.length;
  return {
    correctAnswers,
    totalQuestions,
    score: totalQuestions === 0 ? 0 : Math.round((correctAnswers / totalQuestions) * 100),
  };
}
