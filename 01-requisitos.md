# SmartFlow ERP: Requisitos funcionales y no funcionales

| | |
|---|---|
| **Proyecto** | SmartFlow: Plataforma Inteligente de Facturación, Gestión de Pedidos e Inventario |
| **Autora** | Maria Cristina Lopez (62151021), Ingeniería en Informática, CEUTEC |
| **Asignatura** | Ingeniería de Software I |
| **Versión** | 1.0 (borrador), noviembre de 2026 |
| **Elaboración** | Generado con asistencia de Claude a partir de la ficha del proyecto; pendiente de revisión de la autora |

---

## 1. Introducción

### 1.1 Propósito
Este documento define **qué debe hacer** SmartFlow (requisitos funcionales) y **qué cualidades debe tener** (requisitos no funcionales). Es la base para las historias de usuario, el modelo de datos, la arquitectura y las pruebas.

### 1.2 Objetivo del sistema
Digitalizar y centralizar la gestión de clientes, productos, pedidos, inventario y facturación de una PYME, para lograr un mejor control operativo y facilitar el crecimiento futuro del negocio.

### 1.3 Alcance

| Dentro del alcance | Fuera del alcance |
|---|---|
| Pedidos con estados y detalle | Facturación fiscal electrónica oficial |
| Facturación con impuestos y PDF | IA y predicción de ventas (futuro) |
| Inventario con descuento automático | Pasarelas de pago en línea |
| Clientes y productos (CRUD) | Versión multiempresa SaaS (futuro) |
| Roles y permisos por usuario | |
| Dashboard, reportes y alertas | |
| Aplicación web (React) y móvil (React Native) | |
| Portal del cliente: catálogo, pedidos propios y facturas | |

### 1.4 Convenciones

- **Identificadores:** `RF-<MÓDULO>-<NN>` para funcionales y `RNF-<CATEGORÍA>-<NN>` para no funcionales.
- **Prioridad (MoSCoW):** **M** = Must (imprescindible), **S** = Should (importante), **C** = Could (deseable).
- Cada requisito incluye un **criterio de aceptación** verificable.

### 1.5 Módulos

| Código | Módulo | Etiqueta en Trello |
|---|---|---|
| AUT | Autenticación y sesión | Backend |
| ROL | Usuarios, roles y permisos | Backend |
| CLI | Gestión de clientes | Backend / Frontend |
| PRO | Gestión de productos | Backend / Frontend |
| INV | Control de inventario | Backend / Base de datos |
| PED | Gestión de pedidos | Backend / Frontend |
| FAC | Generación de facturas | Backend / Frontend |
| REP | Reportes y dashboard | Frontend |
| NOT | Notificaciones | Backend |
| MOV | Aplicación móvil | Móvil |
| POR | Portal del cliente | Frontend / Backend |

---

## 2. Requisitos funcionales

### 2.1 AUT: Autenticación y sesión

| ID | Requisito | Prior. | Criterio de aceptación |
|---|---|---|---|
| RF-AUT-01 | El sistema permite iniciar sesión con correo y contraseña mediante Supabase Auth. | M | Con credenciales válidas se obtiene una sesión con token JWT; con credenciales inválidas se muestra un mensaje genérico, sin indicar cuál dato falló. |
| RF-AUT-02 | El sistema permite cerrar sesión. | M | Tras cerrar sesión, el token deja de ser aceptado por la interfaz y se redirige al login. |
| RF-AUT-03 | El usuario puede recuperar su contraseña por correo electrónico. | S | Al solicitarla, se envía un enlace de restablecimiento al correo registrado. |
| RF-AUT-04 | La API valida el JWT en cada petición protegida. | M | Una petición sin token o con token vencido recibe respuesta 401. |
| RF-AUT-05 | El sistema impide el acceso a usuarios desactivados. | M | Un usuario con `activo = false` recibe 403 aunque tenga un token válido. |

### 2.2 ROL: Usuarios, roles y permisos

| ID | Requisito | Prior. | Criterio de aceptación |
|---|---|---|---|
| RF-ROL-01 | El administrador crea, edita y desactiva usuarios. | M | El usuario nuevo aparece en el listado y puede iniciar sesión; el desactivado no. |
| RF-ROL-02 | Cada usuario tiene exactamente un rol asignado. | M | No se puede guardar un usuario sin rol. |
| RF-ROL-03 | La API aplica los permisos de cada rol en cada endpoint. | M | Una acción no permitida para el rol recibe 403 y no modifica datos. |
| RF-ROL-04 | La interfaz oculta las opciones no permitidas para el rol del usuario. | S | Un vendedor no ve el menú de usuarios ni el de reportes financieros. |
| RF-ROL-05 | El administrador consulta los roles y sus permisos. | S | Existe una vista de solo lectura con la matriz de permisos. |

### 2.3 CLI: Gestión de clientes

| ID | Requisito | Prior. | Criterio de aceptación |
|---|---|---|---|
| RF-CLI-01 | Registrar un cliente con nombre y datos de contacto. | M | El nombre es obligatorio; al guardar, el cliente aparece en el listado. |
| RF-CLI-02 | Editar los datos de un cliente. | M | Los cambios se reflejan de inmediato y se actualiza la fecha de modificación. |
| RF-CLI-03 | Listar clientes con búsqueda y paginación. | M | Se puede buscar por nombre o identificación; cada página tiene un máximo de 50 registros. |
| RF-CLI-04 | Consultar el detalle de un cliente con su historial de pedidos. | S | La ficha muestra los pedidos del cliente ordenados por fecha. |
| RF-CLI-05 | Desactivar un cliente (baja lógica). | M | El cliente desactivado no aparece al crear pedidos, pero se conservan sus pedidos anteriores. |
| RF-CLI-06 | Evitar clientes duplicados por número de identificación. | S | Registrar una identificación ya existente muestra un error claro. |
| RF-CLI-07 | El personal crea un acceso (usuario con rol cliente) para un cliente registrado. | S | El cliente puede iniciar sesión y solo ve su propia información. |

### 2.4 PRO: Gestión de productos

| ID | Requisito | Prior. | Criterio de aceptación |
|---|---|---|---|
| RF-PRO-01 | Registrar un producto con SKU único, nombre y precio. | M | SKU duplicado o precio negativo son rechazados con mensaje de error. |
| RF-PRO-02 | Editar los datos de un producto. | M | Un cambio de precio no altera pedidos ya creados (se conserva el precio original). |
| RF-PRO-03 | Listar y buscar productos por nombre o SKU. | M | El listado es paginado e indica las existencias de cada producto. |
| RF-PRO-04 | Desactivar un producto (baja lógica). | M | Un producto inactivo no se puede agregar a pedidos nuevos. |
| RF-PRO-05 | Indicar si un producto aplica impuesto. | M | El cálculo del impuesto del pedido solo considera productos marcados. |
| RF-PRO-06 | Al crear un producto se crea automáticamente su registro de inventario. | M | Todo producto nuevo tiene un registro de inventario con existencias en 0. |

### 2.5 INV: Control de inventario

| ID | Requisito | Prior. | Criterio de aceptación |
|---|---|---|---|
| RF-INV-01 | Consultar las existencias de cada producto. | M | El listado muestra existencias y mínimo por producto. |
| RF-INV-02 | Definir el stock mínimo de un producto. | M | El valor mínimo es un entero mayor o igual a 0. |
| RF-INV-03 | Descontar automáticamente el inventario al confirmar un pedido. | M | Después de confirmar, las existencias disminuyen exactamente en la cantidad pedida. |
| RF-INV-04 | Impedir confirmar un pedido con existencias insuficientes. | M | El sistema rechaza la confirmación, indica el producto afectado y no modifica ninguna existencia. |
| RF-INV-05 | Registrar entradas de mercadería. | M | La entrada suma la cantidad a las existencias del producto. |
| RF-INV-06 | Realizar ajustes manuales de existencias. | S | Solo roles autorizados pueden ajustar; el resultado nunca puede ser negativo. |
| RF-INV-07 | Restituir el inventario al cancelar un pedido confirmado. | M | Tras cancelar, las existencias vuelven al valor previo a la confirmación. |
| RF-INV-08 | Listar los productos que están en o por debajo del mínimo. | S | El listado se ordena por criticidad (existencias menos mínimo). |
| RF-INV-09 | Registrar un historial de movimientos de inventario. | C | Extensión futura: requiere una tabla adicional fuera de las 9 entidades base. |

### 2.6 PED: Gestión de pedidos

| ID | Requisito | Prior. | Criterio de aceptación |
|---|---|---|---|
| RF-PED-01 | Crear un pedido para un cliente con uno o más productos. | M | Un pedido sin cliente o sin productos no puede confirmarse. |
| RF-PED-02 | Agregar, quitar o cambiar la cantidad de productos mientras el pedido esté pendiente. | M | Un pedido confirmado no permite modificar su detalle. |
| RF-PED-03 | Calcular subtotal, impuesto y total del pedido. | M | Total = subtotal + impuesto; los montos tienen 2 decimales. |
| RF-PED-04 | Gestionar los estados: pendiente, confirmado, facturado, entregado y cancelado. | M | Solo se permiten las transiciones válidas (ver 03-historias-usuario). |
| RF-PED-05 | Validar el inventario al confirmar un pedido. | M | Ver RF-INV-03 y RF-INV-04. |
| RF-PED-06 | Cancelar un pedido pendiente o confirmado. | M | Un pedido facturado o entregado no se puede cancelar. |
| RF-PED-07 | Listar y filtrar pedidos por estado, cliente y rango de fechas. | M | Los filtros se pueden combinar y el listado es paginado. |
| RF-PED-08 | Consultar el detalle completo de un pedido. | M | Muestra cliente, productos, montos, estado y quién lo registró. |
| RF-PED-09 | Limitar a los vendedores a ver solo sus propios pedidos y los creados desde el portal. | S | Un vendedor no puede consultar pedidos creados por otro vendedor, pero sí los del portal, que debe atender. |
| RF-PED-10 | Conservar el precio unitario vigente al agregar un producto al pedido. | M | Si el precio del producto cambia después, el pedido mantiene el precio anterior. |
| RF-PED-11 | Marcar un pedido facturado como entregado. | M | El pedido pasa a "entregado" y queda registrado. |

### 2.7 FAC: Generación de facturas

| ID | Requisito | Prior. | Criterio de aceptación |
|---|---|---|---|
| RF-FAC-01 | Emitir una factura a partir de un pedido confirmado. | M | Solo se puede facturar un pedido en estado "confirmado". |
| RF-FAC-02 | Asignar a cada factura un número correlativo único. | M | No existen dos facturas con el mismo número. |
| RF-FAC-03 | Mostrar en la factura subtotal, impuesto y total. | M | Los montos coinciden con los del pedido. |
| RF-FAC-04 | Definir la tasa de impuesto como parámetro configurable. | M | Cambiar el parámetro no requiere modificar el código. |
| RF-FAC-05 | Generar la factura en PDF. | M | El PDF incluye datos del negocio, cliente, detalle, impuestos y total. |
| RF-FAC-06 | Descargar o reimprimir el PDF de una factura emitida. | M | El PDF descargado es idéntico al original. |
| RF-FAC-07 | Registrar el pago de una factura (método y fecha). | S | La factura pasa a "pagada" y se guarda la fecha. |
| RF-FAC-08 | Permitir una sola factura por pedido. | M | Un segundo intento de facturar el mismo pedido es rechazado. |
| RF-FAC-09 | No permitir editar una factura emitida. | M | No existen endpoints de edición; solo el registro de pago. |

### 2.8 REP: Reportes y dashboard

| ID | Requisito | Prior. | Criterio de aceptación |
|---|---|---|---|
| RF-REP-01 | Mostrar un dashboard con ventas del día y del mes, pedidos por estado y productos bajo el mínimo. | M | Los valores coinciden con los datos registrados. |
| RF-REP-02 | Generar un reporte de ventas por rango de fechas. | M | Muestra total vendido, impuestos y cantidad de facturas. |
| RF-REP-03 | Mostrar los productos más vendidos. | S | Ranking de los 10 productos con más unidades vendidas en el periodo. |
| RF-REP-04 | Generar un reporte de inventario valorizado. | S | Muestra existencias por precio, y el total. |
| RF-REP-05 | Presentar gráficos de ventas por periodo. | S | Gráfico de barras o líneas por día o mes. |
| RF-REP-06 | Exportar reportes a CSV o PDF. | C | El archivo exportado coincide con lo mostrado en pantalla. |

### 2.9 NOT: Notificaciones

| ID | Requisito | Prior. | Criterio de aceptación |
|---|---|---|---|
| RF-NOT-01 | Notificar automáticamente cuando un producto llega al stock mínimo. | M | Al confirmar un pedido que deja un producto en o bajo el mínimo, se notifica a administradores y personal de almacén. |
| RF-NOT-02 | Notificar a los usuarios correspondientes cuando se confirma un pedido nuevo. | S | Los roles de almacén y facturación reciben el aviso. |
| RF-NOT-03 | Notificar al vendedor cuando se emite la factura de su pedido. | S | El vendedor creador del pedido recibe el aviso. |
| RF-NOT-04 | Notificar cuando se registra un pago. | C | El administrador recibe el aviso. |
| RF-NOT-05 | Listar notificaciones y marcarlas como leídas. | M | Cada usuario solo ve las suyas. |
| RF-NOT-06 | Mostrar el contador de notificaciones no leídas. | S | El contador se actualiza al marcar como leída. |

### 2.10 MOV: Aplicación móvil

| ID | Requisito | Prior. | Criterio de aceptación |
|---|---|---|---|
| RF-MOV-01 | Iniciar sesión desde la aplicación móvil. | M | Usa las mismas credenciales y roles que la web. |
| RF-MOV-02 | Consultar el catálogo de productos y sus existencias. | M | Búsqueda por nombre o SKU. |
| RF-MOV-03 | Crear pedidos desde el teléfono. | M | Aplica las mismas validaciones que en la web. |
| RF-MOV-04 | Consultar el estado de los pedidos. | M | Lista filtrable por estado. |
| RF-MOV-05 | Ver las notificaciones dentro de la aplicación. | S | Se listan y se pueden marcar como leídas. |
| RF-MOV-06 | Consultar la información de los clientes. | S | Búsqueda por nombre. |

### 2.11 POR: Portal del cliente

Los clientes pueden tener un acceso propio para consultar el catálogo y hacer pedidos. **El pedido del portal nace pendiente y no descuenta inventario** hasta que el personal lo confirma.

| ID | Requisito | Prior. | Criterio de aceptación |
|---|---|---|---|
| RF-POR-01 | El cliente inicia sesión en el portal con su propio usuario. | S | Con credenciales válidas ve solo las opciones del portal. |
| RF-POR-02 | El cliente consulta el catálogo de productos activos con precio y disponibilidad (disponible o agotado). | S | No se muestran existencias exactas ni productos inactivos. |
| RF-POR-03 | El cliente crea un pedido propio. | S | El pedido queda `pendiente`, asociado a su registro de cliente, con origen `portal`, y no modifica el inventario. |
| RF-POR-04 | El cliente edita o cancela su pedido mientras esté pendiente. | S | Un pedido confirmado ya no puede modificarse ni cancelarse por el cliente. |
| RF-POR-05 | El cliente consulta sus pedidos y el estado de cada uno. | S | Solo ve sus pedidos, nunca los de otro cliente. |
| RF-POR-06 | El cliente consulta y descarga sus facturas en PDF. | S | Solo accede a facturas de sus propios pedidos. |
| RF-POR-07 | El cliente recibe notificaciones sobre sus pedidos. | C | Requiere ampliar las notificaciones (hoy están pensadas para el personal). |
| RF-POR-08 | El personal recibe una notificación cuando entra un pedido del portal. | S | Administradores y vendedores reciben el aviso de pedido nuevo pendiente. |
| RF-POR-09 | El portal nunca expone datos de otros clientes, de inventario exacto ni datos internos. | M | Prueba con dos clientes distintos y con intentos de acceso directo a la API. |

---

## 3. Requisitos no funcionales

| ID | Categoría | Requisito | Criterio de verificación |
|---|---|---|---|
| RNF-REN-01 | Rendimiento | Las consultas de listados responden con rapidez. | El 95 % de las consultas con hasta 1 000 registros responde en menos de 800 ms. |
| RNF-REN-02 | Rendimiento | Los listados se paginan. | Máximo 50 registros por página. |
| RNF-SEG-01 | Seguridad | Toda comunicación cliente-servidor usa HTTPS. | Ninguna petición en el entorno desplegado se acepta por HTTP. |
| RNF-SEG-02 | Seguridad | Las contraseñas las gestiona Supabase Auth; la aplicación nunca las almacena ni las registra. | Revisión de código y de la base de datos. |
| RNF-SEG-03 | Seguridad | Las claves secretas (por ejemplo `service_role`) solo existen en el backend, en variables de entorno. | `.env` en `.gitignore`; búsqueda de secretos en el repositorio sin resultados. |
| RNF-SEG-04 | Seguridad | Row Level Security activo en todas las tablas. | Prueba de acceso con distintos roles. |
| RNF-SEG-05 | Seguridad | Toda entrada se valida en el servidor y las consultas son parametrizadas. | Pruebas con entradas inválidas y con intentos de inyección. |
| RNF-SEG-06 | Seguridad | Los mensajes de error no revelan datos internos. | Revisión de respuestas de error. |
| RNF-SEG-07 | Seguridad | Un cliente solo accede a sus propios datos. | Prueba con dos clientes y con peticiones directas a la API. |
| RNF-USA-01 | Usabilidad | Interfaz en español. | Todos los textos visibles están en español. |
| RNF-USA-02 | Usabilidad | La web es responsive (escritorio, tableta y teléfono). | Prueba en tres anchos de pantalla. |
| RNF-USA-03 | Usabilidad | Un usuario capacitado registra un pedido de 3 productos en menos de 2 minutos. | Prueba de uso cronometrada. |
| RNF-FIA-01 | Fiabilidad | Las operaciones que modifican varias tablas (confirmar, facturar, cancelar) son transaccionales. | Si falla un paso, no queda ningún cambio parcial. |
| RNF-FIA-02 | Fiabilidad | Existen respaldos de la base de datos. | Configuración de respaldos del proveedor documentada. |
| RNF-DIS-01 | Disponibilidad | Disponible en horario laboral durante la demostración. | Objetivo del 99 %, sujeto a los servicios en la nube usados. |
| RNF-MAN-01 | Mantenibilidad | El código backend está organizado en capas (rutas, controladores, servicios). | Estructura de carpetas conforme a 05-arquitectura. |
| RNF-MAN-02 | Mantenibilidad | Se aplican convenciones de estilo con ESLint y Prettier. | El lint pasa sin errores. |
| RNF-MAN-03 | Mantenibilidad | El repositorio tiene README y documentación en `docs/`. | Los 5 documentos y el README existen. |
| RNF-MAN-04 | Mantenibilidad | Se trabaja con ramas por módulo y commits descriptivos. | Historial de Git revisado. |
| RNF-PRU-01 | Calidad | Existen pruebas unitarias de la lógica crítica. | Pruebas del cálculo de totales y de la validación de existencias. |
| RNF-POR-01 | Portabilidad | La web funciona en navegadores modernos; la app, en Android e iOS recientes. | Prueba en Chrome, Edge y Firefox; app en emulador o dispositivo. |
| RNF-LOC-01 | Localización | Moneda en lempiras (L), fechas en formato dd/mm/aaaa y zona horaria de Honduras. | Revisión visual de montos y fechas. |
| RNF-DAT-01 | Integridad de datos | La base de datos impone claves foráneas, valores únicos y restricciones de dominio. | Intentos de insertar datos inválidos son rechazados. |
| RNF-DAT-02 | Integridad de datos | Clientes y productos se dan de baja de forma lógica, no física. | No se eliminan registros con historial. |
| RNF-DES-01 | Restricción | El proyecto debe poder realizarse por una persona en unas 8 semanas. | Alcance acotado a lo definido y priorizado con MoSCoW. |

---

## 4. Supuestos y puntos a validar

1. **Impuesto sobre ventas (ISV):** la tasa general en Honduras es del 15 %. Existe una tasa del 18 % para ciertos bienes (por ejemplo, alcohol y tabaco) y hay productos exentos (como la canasta básica). Esta versión soporta **15 % o exento** por producto; el 18 % queda como mejora. Confirma con la normativa vigente del SAR y con el negocio.
2. **Pagos:** al no haber pasarela de pago (fuera de alcance), el pago se registra de forma manual.
3. **Facturación:** el documento generado es un comprobante interno; no sustituye la factura fiscal oficial.
4. **Un solo negocio (single-tenant):** no hay multiempresa en esta versión.
5. **Roles:** se proponen 5: cuatro del personal (administrador, vendedor, almacén y facturación) y el **cliente** del portal. Se pueden ajustar tras validar con el profesor o el negocio real.
7. **Portal del cliente:** amplía el alcance de la ficha original (donde el cliente es solo un registro). Su prioridad es *Should*: entra solo si los sprints 2 y 3 terminan a tiempo.
6. **Historial de movimientos de inventario:** queda como mejora, porque implica una décima tabla.

## 5. Trazabilidad con otros documentos

| Documento | Qué toma de este |
|---|---|
| `02-roles-permisos.md` | RF-ROL-xx y RNF-SEG-xx |
| `03-historias-usuario.md` | Cada historia enlaza uno o más RF |
| `04-modelo-datos.md` | Entidades y restricciones que soportan los RF y RNF-DAT |
| `05-arquitectura.md` | RNF de rendimiento, seguridad y mantenibilidad |
