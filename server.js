const fastify = require('fastify')({ logger: { level: 'info' } });

// Declare a route
fastify.get('/', async (request, reply) => {
    return { hello: 'world' };
})
//Health
fastify.get('/health', async (request, reply) => {
    return { status: 'ok' };
})

module.exports = fastify;
