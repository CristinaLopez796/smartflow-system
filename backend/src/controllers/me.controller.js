const { ok } = require('../utils/respuesta');

function me(req, res) {
  return ok(res, req.usuario);
}

module.exports = { me };