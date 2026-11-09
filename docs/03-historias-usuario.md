# SmartFlow ERP: Historias de usuario

| | |
|---|---|
| **Proyecto** | SmartFlow ERP |
| **Autora** | Maria Cristina Lopez (62151021), CEUTEC |
| **Versión** | 1.0 (borrador), noviembre de 2026 |
| **Elaboración** | Generado con asistencia de Claude; pendiente de revisión de la autora |
| **Relacionado con** | `01-requisitos.md` (RF) y `02-roles-permisos.md` (roles) |

---

## 1. Cómo leer este documento

**Formato de cada historia:** *Como* [rol], *quiero* [acción], *para* [beneficio].

**Criterios de aceptación:** se escriben en formato **Dado / Cuando / Entonces** (Given / When / Then).

**Estimación:** puntos de historia con escala Fibonacci (1, 2, 3, 5, 8). Representan esfuerzo relativo, no horas.

**Prioridad:** MoSCoW (Must / Should / Could), igual que en `01-requisitos.md`.

**Plan de sprints** (4 sprints de 2 semanas, unas 8 semanas):

| Sprint | Enfoque |
|---|---|
| **1** | Análisis, diseño y preparación del entorno (documentos 01 a 05, repositorio, Supabase). Sin historias de código. |
| **2** | Seguridad, usuarios, clientes, productos e inventario base |
| **3** | Núcleo del negocio: pedidos, validación de inventario y facturación |
| **4** | Dashboard, reportes, notificaciones, aplicación móvil, pruebas y despliegue |

---

## 2. Índice de historias

| ID | Historia | Rol | Prior. | Pts | Sprint | RF relacionados |
|---|---|---|---|---:|:---:|---|
| HU-01 | Iniciar y cerrar sesión | Todos | M | 3 | 2 | RF-AUT-01, 02, 04, 05 |
| HU-02 | Gestionar usuarios y asignar roles | Administrador | M | 5 | 2 | RF-ROL-01, 02 |
| HU-03 | Restringir acciones según el rol | Administrador | M | 5 | 2 | RF-ROL-03, 04 |
| HU-04 | Registrar y editar clientes | Vendedor | M | 3 | 2 | RF-CLI-01, 02, 06 |
| HU-05 | Consultar y buscar clientes | Vendedor | M | 2 | 2 | RF-CLI-03, 04, 05 |
| HU-06 | Registrar y editar productos | Almacén | M | 3 | 2 | RF-PRO-01, 02, 04, 05, 06 |
| HU-07 | Consultar el catálogo con existencias | Vendedor | M | 2 | 2 | RF-PRO-03, RF-INV-01 |
| HU-08 | Registrar entradas de mercadería | Almacén | M | 3 | 2 | RF-INV-02, 05, 06 |
| HU-09 | Recibir alertas de stock bajo | Almacén | M | 3 | 3 | RF-INV-08, RF-NOT-01 |
| HU-10 | Crear un pedido | Vendedor | M | 8 | 3 | RF-PED-01, 02, 03, 10 |
| HU-11 | Confirmar un pedido validando inventario | Vendedor | M | 8 | 3 | RF-PED-04, 05, RF-INV-03, 04 |
| HU-12 | Cancelar un pedido | Vendedor / Admin | M | 3 | 3 | RF-PED-06, RF-INV-07 |
| HU-13 | Consultar el estado de los pedidos | Vendedor | M | 3 | 3 | RF-PED-07, 08, 09 |
| HU-14 | Emitir una factura | Facturación | M | 8 | 3 | RF-FAC-01, 02, 03, 04, 08, 09 |
| HU-15 | Descargar la factura en PDF | Facturación | M | 5 | 4 | RF-FAC-05, 06 |
| HU-16 | Registrar el pago de una factura | Facturación | S | 3 | 4 | RF-FAC-07 |
| HU-17 | Marcar un pedido como entregado | Almacén | M | 2 | 4 | RF-PED-11 |
| HU-18 | Ver el dashboard de ventas e inventario | Administrador | M | 8 | 4 | RF-REP-01, 05 |
| HU-19 | Generar el reporte de ventas por fechas | Facturación | M | 5 | 4 | RF-REP-02, 03 |
| HU-20 | Ver y gestionar mis notificaciones | Todos | M | 3 | 4 | RF-NOT-02, 03, 05, 06 |
| HU-21 | Crear pedidos desde la app móvil | Vendedor | M | 8 | 4 | RF-MOV-01, 02, 03 |
| HU-22 | Consultar pedidos e inventario desde el móvil | Vendedor | S | 3 | 4 | RF-MOV-04, 05, 06 |
| HU-23 | Hacer un pedido desde el portal | Cliente | S | 5 | 4 | RF-POR-01, 02, 03, 04, 09 |
| HU-24 | Consultar mis pedidos y facturas | Cliente | S | 3 | 4 | RF-POR-05, 06 |
| HU-25 | Dar acceso al portal a un cliente | Administrador / Vendedor | S | 3 | 4 | RF-CLI-07, RF-POR-08 |

**Totales por sprint:** Sprint 2 = 26 pts · Sprint 3 = 33 pts · Sprint 4 = 37 pts. Los Sprints 3 y 4 son los más cargados; si el tiempo aprieta, HU-22 y HU-16 son las primeras candidatas a recortarse (prioridad *Should*).

**Portal del cliente (HU-23 a HU-25, 11 pts):** si se incluye, el Sprint 4 sube a **48 pts**, lo que no es realista. El portal entra solo si los sprints 2 y 3 terminan a tiempo; de lo contrario, se deja como versión 2 y se presenta como mejora futura.

---

## 3. Historias de usuario detalladas

### Módulo de acceso y usuarios

#### HU-01: Iniciar y cerrar sesión
**Como** usuario del sistema, **quiero** iniciar sesión con mi correo y contraseña, **para** acceder solo a lo que me corresponde.
**Prioridad:** M · **Puntos:** 3 · **Sprint:** 2

1. **Dado** que tengo una cuenta activa, **cuando** ingreso mi correo y contraseña correctos, **entonces** accedo al sistema y veo las opciones de mi rol.
2. **Dado** que ingreso una contraseña incorrecta, **cuando** intento iniciar sesión, **entonces** veo un mensaje genérico ("Credenciales inválidas") sin saber cuál dato falló.
3. **Dado** que mi cuenta fue desactivada, **cuando** intento entrar, **entonces** el sistema me niega el acceso.
4. **Dado** que estoy dentro, **cuando** cierro sesión, **entonces** vuelvo al login y no puedo regresar con el botón "atrás".

#### HU-02: Gestionar usuarios y asignar roles
**Como** administrador, **quiero** crear, editar y desactivar usuarios y asignarles un rol, **para** controlar quién usa el sistema.
**Prioridad:** M · **Puntos:** 5 · **Sprint:** 2

1. **Dado** que soy administrador, **cuando** registro un usuario con nombre, correo, contraseña temporal y rol, **entonces** el usuario aparece en el listado y puede iniciar sesión.
2. **Dado** que intento guardar un usuario sin rol, **cuando** presiono guardar, **entonces** el sistema lo rechaza indicando que el rol es obligatorio.
3. **Dado** un usuario activo, **cuando** lo desactivo, **entonces** ya no puede iniciar sesión y sus registros históricos se conservan.
4. **Dado** que no soy administrador, **cuando** intento acceder a la gestión de usuarios, **entonces** el sistema me responde "sin permiso".

#### HU-03: Restringir acciones según el rol
**Como** administrador, **quiero** que cada rol solo pueda realizar las acciones permitidas, **para** proteger la información y evitar errores.
**Prioridad:** M · **Puntos:** 5 · **Sprint:** 2

1. **Dado** que soy vendedor, **cuando** abro el menú, **entonces** no veo las opciones de usuarios ni reportes financieros.
2. **Dado** que soy vendedor, **cuando** intento llamar directamente a un servicio de facturación, **entonces** la API responde 403 y no se modifica nada.
3. **Dado** que soy vendedor, **cuando** consulto pedidos, **entonces** solo veo los que yo creé.
4. **Dado** que soy administrador, **cuando** consulto la matriz de permisos, **entonces** veo qué puede hacer cada rol.

### Módulo de clientes

#### HU-04: Registrar y editar clientes
**Como** vendedor, **quiero** registrar y actualizar los datos de mis clientes, **para** asociarlos a sus pedidos sin repetir información.
**Prioridad:** M · **Puntos:** 3 · **Sprint:** 2

1. **Dado** que estoy en el formulario de cliente, **cuando** guardo con nombre y contacto, **entonces** el cliente queda registrado.
2. **Dado** que dejo el nombre vacío, **cuando** intento guardar, **entonces** el sistema indica que el nombre es obligatorio.
3. **Dado** que existe un cliente con la misma identificación, **cuando** intento registrar otro igual, **entonces** el sistema me avisa del duplicado.
4. **Dado** un cliente existente, **cuando** modifico su teléfono y guardo, **entonces** el cambio se refleja de inmediato.

#### HU-05: Consultar y buscar clientes
**Como** vendedor, **quiero** buscar clientes por nombre o identificación y ver su historial, **para** atenderlos con rapidez.
**Prioridad:** M · **Puntos:** 2 · **Sprint:** 2

1. **Dado** que hay más de 50 clientes, **cuando** abro el listado, **entonces** veo la primera página y puedo navegar entre páginas.
2. **Dado** que escribo parte de un nombre, **cuando** busco, **entonces** veo solo los clientes que coinciden.
3. **Dado** un cliente con pedidos, **cuando** abro su ficha, **entonces** veo sus pedidos ordenados por fecha.
4. **Dado** un cliente desactivado, **cuando** creo un pedido, **entonces** ya no aparece entre las opciones, pero sus pedidos anteriores se conservan.

### Módulo de productos e inventario

#### HU-06: Registrar y editar productos
**Como** encargado de almacén, **quiero** registrar productos con SKU, nombre, precio e impuesto, **para** tener un catálogo ordenado.
**Prioridad:** M · **Puntos:** 3 · **Sprint:** 2

1. **Dado** que registro un producto con SKU nuevo, **cuando** guardo, **entonces** queda creado y su inventario inicia en 0.
2. **Dado** que el SKU ya existe, **cuando** guardo, **entonces** el sistema lo rechaza.
3. **Dado** que ingreso un precio negativo, **cuando** guardo, **entonces** el sistema lo rechaza.
4. **Dado** un producto desactivado, **cuando** creo un pedido, **entonces** no puedo agregarlo.

#### HU-07: Consultar el catálogo con existencias
**Como** vendedor, **quiero** ver los productos con su precio y sus existencias, **para** saber qué puedo ofrecer al cliente.
**Prioridad:** M · **Puntos:** 2 · **Sprint:** 2

1. **Dado** el catálogo, **cuando** lo abro, **entonces** veo SKU, nombre, precio y existencias de cada producto.
2. **Dado** que escribo un SKU o parte de un nombre, **cuando** busco, **entonces** se filtran los resultados.
3. **Dado** un producto sin existencias, **cuando** lo veo en el listado, **entonces** aparece marcado como agotado.

#### HU-08: Registrar entradas de mercadería
**Como** encargado de almacén, **quiero** registrar la mercadería que llega y definir el stock mínimo, **para** mantener el inventario al día.
**Prioridad:** M · **Puntos:** 3 · **Sprint:** 2

1. **Dado** un producto con 10 unidades, **cuando** registro una entrada de 25, **entonces** las existencias pasan a 35.
2. **Dado** que ingreso una cantidad menor o igual a 0, **cuando** guardo la entrada, **entonces** el sistema la rechaza.
3. **Dado** un producto, **cuando** defino su mínimo en 8, **entonces** el sistema usa ese valor para las alertas.
4. **Dado** que hago un ajuste manual, **cuando** el resultado sería negativo, **entonces** el sistema lo rechaza.

#### HU-09: Recibir alertas de stock bajo
**Como** encargado de almacén, **quiero** recibir una alerta cuando un producto llega al mínimo, **para** reabastecer a tiempo.
**Prioridad:** M · **Puntos:** 3 · **Sprint:** 3

1. **Dado** un producto con 12 unidades y mínimo 10, **cuando** se confirma un pedido que lo deja en 8, **entonces** recibo una notificación de stock bajo.
2. **Dado** que existen productos bajo el mínimo, **cuando** abro "Stock bajo", **entonces** los veo ordenados del más crítico al menos crítico.
3. **Dado** que leí la notificación, **cuando** la marco como leída, **entonces** deja de contarse como pendiente.

### Módulo de pedidos

#### HU-10: Crear un pedido
**Como** vendedor, **quiero** crear un pedido eligiendo cliente y productos, **para** registrar la venta sin papel.
**Prioridad:** M · **Puntos:** 8 · **Sprint:** 3

1. **Dado** que elijo un cliente y agrego 3 productos con cantidades, **cuando** guardo, **entonces** se crea un pedido en estado "pendiente".
2. **Dado** un pedido en construcción, **cuando** agrego un producto, **entonces** se calculan subtotal, impuesto y total.
3. **Dado** un producto que aplica impuesto, **cuando** se calcula el total, **entonces** el impuesto usa la tasa configurada; si no aplica, el impuesto es 0.
4. **Dado** que el precio de un producto cambia después, **cuando** reviso mi pedido, **entonces** conserva el precio con el que lo agregué.
5. **Dado** un pedido pendiente, **cuando** cambio una cantidad o quito un producto, **entonces** los montos se recalculan.

#### HU-11: Confirmar un pedido validando inventario
**Como** vendedor, **quiero** confirmar un pedido y que el sistema verifique el inventario, **para** no vender lo que no tengo.
**Prioridad:** M · **Puntos:** 8 · **Sprint:** 3

1. **Dado** un pedido pendiente con existencias suficientes, **cuando** lo confirmo, **entonces** pasa a "confirmado" y las existencias bajan según las cantidades pedidas.
2. **Dado** un pedido donde un producto no tiene existencias suficientes, **cuando** lo confirmo, **entonces** el sistema me indica cuál producto falla y no cambia ninguna existencia ni el estado.
3. **Dado** un pedido sin productos, **cuando** intento confirmarlo, **entonces** el sistema me lo impide.
4. **Dado** que dos vendedores confirman al mismo tiempo pedidos con el mismo producto y existencias para uno solo, **cuando** ambos confirman, **entonces** solo uno tiene éxito y las existencias nunca quedan negativas.
5. **Dado** un pedido confirmado, **cuando** intento editar su detalle, **entonces** el sistema lo rechaza.
6. **Dado** un pedido creado por un cliente desde el portal, **cuando** lo reviso y lo confirmo, **entonces** se aplican las mismas validaciones de inventario y el cliente ve el nuevo estado.

#### HU-12: Cancelar un pedido
**Como** vendedor o administrador, **quiero** cancelar un pedido, **para** corregir errores o ventas que no se concretan.
**Prioridad:** M · **Puntos:** 3 · **Sprint:** 3

1. **Dado** un pedido pendiente, **cuando** lo cancelo, **entonces** pasa a "cancelado" sin afectar el inventario.
2. **Dado** un pedido confirmado, **cuando** el administrador lo cancela, **entonces** las existencias se restituyen.
3. **Dado** que soy vendedor y el pedido está confirmado, **cuando** intento cancelarlo, **entonces** el sistema me niega el permiso.
4. **Dado** un pedido facturado o entregado, **cuando** intento cancelarlo, **entonces** el sistema lo rechaza.

#### HU-13: Consultar el estado de los pedidos
**Como** vendedor, **quiero** ver mis pedidos y filtrarlos por estado, cliente o fecha, **para** dar seguimiento a cada venta.
**Prioridad:** M · **Puntos:** 3 · **Sprint:** 3

1. **Dado** que tengo pedidos en varios estados, **cuando** filtro por "confirmado", **entonces** veo solo esos.
2. **Dado** que combino cliente y rango de fechas, **cuando** busco, **entonces** el resultado cumple ambos filtros.
3. **Dado** que abro un pedido, **cuando** veo el detalle, **entonces** aparecen cliente, productos, montos, estado y fecha.
4. **Dado** que soy vendedor, **cuando** consulto el listado, **entonces** no veo pedidos de otros vendedores, pero sí los creados por clientes desde el portal.

### Módulo de facturación

#### HU-14: Emitir una factura
**Como** responsable de facturación, **quiero** emitir la factura de un pedido confirmado, **para** formalizar la venta con sus impuestos.
**Prioridad:** M · **Puntos:** 8 · **Sprint:** 3

1. **Dado** un pedido confirmado, **cuando** emito la factura, **entonces** se crea con número único, subtotal, impuesto y total, y el pedido pasa a "facturado".
2. **Dado** un pedido pendiente, **cuando** intento facturarlo, **entonces** el sistema lo rechaza.
3. **Dado** un pedido ya facturado, **cuando** intento emitir otra factura, **entonces** el sistema lo rechaza.
4. **Dado** una factura emitida, **cuando** busco cómo editarla, **entonces** no existe esa opción.
5. **Dado** que se emite la factura, **cuando** termina el proceso, **entonces** el vendedor del pedido recibe una notificación.

#### HU-15: Descargar la factura en PDF
**Como** responsable de facturación, **quiero** descargar la factura en PDF, **para** entregarla al cliente.
**Prioridad:** M · **Puntos:** 5 · **Sprint:** 4

1. **Dado** una factura emitida, **cuando** presiono "Descargar PDF", **entonces** obtengo un archivo con datos del negocio, cliente, detalle, impuestos y total.
2. **Dado** que descargo la misma factura otra vez, **cuando** comparo los archivos, **entonces** el contenido es idéntico.
3. **Dado** que soy vendedor, **cuando** abro una factura de otro vendedor, **entonces** el sistema me niega el acceso.

#### HU-16: Registrar el pago de una factura
**Como** responsable de facturación, **quiero** registrar el pago de una factura, **para** saber qué ventas están cobradas.
**Prioridad:** S · **Puntos:** 3 · **Sprint:** 4

1. **Dado** una factura pendiente, **cuando** registro el pago con método (efectivo, transferencia o tarjeta), **entonces** pasa a "pagada" y se guarda la fecha.
2. **Dado** una factura ya pagada, **cuando** intento registrar otro pago, **entonces** el sistema lo rechaza.

#### HU-17: Marcar un pedido como entregado
**Como** encargado de almacén, **quiero** marcar un pedido facturado como entregado, **para** cerrar el ciclo.
**Prioridad:** M · **Puntos:** 2 · **Sprint:** 4

1. **Dado** un pedido facturado, **cuando** lo marco como entregado, **entonces** su estado cambia a "entregado".
2. **Dado** un pedido que no está facturado, **cuando** intento marcarlo como entregado, **entonces** el sistema lo rechaza.

### Módulo de reportes y notificaciones

#### HU-18: Ver el dashboard de ventas e inventario
**Como** administrador, **quiero** ver un panel con ventas, pedidos y stock bajo, **para** tomar decisiones rápidas.
**Prioridad:** M · **Puntos:** 8 · **Sprint:** 4

1. **Dado** que abro el dashboard, **cuando** carga, **entonces** veo ventas del día y del mes, pedidos por estado y productos bajo el mínimo.
2. **Dado** que se emite una factura nueva, **cuando** actualizo el panel, **entonces** las ventas reflejan el nuevo monto.
3. **Dado** el gráfico de ventas, **cuando** cambio entre días y meses, **entonces** el gráfico se actualiza.
4. **Dado** que soy vendedor, **cuando** abro el dashboard, **entonces** solo veo información de mis propias ventas.

#### HU-19: Generar el reporte de ventas por fechas
**Como** responsable de facturación, **quiero** un reporte de ventas por rango de fechas, **para** conocer lo vendido y los impuestos del periodo.
**Prioridad:** M · **Puntos:** 5 · **Sprint:** 4

1. **Dado** un rango de fechas, **cuando** genero el reporte, **entonces** veo total vendido, impuestos y cantidad de facturas.
2. **Dado** un rango sin ventas, **cuando** genero el reporte, **entonces** veo ceros y un mensaje claro, no un error.
3. **Dado** el reporte, **cuando** lo reviso, **entonces** veo el ranking de los 10 productos más vendidos del periodo.

#### HU-20: Ver y gestionar mis notificaciones
**Como** usuario, **quiero** ver mis notificaciones y marcarlas como leídas, **para** enterarme de lo importante.
**Prioridad:** M · **Puntos:** 3 · **Sprint:** 4

1. **Dado** que tengo 3 notificaciones sin leer, **cuando** abro el sistema, **entonces** el contador muestra 3.
2. **Dado** una notificación, **cuando** la marco como leída, **entonces** el contador baja en 1.
3. **Dado** que existen notificaciones de otros usuarios, **cuando** abro mi bandeja, **entonces** solo veo las mías.

### Módulo móvil

#### HU-21: Crear pedidos desde la app móvil
**Como** vendedor, **quiero** crear pedidos desde mi teléfono, **para** atender clientes fuera de la oficina.
**Prioridad:** M · **Puntos:** 8 · **Sprint:** 4

1. **Dado** que inicio sesión en la app, **cuando** ingreso mis credenciales, **entonces** accedo con el mismo rol que en la web.
2. **Dado** el catálogo en el móvil, **cuando** busco un producto y lo agrego a un pedido, **entonces** veo el total actualizado.
3. **Dado** un pedido creado en el móvil, **cuando** abro la web, **entonces** aparece en mi listado.
4. **Dado** que no hay conexión, **cuando** intento guardar, **entonces** la app me avisa del error sin perder lo que escribí.

#### HU-22: Consultar pedidos e inventario desde el móvil
**Como** vendedor, **quiero** consultar el estado de mis pedidos, las existencias y mis notificaciones desde el teléfono, **para** responder rápido al cliente.
**Prioridad:** S · **Puntos:** 3 · **Sprint:** 4

1. **Dado** la app móvil, **cuando** abro "Mis pedidos", **entonces** veo la lista y puedo filtrar por estado.
2. **Dado** un producto, **cuando** lo consulto, **entonces** veo sus existencias actuales.
3. **Dado** una notificación nueva, **cuando** abro la app, **entonces** la veo en la bandeja.

### Módulo portal del cliente

#### HU-23: Hacer un pedido desde el portal
**Como** cliente, **quiero** ver el catálogo y hacer mi pedido por mi cuenta, **para** comprar sin tener que llamar o visitar el negocio.
**Prioridad:** S · **Puntos:** 5 · **Sprint:** 4

1. **Dado** que inicio sesión como cliente, **cuando** abro el portal, **entonces** veo solo el catálogo, mis pedidos y mis facturas.
2. **Dado** el catálogo, **cuando** lo consulto, **entonces** veo precio y si el producto está disponible o agotado, pero no las existencias exactas.
3. **Dado** que agrego productos y envío el pedido, **cuando** lo guardo, **entonces** queda en estado "pendiente" a mi nombre y el inventario no cambia.
4. **Dado** un pedido pendiente, **cuando** cambio una cantidad o lo cancelo, **entonces** el cambio se aplica; si ya fue confirmado, el sistema no me lo permite.
5. **Dado** que envío el pedido, **cuando** termina el proceso, **entonces** administradores y vendedores reciben una notificación de pedido nuevo.

#### HU-24: Consultar mis pedidos y facturas
**Como** cliente, **quiero** ver el estado de mis pedidos y descargar mis facturas, **para** dar seguimiento a mis compras.
**Prioridad:** S · **Puntos:** 3 · **Sprint:** 4

1. **Dado** que tengo pedidos en distintos estados, **cuando** abro "Mis pedidos", **entonces** veo solo los míos con su estado.
2. **Dado** un pedido facturado, **cuando** abro la factura, **entonces** puedo descargar el PDF.
3. **Dado** que intento abrir el pedido o la factura de otro cliente, **cuando** modifico el enlace o la petición, **entonces** el sistema me niega el acceso.

#### HU-25: Dar acceso al portal a un cliente
**Como** administrador o vendedor, **quiero** crear un acceso para un cliente registrado, **para** que pueda hacer sus pedidos en línea.
**Prioridad:** S · **Puntos:** 3 · **Sprint:** 4

1. **Dado** la ficha de un cliente sin acceso, **cuando** creo su acceso con un correo y una contraseña temporal, **entonces** el cliente puede iniciar sesión en el portal.
2. **Dado** un cliente que ya tiene acceso, **cuando** intento crear otro, **entonces** el sistema me lo impide.
3. **Dado** un cliente con acceso, **cuando** desactivo su usuario, **entonces** ya no puede entrar, pero sus pedidos y facturas se conservan.

---

## 4. Definición de terminado (DoD)

Una historia pasa a **Hecho** en Trello solo si:

- [ ] Cumple todos sus criterios de aceptación.
- [ ] El código está en una rama por módulo y fue integrado a `develop`.
- [ ] Tiene pruebas manuales documentadas (o pruebas automáticas en la lógica crítica).
- [ ] No incluye secretos ni claves en el repositorio.
- [ ] Está documentada en el README o en `docs/` si cambió la API o la base de datos.

## 5. Cómo pasar estas historias a Trello

1. Crea una tarjeta por historia, con el título `HU-XX: ...`.
2. Copia los criterios de aceptación en la descripción y conviértelos en un checklist.
3. Aplica las etiquetas de módulo (Frontend, Backend, Base de datos, Móvil) y la de prioridad.
4. Las historias del Sprint 2 pasan a "Por hacer (Sprint actual)" cuando termines el Sprint 1.
