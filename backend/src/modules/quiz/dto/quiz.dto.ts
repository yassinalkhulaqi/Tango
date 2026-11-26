import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { ArrayMaxSize, IsArray, IsString, ValidateNested } from 'class-validator';
import { PaginationQueryDto } from '../../../common/pagination';

export class QuizAnswerDto {
  @ApiProperty()
  @IsString()
  questionId: string;

  @ApiProperty()
  @IsString()
  optionId: string;
}

export class SubmitQuizDto {
  @ApiProperty({ type: [QuizAnswerDto] })
  @IsArray()
  @ArrayMaxSize(100)
  @ValidateNested({ each: true })
  @Type(() => QuizAnswerDto)
  answers: QuizAnswerDto[];
}

export class QuizAttemptQueryDto extends PaginationQueryDto {}
