import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { APP_GUARD } from '@nestjs/core';
import { ThrottlerGuard, ThrottlerModule } from '@nestjs/throttler';
import { AuthJwtModule } from './common/jwt.module';
import { JwtAuthGuard } from './common/guards/jwt-auth.guard';
import { RolesGuard } from './common/guards/roles.guard';
import { PrismaModule } from './prisma/prisma.module';
import { RedisModule } from './redis/redis.module';
import { AchievementsModule } from './modules/achievements/achievements.module';
import { AuthModule } from './modules/auth/auth.module';
import { CoursesModule } from './modules/courses/courses.module';
import { HealthModule } from './modules/health/health.module';
import { LeaderboardModule } from './modules/leaderboard/leaderboard.module';
import { NotificationsModule } from './modules/notifications/notifications.module';
import { ProgressModule } from './modules/progress/progress.module';
import { QuizModule } from './modules/quiz/quiz.module';
import { SocialModule } from './modules/social/social.module';
import { StreaksModule } from './modules/streaks/streaks.module';
import { UsersModule } from './modules/users/users.module';
import { XpModule } from './modules/xp/xp.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true, envFilePath: ['.env'] }),
    ThrottlerModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (config: ConfigService) => [
        {
          ttl: Number(config.get<string>('THROTTLE_TTL') ?? 60000),
          limit: Number(config.get<string>('THROTTLE_LIMIT') ?? 100),
        },
      ],
    }),
    AuthJwtModule,
    PrismaModule,
    RedisModule,
    AuthModule,
    UsersModule,
    CoursesModule,
    XpModule,
    StreaksModule,
    AchievementsModule,
    ProgressModule,
    QuizModule,
    LeaderboardModule,
    SocialModule,
    NotificationsModule,
    HealthModule,
  ],
  providers: [
    { provide: APP_GUARD, useClass: ThrottlerGuard },
    { provide: APP_GUARD, useClass: JwtAuthGuard },
    { provide: APP_GUARD, useClass: RolesGuard },
  ],
})
export class AppModule {}
