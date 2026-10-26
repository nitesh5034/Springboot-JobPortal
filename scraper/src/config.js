// src/config.js
import { Agent } from 'http';

export default {
  // Redis connection for Bull queue and caching
  redis: {
    host: process.env.REDIS_HOST || 'redis',
    port: parseInt(process.env.REDIS_PORT || '6379'),
    password: process.env.REDIS_PASSWORD || undefined,
  },
  // HTTP keep‑alive agent for efficient connections
  httpAgent: new Agent({ keepAlive: true, maxSockets: 100 }),

  // PostgreSQL connection (via node‑pg)
  pg: {
    host: process.env.PG_HOST || 'postgres',
    port: parseInt(process.env.PG_PORT || '5432'),
    database: process.env.PG_DB || 'scraper',
    user: process.env.PG_USER || 'scraper',
    password: process.env.PG_PASSWORD || 'change_me',
    max: 20, // max pool size
  },

  // Rate‑limit settings (tokens per second, burst capacity)
  rateLimiter: {
    refillIntervalMs: 1000,
    tokensPerInterval: 1,
    burstCapacity: 5,
  },

  // Circuit breaker parameters
  circuitBreaker: {
    failureThreshold: 5,
    cooldownMs: 30000,
  },
};
