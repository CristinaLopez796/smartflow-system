function ok(res, data, status = 200) {
  return res.status(status).json({ ok: true, data });
}

function fallo(res, status, codigo, mensaje) {
  return res.status(status).json({ ok: false, error: { codigo, mensaje } });
}

module.exports = { ok, fallo };