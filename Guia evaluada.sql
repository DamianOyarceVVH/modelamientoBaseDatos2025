use hotel_reservas;

-- =========================================
-- Parte 1: Limpieza de Datos
-- =========================================

-- Identificación de datos nulos
select*from clientes
where rut is null or correo is null or telefono is null;

select*from personal
where nombre_completo is null or correo is null or telefono is null;

select*from reservas
where fecha_ingreso is null or fecha_salida is null or estado is null;

-- Borrado físico de registros inválidos
delete from clientes
where rut is null or correo is null or telefono is null;

delete from personal
where nombre_completo is null or correo is null or telefono is null;

delete from reservas
where fecha_ingreso is null or fecha_salida is null or estado is null;

-- Corrección de valores nulos
update clientes
set correo = 'andresitolopez@gmail.com' where id_cliente = 3;

update reservas
set fecha_ingreso = '2025-08-08' where id_reserva = 2;

-- =========================================
-- Parte 2: Borrado Lógico y Filtrado Activo
-- =========================================

-- Borrado lógico
update habitaciones 
set deleted = 1 where id_habitacion = 3;

update clientes 
set deleted = 1 where id_cliente = 5;

select * from habitaciones
where deleted = 0;

select * from clientes
where deleted = 0;

-- Listar registros inactivos
select * from habitaciones
where deleted = 1;

select * from clientes
where deleted = 1;

-- =========================================
-- Parte 3: Consultas con INNER JOIN
-- =========================================

-- JOIN de 2 tablas
select c.nombre_completo, c.correo, t.nombre_tipo
from clientes c
join tipo_clientes t on c.id_tipo_cliente = t.id_tipo_cliente
where c.deleted = 0;

-- JOIN de 3 tablas
select c.nombre_completo, h.numero_habitacion, r.estado
from reservas r
join clientes c on r.id_cliente = c.id_cliente
join habitaciones h on r.id_habitacion = h.id_habitacion
where c.deleted = 0 AND r.deleted = 0;

-- JOIN de 4 tablas
select c.nombre_completo as clientes, p.nombre_completo as personal, h.numero_habitacion, r.estado
from reservas r
inner join clientes c on r.id_cliente = c.id_cliente
inner join personal p on r.id_personal = p.id_personal
inner join habitaciones h on r.id_habitacion = h.id_habitacion
where c.deleted = 0 AND p.deleted = 0 AND h.deleted = 0 AND r.deleted = 0;

-- =========================================
-- Parte 3: Consultas con INNER JOIN
-- =========================================

-- Filtros por texto y condiciones 
select*from reservas
where estado = 'confirmada';

select*from clientes
where (length(correo) > 15);

-- Filtros por fecha y estado 
select*from reservas
where fecha_ingreso > '2025-08-10' and estado = 'pendiente';

select*from habitaciones
where estado = 'disponible';