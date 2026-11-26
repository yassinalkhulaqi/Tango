import {
  CanActivate,
  ExecutionContext,
  HttpStatus,
  Injectable,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { JwtService } from '@nestjs/jwt';
import { ApiError } from '../api-error';
import { IS_PUBLIC_KEY } from '../decorators/public.decorator';
import { AuthUser, JwtPayload } from '../types';

@Injectable()
export class JwtAuthGuard implements CanActivate {
  constructor(
    private readonly jwt: JwtService,
    private readonly reflector: Reflector,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const isPublic = this.reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (isPublic) return true;

    const request = context.switchToHttp().getRequest<{
      headers: { authorization?: string };
      user?: AuthUser;
    }>();
    const header = request.headers.authorization;
    if (!header?.startsWith('Bearer ')) {
      throw new ApiError(
        HttpStatus.UNAUTHORIZED,
        'UNAUTHENTICATED',
        'Bearer access token is required',
      );
    }

    try {
      const payload = await this.jwt.verifyAsync<JwtPayload>(header.slice(7));
      if (payload.type !== 'access' || !payload.sub) {
        throw new Error('Invalid token type');
      }
      request.user = {
        id: payload.sub,
        email: payload.email,
        role: payload.role ?? ('USER' as AuthUser['role']),
      };
      return true;
    } catch {
      throw new ApiError(
        HttpStatus.UNAUTHORIZED,
        'UNAUTHENTICATED',
        'Invalid or expired access token',
      );
    }
  }
}
