import { Module } from '@nestjs/common';
import { AchievementsModule } from '../achievements/achievements.module';
import { ProgressModule } from '../progress/progress.module';
import { XpModule } from '../xp/xp.module';
import { QuizController } from './quiz.controller';
import { QuizService } from './quiz.service';

@Module({
  imports: [XpModule, ProgressModule, AchievementsModule],
  controllers: [QuizController],
  providers: [QuizService],
  exports: [QuizService],
})
export class QuizModule {}
