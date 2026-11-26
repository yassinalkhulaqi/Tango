import {
  CallHandler,
  ExecutionContext,
  Injectable,
  NestInterceptor,
} from '@nestjs/common';
import { Observable, map } from 'rxjs';

function toCamelKey(key: string): string {
  if (key === '_count') return 'count';
  return key.replace(/_([a-z0-9])/g, (_match, char: string) => char.toUpperCase());
}

function snakeToCamel(value: unknown): unknown {
  if (value === null || value === undefined || typeof value !== 'object') {
    return value;
  }
  if (value instanceof Date || Buffer.isBuffer(value)) return value;
  if (Array.isArray(value)) return value.map(snakeToCamel);

  const result: Record<string, unknown> = {};
  for (const [key, item] of Object.entries(value as Record<string, unknown>)) {
    result[toCamelKey(key)] = snakeToCamel(item);
  }
  return result;
}

@Injectable()
export class CamelCaseInterceptor implements NestInterceptor {
  intercept(_context: ExecutionContext, next: CallHandler): Observable<unknown> {
    return next.handle().pipe(map(snakeToCamel));
  }
}
