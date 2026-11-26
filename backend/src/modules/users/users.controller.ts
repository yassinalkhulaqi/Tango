import { Body, Controller, Get, Patch, Param, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { AuthUser } from '../../common/types';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { SearchUsersDto, UpdateProfileDto, UpdateSettingsDto } from './dto/users.dto';
import { UsersService } from './users.service';

@ApiTags('users')
@ApiBearerAuth()
@Controller('users')
export class UsersController {
  constructor(private readonly users: UsersService) {}

  @Get('me')
  @ApiOperation({ summary: 'Get current user profile' })
  async me(@CurrentUser() user: AuthUser) {
    return { data: await this.users.me(user.id) };
  }

  @Patch('me')
  @ApiOperation({ summary: 'Update display name, avatar, bio or locale' })
  async updateProfile(@CurrentUser() user: AuthUser, @Body() dto: UpdateProfileDto) {
    return { data: await this.users.updateProfile(user.id, dto) };
  }

  @Get('settings')
  @ApiOperation({ summary: 'Get user settings' })
  async settings(@CurrentUser() user: AuthUser) {
    return { data: await this.users.getSettings(user.id) };
  }

  @Patch('settings')
  @ApiOperation({ summary: 'Update user settings' })
  async updateSettings(@CurrentUser() user: AuthUser, @Body() dto: UpdateSettingsDto) {
    return { data: await this.users.updateSettings(user.id, dto) };
  }

  @Get('search')
  @ApiOperation({ summary: 'Search users' })
  async search(@Query() query: SearchUsersDto) {
    return this.users.search(query);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get a public user profile' })
  async profile(@Param('id') id: string) {
    return { data: await this.users.publicProfile(id) };
  }
}
