import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { Response } from 'express';
import { ApiError } from '../api-error';

@Catch()
export class AllExceptionsFilter implements ExceptionFilter {
  private readonly logger = new Logger(AllExceptionsFilter.name);

  catch(exception: unknown, host: ArgumentsHost): void {
    const response = host.switchToHttp().getResponse<Response>();
    let status = HttpStatus.INTERNAL_SERVER_ERROR;
    let payload: Record<string, unknown> = {
      code: 'INTERNAL_ERROR',
      message: 'Internal server error',
    };

    if (exception instanceof ApiError) {
      status = exception.getStatus();
      payload = exception.getResponse() as Record<string, unknown>;
    } else if (exception instanceof HttpException) {
      status = exception.getStatus();
      const raw = exception.getResponse();
      if (typeof raw === 'string') {
        payload = { code: `HTTP_${status}`, message: raw };
      } else if (raw && typeof raw === 'object') {
        const body = raw as Record<string, unknown>;
        const message = Array.isArray(body.message)
          ? body.message.join('; ')
          : String(body.message ?? exception.message);
        payload = {
          code:
            typeof body.code === 'string'
              ? body.code
              : status === HttpStatus.BAD_REQUEST
                ? 'VALIDATION_ERROR'
                : `HTTP_${status}`,
          message,
          ...(body.details !== undefined ? { details: body.details } : {}),
        };
      }
    } else if (exception instanceof Prisma.PrismaClientKnownRequestError) {
      if (exception.code === 'P2002') {
        status = HttpStatus.CONFLICT;
        payload = {
          code: 'CONFLICT',
          message: 'A record with these unique values already exists',
          details: { target: exception.meta?.target },
        };
      } else if (exception.code === 'P2025') {
        status = HttpStatus.NOT_FOUND;
        payload = { code: 'NOT_FOUND', message: 'Resource not found' };
      } else if (exception.code === 'P2003') {
        status = HttpStatus.CONFLICT;
        payload = { code: 'FOREIGN_KEY_VIOLATION', message: 'Related record not found' };
      }
    }

    if (status >= HttpStatus.INTERNAL_SERVER_ERROR) {
      this.logger.error(
        exception instanceof Error ? exception.stack : String(exception),
      );
    }

    response.status(status).json({ error: payload });
  }
}
