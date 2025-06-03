use mercado;

insert into tipos_usuarios (nombre_tipo, descripcion_tipo, created_by, updated_by)
values ('Administrador', 'Accede a todas las funciones del sistema, incluida la administración de usuarios.', 1, 1),
('Vendedor', 'Interactúa con los clientes para vender los productos', 1, 1);

insert into usuarios (nombre_usuario, password, correo, tipo_usuario_id, created_by, updated_by)
values ('sistema', 'bcrypt', 'sistema@plataforma.cl', null, null, null),
('javier.mendez', '·$&2347$·', 'javiermendez@gmail.com', 1, 1, 1),
('max.reyes', '$t3ph3nCurry', 'maxreyes@gmail.com', 2, 1, 1),
('benjamin.gajardo', 'L4m1n3Y4m4L', 'benjardou@gmail.com', 2, 1, 1);

insert into productos (nombre_producto, precio, stock, created_by, updated_by)
values ('Coca-cola', 850000, 500, 1, 1),
('Mini-cockies', 60000, 200, 1, 1),
('Doritos', 180000, 300, 1, 1);

insert into ventas (usuario_id, fecha, created_by, updated_by)
values (2, '2025-01-23', 1, 1),
(3, '2025-02-17', 1, 1),
(3, '2025-03-12', 1, 1),
(2, '2025-04-30', 1, 1);

insert into detalles_ventas (venta_id, producto_id, cantidad, precio_unitario, created_by, updated_by)
values (2, 3, 50, 600, 1, 1),
(4, 2, 42, 400, 1, 1),
(3, 1, 70, 1700, 1, 1),
(1, 1, 100, 1700, 1, 1);

select*from tipos_usuarios;
select*from usuarios;
select*from productos;
select*from ventas;
select*from detalles_ventas;