create database restricciones;

use restricciones;

-- desactiva la verificación de claves foráneas temporalmente para evitar problemas de orden al crear tablas
set foreign_key_checks = 0;

--
-- tabla: tipo_usuarios
-- define los tipos de usuario permitidos en el sistema.
--
create table tipo_usuarios (
    id_tipo int primary key auto_increment,
    descripcion varchar(50) not null check (descripcion in ('estudiante', 'profesor', 'administrador')), -- la descripción solo puede ser 'estudiante', 'profesor' o 'administrador'
    nivel_acceso tinyint check (nivel_acceso between 1 and 3) -- el nivel de acceso debe estar entre 1 y 3
);

--
-- tabla: usuarios
-- registra información personal y de acceso para cada usuario.
--
create table usuarios (
    id_usuario int primary key auto_increment,
    nombre varchar(100) not null check (char_length(nombre) >= 3 and nombre regexp '^[a-za-z ]+$'), -- el nombre debe tener al menos 3 caracteres y solo contener letras y espacios
    email varchar(100) not null unique check (email like '%@%.%'), -- el email debe ser único y tener un formato básico de correo electrónico
    fecha_registro date default (current_date), -- la fecha de registro se asigna automáticamente a la fecha actual
    activo boolean default true, -- el usuario está activo por defecto
    edad tinyint check (edad between 13 and 100), -- la edad debe estar entre 13 y 100 años
    id_tipo int,
    foreign key (id_tipo) references tipo_usuarios(id_tipo) -- clave foránea que referencia a la tabla tipo_usuarios
);

--
-- tabla: cursos
-- contiene información sobre los cursos disponibles en la plataforma.
--
create table cursos (
    id_curso int primary key auto_increment,
    titulo varchar(200) not null check (char_length(titulo) between 5 and 200), -- el título debe tener entre 5 y 200 caracteres
    duracion_horas decimal(4,2) check (duracion_horas > 0 and duracion_horas <= 100), -- la duración debe ser mayor que 0 y menor o igual a 100 horas
    nivel varchar(20) check (nivel in ('principiante', 'intermedio', 'avanzado')), -- el nivel solo puede ser 'principiante', 'intermedio' o 'avanzado'
    precio decimal(10,2) check (precio >= 0), -- el precio no puede ser negativo
    fecha_publicacion date check (fecha_publicacion >= '2020-01-01'), -- la fecha de publicación no puede ser anterior a 2020
    -- restricción combinada: los cursos principiantes deben costar hasta 50, y los intermedios/avanzados hasta 200
    check (
        (nivel = 'principiante' and precio <= 50) or
        (nivel in ('intermedio', 'avanzado') and precio <= 200)
    )
);

-- reactiva la verificación de claves foráneas
set foreign_key_checks = 1;
