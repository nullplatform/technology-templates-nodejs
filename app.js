const awsLambdaFastify = require('@fastify/aws-lambda');
const server = require('./server');

const proxy = awsLambdaFastify(server)

exports.handler = proxy;
