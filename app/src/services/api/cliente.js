const API_URL = process.env.EXPO_PUBLIC_API_URL;

export async function obtenerMe(token) {
  const resp = await fetch(`${API_URL}/me`, {
    headers: { Authorization: `Bearer ${token}` },
  });
  const json = await resp.json();

  if (!json.ok) {
    const err = new Error(json.error?.mensaje || 'Error al consultar la API');
    err.codigo = json.error?.codigo;
    throw err;
  }
  return json.data;
}