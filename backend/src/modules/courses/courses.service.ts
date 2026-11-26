import { HttpStatus, Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { ApiError } from '../../common/api-error';
import { paginate, Paginated } from '../../common/pagination';
import { PrismaService } from '../../prisma/prisma.service';
import { ListCoursesDto, ListLessonsDto, ListModulesDto } from './dto/courses.dto';

@Injectable()
export class CoursesService {
  constructor(private readonly prisma: PrismaService) {}

  async list(query: ListCoursesDto): Promise<Paginated<Prisma.CourseGetPayload<{
    include: { category: true; _count: { select: { modules: true; enrollments: true } } };
  }>>> {
    const limit = query.limit ?? 20;
    const where: Prisma.CourseWhereInput = {
      published: true,
      ...(query.category ? { category: { slug: query.category } } : {}),
      ...(query.level ? { level: query.level } : {}),
      ...(query.featured ? { featured: query.featured === 'true' } : {}),
      ...(query.q
        ? {
            OR: [
              { title: { contains: query.q, mode: 'insensitive' } },
              { description: { contains: query.q, mode: 'insensitive' } },
            ],
          }
        : {}),
    };
    const rows = await this.prisma.course.findMany({
      where,
      take: limit + 1,
      ...(query.cursor ? { cursor: { id: query.cursor }, skip: 1 } : {}),
      orderBy: [{ featured: 'desc' }, { createdAt: 'desc' }],
      include: { category: true, _count: { select: { modules: true, enrollments: true } } },
    });
    return paginate(rows, limit);
  }

  async categories(query: ListModulesDto) {
    const limit = query.limit ?? 20;
    const rows = await this.prisma.category.findMany({
      take: limit + 1,
      ...(query.cursor ? { cursor: { id: query.cursor }, skip: 1 } : {}),
      orderBy: { sortOrder: 'asc' },
      include: { _count: { select: { courses: true } } },
    });
    return paginate(rows, limit);
  }

  async findBySlug(slug: string) {
    const course = await this.prisma.course.findUnique({
      where: { slug },
      include: {
        category: true,
        modules: {
          orderBy: { order: 'asc' },
          include: { _count: { select: { lessons: true } } },
        },
        quizzes: { where: { published: true }, select: { id: true, slug: true, title: true } },
        _count: { select: { enrollments: true } },
      },
    });
    if (!course || !course.published) {
      throw new ApiError(HttpStatus.NOT_FOUND, 'COURSE_NOT_FOUND', 'Course not found');
    }
    return course;
  }

  async modules(slug: string, query: ListModulesDto) {
    const course = await this.courseIdBySlug(slug);
    const limit = query.limit ?? 20;
    const rows = await this.prisma.module.findMany({
      where: { courseId: course },
      take: limit + 1,
      ...(query.cursor ? { cursor: { id: query.cursor }, skip: 1 } : {}),
      orderBy: { order: 'asc' },
      include: { _count: { select: { lessons: true } } },
    });
    return paginate(rows, limit);
  }

  async lessons(slug: string, query: ListLessonsDto) {
    const courseId = await this.courseIdBySlug(slug);
    const limit = query.limit ?? 20;
    const rows = await this.prisma.lesson.findMany({
      where: {
        module: { courseId },
        ...(query.moduleId ? { moduleId: query.moduleId } : {}),
      },
      take: limit + 1,
      ...(query.cursor ? { cursor: { id: query.cursor }, skip: 1 } : {}),
      orderBy: [{ module: { order: 'asc' } }, { order: 'asc' }],
      include: { module: { select: { id: true, title: true, order: true } } },
    });
    return paginate(rows, limit);
  }

  private async courseIdBySlug(slug: string): Promise<string> {
    const course = await this.prisma.course.findUnique({
      where: { slug },
      select: { id: true, published: true },
    });
    if (!course || !course.published) {
      throw new ApiError(HttpStatus.NOT_FOUND, 'COURSE_NOT_FOUND', 'Course not found');
    }
    return course.id;
  }
}
