# SmartFlow ERP: Roles y permisos

| | |
|---|---|
| **Proyecto** | SmartFlow ERP |
| **Autora** | Maria Cristina Lopez (62151021), CEUTEC |
| **Versión** | 1.0 (borrador), noviembre de 2026 |
| **Elaboración** | Generado con asistencia de Claude; pendiente de revisión de la autora |
| **Relacionado con** | `01-requisitos.md` (RF-ROL-01 a RF-ROL-05, RF-AUT-05, RNF-SEG-04) |

---

## 1. Modelo de control de acceso

SmartFlow usa **control de acceso basado en roles (RBAC, Role-Based Access Control)**:

1. Cada usuario tiene **exactamente un rol**.
2. Cada rol agrupa un conjunto de **permisos** con el formato `modulo:accion`.
3. Se aplica el **principio de mínimo privilegio**: cada rol recibe solo lo necesario para su trabajo.

### Defensa en capas

| Capa | Mecanismo | Función |
|---|---|---|
| Interfaz (React / React Native) | Oculta menús y botones según el rol | **Solo comodidad.** No es una medida de seguridad. |
| API (Node + Express) | Middleware `autenticar` y `autorizar(...)` | **Control principal.** Responde 401 o 403. |
| Base de datos (Supabase) | Row Level Security (RLS) | **Defensa en profundidad.** Protege aun si alguien salta la API. |

> Regla de oro: la interfaz nunca decide la seguridad. El servidor siempre vuelve a comprobar el rol.

---

## 2. Roles del sistema

| Rol (`roles.nombre`) | Descripción | Usuario típico |
|---|---|---|
| `administrador` | Control total del sistema: usuarios, catálogos, configuración y reportes. | Dueño o gerente del negocio |
| `vendedor` | Registra clientes y crea y confirma pedidos. Ve solo sus propios pedidos. | Personal de ventas |
| `almacen` | Gestiona existencias y productos, prepara y entrega pedidos. | Encargado de bodega |
| `facturacion` | Emite facturas, registra pagos y consulta reportes de ventas. | Contador o cajero |
| `cliente` | Usuario externo del portal: consulta el catálogo, hace sus pedidos y ve sus facturas. Nunca ve datos de otros clientes. | Cliente del negocio |

---

## 3. Matriz de permisos

> Las tablas 3.1 a 3.6 describen al **personal** (administrador, vendedor, almacén y facturación). El rol **cliente** solo tiene los permisos de la sección 3.7; todo lo demás le está prohibido.

**Leyenda:** ✔ permitido · ✖ no permitido · **Propios** = solo los registros que el usuario creó.

### 3.1 Usuarios y roles

| Acción | Administrador | Vendedor | Almacén | Facturación |
|---|:---:|:---:|:---:|:---:|
| Crear / editar / desactivar usuarios | ✔ | ✖ | ✖ | ✖ |
| Listar usuarios | ✔ | ✖ | ✖ | ✖ |
| Ver y editar su propio perfil | ✔ | ✔ | ✔ | ✔ |
| Consultar roles y permisos | ✔ | ✖ | ✖ | ✖ |

### 3.2 Clientes

| Acción | Administrador | Vendedor | Almacén | Facturación |
|---|:---:|:---:|:---:|:---:|
| Crear cliente | ✔ | ✔ | ✖ | ✖ |
| Editar cliente | ✔ | ✔ | ✖ | ✖ |
| Consultar / buscar clientes | ✔ | ✔ | ✔ | ✔ |
| Desactivar cliente | ✔ | ✖ | ✖ | ✖ |
| Crear el acceso al portal de un cliente | ✔ | ✔ | ✖ | ✖ |

### 3.3 Productos e inventario

| Acción | Administrador | Vendedor | Almacén | Facturación |
|---|:---:|:---:|:---:|:---:|
| Crear / editar producto | ✔ | ✖ | ✔ | ✖ |
| Desactivar producto | ✔ | ✖ | ✖ | ✖ |
| Consultar productos y existencias | ✔ | ✔ | ✔ | ✔ |
| Registrar entradas de mercadería | ✔ | ✖ | ✔ | ✖ |
| Ajustar existencias / definir mínimo | ✔ | ✖ | ✔ | ✖ |
| Ver productos bajo el mínimo | ✔ | ✔ | ✔ | ✖ |

### 3.4 Pedidos

| Acción | Administrador | Vendedor | Almacén | Facturación |
|---|:---:|:---:|:---:|:---:|
| Crear pedido | ✔ | ✔ | ✖ | ✖ |
| Ver pedidos | Todos | **Propios y del portal** | Todos | Todos |
| Editar detalle (solo si está pendiente) | ✔ | **Propios** | ✖ | ✖ |
| Confirmar pedido | ✔ | **Propios y del portal** | ✖ | ✖ |
| Cancelar pedido pendiente | ✔ | **Propios y del portal** | ✖ | ✖ |
| Cancelar pedido confirmado | ✔ | ✖ | ✖ | ✖ |
| Marcar como entregado | ✔ | ✖ | ✔ | ✖ |

### 3.5 Facturación

| Acción | Administrador | Vendedor | Almacén | Facturación |
|---|:---:|:---:|:---:|:---:|
| Emitir factura | ✔ | ✖ | ✖ | ✔ |
| Ver factura / descargar PDF | ✔ | **Propios** | ✖ | ✔ |
| Registrar pago | ✔ | ✖ | ✖ | ✔ |

### 3.6 Reportes, dashboard y notificaciones

| Acción | Administrador | Vendedor | Almacén | Facturación |
|---|:---:|:---:|:---:|:---:|
| Dashboard general | ✔ | Solo sus ventas | Solo inventario | Solo ventas |
| Reporte de ventas | ✔ | ✖ | ✖ | ✔ |
| Reporte de inventario | ✔ | ✖ | ✔ | ✖ |
| Ver y marcar sus notificaciones | ✔ | ✔ | ✔ | ✔ |


### 3.7 Rol cliente (portal)

| Acción | Cliente |
|---|:---:|
| Iniciar sesión y ver su perfil | ✔ |
| Ver el catálogo de productos activos (precio y disponible/agotado, sin existencias exactas) | ✔ |
| Crear un pedido propio (nace pendiente, no descuenta inventario) | ✔ |
| Editar el detalle de su pedido mientras esté pendiente | **Propios** |
| Cancelar su pedido mientras esté pendiente | **Propios** |
| Ver sus pedidos y su estado | **Propios** |
| Ver y descargar sus facturas | **Propias** |
| Ver y marcar sus notificaciones | ✔ |
| Ver otros clientes, usuarios, inventario exacto, reportes o dashboard | ✖ |
| Confirmar, facturar o marcar como entregado | ✖ |

**Cómo se vincula un cliente con su usuario:** el registro en `clientes` tiene el campo `usuario_id`. El personal (administrador o vendedor) crea el acceso desde la ficha del cliente: se crea el usuario en Supabase Auth, se registra en `usuarios` con el rol `cliente` y se enlaza con `clientes.usuario_id`. Todo lo que el cliente consulta se filtra por ese enlace.

---

## 4. Transiciones de estado de un pedido

| De → A | Quién puede hacerlo | Efecto |
|---|---|---|
| (nuevo pedido del portal) → pendiente | Cliente | No descuenta inventario; avisa a administradores y vendedores |
| pendiente → confirmado | Administrador, vendedor (propios y del portal) | Valida y descuenta inventario; calcula totales; notifica |
| confirmado → facturado | Administrador, facturación | Emite la factura |
| facturado → entregado | Administrador, almacén | Cierra el ciclo |
| pendiente → cancelado | Administrador, vendedor (propios y del portal), cliente (propios) | Sin efecto en inventario |
| confirmado → cancelado | Solo administrador | Restituye inventario |
| facturado / entregado → cancelado | Nadie | No permitido en esta versión |

---

## 5. Implementación

### 5.1 Almacenamiento de permisos

Los permisos se guardan en `roles.permisos` (campo JSON). Ejemplo para el rol `vendedor`:

```json
{
  "clientes": ["crear", "editar", "ver"],
  "productos": ["ver"],
  "inventario": ["ver"],
  "pedidos": ["crear", "ver_propios", "editar_propios", "confirmar_propios", "cancelar_propios",
               "ver_portal", "confirmar_portal", "cancelar_portal"],
  "facturas": ["ver_propias"],
  "notificaciones": ["ver"]
}
```

Resumen de permisos por rol:

| Rol | Permisos |
|---|---|
| `administrador` | `*` (todos) |
| `vendedor` | `clientes:crear`, `clientes:editar`, `clientes:ver`, `productos:ver`, `inventario:ver`, `pedidos:crear`, `pedidos:ver_propios`, `pedidos:editar_propios`, `pedidos:confirmar_propios`, `pedidos:cancelar_propios`, `pedidos:ver_portal`, `pedidos:confirmar_portal`, `pedidos:cancelar_portal`, `facturas:ver_propias` |
| `almacen` | `clientes:ver`, `productos:ver`, `productos:crear`, `productos:editar`, `inventario:ver`, `inventario:entrada`, `inventario:ajustar`, `pedidos:ver`, `pedidos:entregar`, `reportes:inventario` |
| `facturacion` | `clientes:ver`, `productos:ver`, `inventario:ver`, `pedidos:ver`, `facturas:emitir`, `facturas:ver`, `facturas:pago`, `reportes:ventas` |
| `cliente` | `catalogo:ver`, `portal_pedidos:crear`, `portal_pedidos:ver_propios`, `portal_pedidos:cancelar_propios`, `facturas:ver_propias`, `notificaciones:ver` |

### 5.2 Middleware de autorización (Express)

El middleware `autenticar` (ver `05-arquitectura.md`) valida el token y deja el usuario con su rol en `req.usuario`. Luego `autorizar` comprueba el rol permitido para cada ruta:

```javascript
// backend/src/middlewares/autorizar.js
export const autorizar = (...rolesPermitidos) => (req, res, next) => {
  const rol = req.usuario?.rol;
  if (!rol || !rolesPermitidos.includes(rol)) {
    return res.status(403).json({
      ok: false,
      error: { codigo: 'PROHIBIDO', mensaje: 'No tienes permiso para realizar esta acción.' },
    });
  }
  next();
};

// Uso en las rutas
router.post('/clientes', autenticar, autorizar('administrador', 'vendedor'), crearCliente);
router.post('/pedidos/:id/factura', autenticar, autorizar('administrador', 'facturacion'), emitirFactura);
```

### 5.3 Reglas "Propios" (vendedor)

Estas reglas dependen del registro, no solo del rol, así que se resuelven en el **servicio**:

- En `GET /pedidos`: si el rol es `vendedor`, se filtra por `creado_por = req.usuario.id` **o** `origen = 'portal'`.
- En `GET /pedidos/:id`, `PATCH`, `confirmar` y `cancelar`: si el rol es `vendedor`, el pedido debe ser suyo o de origen `portal`; si no, se responde 403.
- **Rutas del portal (`/portal/*`):** solo el rol `cliente`. El servicio obtiene el `cliente_id` desde `clientes.usuario_id = req.usuario.id` y **nunca** lo recibe del cuerpo de la petición. Así un cliente no puede pedir ni consultar a nombre de otro.

### 5.4 Row Level Security (RLS)

Las políticas del script SQL (`04-modelo-datos.md`) reproducen esta matriz con la función `public.rol_actual()`. La API usa la clave `service_role`, que **no** pasa por RLS, por eso la autorización en Express es obligatoria. RLS protege los accesos directos con la clave pública (`anon`) y actúa como red de seguridad ante errores.

---

## 6. Casos de prueba de seguridad

| # | Caso | Resultado esperado |
|---|---|---|
| 1 | Petición sin token | 401 |
| 2 | Token válido de un usuario desactivado | 403 |
| 3 | Vendedor llama `GET /usuarios` | 403 |
| 4 | Vendedor A consulta el pedido de vendedor B | 403 |
| 5 | Vendedor llama `POST /pedidos/:id/factura` | 403 |
| 6 | Facturación llama `POST /pedidos` | 403 |
| 7 | Almacén intenta cancelar un pedido confirmado | 403 |
| 8 | Administrador cancela un pedido confirmado | 200 y existencias restituidas |
| 9 | Usuario con la clave `anon` consulta `facturas` directamente | Sin filas (RLS) |
| 10 | Cliente A consulta `GET /portal/pedidos/:id` de un pedido del cliente B | 404 o 403 |
| 11 | Cliente envía `cliente_id` de otro cliente en `POST /portal/pedidos` | Se ignora; el pedido se crea con su propio cliente |
| 12 | Cliente llama `GET /inventario` o `GET /usuarios` | 403 |
| 13 | Cliente llama `POST /pedidos/:id/confirmar` | 403 |
| 14 | Cliente cancela su pedido ya confirmado | Rechazado |

## 7. Puntos a validar

- Si el negocio necesita roles adicionales (por ejemplo, **gerente** de solo lectura), se agregan como filas nuevas en `roles`, sin cambiar el código de autenticación.
- La matriz es una propuesta inicial; conviene confirmarla con el profesor o con un negocio real.
