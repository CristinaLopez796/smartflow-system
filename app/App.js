import { View, ActivityIndicator } from 'react-native';
import { AuthProvider, useAuth } from './src/auth/AuthContext';
import LoginScreen from './src/screens/LoginScreen';
import InicioScreen from './src/screens/InicioScreen';

function Raiz() {
  const { usuario, cargando } = useAuth();

  if (cargando) {
    return (
      <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
        <ActivityIndicator size="large" />
      </View>
    );
  }
  return usuario ? <InicioScreen /> : <LoginScreen />;
}

export default function App() {
  return (
    <AuthProvider>
      <Raiz />
    </AuthProvider>
  );
}