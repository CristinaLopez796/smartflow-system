const AppError = require('../utils/AppError');
const { fallo } = require('../utils/respuesta');

function noEncontrado(req, res) {
  return fallo(res, 404, 'NO_ENCONTRADO', 'Ruta no encontrada');
}

function manejarErrores(err, req, res, next) {
  if (err instanceof AppError) {
    return fallo(res, err.status, err.codigo, err.message);
  }

  if (err.type === 'entity.parse.failed') {
    return fallo(res, 400, 'JSON_INVALIDO', 'El cuerpo de la petición no es un JSON válido');
  }

  // El detalle real solo se muestra en la consola del servidor, nunca al cliente
  console.error(err);
  return fallo(res, 500, 'ERROR_INTERNO', 'Error interno del servidor');
}

module.exports = { noEncontrado, manejarErrores };