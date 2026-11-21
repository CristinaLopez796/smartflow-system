require('dotenv').config();
const { createClient } = require('@supabase/supabase-js');

const url = process.env.SUPABASE_URL;
const clave = process.env.SUPABASE_SECRET_KEY;

if (!url || !clave) {
  throw new Error('Faltan SUPABASE_URL o SUPABASE_SECRET_KEY en el archivo .env');
}

const supabase = createClient(url, clave, {
  auth: { autoRefreshToken: false, persistSession: false },
});

module.exports = supabase;