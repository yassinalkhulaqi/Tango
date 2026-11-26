import { Injectable, Logger, OnModuleDestroy } from '@nestjs/common';
import Redis from 'ioredis';

@Injectable()
export class RedisService implements OnModuleDestroy {
  private readonly logger = new Logger(RedisService.name);
  private readonly enabled = process.env.REDIS_ENABLED !== 'false';
  private connection: Promise<Redis | null> | null = null;
  private clientRef: Redis | null = null;

  get available(): boolean {
    return this.clientRef !== null && this.clientRef.status === 'ready';
  }

  private async client(): Promise<Redis | null> {
    if (!this.enabled) return null;
    if (!this.connection) {
      this.connection = (async (): Promise<Redis | null> => {
        const client = new Redis({
          host: process.env.REDIS_HOST ?? 'localhost',
          port: Number(process.env.REDIS_PORT ?? 6379),
          db: Number(process.env.REDIS_DB ?? 0),
          ...(process.env.REDIS_PASSWORD
            ? { password: process.env.REDIS_PASSWORD }
            : {}),
          lazyConnect: true,
          maxRetriesPerRequest: 1,
          enableOfflineQueue: false,
          retryStrategy: () => null,
        });
        client.on('error', () => undefined);
        this.clientRef = client;
        try {
          await client.connect();
          return client;
        } catch {
          this.logger.warn('Redis unavailable; leaderboards use PostgreSQL fallback');
          return null;
        }
      })();
    }
    return this.connection;
  }

  async ping(): Promise<boolean> {
    const client = await this.client();
    if (!client) return false;
    try {
      return (await client.ping()) === 'PONG';
    } catch {
      return false;
    }
  }

  async get(key: string): Promise<string | null> {
    const client = await this.client();
    if (!client) return null;
    return client.get(key);
  }

  async set(key: string, value: string, ttlSeconds?: number): Promise<void> {
    const client = await this.client();
    if (!client) return;
    if (ttlSeconds) await client.set(key, value, 'EX', ttlSeconds);
    else await client.set(key, value);
  }

  async zadd(key: string, members: Array<[number, string]>): Promise<void> {
    const client = await this.client();
    if (!client || members.length === 0) return;
    const args: Array<string | number> = [key];
    for (const [score, member] of members) args.push(score, member);
    await client.zadd(...(args as [string, ...Array<string | number>]));
  }

  async zincrby(key: string, amount: number, member: string): Promise<void> {
    const client = await this.client();
    if (!client) return;
    await client.zincrby(key, amount, member);
  }

  async zrevrange(key: string, start: number, stop: number): Promise<string[]> {
    const client = await this.client();
    if (!client) return [];
    return client.zrevrange(key, start, stop);
  }

  async zrank(key: string, member: string): Promise<number | null> {
    const client = await this.client();
    if (!client) return null;
    return client.zrank(key, member);
  }

  async zscore(key: string, member: string): Promise<number | null> {
    const client = await this.client();
    if (!client) return null;
    const value = await client.zscore(key, member);
    return value === null ? null : Number(value);
  }

  async exists(key: string): Promise<boolean> {
    const client = await this.client();
    if (!client) return false;
    return (await client.exists(key)) > 0;
  }

  async expire(key: string, seconds: number): Promise<void> {
    const client = await this.client();
    if (!client) return;
    await client.expire(key, seconds);
  }

  async del(key: string): Promise<void> {
    const client = await this.client();
    if (!client) return;
    await client.del(key);
  }

  async onModuleDestroy(): Promise<void> {
    if (this.clientRef && this.clientRef.status !== 'end') {
      await this.clientRef.quit().catch(() => undefined);
    }
  }
}
