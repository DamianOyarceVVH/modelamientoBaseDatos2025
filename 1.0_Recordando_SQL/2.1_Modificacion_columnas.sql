use mercado;

alter table usuarios
change column nombre nombre_usuario varchar(100) not null,
change column password password varchar(45) not null;

alter table tipos_usuarios
change column nombre nombre_tipo varchar(50) not null,
change column descripcion descripcion_tipo varchar(200) not null;

alter table productos
change column nombre nombre_producto varchar(100) not null