-- Crear la base de datos y usarla
DROP DATABASE IF EXISTS clinica_veterinaria;
CREATE DATABASE clinica_veterinaria;
USE clinica_veterinaria;

create table dueños(-- 1
id_dueño INT AUTO_INCREMENT PRIMARY KEY,
nombre_dueño varchar(50) not null
CHECK (CHAR_LENGTH(nombre_dueño) >= 3 AND nombre_dueño REGEXP '^[A-Za-z ]+$'),
rut varchar(25) unique not null,
correo VARCHAR(100) UNIQUE,
direccion varchar(200),
telefono varchar(20),
-- Campos de auditoría
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
ON UPDATE CURRENT_TIMESTAMP,
created_by INT,
updated_by INT,
deleted BOOLEAN DEFAULT FALSE
);

CREATE TABLE tipo_usuarios (
  id_tipo_usuario INT AUTO_INCREMENT PRIMARY KEY,
  nombre_tipo VARCHAR(100) NOT NULL
  CHECK (nombre_tipo IN ('veterinario', 'dueño', 'recepcionista')),
  descripcion_tipo VARCHAR(300) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  created_by INT,
  updated_by INT,
  deleted BOOLEAN DEFAULT FALSE
);


CREATE TABLE usuarios (-- 3
id_usuario INT AUTO_INCREMENT PRIMARY KEY,
nombre_usuario VARCHAR(100) NOT NULL
CHECK (CHAR_LENGTH(nombre_usuario) >= 3 AND nombre_usuario REGEXP '^[A-Za-z ]+$'),
password varchar(100) not null,
id_tipo_usuario INT,
foreign key(id_tipo_usuario) references tipo_usuarios(id_tipo_usuario),
id_dueño int,
foreign key (id_dueño) references dueños(id_dueño),
-- Campos de auditoría
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
ON UPDATE CURRENT_TIMESTAMP,
created_by INT,
updated_by INT,
deleted BOOLEAN DEFAULT FALSE
);



create table tipo_mascotas(-- 5
id_tipo_mascota int primary key auto_increment,
especie varchar(100) not null,
descripcion_especie varchar(300) not null CHECK (CHAR_LENGTH(descripcion_especie) >= 20 AND descripcion_especie REGEXP '^[A-Za-z ]+$'),
-- campos de auditoria
created_at datetime default current_timestamp,
updated_at datetime default current_timestamp
on update current_timestamp,
created_by int,
updated_by int,
deleted boolean default false
);

create table razas (-- 6
id_raza int primary key auto_increment,
raza varchar(100) not null
CHECK (CHAR_LENGTH(raza) >= 3 AND raza REGEXP '^[A-Za-z ]+$'),
id_tipo_mascota int,
foreign key (id_tipo_mascota) references tipo_mascotas(id_tipo_mascota),
-- campos de auditoria
created_at datetime default current_timestamp,
updated_at datetime default current_timestamp
on update current_timestamp,
created_by int,
updated_by int,
deleted boolean default false
);

create table mascotas(-- 7
id_mascota int primary key auto_increment,
nombre_mascota varchar(100) not null
CHECK (CHAR_LENGTH(nombre_mascota) >= 3 AND nombre_mascota REGEXP '^[A-Za-z ]+$'),
comportamiento varchar(300) not null,
fecha_nacimiento date not null,
sexo varchar(50) CHECK(sexo in ('macho', 'hembra')),
id_dueño int,
foreign key (id_dueño) references dueños(id_dueño),
id_raza int,
foreign key (id_raza) references razas(id_raza),
-- campos de auditoria
created_at datetime default current_timestamp,
updated_at datetime default current_timestamp
on update current_timestamp,
created_by int,
updated_by int,
deleted boolean default false
);

create table diagnosticos(-- 8
id_diagnostico int primary key auto_increment,
descripcion_diagnostico varchar(100) not null
CHECK (CHAR_LENGTH(descripcion_diagnostico) >= 20 AND descripcion_diagnostico REGEXP '^[A-Za-z ]+$'),
-- Campos de auditoría
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
ON UPDATE CURRENT_TIMESTAMP,
created_by INT,
updated_by INT,
deleted BOOLEAN DEFAULT FALSE
);

create table consultas(-- 9
id_consulta int primary key auto_increment,
fecha_consulta date not null,
motivo varchar(100) not null
CHECK (CHAR_LENGTH(motivo) >= 20 AND motivo REGEXP '^[A-Za-z ]+$'),
id_diagnostico int,
foreign key (id_diagnostico) references diagnosticos(id_diagnostico),
id_mascota int,
foreign key (id_mascota) references mascotas(id_mascota),
id_usuario int,
foreign key (id_usuario) references usuarios(id_usuario),
-- Campos de auditoría
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
ON UPDATE CURRENT_TIMESTAMP,
created_by INT,
updated_by INT,
deleted BOOLEAN DEFAULT FALSE
);

create table recetas(-- 10
id_receta int primary key auto_increment,
fecha_emision datetime,
id_consulta int,
foreign key (id_consulta) references consultas(id_consulta),
-- Campos de auditoría
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
ON UPDATE CURRENT_TIMESTAMP,
created_by INT CHECK (created_by <> 0),
updated_by INT,
deleted BOOLEAN DEFAULT FALSE
);



create table evaluaciones_medicas( -- 11
id_evaluacion_medica int primary key auto_increment,
id_receta int not null,
id_diagnostico int not null,
fecha_evaluacion datetime,
-- Campos de auditoría
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
ON UPDATE CURRENT_TIMESTAMP,
created_by INT CHECK (created_by <> 0),
updated_by INT,
deleted BOOLEAN DEFAULT FALSE
);

alter table evaluaciones_medicas
add constraint fk_diagnosticos_evaluaciones_medicas
foreign key (id_diagnostico) references diagnosticos(id_diagnostico);

alter table evaluaciones_medicas
add constraint fk_recetas_evaluaciones_medicas
foreign key (id_receta) references recetas(id_receta);

create table medicamentos(-- 12
id_medicamento int primary key auto_increment,
nombre_medicamento varchar(100) not null
CHECK (CHAR_LENGTH(nombre_medicamento) >= 3 AND nombre_medicamento REGEXP '^[A-Za-z ]+$'),
principio_activo varchar(100) not null,
-- Campos de auditoría
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
ON UPDATE CURRENT_TIMESTAMP,
created_by INT,
updated_by INT,
deleted BOOLEAN DEFAULT FALSE
);

create table prescripciones(-- 13
id_prescripcion int primary key auto_increment,
id_receta int not null,
id_medicamento int not null,
dosis int not null,
frecuencia int not null,
duracion int not null,
fecha_analisis datetime,
-- Campos de auditoría
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
ON UPDATE CURRENT_TIMESTAMP,
created_by INT
CHECK (created_by <> 0),
updated_by INT,
deleted BOOLEAN DEFAULT FALSE
);

alter table prescripciones
add constraint fk_recetas_prescripciones
foreign key (id_receta) references recetas(id_receta);

alter table prescripciones
add constraint fk_medicamentos_prescripciones
foreign key (id_medicamento) references medicamentos(id_medicamento);

-- 1. Insertar dueños
INSERT INTO dueños (nombre_dueño, rut, correo, direccion, telefono, created_by)
VALUES
('Ana Torres', '12345678-9', 'ana.torres@mail.com', 'Calle Falsa 123', '987654321', 1),
('Carlos Paredes', '12345678-0', 'carlos@mail.com', 'Av Central 123', '912345678', 1),
('Maria Lopez', '23456789-1', 'maria@mail.com', 'Calle Norte 456', '987654321', 1),
('Jorge Herrera', '34567890-2', 'jorge@mail.com', 'Pasaje Sur 789', '956789123', 1),
('Patricia Vidal', '45678901-3', 'patricia@mail.com', 'Calle Este 321', '934567890', 1),
('Esteban Silva', '56789012-4', 'esteban@mail.com', 'Calle Oeste 111', '978654321', 1),
('Sofia Araya', '67890123-5', 'sofia@mail.com', 'Villa Norte 222', '932112345', 1),
('Luis Morales', '78901234-6', 'luis@mail.com', 'Calle Poniente 555', '945678321', 1),
('Daniela Rojas', '89012345-7', 'daniela@mail.com', 'Plaza Sur 333', '911223344', 1),
('Victor Castillo', '90123456-8', 'victor@mail.com', 'Camino Rural 777', '987321456', 1);

INSERT INTO tipo_usuarios (nombre_tipo, descripcion_tipo, created_by)
VALUES
('veterinario', 'Usuario encargado de realizar consultas médicas', 1),
('dueño', 'Persona que tiene una o más mascotas', 1),
('recepcionista', 'Personal de recepción y agenda', 1);

-- 2. Insertar usuarios (veterinarios y dueños)
INSERT INTO usuarios (nombre_usuario, password, id_tipo_usuario, id_dueño, created_by)
VALUES
('Dr Carlos Soto', 'veterinario123', 1, NULL, 1),
('Andrea Guzman', 'vet456', 1, NULL, 1),
('Ana Torres', 'ana123', 2, 1, 1),
('Carlos Paredes', 'carlos123', 2, 2, 1),
('Maria Lopez', 'maria123', 2, 3, 1),
('Jorge Herrera', 'jorge123', 2, 4, 1),
('Patricia Vidal', 'patricia123', 2, 5, 1),
('Esteban Silva', 'esteban123', 2, 6, 1),
('Sofia Araya', 'sofia123', 2, 7, 1),
('Luis Morales', 'luis123', 2, 8, 1);

-- 3. Insertar tipos de mascota
INSERT INTO tipo_mascotas (especie, descripcion_especie, created_by)
VALUES
('Perro', 'Animal leal y muy inteligente para compania', 1),
('Gato', 'Animal independiente y curioso gran cazador', 1),
('Conejo', 'Animal tranquilo peludo y rapido para saltar', 1);

-- 4. Insertar razas
INSERT INTO razas (raza, id_tipo_mascota, created_by)
VALUES
('Labrador', 1, 1),
('Poodle', 1, 1),
('Bulldog', 1, 1),
('Persa', 2, 1),
('Siames', 2, 1),
('Maine Coon', 2, 1),
('Enano', 3, 1),
('Belier', 3, 1),
('Rex', 3, 1),
('Gigante de Flandes', 3, 1);

-- 5. Insertar mascotas
INSERT INTO mascotas (nombre_mascota, comportamiento, fecha_nacimiento, sexo, id_dueño, id_raza, created_by)
VALUES
('Firulais', 'Muy jugueton y ladra cuando esta feliz', '2020-05-10', 'macho', 1, 1, 1),
('Max', 'Tranquilo y obediente le gusta correr', '2019-08-15', 'macho', 2, 2, 1),
('Luna', 'Curiosa y dormilona', '2021-04-12', 'hembra', 3, 4, 1),
('Tom', 'Agresivo con extranos pero carinoso', '2020-09-20', 'macho', 4, 5, 1),
('Nina', 'Saltadora y muy activa', '2022-01-10', 'hembra', 5, 7, 1),
('Rocky', 'Guardia y muy protector', '2018-07-18', 'macho', 6, 3, 1),
('Mia', 'Le encanta dormir y subir a lugares altos', '2020-02-25', 'hembra', 7, 6, 1),
('Toby', 'Le gusta jugar con pelotas', '2021-03-30', 'macho', 8, 1, 1),
('Pelusa', 'Esponjoso y amigable', '2019-12-12', 'macho', 9, 8, 1),
('Copito', 'Muy suave le gusta estar en brazos', '2023-05-01', 'hembra', 10, 10, 1);

-- 6. Insertar diagnosticos
INSERT INTO diagnosticos (descripcion_diagnostico, created_by)
VALUES
('Infeccion respiratoria leve sin fiebre detectada', 1),
('Otitis externa moderada con secrecion y picazon', 1),
('Problemas digestivos leves por cambio de alimento', 1),
('Dermatitis alergica causada por pulgas', 1),
('Fractura en pata posterior sin desplazamiento', 1),
('Infeccion urinaria con presencia de sangre', 1),
('Problema ocular con lagrimeo constante', 1),
('Gripe felina detectada en primeras fases', 1),
('Herida superficial por mordida de otro perro', 1),
('Desnutricion leve por alimentacion inadecuada', 1);

-- 7. Insertar consultas
INSERT INTO consultas (fecha_consulta, motivo, id_diagnostico, id_mascota, id_usuario, created_by)
VALUES
('2025-07-01', 'Tos persistente y secrecion nasal', 1, 1, 1, 1),
('2025-07-02', 'Rascado constante en orejas', 2, 2, 2, 1),
('2025-07-03', 'Vomitos luego de cambio de dieta', 3, 3, 1, 1),
('2025-07-04', 'Urgencia, Piel roja y picazon intensa', 4, 4, 2, 1),
('2025-07-05', 'Cojea al caminar posible fractura', 5, 5, 1, 1),
('2025-07-06', 'Orina con mal olor y color', 6, 6, 2, 1),
('2025-07-07', 'Ojo con lagrimeo constante', 7, 7, 1, 1),
('2025-07-08', 'Estornudos frecuentes en gato', 8, 8, 2, 1),
('2025-07-09', 'Mordida en pelea con otro perro, urgencia', 9, 9, 1, 1),
('2025-07-10', 'Delgadez y caida de pelo', 10, 10, 2, 1);