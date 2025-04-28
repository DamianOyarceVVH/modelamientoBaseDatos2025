create database mercado;

use mercado;

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

create table detalle_ventas (
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
)