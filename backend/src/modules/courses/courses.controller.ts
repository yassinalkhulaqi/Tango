import { Controller, Get, Param, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { CoursesService } from './courses.service';
import { ListCoursesDto, ListLessonsDto, ListModulesDto } from './dto/courses.dto';

@ApiTags('courses')
@ApiBearerAuth()
@Controller('courses')
export class CoursesController {
  constructor(private readonly courses: CoursesService) {}

  @Get()
  @ApiOperation({ summary: 'List published courses with filters and pagination' })
  async list(@Query() query: ListCoursesDto) {
    return this.courses.list(query);
  }

  @Get('categories')
  @ApiOperation({ summary: 'List categories' })
  async categories(@Query() query: ListModulesDto) {
    return this.courses.categories(query);
  }

  @Get(':slug')
  @ApiOperation({ summary: 'Get course detail with modules' })
  async detail(@Param('slug') slug: string) {
    return { data: await this.courses.findBySlug(slug) };
  }

  @Get(':slug/modules')
  @ApiOperation({ summary: 'List modules of a course' })
  async modules(@Param('slug') slug: string, @Query() query: ListModulesDto) {
    return this.courses.modules(slug, query);
  }

  @Get(':slug/lessons')
  @ApiOperation({ summary: 'List lessons of a course' })
  async lessons(@Param('slug') slug: string, @Query() query: ListLessonsDto) {
    return this.courses.lessons(slug, query);
  }
}
