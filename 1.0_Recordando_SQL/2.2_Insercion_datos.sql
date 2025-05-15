insert into tipos_usuarios (nombre_tipo, descripcion_tipo, created_by, updated_by)
values ('Administrador', 'Accede a todas las funciones del sistema, incluida la administración de usuarios.', 1, 1),
('Vendedor', 'Interactúa con los clientes para vender los productos', 1, 1);

insert into usuario (nombre_usuario, password, correo, tipo_usuario_id, created_by, updated_by)
values ('sistema', 'bcrypt', 'sistema@plataforma.cl', null, null, null),
('javier.mendez', '·$&2347$·', 'javiermendez@gmail.com', 1, 1, 1),
('max.reyes', '$t3ph3nCurry', 'maxreyes@gmail.com', 2, 1, 1),
('benjamin.gajardo', 'L4m1n3Y4m4L', 'benjardou@gmail.com', 2, 1, 1);

insert into productos (nombre_producto, precio, stock, created_by, updated_by)
values ('Coca-cola', 1200, 500, 1, 1),
('Mini-cockies', 400, 200, 1, 1),
('Doritos', 600, 300, 1, 1);

insert into ventas (usuario_id, fecha, created_by, updated_by)
values (2, 23-01-2025, 1, 1),
(3, 17-02-2025, 1, 1),
(3, 12-03-2025, 1, 1),
(2, 30-04-2025, 1, 1);