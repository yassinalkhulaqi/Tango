import { Module } from '@nestjs/common';
import { AchievementsModule } from '../achievements/achievements.module';
import { StreaksModule } from '../streaks/streaks.module';
import { XpModule } from '../xp/xp.module';
import { ProgressController } from './progress.controller';
import { ProgressService } from './progress.service';

@Module({
  imports: [XpModule, StreaksModule, AchievementsModule],
  controllers: [ProgressController],
  providers: [ProgressService],
  exports: [ProgressService],
})
export class ProgressModule {}
