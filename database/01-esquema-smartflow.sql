-- ============================================================
-- SmartFlow ERP - Esquema completo de base de datos (Supabase)
-- Ejecutar UNA SOLA VEZ en Supabase > SQL Editor > New query
-- ============================================================

-- ---------- 5.1 Tipos, secuencias y funciones auxiliares ----------
-- ============================================================
-- SmartFlow ERP: esquema inicial (Supabase / PostgreSQL)
-- ============================================================

-- Tipos enumerados
create type public.estado_pedido as enum
  ('pendiente', 'confirmado', 'facturado', 'entregado', 'cancelado');
create type public.estado_pago as enum
  ('pendiente', 'pagada', 'anulada');
create type public.tipo_notificacion as enum
  ('stock_bajo', 'pedido_nuevo', 'factura_emitida', 'pago_recibido');

-- Secuencias para la numeración automática
create sequence public.seq_pedidos  start 1;
create sequence public.seq_facturas start 1;

-- Mantiene actualizado el campo actualizado_en
create or replace function public.set_actualizado_en()
returns trigger
language plpgsql
as $$
begin
  new.actualizado_en = now();
  return new;
end;
$$;

-- ---------- 5.2 Tablas ----------
-- 1. Roles
create table public.roles (
  id          smallint generated always as identity primary key,
  nombre      text not null unique
              check (nombre in ('administrador', 'vendedor', 'almacen', 'facturacion', 'cliente')),
  descripcion text,
  permisos    jsonb not null default '[]'::jsonb
);

-- 2. Usuarios (perfil enlazado a Supabase Auth)
create table public.usuarios (
  id              uuid primary key references auth.users (id) on delete cascade,
  nombre_completo text not null,
  email           text not null unique,
  rol_id          smallint not null references public.roles (id),
  activo          boolean not null default true,
  creado_en       timestamptz not null default now()
);

-- 3. Clientes
create table public.clientes (
  id             bigint generated always as identity primary key,
  nombre         text not null,
  identificacion text unique,
  usuario_id     uuid unique references public.usuarios (id),
  email          text,
  telefono       text,
  direccion      text,
  activo         boolean not null default true,
  creado_en      timestamptz not null default now(),
  actualizado_en timestamptz not null default now()
);

-- 4. Productos
create table public.productos (
  id              bigint generated always as identity primary key,
  sku             text not null unique,
  nombre          text not null,
  descripcion     text,
  precio          numeric(12,2) not null check (precio >= 0),
  aplica_impuesto boolean not null default true,
  activo          boolean not null default true,
  creado_en       timestamptz not null default now(),
  actualizado_en  timestamptz not null default now()
);

-- 5. Inventario (1:1 con productos)
create table public.inventario (
  id             bigint generated always as identity primary key,
  producto_id    bigint not null unique
                 references public.productos (id) on delete cascade,
  existencias    integer not null default 0 check (existencias >= 0),
  minimo         integer not null default 0 check (minimo >= 0),
  actualizado_en timestamptz not null default now()
);

-- 6. Pedidos
create table public.pedidos (
  id             bigint generated always as identity primary key,
  numero         text not null unique
                 default ('PED-' || lpad(nextval('public.seq_pedidos')::text, 6, '0')),
  cliente_id     bigint not null references public.clientes (id),
  creado_por     uuid not null references public.usuarios (id),
  estado         public.estado_pedido not null default 'pendiente',
  subtotal       numeric(12,2) not null default 0 check (subtotal >= 0),
  impuesto       numeric(12,2) not null default 0 check (impuesto >= 0),
  total          numeric(12,2) not null default 0 check (total >= 0),
  tasa_impuesto  numeric(5,2),
  origen         text not null default 'interno' check (origen in ('interno', 'portal')),
  notas          text,
  creado_en      timestamptz not null default now(),
  actualizado_en timestamptz not null default now()
);

-- 7. Detalle del pedido
create table public.detalle_pedido (
  id              bigint generated always as identity primary key,
  pedido_id       bigint not null references public.pedidos (id) on delete cascade,
  producto_id     bigint not null references public.productos (id),
  cantidad        integer not null check (cantidad > 0),
  precio_unitario numeric(12,2) not null check (precio_unitario >= 0),
  subtotal        numeric(12,2) generated always as (cantidad * precio_unitario) stored,
  unique (pedido_id, producto_id)
);

-- 8. Facturas (1:1 con pedidos)
create table public.facturas (
  id            bigint generated always as identity primary key,
  numero        text not null unique
                default ('FAC-' || lpad(nextval('public.seq_facturas')::text, 6, '0')),
  pedido_id     bigint not null unique references public.pedidos (id),
  emitida_por   uuid not null references public.usuarios (id),
  fecha_emision timestamptz not null default now(),
  subtotal      numeric(12,2) not null,
  tasa_impuesto numeric(5,2)  not null,
  impuesto      numeric(12,2) not null,
  total         numeric(12,2) not null,
  estado_pago   public.estado_pago not null default 'pendiente',
  metodo_pago   text check (metodo_pago in ('efectivo', 'transferencia', 'tarjeta')),
  fecha_pago    timestamptz,
  check ((estado_pago = 'pagada') = (fecha_pago is not null))
);

-- 9. Notificaciones
create table public.notificaciones (
  id         bigint generated always as identity primary key,
  usuario_id uuid not null references public.usuarios (id) on delete cascade,
  tipo       public.tipo_notificacion not null,
  mensaje    text not null,
  leida      boolean not null default false,
  creada_en  timestamptz not null default now()
);

-- ---------- 5.3 Indices y triggers ----------
-- Índices (además de los que crean las claves primarias y UNIQUE)
create index idx_pedidos_cliente        on public.pedidos (cliente_id);
create index idx_pedidos_estado         on public.pedidos (estado);
create index idx_pedidos_creado_por     on public.pedidos (creado_por);
create index idx_pedidos_creado_en      on public.pedidos (creado_en desc);
create index idx_detalle_producto       on public.detalle_pedido (producto_id);
create index idx_notif_usuario_leida    on public.notificaciones (usuario_id, leida);
create index idx_facturas_fecha         on public.facturas (fecha_emision desc);
create index idx_usuarios_rol           on public.usuarios (rol_id);

-- Actualización automática de actualizado_en
create trigger trg_clientes_actualizado  before update on public.clientes
  for each row execute function public.set_actualizado_en();
create trigger trg_productos_actualizado before update on public.productos
  for each row execute function public.set_actualizado_en();
create trigger trg_inventario_actualizado before update on public.inventario
  for each row execute function public.set_actualizado_en();
create trigger trg_pedidos_actualizado   before update on public.pedidos
  for each row execute function public.set_actualizado_en();

-- Al crear un producto se crea su registro de inventario
create or replace function public.crear_inventario_producto()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.inventario (producto_id) values (new.id);
  return new;
end;
$$;

create trigger trg_productos_inventario after insert on public.productos
  for each row execute function public.crear_inventario_producto();

-- Un pedido creado desde el portal avisa a administradores y vendedores
create or replace function public.notificar_pedido_portal()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.origen = 'portal' then
    insert into public.notificaciones (usuario_id, tipo, mensaje)
    select u.id, 'pedido_nuevo',
           format('Nuevo pedido del portal %s pendiente de confirmar', new.numero)
      from public.usuarios u
      join public.roles r on r.id = u.rol_id
     where u.activo and r.nombre in ('administrador', 'vendedor');
  end if;
  return new;
end;
$$;

create trigger trg_pedidos_portal after insert on public.pedidos
  for each row execute function public.notificar_pedido_portal();

-- ---------- 5.4 Logica de negocio ----------
-- Confirmar pedido: valida existencias, descuenta inventario, calcula totales y notifica
create or replace function public.confirmar_pedido(
  p_pedido_id bigint,
  p_tasa      numeric default 15.00
)
returns public.pedidos
language plpgsql
as $$
declare
  v_pedido   public.pedidos;
  v_item     record;
  v_subtotal numeric(12,2);
  v_impuesto numeric(12,2);
begin
  select * into v_pedido
  from public.pedidos where id = p_pedido_id for update;

  if not found then
    raise exception 'El pedido % no existe', p_pedido_id;
  end if;
  if v_pedido.estado <> 'pendiente' then
    raise exception 'Solo se puede confirmar un pedido pendiente (estado actual: %)', v_pedido.estado;
  end if;
  if not exists (select 1 from public.detalle_pedido where pedido_id = p_pedido_id) then
    raise exception 'El pedido no tiene productos';
  end if;

  -- Valida existencias y bloquea las filas de inventario involucradas
  for v_item in
    select d.cantidad, i.existencias, p.nombre
    from public.detalle_pedido d
    join public.inventario i on i.producto_id = d.producto_id
    join public.productos  p on p.id = d.producto_id
    where d.pedido_id = p_pedido_id
    order by d.producto_id
    for update of i
  loop
    if v_item.existencias < v_item.cantidad then
      raise exception 'Existencias insuficientes de "%": disponibles %, solicitadas %',
        v_item.nombre, v_item.existencias, v_item.cantidad;
    end if;
  end loop;

  -- Descuenta el inventario
  update public.inventario i
     set existencias = i.existencias - d.cantidad
    from public.detalle_pedido d
   where d.pedido_id = p_pedido_id
     and i.producto_id = d.producto_id;

  -- Calcula los totales
  select coalesce(sum(d.cantidad * d.precio_unitario), 0),
         coalesce(sum(case when p.aplica_impuesto
                           then d.cantidad * d.precio_unitario * p_tasa / 100
                           else 0 end), 0)
    into v_subtotal, v_impuesto
    from public.detalle_pedido d
    join public.productos p on p.id = d.producto_id
   where d.pedido_id = p_pedido_id;

  update public.pedidos
     set estado        = 'confirmado',
         subtotal      = v_subtotal,
         impuesto      = round(v_impuesto, 2),
         total         = v_subtotal + round(v_impuesto, 2),
         tasa_impuesto = p_tasa
   where id = p_pedido_id
   returning * into v_pedido;

  -- Notifica a almacén y facturación que hay un pedido confirmado
  insert into public.notificaciones (usuario_id, tipo, mensaje)
  select u.id, 'pedido_nuevo', format('Pedido %s confirmado', v_pedido.numero)
    from public.usuarios u
    join public.roles r on r.id = u.rol_id
   where u.activo and r.nombre in ('almacen', 'facturacion');

  -- Notifica stock bajo a administradores y almacén
  insert into public.notificaciones (usuario_id, tipo, mensaje)
  select u.id, 'stock_bajo',
         format('Stock bajo: %s (quedan %s, mínimo %s)', p.nombre, i.existencias, i.minimo)
    from public.detalle_pedido d
    join public.inventario i on i.producto_id = d.producto_id
    join public.productos  p on p.id = d.producto_id
    join public.usuarios   u on u.activo
    join public.roles      r on r.id = u.rol_id and r.nombre in ('administrador', 'almacen')
   where d.pedido_id = p_pedido_id
     and i.existencias <= i.minimo;

  return v_pedido;
end;
$$;

-- Emitir factura de un pedido confirmado
create or replace function public.emitir_factura(
  p_pedido_id   bigint,
  p_emitida_por uuid
)
returns public.facturas
language plpgsql
as $$
declare
  v_pedido  public.pedidos;
  v_factura public.facturas;
begin
  select * into v_pedido
  from public.pedidos where id = p_pedido_id for update;

  if not found then
    raise exception 'El pedido % no existe', p_pedido_id;
  end if;
  if v_pedido.estado <> 'confirmado' then
    raise exception 'Solo se puede facturar un pedido confirmado (estado actual: %)', v_pedido.estado;
  end if;

  insert into public.facturas
    (pedido_id, emitida_por, subtotal, tasa_impuesto, impuesto, total)
  values
    (v_pedido.id, p_emitida_por, v_pedido.subtotal, v_pedido.tasa_impuesto,
     v_pedido.impuesto, v_pedido.total)
  returning * into v_factura;

  update public.pedidos set estado = 'facturado' where id = v_pedido.id;

  insert into public.notificaciones (usuario_id, tipo, mensaje)
  values (v_pedido.creado_por, 'factura_emitida',
          format('Factura %s emitida para el pedido %s', v_factura.numero, v_pedido.numero));

  return v_factura;
end;
$$;

-- Cancelar pedido (restituye inventario si estaba confirmado)
create or replace function public.cancelar_pedido(p_pedido_id bigint)
returns public.pedidos
language plpgsql
as $$
declare
  v_pedido public.pedidos;
begin
  select * into v_pedido
  from public.pedidos where id = p_pedido_id for update;

  if not found then
    raise exception 'El pedido % no existe', p_pedido_id;
  end if;
  if v_pedido.estado not in ('pendiente', 'confirmado') then
    raise exception 'No se puede cancelar un pedido en estado %', v_pedido.estado;
  end if;

  if v_pedido.estado = 'confirmado' then
    update public.inventario i
       set existencias = i.existencias + d.cantidad
      from public.detalle_pedido d
     where d.pedido_id = p_pedido_id
       and i.producto_id = d.producto_id;
  end if;

  update public.pedidos set estado = 'cancelado'
   where id = p_pedido_id
   returning * into v_pedido;

  return v_pedido;
end;
$$;

-- Solo el backend (service_role) puede ejecutar estas funciones
revoke execute on function public.confirmar_pedido(bigint, numeric) from public, anon, authenticated;
revoke execute on function public.emitir_factura(bigint, uuid)       from public, anon, authenticated;
revoke execute on function public.cancelar_pedido(bigint)            from public, anon, authenticated;

-- ---------- 5.5 Row Level Security ----------
-- Funciones auxiliares (security definer para evitar recursión de RLS)
create or replace function public.rol_actual()
returns text
language sql
stable
security definer
set search_path = public
as $$
  select r.nombre
    from public.usuarios u
    join public.roles r on r.id = u.rol_id
   where u.id = auth.uid() and u.activo;
$$;

-- true si el usuario es del personal (no es cliente del portal)
create or replace function public.es_personal()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(public.rol_actual() in ('administrador', 'vendedor', 'almacen', 'facturacion'), false);
$$;

-- Activar RLS en las 9 tablas
alter table public.roles          enable row level security;
alter table public.usuarios       enable row level security;
alter table public.clientes       enable row level security;
alter table public.productos      enable row level security;
alter table public.inventario     enable row level security;
alter table public.pedidos        enable row level security;
alter table public.detalle_pedido enable row level security;
alter table public.facturas       enable row level security;
alter table public.notificaciones enable row level security;

-- roles
create policy roles_select on public.roles for select to authenticated
  using (public.es_personal());
create policy roles_admin on public.roles for all to authenticated
  using (public.rol_actual() = 'administrador')
  with check (public.rol_actual() = 'administrador');

-- usuarios
create policy usuarios_select on public.usuarios for select to authenticated
  using (id = auth.uid() or public.rol_actual() = 'administrador');
create policy usuarios_admin on public.usuarios for all to authenticated
  using (public.rol_actual() = 'administrador')
  with check (public.rol_actual() = 'administrador');

-- clientes: el personal ve todos; un cliente del portal solo su propio registro
create policy clientes_select on public.clientes for select to authenticated
  using (public.es_personal() or usuario_id = auth.uid());
create policy clientes_insert on public.clientes for insert to authenticated
  with check (public.rol_actual() in ('administrador', 'vendedor'));
create policy clientes_update on public.clientes for update to authenticated
  using (public.rol_actual() in ('administrador', 'vendedor'))
  with check (public.rol_actual() in ('administrador', 'vendedor'));
create policy clientes_delete on public.clientes for delete to authenticated
  using (public.rol_actual() = 'administrador');

-- productos: el cliente solo ve los activos
create policy productos_select on public.productos for select to authenticated
  using (public.es_personal() or (public.rol_actual() = 'cliente' and activo));
create policy productos_insert on public.productos for insert to authenticated
  with check (public.rol_actual() in ('administrador', 'almacen'));
create policy productos_update on public.productos for update to authenticated
  using (public.rol_actual() in ('administrador', 'almacen'))
  with check (public.rol_actual() in ('administrador', 'almacen'));
create policy productos_delete on public.productos for delete to authenticated
  using (public.rol_actual() = 'administrador');

-- inventario: el cliente no ve las existencias (la API le muestra solo disponible o agotado)
create policy inventario_select on public.inventario for select to authenticated
  using (public.es_personal());
create policy inventario_write on public.inventario for all to authenticated
  using (public.rol_actual() in ('administrador', 'almacen'))
  with check (public.rol_actual() in ('administrador', 'almacen'));

-- pedidos: el vendedor ve los suyos y los del portal; el cliente solo los suyos
create policy pedidos_select on public.pedidos for select to authenticated
  using (
    public.rol_actual() in ('administrador', 'almacen', 'facturacion')
    or (public.rol_actual() = 'vendedor' and (creado_por = auth.uid() or origen = 'portal'))
    or (public.rol_actual() = 'cliente'
        and cliente_id in (select c.id from public.clientes c where c.usuario_id = auth.uid()))
  );
create policy pedidos_insert on public.pedidos for insert to authenticated
  with check (
    (public.rol_actual() in ('administrador', 'vendedor')
       and creado_por = auth.uid() and origen = 'interno')
    or (public.rol_actual() = 'cliente'
        and creado_por = auth.uid() and origen = 'portal'
        and cliente_id in (select c.id from public.clientes c where c.usuario_id = auth.uid()))
  );
create policy pedidos_update on public.pedidos for update to authenticated
  using (
    public.rol_actual() in ('administrador', 'almacen')
    or (public.rol_actual() = 'vendedor' and (creado_por = auth.uid() or origen = 'portal'))
  );

-- detalle_pedido: hereda la visibilidad del pedido; solo se edita si está pendiente
create policy detalle_select on public.detalle_pedido for select to authenticated
  using (exists (select 1 from public.pedidos p where p.id = pedido_id));
create policy detalle_write on public.detalle_pedido for all to authenticated
  using (exists (
    select 1 from public.pedidos p
     where p.id = pedido_id and p.estado = 'pendiente'
       and (public.rol_actual() = 'administrador' or p.creado_por = auth.uid())
  ))
  with check (exists (
    select 1 from public.pedidos p
     where p.id = pedido_id and p.estado = 'pendiente'
       and (public.rol_actual() = 'administrador' or p.creado_por = auth.uid())
  ));

-- facturas: quien puede ver el pedido (vendedor o cliente) puede ver su factura
create policy facturas_select on public.facturas for select to authenticated
  using (
    public.rol_actual() in ('administrador', 'facturacion')
    or (public.rol_actual() in ('vendedor', 'cliente') and exists (
         select 1 from public.pedidos p where p.id = pedido_id))
  );
create policy facturas_write on public.facturas for all to authenticated
  using (public.rol_actual() in ('administrador', 'facturacion'))
  with check (public.rol_actual() in ('administrador', 'facturacion'));

-- notificaciones: cada usuario ve y marca solo las suyas
create policy notif_select on public.notificaciones for select to authenticated
  using (usuario_id = auth.uid());
create policy notif_update on public.notificaciones for update to authenticated
  using (usuario_id = auth.uid())
  with check (usuario_id = auth.uid());

-- ---------- 5.6 Datos iniciales (roles y datos de ejemplo) ----------
-- Roles (permisos resumidos; ver 02-roles-permisos.md)
insert into public.roles (nombre, descripcion, permisos) values
  ('administrador', 'Control total del sistema', '["*"]'),
  ('vendedor',      'Gestiona clientes y pedidos propios',
   '["clientes:crear","clientes:editar","clientes:ver","productos:ver","inventario:ver","pedidos:crear","pedidos:ver_propios","pedidos:editar_propios","pedidos:confirmar_propios","pedidos:cancelar_propios","pedidos:ver_portal","pedidos:confirmar_portal","pedidos:cancelar_portal","facturas:ver_propias"]'),
  ('almacen',       'Gestiona productos, existencias y entregas',
   '["clientes:ver","productos:ver","productos:crear","productos:editar","inventario:ver","inventario:entrada","inventario:ajustar","pedidos:ver","pedidos:entregar","reportes:inventario"]'),
  ('facturacion',   'Emite facturas y registra pagos',
   '["clientes:ver","productos:ver","inventario:ver","pedidos:ver","facturas:emitir","facturas:ver","facturas:pago","reportes:ventas"]'),
  ('cliente',       'Cliente con acceso al portal',
   '["catalogo:ver","portal_pedidos:crear","portal_pedidos:ver_propios","portal_pedidos:cancelar_propios","facturas:ver_propias","notificaciones:ver"]');

-- Datos de prueba (productos y clientes de ejemplo)
insert into public.productos (sku, nombre, precio) values
  ('SKU-001', 'Camisa polo',     250.00),
  ('SKU-002', 'Pantalón jeans',  420.00),
  ('SKU-003', 'Gorra deportiva', 120.00);

update public.inventario set existencias = 50, minimo = 10;

insert into public.clientes (nombre, identificacion, email, telefono) values
  ('Comercial Los Pinos', '0501-1990-00001', 'ventas@lospinos.example', '9999-0001'),
  ('María Fernández',     '0501-1995-00002', 'maria@example.com',       '9999-0002');
