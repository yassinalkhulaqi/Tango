import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { FriendRequestStatus } from '@prisma/client';
import {
  IsEnum,
  IsIn,
  IsOptional,
  IsString,
  MaxLength,
  MinLength,
} from 'class-validator';
import { PaginationQueryDto } from '../../../common/pagination';

export class CreateFriendRequestDto {
  @ApiProperty()
  @IsString()
  @MinLength(1)
  receiverId: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(240)
  message?: string;
}

export class ListFriendRequestsDto extends PaginationQueryDto {
  @ApiPropertyOptional({ enum: ['incoming', 'outgoing'], default: 'incoming' })
  @IsOptional()
  @IsIn(['incoming', 'outgoing'])
  direction?: 'incoming' | 'outgoing';

  @ApiPropertyOptional({ enum: FriendRequestStatus })
  @IsOptional()
  @IsEnum(FriendRequestStatus)
  status?: FriendRequestStatus;
}

export class CreatePostDto {
  @ApiProperty()
  @IsString()
  @MinLength(1)
  @MaxLength(2000)
  content: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(500)
  imageUrl?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(10000)
  codeSnippet?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(30)
  language?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  courseId?: string;
}

export class ListPostsDto extends PaginationQueryDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  authorId?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  courseId?: string;
}

export class CreateCommentDto {
  @ApiProperty()
  @IsString()
  @MinLength(1)
  @MaxLength(1000)
  content: string;
}

export class ListCommentsDto extends PaginationQueryDto {}
