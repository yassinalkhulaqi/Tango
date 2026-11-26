import { HttpStatus } from '@nestjs/common';
import { XPReason } from '@prisma/client';
import { ApiError } from '../../common/api-error';
import { QuizService } from './quiz.service';
import { SubmitQuizDto } from './dto/quiz.dto';

const quiz = {
  id: 'quiz-1',
  title: 'Checkpoint',
  slug: 'checkpoint',
  published: true,
  passingScore: 70,
  xpReward: 50,
  questions: [
    {
      id: 'q1',
      prompt: 'Two plus two?',
      explanation: 'Basic arithmetic',
      order: 1,
      options: [
        { id: 'a1', label: '3', isCorrect: false },
        { id: 'a2', label: '4', isCorrect: true },
      ],
    },
    {
      id: 'q2',
      prompt: 'Sky colour?',
      explanation: null,
      order: 2,
      options: [{ id: 'b1', label: 'Blue', isCorrect: true }],
    },
  ],
};

function buildService() {
  const prisma = {
    quiz: { findUnique: jest.fn().mockResolvedValue(quiz) },
    quizAttempt: { create: jest.fn().mockResolvedValue({ id: 'attempt-1' }) },
  };
  const xp = { award: jest.fn().mockResolvedValue({ xp: 50, level: 1, leveledUp: false }) };
  const progress = { advanceQuest: jest.fn().mockResolvedValue(undefined) };
  const achievements = { evaluate: jest.fn().mockResolvedValue({ evaluated: 0, unlocked: [] }) };
  const service = new QuizService(
    prisma as never,
    xp as never,
    progress as never,
    achievements as never,
  );
  return { service, prisma, xp, progress, achievements };
}

describe('QuizService', () => {
  it('hides correct options when returning a quiz', async () => {
    const { service } = buildService();
    const result = await service.getQuiz('quiz-1');
    expect(result.questions).toHaveLength(2);
    for (const question of result.questions) {
      for (const option of question.options) {
        expect(option).not.toHaveProperty('isCorrect');
      }
    }
  });

  it('grades a fully correct attempt and awards XP', async () => {
    const { service, prisma, xp, progress, achievements } = buildService();
    const dto: SubmitQuizDto = {
      answers: [
        { questionId: 'q1', optionId: 'a2' },
        { questionId: 'q2', optionId: 'b1' },
      ],
    };
    const result = await service.submit('user-1', 'quiz-1', dto);
    expect(result).toMatchObject({ score: 100, correctAnswers: 2, passed: true, xpAwarded: 50 });
    expect(prisma.quizAttempt.create).toHaveBeenCalled();
    expect(xp.award).toHaveBeenCalledWith('user-1', 50, XPReason.QUIZ_PASS, 'quiz-1', expect.any(String));
    expect(progress.advanceQuest).toHaveBeenCalledTimes(2);
    expect(achievements.evaluate).toHaveBeenCalledWith('user-1');
  });

  it('does not award XP for a failed attempt', async () => {
    const { service, xp } = buildService();
    const dto: SubmitQuizDto = { answers: [{ questionId: 'q1', optionId: 'a1' }] };
    const result = await service.submit('user-1', 'quiz-1', dto);
    expect(result.passed).toBe(false);
    expect(result.score).toBe(0);
    expect(xp.award).not.toHaveBeenCalled();
  });

  it('rejects an answer that does not belong to a question', async () => {
    const { service } = buildService();
    const dto: SubmitQuizDto = { answers: [{ questionId: 'q1', optionId: 'missing' }] };
    await expect(service.submit('user-1', 'quiz-1', dto)).rejects.toMatchObject({
      status: HttpStatus.BAD_REQUEST,
      code: 'INVALID_QUIZ_ANSWER',
    });
  });

  it('throws when the quiz is missing', async () => {
    const { service, prisma } = buildService();
    prisma.quiz.findUnique.mockResolvedValueOnce(null);
    await expect(service.getQuiz('missing')).rejects.toBeInstanceOf(ApiError);
  });
});
