import { HttpException, HttpStatus } from '@nestjs/common';

export class ApiError extends HttpException {
  constructor(
    status: HttpStatus,
    public readonly code: string,
    message: string,
    details?: unknown,
  ) {
    super(
      {
        code,
        message,
        ...(details !== undefined ? { details } : {}),
      },
      status,
    );
  }
}
