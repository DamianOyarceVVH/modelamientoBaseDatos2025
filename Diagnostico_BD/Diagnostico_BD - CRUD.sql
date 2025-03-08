-- CREATE:

USE mydb;

-- tipos_usuarios
INSERT INTO `mydb`.`tipos_usuarios` (`nombre`, `descripcion`, `create`, `update`) VALUES
('Administrador', 'Usuario con privilegios completos.', NOW(), NOW()),
('Doctor', 'Usuario médico con acceso a pacientes.', NOW(), NOW()),
('Paciente', 'Usuario paciente con acceso a citas y consultas.', NOW(), NOW()),
('Recepcionista', 'Usuario que gestiona citas y registros.', NOW(), NOW()),
('Invitado', 'Usuario con acceso limitado.', NOW(), NOW());

-- usuarios
INSERT INTO `mydb`.`usuarios` (`nombre`, `email`, `contraseña`, `create`, `update`, `id_tipo_usuario`) VALUES
('Admin1', 'admin1@ejemplo.com', 'admin123', NOW(), NOW(), 1),
('Doctor1', 'doctor1@ejemplo.com', 'doctor456', NOW(), NOW(), 2),
('Paciente1', 'paciente1@ejemplo.com', 'paciente789', NOW(), NOW(), 3),
('Recepcionista1', 'recepcionista1@ejemplo.com', 'recep101', NOW(), NOW(), 4),
('Invitado1', 'invitado1@ejemplo.com', 'guest112', NOW(), NOW(), 5);

-- areas_medicas
INSERT INTO `mydb`.`areas_medicas` (`nombre`, `descripcion`, `create`, `update`) VALUES
('Cardiología', 'Especialidad en el corazón y sistema circulatorio.', NOW(), NOW()),
('Dermatología', 'Especialidad en la piel y sus enfermedades.', NOW(), NOW()),
('Pediatría', 'Especialidad en la salud de los niños.', NOW(), NOW()),
('Neurología', 'Especialidad en el sistema nervioso.', NOW(), NOW()),
('Oncología', 'Especialidad en el tratamiento del cáncer.', NOW(), NOW());

-- doctores
INSERT INTO `mydb`.`doctores` (`nombre`, `apellido`, `especialidad`, `email`, `contraseña`, `telefono`, `fecha_contratacion`, `create`, `update`, `id_area_medica`, `id_usuario`) VALUES
('Juan', 'Pérez', 'Cardiólogo', 'juan.perez@ejemplo.com', 'doctor123', 12345678, '2023-01-15', NOW(), NOW(), 1, 1),
('María', 'Gómez', 'Dermatóloga', 'maria.gomez@ejemplo.com', 'doctor456', 87654321, '2022-11-20', NOW(), NOW(), 2, 2),
('Carlos', 'López', 'Pediatra', 'carlos.lopez@ejemplo.com', 'doctor789', 11223344, '2023-03-10', NOW(), NOW(), 3, 3),
('Ana', 'Rodríguez', 'Neuróloga', 'ana.rodriguez@ejemplo.com', 'doctor101', 55667788, '2022-09-05', NOW(), NOW(), 4, 4),
('Pedro', 'Martínez', 'Oncólogo', 'pedro.martinez@ejemplo.com', 'doctor112', 99887766, '2023-05-22', NOW(), NOW(), 5, 5);

-- tratamientos
INSERT INTO `mydb`.`tratamientos` (`nombre`, `descripcion`, `create`, `update`) VALUES
('Electrocardiograma', 'Registro de la actividad eléctrica del corazón.', NOW(), NOW()),
('Biopsia de piel', 'Extracción de tejido para diagnóstico.', NOW(), NOW()),
('Vacunación infantil', 'Administración de vacunas para niños.', NOW(), NOW()),
('Resonancia magnética', 'Imagen detallada del cerebro y la médula espinal.', NOW(), NOW()),
('Quimioterapia', 'Tratamiento con medicamentos para el cáncer.', NOW(), NOW());

-- pacientes
INSERT INTO `mydb`.`pacientes` (`RUT`, `nombre`, `apellido_p`, `apellido_m`, `email`, `contraseña`, `telefono`, `sexo`, `create`, `update`) VALUES
('12345678-9', 'Sofía', 'Fernández', 'Ruiz', 'sofia.fernandez@ejemplo.com', 'paciente123', 98765432, 'f', NOW(), NOW()),
('98765432-1', 'Luis', 'Sánchez', 'Pérez', 'luis.sanchez@ejemplo.com', 'paciente456', 23456789, 'm', NOW(), NOW()),
('11223344-5', 'Laura', 'García', 'López', 'laura.garcia@ejemplo.com', 'paciente789', 34567890, 'f', NOW(), NOW()),
('55667788-0', 'Diego', 'Martínez', 'González', 'diego.martinez@ejemplo.com', 'paciente101', 45678901, 'm', NOW(), NOW()),
('99887766-2', 'Elena', 'Rodríguez', 'Torres', 'elena.rodriguez@ejemplo.com', 'paciente112', 56789012, 'f', NOW(), NOW());

-- citas 
INSERT INTO `mydb`.`citas` (`diagnostico`, `fecha`, `create`, `update`, `id_tratamiento`, `RUT`, `id_doctor`, `id_usuario`) VALUES
('Sospecha de arritmia', '2023-11-10', NOW(), NOW(), 1, '12345678-9', 1, 3),
('Erupción cutánea', '2023-11-12', NOW(), NOW(), 2, '98765432-1', 2, 3),
('Control de vacunas', '2023-11-15', NOW(), NOW(), 3, '11223344-5', 3, 3),
('Dolor de cabeza crónico', '2023-11-18', NOW(), NOW(), 4, '55667788-0', 4, 3),
('Seguimiento de tratamiento', '2023-11-20', NOW(), NOW(), 5, '99887766-2', 5, 3);

-- consultas
INSERT INTO `mydb`.`consultas` (`motivo`, `fecha`, `create`, `update`, `RUT`, `id_doctor`) VALUES
('Dolor en el pecho', '2023-11-11', NOW(), NOW(), '12345678-9', 1),
('Manchas en la piel', '2023-11-13', NOW(), NOW(), '98765432-1', 2),
('Fiebre alta', '2023-11-16', NOW(), NOW(), '11223344-5', 3),
('Mareos frecuentes', '2023-11-19', NOW(), NOW(), '55667788-0', 4),
('Fatiga persistente', '2023-11-21', NOW(), NOW(), '99887766-2', 5);

-- READ:
SELECT*FROM tipos_usuarios;
SELECT*FROM usuarios;
SELECT*FROM areas_medicas;
SELECT*FROM doctores;
SELECT*FROM tratamientos;
SELECT*FROM pacientes;
SELECT*FROM citas;
SELECT*FROM consultas;

-- UPDATE 
UPDATE pacientes 
SET nombre = 'Martin' WHERE RUT = '55667788-0';

UPDATE doctores 
SET apellido = 'San Martin' WHERE especialidad = 'Dermatóloga';

UPDATE citas 
SET fecha = '2023-9-10' WHERE diagnostico = 'Dolor de cabeza crónico';

UPDATE consultas 
SET motivo = 'Sarpullido' WHERE fecha = '2023-11-16';

UPDATE usuarios 
SET email = 'r3cEpc1onIst41@egmail.com' WHERE nombre = 'Recepcionista1';

-- DELETE
DELETE FROM tipos_usuarios
WHERE nombre = 'Administrador'