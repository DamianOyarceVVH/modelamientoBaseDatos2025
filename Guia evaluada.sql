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