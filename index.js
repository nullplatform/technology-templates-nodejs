const server = require('./server');
const HOST = process.env.HOST || '0.0.0.0'
const PORT = process.env.PORT || 8080;

// Run the server!
const start = async () => {
    try {
        server.log.info(`Starting server on port: ${PORT}`);
        await server.listen({ host: HOST, port: PORT });
    } catch (err) {
        server.log.error(err);
        process.exit(1);
    }
}
start();
