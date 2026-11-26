import { Controller, Get, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { AuthUser } from '../../common/types';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { XpLedgerQueryDto } from './dto/xp.dto';
import { XpService } from './xp.service';

@ApiTags('xp')
@ApiBearerAuth()
@Controller('xp')
export class XpController {
  constructor(private readonly xp: XpService) {}

  @Get('ledger')
  @ApiOperation({ summary: 'Paginated XP transaction history' })
  async ledger(@CurrentUser() user: AuthUser, @Query() query: XpLedgerQueryDto) {
    return this.xp.ledger(user.id, query);
  }

  @Get('summary')
  @ApiOperation({ summary: 'XP totals and weekly earnings' })
  async summary(@CurrentUser() user: AuthUser) {
    return { data: await this.xp.summary(user.id) };
  }
}
