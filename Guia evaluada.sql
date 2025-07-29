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