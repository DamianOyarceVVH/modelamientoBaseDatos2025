USE `eco_trash`;

-- ===============================================
-- Inserciones de datos base
-- ===============================================

-- Roles
INSERT INTO roles (nombre, descripcion) VALUES
('Administrador', 'Gestiona todo el sistema'),
('Técnico', 'Mantiene y repara los basureros'),
('Recolector', 'Encargado de la recolección de residuos');

-- Usuarios
INSERT INTO usuarios (nombre, apellido, num_contacto, roles_id_roles) VALUES
('Carlos', 'Soto', '987654321', 1),
('Ana', 'Martínez', '912345678', 2),
('Luis', 'Torres', '934567890', 3);

-- Basureros
INSERT INTO basureros (ubicacion, capacidad_kg) VALUES
('Parque Central', 200),
('Plaza Norte', 300);

-- Materiales
INSERT INTO materiales (nombre, composicion, precio_unidad) VALUES
('Plástico', 'Polietileno', 50.00),
('Vidrio', 'Silicato', 30.00),
('Metal', 'Aluminio', 80.00);

-- Objetos
INSERT INTO objetos (nombre, descripcion, id_material, id_basurero) VALUES
('Botella de plástico', 'Botella de agua PET', 1, 1),
('Lata de bebida', 'Lata de aluminio', 3, 2);

-- Métodos de pago
INSERT INTO metodos_pago (nombre, otros_detalles) VALUES
('Transferencia', 'Banco Estado'),
('Efectivo', 'Pago directo');

-- Pagos
INSERT INTO pagos (monto, fec_pago, id_objetos, id_usuario, id_metodo_pago) VALUES
(1000.00, NOW(), 1, 1, 1),
(500.00, NOW(), 2, 3, 2);

-- ===============================================
-- Consultas de verificación
-- ===============================================

-- Ver todos los registros
SELECT * FROM usuarios;
SELECT * FROM materiales;
SELECT * FROM objetos;
SELECT * FROM pagos;

-- Mostrar solo registros activos
SELECT * FROM usuarios WHERE deleted = 0;

-- Verificar relaciones: objetos con materiales y basureros
SELECT o.nombre AS objeto, m.nombre AS material, b.ubicacion AS basurero
FROM objetos o
JOIN materiales m ON o.id_material = m.id_material
JOIN basureros b ON o.id_basurero = b.id_basurero;

-- Verificar pagos con usuarios y métodos
SELECT p.id_pago, u.nombre AS usuario, mp.nombre AS metodo, p.monto
FROM pagos p
JOIN usuarios u ON p.id_usuario = u.id_usuario
JOIN metodos_pago mp ON p.id_metodo_pago = mp.id_metodo_pago;
