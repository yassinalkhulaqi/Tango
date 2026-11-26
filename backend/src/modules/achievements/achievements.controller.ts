import { Controller, Get, HttpCode, HttpStatus, Post, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { AuthUser } from '../../common/types';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { AchievementsService } from './achievements.service';
import { AchievementsQueryDto } from './dto/achievements.dto';

@ApiTags('achievements')
@ApiBearerAuth()
@Controller('achievements')
export class AchievementsController {
  constructor(private readonly achievements: AchievementsService) {}

  @Get('badges')
  @ApiOperation({ summary: 'List all badges' })
  async badges(@Query() query: AchievementsQueryDto) {
    return this.achievements.listBadges(query);
  }

  @Get('me')
  @ApiOperation({ summary: 'List badges unlocked by the current user' })
  async mine(@CurrentUser() user: AuthUser, @Query() query: AchievementsQueryDto) {
    return this.achievements.myBadges(user.id, query);
  }

  @Post('evaluate')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Evaluate and unlock earned badges' })
  async evaluate(@CurrentUser() user: AuthUser) {
    return { data: await this.achievements.evaluate(user.id) };
  }
}
