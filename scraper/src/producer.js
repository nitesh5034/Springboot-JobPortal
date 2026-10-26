// src/producer.js
import Queue from 'bull';
import { v4 as uuid } from 'uuid';
import config from './config.js';

const scrapeQueue = new Queue('scrape', {
  redis: config.redis,
});

/**
 * Enqueue a scraping job.
 * @param {string} url - Target URL to scrape.
 * @param {object} [meta] - Optional metadata (e.g., headers, priority).
 */
export async function enqueueScrape(url, meta = {}) {
  await scrapeQueue.add(
    { url, id: uuid(), ...meta },
    {
      attempts: 5,
      backoff: { type: 'exponential', delay: 2000 },
      removeOnComplete: true,
      // priority can be set per job if needed
    }
  );
}

// Example usage (can be called from an API endpoint or CLI)
// enqueueScrape('https://example.com');
