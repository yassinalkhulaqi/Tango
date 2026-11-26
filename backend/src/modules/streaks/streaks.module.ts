import { Module } from '@nestjs/common';
import { XpModule } from '../xp/xp.module';
import { StreaksController } from './streaks.controller';
import { StreaksService } from './streaks.service';

@Module({
  imports: [XpModule],
  controllers: [StreaksController],
  providers: [StreaksService],
  exports: [StreaksService],
})
export class StreaksModule {}
