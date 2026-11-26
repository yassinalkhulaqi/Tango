import { Controller, Get, HttpCode, HttpStatus, Post, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { AuthUser } from '../../common/types';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { StreakQueryDto } from './dto/streaks.dto';
import { StreaksService } from './streaks.service';

@ApiTags('streaks')
@ApiBearerAuth()
@Controller('streaks')
export class StreaksController {
  constructor(private readonly streaks: StreaksService) {}

  @Post('check-in')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Check in for today and advance the streak' })
  async checkIn(@CurrentUser() user: AuthUser) {
    return { data: await this.streaks.checkIn(user.id) };
  }

  @Post('freeze')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Consume a streak freeze for today' })
  async freeze(@CurrentUser() user: AuthUser) {
    return { data: await this.streaks.freeze(user.id) };
  }

  @Get('stats')
  @ApiOperation({ summary: 'Streak summary and event history' })
  async stats(@CurrentUser() user: AuthUser, @Query() query: StreakQueryDto) {
    return this.streaks.stats(user.id, query);
  }
}
