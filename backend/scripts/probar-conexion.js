const supabase = require('../src/config/supabase');

async function main() {
  const { data, error } = await supabase.from('roles').select('id, nombre').order('id');

  if (error) {
    console.error('Error al consultar roles:', error.message);
    process.exit(1);
  }

  console.log('Conexión exitosa. Roles encontrados:');
  console.table(data);
}

main();