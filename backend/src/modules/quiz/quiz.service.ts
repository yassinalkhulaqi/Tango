import { HttpStatus, Injectable } from '@nestjs/common';
import { Prisma, QuestKind, QuizAttemptStatus, XPReason } from '@prisma/client';
import { ApiError } from '../../common/api-error';
import { paginate } from '../../common/pagination';
import { PrismaService } from '../../prisma/prisma.service';
import { AchievementsService } from '../achievements/achievements.service';
import { ProgressService } from '../progress/progress.service';
import { XpService } from '../xp/xp.service';
import { QuizAnswerInput } from './quiz-score';
import { SubmitQuizDto, QuizAttemptQueryDto } from './dto/quiz.dto';
import { scoreQuiz } from './quiz-score';

@Injectable()
export class QuizService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly xp: XpService,
    private readonly progress: ProgressService,
    private readonly achievements: AchievementsService,
  ) {}

  async getQuiz(id: string) {
    const quiz = await this.prisma.quiz.findUnique({
      where: { id },
      include: {
        questions: {
          orderBy: { order: 'asc' },
          include: { options: { orderBy: { order: 'asc' }, select: { id: true, label: true, order: true } } },
        },
      },
    });
    if (!quiz || !quiz.published) {
      throw new ApiError(HttpStatus.NOT_FOUND, 'QUIZ_NOT_FOUND', 'Quiz not found');
    }
    const { questions, ...meta } = quiz;
    return {
      ...meta,
      questions: questions.map((question) => ({
        id: question.id,
        prompt: question.prompt,
        explanation: question.explanation,
        order: question.order,
        options: question.options.map((option) => ({
          id: option.id,
          label: option.label,
          order: option.order,
        })),
      })),
    };
  }

  async submit(userId: string, quizId: string, dto: SubmitQuizDto) {
    const quiz = await this.prisma.quiz.findUnique({
      where: { id: quizId },
      include: { questions: { include: { options: true } } },
    });
    if (!quiz || !quiz.published) {
      throw new ApiError(HttpStatus.NOT_FOUND, 'QUIZ_NOT_FOUND', 'Quiz not found');
    }

    const validAnswers = new Map(
      quiz.questions.map((question) => [
        question.id,
        new Set(question.options.map((option) => option.id)),
      ]),
    );
    const answers: QuizAnswerInput[] = dto.answers.map((answer) => {
      const optionIds = validAnswers.get(answer.questionId);
      if (!optionIds || !optionIds.has(answer.optionId)) {
        throw new ApiError(
          HttpStatus.BAD_REQUEST,
          'INVALID_QUIZ_ANSWER',
          `Answer for question ${answer.questionId} is invalid`,
        );
      }
      return { questionId: answer.questionId, optionId: answer.optionId };
    });

    const result = scoreQuiz(quiz.questions, answers);
    const passed = result.totalQuestions > 0 && result.score >= quiz.passingScore;
    const attempt = await this.prisma.quizAttempt.create({
      data: {
        userId,
        quizId,
        score: result.score,
        totalQuestions: result.totalQuestions,
        correctAnswers: result.correctAnswers,
        passed,
        answers: answers as unknown as Prisma.InputJsonValue,
        status: passed ? QuizAttemptStatus.PASSED : QuizAttemptStatus.FAILED,
        completedAt: new Date(),
      },
    });

    let xpAwarded = 0;
    if (passed) {
      xpAwarded = quiz.xpReward;
      await this.xp.award(userId, xpAwarded, XPReason.QUIZ_PASS, quiz.id, `Quiz passed: ${quiz.title}`);
      await this.progress.advanceQuest(userId, QuestKind.QUIZZES, 1);
      await this.progress.advanceQuest(userId, QuestKind.XP, xpAwarded);
      await this.achievements.evaluate(userId);
    }

    return {
      attemptId: attempt.id,
      score: result.score,
      correctAnswers: result.correctAnswers,
      totalQuestions: result.totalQuestions,
      passed,
      xpAwarded,
    };
  }

  async myAttempts(userId: string, quizId: string, query: QuizAttemptQueryDto) {
    const limit = query.limit ?? 20;
    const rows = await this.prisma.quizAttempt.findMany({
      where: { userId, quizId },
      take: limit + 1,
      ...(query.cursor ? { cursor: { id: query.cursor }, skip: 1 } : {}),
      orderBy: { completedAt: 'desc' },
    });
    return paginate(rows, limit);
  }
}
