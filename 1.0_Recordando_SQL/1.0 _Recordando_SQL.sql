create database mercado;

use mercado;

create table usuarios (
id_usuario int auto_increment primary key,
nombre varchar(100) not null,
correo varchar(100) not null unique,
tipo_usuario_id int not null,
created_at datetime default current_timestamp,
updated_at datetime default current_timestamp
on update current_timestamp,
created_by int,
updated_by int,
deleted boolean default false
);

create table tipos_usuarios (
id_tipo_usuario int auto_increment primary key,
nombre varchar(100) not null,
descripcion varchar(200) not null ,
created_at datetime default current_timestamp,
updated_at datetime default current_timestamp
on update current_timestamp,
created_by int,
updated_by int,
deleted boolean default false
);

create table productos (
id_producto int auto_increment primary key,
nombre varchar(100) not null,
precio float not null,
stock int not null,
created_at datetime default current_timestamp,
updated_at datetime default current_timestamp
on update current_timestamp,
created_by int,
updated_by int,
deleted boolean default false
);

create table ventas (
id_venta int auto_increment primary key,
usuario_id int not null,
fecha date not null,
created_at datetime default current_timestamp,
updated_at datetime default current_timestamp
on update current_timestamp,
created_by int,
updated_by int,
deleted boolean default false
);

create table detalles_ventas (
id_detalle_venta int auto_increment primary key,
venta_id int not null,
producto_id int not null,
cantidad int not null,
precio_unitario float not null,
created_at datetime default current_timestamp,
updated_at datetime default current_timestamp
on update current_timestamp,
created_by int,
updated_by int,
deleted boolean default false
);

alter table usuarios
add constraint fk_usuarios_tipo_usuario
foreign key (tipo_usuario_id)
references tipos_usuarios (id_tipo_usuario);

alter table ventas
add constraint fk_ventas_usuario
foreign key (usuario_id)
references usuarios (id_usuario);

alter table detalles_ventas
add constraint fk_detalles_ventas_venta
foreign key (venta_id)
references ventas(id_venta);

alter table detalles_ventas
add constraint fk_detalles_ventas_producto
foreign key (producto_id)
references productos(id_producto);