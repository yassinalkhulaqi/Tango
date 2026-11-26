import { ConfigModule, ConfigService } from '@nestjs/config';
import { Global, Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';

@Global()
@Module({
  imports: [
    JwtModule.registerAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (config: ConfigService) => {
        const secret = config.get<string>('JWT_ACCESS_SECRET');
        if (!secret) throw new Error('JWT_ACCESS_SECRET must be configured');
        return {
          secret,
          signOptions: {
            expiresIn: config.get<string>('JWT_ACCESS_TTL') ?? '15m',
          },
        };
      },
    }),
  ],
  exports: [JwtModule],
})
export class AuthJwtModule {}
