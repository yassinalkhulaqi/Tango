import { createParamDecorator, ExecutionContext } from '@nestjs/common';
import { AuthUser } from '../types';

export const CurrentUser = createParamDecorator(
  (_data: unknown, context: ExecutionContext): AuthUser => {
    const request = context.switchToHttp().getRequest<{ user?: AuthUser }>();
    if (!request.user) {
      throw new Error('Authenticated user is missing from request context');
    }
    return request.user;
  },
);
