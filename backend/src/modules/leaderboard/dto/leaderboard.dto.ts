import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsEnum, IsOptional } from 'class-validator';
import { PaginationQueryDto } from '../../../common/pagination';
import { LeaderboardPeriod, LEADERBOARD_PERIODS } from '../leaderboard.keys';

export class LeaderboardQueryDto extends PaginationQueryDto {
  @ApiPropertyOptional({ enum: LEADERBOARD_PERIODS, default: 'allTime' })
  @IsOptional()
  @IsEnum(LEADERBOARD_PERIODS)
  period?: LeaderboardPeriod;
}
