import { Module } from '@nestjs/common';
import { LeaderboardModule } from '../leaderboard/leaderboard.module';
import { SocialController } from './social.controller';
import { SocialService } from './social.service';

@Module({
  imports: [LeaderboardModule],
  controllers: [SocialController],
  providers: [SocialService],
  exports: [SocialService],
})
export class SocialModule {}
