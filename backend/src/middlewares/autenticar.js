const supabase = require('../config/supabase');
const AppError = require('../utils/AppError');

async function autenticar(req, res, next) {
  const cabecera = req.headers.authorization || '';
  const token = cabecera.startsWith('Bearer ') ? cabecera.slice(7).trim() : '';

  if (!token) {
    throw new AppError(401, 'NO_AUTENTICADO', 'Falta el token.');
  }

  const { data, error } = await supabase.auth.getUser(token);
  if (error || !data?.user) {
    throw new AppError(401, 'TOKEN_INVALIDO', 'Sesión inválida o vencida.');
  }

  const { data: perfil } = await supabase
    .from('usuarios')
    .select('id, nombre_completo, activo, roles(nombre)')
    .eq('id', data.user.id)
    .maybeSingle();

  if (!perfil || !perfil.activo) {
    throw new AppError(403, 'USUARIO_INACTIVO', 'Usuario sin acceso.');
  }

  req.usuario = {
    id: perfil.id,
    nombre: perfil.nombre_completo,
    rol: perfil.roles.nombre,
  };

  // Si es un cliente del portal, también guardamos su cliente_id
  if (req.usuario.rol === 'cliente') {
    const { data: cliente } = await supabase
      .from('clientes')
      .select('id')
      .eq('usuario_id', perfil.id)
      .maybeSingle();
    req.usuario.cliente_id = cliente ? cliente.id : null;
  }

  next();
}

module.exports = autenticar;