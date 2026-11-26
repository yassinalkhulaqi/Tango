import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Locale } from '@prisma/client';
import { IsEmail, IsEnum, IsOptional, IsString, MaxLength, MinLength } from 'class-validator';

export class RegisterDto {
  @ApiProperty({ example: 'learner@codebro.app' })
  @IsEmail()
  @MaxLength(255)
  email: string;

  @ApiProperty({ minLength: 8, maxLength: 72, example: 'StrongPass123!' })
  @IsString()
  @MinLength(8)
  @MaxLength(72)
  password: string;

  @ApiProperty({ example: 'CodeBro Learner' })
  @IsString()
  @MinLength(2)
  @MaxLength(60)
  displayName: string;

  @ApiPropertyOptional({ enum: Locale, default: Locale.en })
  @IsOptional()
  @IsEnum(Locale)
  locale?: Locale;
}

export class LoginDto {
  @ApiProperty({ example: 'learner@codebro.app' })
  @IsEmail()
  email: string;

  @ApiProperty({ example: 'StrongPass123!' })
  @IsString()
  @MinLength(1)
  password: string;
}

export class RefreshDto {
  @ApiProperty({ description: 'Refresh token returned by login/register' })
  @IsString()
  @MinLength(1)
  refreshToken: string;
}

export class ForgotPasswordDto {
  @ApiProperty({ example: 'learner@codebro.app' })
  @IsEmail()
  email: string;
}

export class LogoutDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  refreshToken?: string;
}
