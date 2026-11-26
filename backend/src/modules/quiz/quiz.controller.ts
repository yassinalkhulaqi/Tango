import { Body, Controller, Get, Param, Post, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { AuthUser } from '../../common/types';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { QuizAttemptQueryDto, SubmitQuizDto } from './dto/quiz.dto';
import { QuizService } from './quiz.service';

@ApiTags('quizzes')
@ApiBearerAuth()
@Controller('quizzes')
export class QuizController {
  constructor(private readonly quizzes: QuizService) {}

  @Get(':id')
  @ApiOperation({ summary: 'Get a quiz without revealing correct options' })
  async quiz(@Param('id') id: string) {
    return { data: await this.quizzes.getQuiz(id) };
  }

  @Post(':id/attempts')
  @ApiOperation({ summary: 'Submit answers, score the attempt and award XP' })
  async submit(
    @CurrentUser() user: AuthUser,
    @Param('id') id: string,
    @Body() dto: SubmitQuizDto,
  ) {
    return { data: await this.quizzes.submit(user.id, id, dto) };
  }

  @Get(':id/attempts')
  @ApiOperation({ summary: 'List my attempts for a quiz' })
  async attempts(
    @CurrentUser() user: AuthUser,
    @Param('id') id: string,
    @Query() query: QuizAttemptQueryDto,
  ) {
    return this.quizzes.myAttempts(user.id, id, query);
  }
}
