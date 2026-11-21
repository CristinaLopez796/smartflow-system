const { ok } = require('../utils/respuesta');

function health(req, res) {
  return ok(res, {
    status: 'ok',
    service: 'smartflow-api',
    timestamp: new Date().toISOString(),
  });
}

module.exports = { health };