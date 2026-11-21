import { View, Text, Pressable, StyleSheet } from 'react-native';
import { useAuth } from '../auth/AuthContext';

// Cada rol tiene su panel. Más adelante cada uno tendrá sus pantallas reales.
const PANELES = {
  administrador: 'Panel de administración',
  vendedor: 'Panel de ventas',
  almacen: 'Panel de almacén',
  facturacion: 'Panel de facturación',
  cliente: 'Portal del cliente',
};

export default function InicioScreen() {
  const { usuario, logout } = useAuth();

  return (
    <View style={estilos.pantalla}>
      <View style={estilos.tarjeta}>
        <Text style={estilos.panel}>{PANELES[usuario.rol] || 'Inicio'}</Text>
        <Text style={estilos.texto}>Hola, {usuario.nombre}</Text>
        <Text style={estilos.texto}>Rol: {usuario.rol}</Text>

        <Pressable style={estilos.boton} onPress={logout}>
          <Text style={estilos.botonTexto}>Cerrar sesión</Text>
        </Pressable>
      </View>
    </View>
  );
}

const estilos = StyleSheet.create({
  pantalla: { flex: 1, backgroundColor: '#f1f5f9', justifyContent: 'center', alignItems: 'center', padding: 16 },
  tarjeta: { width: '100%', maxWidth: 400, backgroundColor: '#fff', borderRadius: 12, padding: 24, gap: 12 },
  panel: { fontSize: 22, fontWeight: 'bold', color: '#1e3a8a' },
  texto: { fontSize: 16, color: '#334155' },
  boton: { backgroundColor: '#dc2626', borderRadius: 8, padding: 14, alignItems: 'center', marginTop: 8 },
  botonTexto: { color: '#fff', fontSize: 16, fontWeight: 'bold' },
});