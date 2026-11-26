import { Transform } from 'class-transformer';
import { IsBooleanString, IsOptional } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { PaginationQueryDto } from '../../../common/pagination';

export class NotificationQueryDto extends PaginationQueryDto {
  @ApiPropertyOptional({ example: 'false' })
  @IsOptional()
  @IsBooleanString()
  @Transform(({ value }) => value === 'true' || value === true)
  read?: boolean;
}
