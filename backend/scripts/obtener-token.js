require('dotenv').config();
const readline = require('readline');
const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_PUBLISHABLE_KEY,
  { auth: { autoRefreshToken: false, persistSession: false } }
);

const rl = readline.createInterface({ input: process.stdin, output: process.stderr });
const preguntar = (texto) => new Promise((resolver) => rl.question(texto, resolver));

async function main() {
  const email = await preguntar('Correo: ');
  const password = await preguntar('Contraseña: ');
  rl.close();

  const { data, error } = await supabase.auth.signInWithPassword({ email, password });
  if (error) {
    console.error('No se pudo iniciar sesión:', error.message);
    process.exit(1);
  }
  console.log(data.session.access_token);
}

main();