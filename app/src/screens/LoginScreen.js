import { useState } from 'react';
import {
  View, Text, TextInput, Pressable, ActivityIndicator, StyleSheet,
} from 'react-native';
import { useAuth } from '../auth/AuthContext';

export default function LoginScreen() {
  const { login } = useAuth();
  const [correo, setCorreo] = useState('');
  const [clave, setClave] = useState('');
  const [error, setError] = useState('');
  const [enviando, setEnviando] = useState(false);

  async function entrar() {
    if (!correo.trim() || !clave) {
      setError('Escribe tu correo y tu contraseña.');
      return;
    }
    setError('');
    setEnviando(true);
    try {
      await login(correo, clave);
    } catch (e) {
      if (e.message === 'CREDENCIALES') {
        // Mensaje genérico: no revela si falló el correo o la contraseña
        setError('Correo o contraseña incorrectos.');
      } else if (e.codigo) {
        setError(e.message);
      } else {
        setError('No se pudo conectar con el servidor. Intenta de nuevo.');
      }
    } finally {
      setEnviando(false);
    }
  }

  return (
    <View style={estilos.pantalla}>
      <View style={estilos.tarjeta}>
        <Text style={estilos.titulo}>SmartFlow ERP</Text>
        <Text style={estilos.subtitulo}>Inicia sesión para continuar</Text>

        <TextInput
          style={estilos.input}
          placeholder="Correo"
          autoCapitalize="none"
          keyboardType="email-address"
          value={correo}
          onChangeText={setCorreo}
        />
        <TextInput
          style={estilos.input}
          placeholder="Contraseña"
          secureTextEntry
          value={clave}
          onChangeText={setClave}
          onSubmitEditing={entrar}
        />

        {error ? <Text style={estilos.error}>{error}</Text> : null}

        <Pressable style={estilos.boton} onPress={entrar} disabled={enviando}>
          {enviando ? (
            <ActivityIndicator color="#fff" />
          ) : (
            <Text style={estilos.botonTexto}>Entrar</Text>
          )}
        </Pressable>
      </View>
    </View>
  );
}

const estilos = StyleSheet.create({
  pantalla: { flex: 1, backgroundColor: '#f1f5f9', justifyContent: 'center', alignItems: 'center', padding: 16 },
  tarjeta: { width: '100%', maxWidth: 400, backgroundColor: '#fff', borderRadius: 12, padding: 24, gap: 12 },
  titulo: { fontSize: 26, fontWeight: 'bold', color: '#1e3a8a', textAlign: 'center' },
  subtitulo: { fontSize: 14, color: '#64748b', textAlign: 'center', marginBottom: 8 },
  input: { borderWidth: 1, borderColor: '#cbd5e1', borderRadius: 8, padding: 12, fontSize: 16 },
  error: { color: '#dc2626', fontSize: 14 },
  boton: { backgroundColor: '#2563eb', borderRadius: 8, padding: 14, alignItems: 'center' },
  botonTexto: { color: '#fff', fontSize: 16, fontWeight: 'bold' },
});