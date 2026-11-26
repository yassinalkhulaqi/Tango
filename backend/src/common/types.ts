import { Role } from '@prisma/client';

export interface JwtPayload {
  sub: string;
  email?: string;
  role?: Role;
  type: 'access' | 'refresh';
  jti?: string;
  iat?: number;
  exp?: number;
}

export interface AuthUser {
  id: string;
  email?: string;
  role: Role;
}
