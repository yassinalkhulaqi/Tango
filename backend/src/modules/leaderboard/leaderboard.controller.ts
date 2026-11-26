import { Controller, Get, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { AuthUser } from '../../common/types';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { LeaderboardQueryDto } from './dto/leaderboard.dto';
import { LeaderboardPeriod } from './leaderboard.keys';
import { LeaderboardService } from './leaderboard.service';

@ApiTags('leaderboard')
@ApiBearerAuth()
@Controller('leaderboard')
export class LeaderboardController {
  constructor(private readonly leaderboard: LeaderboardService) {}

  @Get()
  @ApiOperation({ summary: 'Ranked learners (weekly, monthly, all-time or friends)' })
  async list(@CurrentUser() user: AuthUser, @Query() query: LeaderboardQueryDto) {
    return this.leaderboard.list(user.id, query);
  }

  @Get('me')
  @ApiOperation({ summary: 'Current user rank for a leaderboard period' })
  async me(
    @CurrentUser() user: AuthUser,
    @Query('period') period?: LeaderboardPeriod,
  ) {
    return {
      data: await this.leaderboard.myRank(user.id, period ?? 'allTime'),
    };
  }
}
