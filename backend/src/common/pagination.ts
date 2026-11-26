import { ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsInt, IsOptional, IsString, Max, Min } from 'class-validator';

export class PaginationQueryDto {
  @ApiPropertyOptional({ minimum: 1, maximum: 100, default: 20 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  limit = 20;

  @ApiPropertyOptional({ description: 'Cursor from meta.nextCursor' })
  @IsOptional()
  @IsString()
  cursor?: string;
}

export interface PaginationMeta {
  nextCursor: string | null;
  hasMore: boolean;
  total?: number;
}

export interface Paginated<T> {
  data: T[];
  meta: PaginationMeta;
}

export function paginate<T extends { id: string }>(
  items: T[],
  limit: number,
  total?: number,
): Paginated<T> {
  const hasMore = items.length > limit;
  const data = hasMore ? items.slice(0, limit) : items;
  return {
    data,
    meta: {
      nextCursor: hasMore && data.length > 0 ? data[data.length - 1].id : null,
      hasMore,
      ...(total !== undefined ? { total } : {}),
    },
  };
}

export function paginateOffset<T>(
  items: T[],
  limit: number,
  offset: number,
  total: number,
): Paginated<T> {
  const hasMore = offset + items.length < total;
  return {
    data: items,
    meta: {
      nextCursor: hasMore ? String(offset + items.length) : null,
      hasMore,
      total,
    },
  };
}
