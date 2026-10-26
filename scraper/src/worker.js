// src/worker.js
const Queue = require('bull');
const axios = require('axios');
const Redis = require('ioredis');
const { rateLimiter } = require('./rateLimiter');
const { circuitBreaker } = require('./circuitBreaker');
const { dedup } = require('./dedup');
const { validate } = require('./validation');
const { parseAndExtract } = require('./pipeline');
const logger = require('./logger');
const { pool } = require('./db/pgPool');
const { batchInsert } = require('./db/batchInsert');
const config = require('./config');

// Initialise Bull queue
const scrapeQueue = new Queue('scrape', {
  redis: { host: config.REDIS_HOST, port: config.REDIS_PORT },
});

// Dead‑letter queue for failed jobs
const dlq = new Queue('scrape-dlq', {
  redis: { host: config.REDIS_HOST, port: config.REDIS_PORT },
});

// Process jobs – Bull will handle retries based on job options (see producer.js)
scrapeQueue.process(async (job, done) => {
  const { url, id, meta } = job.data;
  const requestId = `${id}`;
  logger.info({ requestId, url, msg: 'Job started' });

  // Rate limiting per domain
  try {
    await rateLimiter.wait(url);
  } catch (err) {
    logger.error({ requestId, err: err.message, msg: 'Rate limiter error' });
    return done(err);
  }

  // Circuit breaker check
  const cb = circuitBreaker.get(url);
  if (!cb.allowRequest()) {
    const errMsg = 'Circuit open – rejecting request';
    logger.warn({ requestId, url, msg: errMsg });
    return done(new Error(errMsg));
  }

  // HTTP request using keep‑alive agent
  try {
    const response = await axios.get(url, {
      timeout: config.HTTP_TIMEOUT_MS,
      httpAgent: config.HTTP_AGENT,
      httpsAgent: config.HTTPS_AGENT,
      headers: { 'User-Agent': config.randomUserAgent() },
    });

    // Duplicate detection (idempotent handling)
    const isDup = await dedup.isDuplicate(requestId);
    if (isDup) {
      logger.info({ requestId, msg: 'Duplicate detected – skipping' });
      cb.recordSuccess();
      return done();
    }

    // Parse HTML and extract structured data
    const extracted = parseAndExtract(response.data);

    // Validate data schema and checksum
    const valid = validate(extracted);
    if (!valid) {
      throw new Error('Validation failed');
    }

    // Cache raw HTML for 24h (optional)
    const cacheKey = `html:${requestId}`;
    await new Redis(config.redis).setex(cacheKey, 86400, response.data);

    // Insert into DB using batchInsert (even single rows go through same path)
    await batchInsert([extracted]);

    // Mark dedup entry as processed
    await dedup.markProcessed(requestId);

    // Record success for CB
    cb.recordSuccess();
    logger.info({ requestId, url, msg: 'Job completed successfully' });
    done();
  } catch (err) {
    // Record failure for CB
    cb.recordFailure();
    logger.error({ requestId, url, err: err.message, msg: 'Job failed' });
    // If retries exhausted, move to DLQ (Bull does this automatically if attempts exceed)
    done(err);
  }
});

module.exports = { scrapeQueue, dlq };
