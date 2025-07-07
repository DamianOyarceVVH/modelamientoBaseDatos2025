USE ejemploselect;

-- Poblar tabla tipo_usuarios
INSERT INTO tipo_usuarios (nombre_tipo, descripcion_tipo, created_by, updated_by) VALUES
('Administrador', 'Acceso completo al sistema', 1, 1),
('Cliente', 'Usuario con acceso restringido', 1, 1),
('Moderador', 'Puede revisar y aprobar contenido', 1, 1);

-- Poblar tabla usuarios
INSERT INTO usuarios (username, contrasenna, email, created_by, updated_by, id_tipo_usuario) VALUES
('admin01', 'pass1234', 'admin01@mail.com', 1, 1, 1),
('jvaldes', 'abc123', 'jvaldes@mail.com', 1, 1, 2),
('cmorales', '123456', 'cmorales@mail.com', 1, 1, 3),
('anavarro', 'pass4321', 'anavarro@mail.com', 1, 1, 2),
('rquezada', 'clave2023', 'rquezada@mail.com', 1, 1, 1),
('pgodoy', 'segura123', 'pgodoy@mail.com', 1, 1, 2),
('mdiaz', 'token456', 'mdiaz@mail.com', 1, 1, 3),
('scarvajal', 'azul789', 'scarvajal@mail.com', 1, 1, 2),
('ltapia', 'lt123', 'ltapia@mail.com', 1, 1, 3),
('afarias', 'afpass', 'afarias@mail.com', 1, 1, 2);

-- Poblar tabla ciudad
INSERT INTO ciudad (nombre_ciudad, region, created_by, updated_by) VALUES
('Santiago', 'Metropolitana', 1, 1),
('Valparaíso', 'Valparaíso', 1, 1),
('Concepción', 'Biobío', 1, 1),
('La Serena', 'Coquimbo', 1, 1),
('Puerto Montt', 'Los Lagos', 1, 1);

-- Poblar tabla personas (relacionadas con usuarios y ciudades)
INSERT INTO personas (rut, nombre_completo, fecha_nac, created_by, updated_by, id_usuario, id_ciudad) VALUES
('11.111.111-1', 'Juan Valdés', '1990-04-12', 1, 1, 2, 1),
('22.222.222-2', 'Camila Morales', '1985-09-25', 1, 1, 3, 2),
('33.333.333-3', 'Andrea Navarro', '1992-11-03', 1, 1, 4, 3),
('44.444.444-4', 'Rodrigo Quezada', '1980-06-17', 1, 1, 5, 1),
('55.555.555-5', 'Patricio Godoy', '1998-12-01', 1, 1, 6, 4),
('66.666.666-6', 'María Díaz', '1987-07-14', 1, 1, 7, 5),
('77.777.777-7', 'Sebastián Carvajal', '1993-03-22', 1, 1, 8, 2),
('88.888.888-8', 'Lorena Tapia', '2000-10-10', 1, 1, 9, 3),
('99.999.999-9', 'Ana Farías', '1995-01-28', 1, 1, 10, 4),
('10.101.010-0', 'Carlos Soto', '1991-08-08', 1, 1, 1, 1); -- admin01