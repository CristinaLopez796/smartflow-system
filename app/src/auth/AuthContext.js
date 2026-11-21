import { createContext, useContext, useEffect, useState } from 'react';
import { supabase } from '../services/supabase';
import { obtenerMe } from '../services/api/cliente';

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [usuario, setUsuario] = useState(null);
  const [cargando, setCargando] = useState(true);

  // Al abrir la app: si ya había una sesión guardada, la restauramos
  useEffect(() => {
    async function restaurar() {
      try {
        const { data } = await supabase.auth.getSession();
        if (data.session) {
          setUsuario(await obtenerMe(data.session.access_token));
        }
      } catch (e) {
        await supabase.auth.signOut();
        setUsuario(null);
      } finally {
        setCargando(false);
      }
    }
    restaurar();
  }, []);

  async function login(correo, clave) {
    const { data, error } = await supabase.auth.signInWithPassword({
      email: correo.trim(),
      password: clave,
    });
    if (error) throw new Error('CREDENCIALES');

    try {
      setUsuario(await obtenerMe(data.session.access_token));
    } catch (e) {
      await supabase.auth.signOut();
      throw e;
    }
  }

  async function logout() {
    await supabase.auth.signOut();
    setUsuario(null);
  }

  return (
    <AuthContext.Provider value={{ usuario, cargando, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  return useContext(AuthContext);
}