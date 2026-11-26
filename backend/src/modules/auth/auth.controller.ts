import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Post,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { AuthUser } from '../../common/types';
import { ApiError } from '../../common/api-error';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { Public } from '../../common/decorators/public.decorator';
import { toPublicUser } from '../../common/mappers';
import { PrismaService } from '../../prisma/prisma.service';
import { AuthService } from './auth.service';
import {
  ForgotPasswordDto,
  LoginDto,
  LogoutDto,
  RefreshDto,
  RegisterDto,
} from './dto/auth.dto';

@ApiTags('auth')
@Controller('auth')
export class AuthController {
  constructor(
    private readonly auth: AuthService,
    private readonly prisma: PrismaService,
  ) {}

  @Public()
  @Post('register')
  @ApiOperation({ summary: 'Create a new learner account' })
  async register(@Body() dto: RegisterDto) {
    return { data: await this.auth.register(dto) };
  }

  @Public()
  @Post('login')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Authenticate with email and password' })
  async login(@Body() dto: LoginDto) {
    return { data: await this.auth.login(dto) };
  }

  @Public()
  @Post('refresh')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Rotate an access/refresh token pair' })
  async refresh(@Body() dto: RefreshDto) {
    return { data: await this.auth.refresh(dto.refreshToken) };
  }

  @Post('logout')
  @HttpCode(HttpStatus.OK)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Revoke refresh token(s)' })
  async logout(@CurrentUser() user: AuthUser, @Body() dto: LogoutDto) {
    return { data: await this.auth.logout(user.id, dto.refreshToken) };
  }

  @Public()
  @Post('forgot-password')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Request a password reset (stub, no email sent)' })
  async forgotPassword(@Body() dto: ForgotPasswordDto) {
    return { data: await this.auth.forgotPassword(dto) };
  }

  @Get('me')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get the authenticated user' })
  async me(@CurrentUser() user: AuthUser) {
    const record = await this.prisma.user.findUnique({ where: { id: user.id } });
    if (!record) {
      throw new ApiError(HttpStatus.NOT_FOUND, 'USER_NOT_FOUND', 'User not found');
    }
    return { data: toPublicUser(record) };
  }
}
