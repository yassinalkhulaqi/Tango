import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, MaxLength } from 'class-validator';
import { PaginationQueryDto } from '../../../common/pagination';

export class EnrollDto {
  @ApiPropertyOptional({ description: 'Course ID (use slug when omitted)' })
  @IsOptional()
  @IsString()
  courseId?: string;

  @ApiPropertyOptional({ description: 'Course slug' })
  @IsOptional()
  @IsString()
  slug?: string;
}

export class CompleteLessonDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(20000)
  codeSnapshot?: string;
}

export class ProgressQueryDto extends PaginationQueryDto {}
