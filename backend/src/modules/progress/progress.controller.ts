import { Body, Controller, Get, HttpCode, HttpStatus, Param, Post } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { AuthUser } from '../../common/types';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { CompleteLessonDto, EnrollDto } from './dto/progress.dto';
import { ProgressService } from './progress.service';

@ApiTags('progress')
@ApiBearerAuth()
@Controller('progress')
export class ProgressController {
  constructor(private readonly progress: ProgressService) {}

  @Post('enroll')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Enroll in a course' })
  async enroll(@CurrentUser() user: AuthUser, @Body() dto: EnrollDto) {
    return { data: await this.progress.enroll(user.id, dto) };
  }

  @Post('lessons/:lessonId/complete')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Complete a lesson and award XP' })
  async completeLesson(
    @CurrentUser() user: AuthUser,
    @Param('lessonId') lessonId: string,
    @Body() dto: CompleteLessonDto,
  ) {
    return { data: await this.progress.completeLesson(user.id, lessonId, dto) };
  }

  @Get('overall')
  @ApiOperation({ summary: 'Overall learner dashboard stats' })
  async overall(@CurrentUser() user: AuthUser) {
    return { data: await this.progress.overview(user.id) };
  }

  @Get('courses/:slug')
  @ApiOperation({ summary: 'Progress within a course' })
  async course(@CurrentUser() user: AuthUser, @Param('slug') slug: string) {
    return { data: await this.progress.courseProgress(user.id, slug) };
  }

  @Get('daily-quests')
  @ApiOperation({ summary: 'Today’s daily quests' })
  async quests(@CurrentUser() user: AuthUser) {
    return this.progress.dailyQuests(user.id);
  }
}
