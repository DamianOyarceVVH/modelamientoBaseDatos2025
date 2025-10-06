-- Script 2: INSERTs de datos representativos y SELECTs de verificación
USE `eco_trash`;

-- -----------------------------
-- INSERT: roles
-- -----------------------------
INSERT INTO `roles` (`nombre`, `descripcion`, `created_by`)
VALUES
  ('Administrador','Acceso completo al sistema','system'),
  ('Técnico','Técnico de campo, gestiona basureros y mantenimiento','system'),
  ('Ciudadano','Usuario general que registra objetos','system');

-- -----------------------------
-- INSERT: usuarios
-- -----------------------------
INSERT INTO `usuarios` (`nombre`,`apellido`,`num_contacto`,`email`,`roles_id_roles`,`created_by`)
VALUES
  ('María','González','+56912345678','maria.g@example.com', 1, 'seed'),
  ('Luis','Rodríguez','+56923456789','luis.r@example.com', 2, 'seed'),
  ('Ana','Pérez','+56934567890','ana.p@example.com', 3, 'seed');

-- -----------------------------
-- INSERT: basureros
-- -----------------------------
INSERT INTO `basureros` (`ubicacion`,`capacidad_kg`,`created_by`)
VALUES
  ('Plaza Central - Av. Libertad 123', 200, 'seed'),
  ('Paradero 12 - Calle Las Flores', 100, 'seed'),
  ('Complejo Deportivo - Sector Norte', 150, 'seed');

-- -----------------------------
-- INSERT: materiales
-- -----------------------------
INSERT INTO `materiales` (`nombre`,`composicion`,`precio_unidad`,`unidad_medida`,`created_by`)
VALUES
  ('Plástico PET','Tereftalato de polietileno', 0.10, 'unidad', 'seed'),
  ('Vidrio','Sílice y aditivos', 0.05, 'kg', 'seed'),
  ('Cartón','Fibra de papel reciclado', 0.02, 'kg', 'seed'),
  ('Metal (Aluminio)','Aleación de aluminio', 0.20, 'kg', 'seed');

-- -----------------------------
-- INSERT: objetos
-- -----------------------------
-- Mapear objetos a materiales y basureros (asegurar FK válidas)
INSERT INTO `objetos` (`nombre`,`descripcion`,`cantidad`,`created_by`,`id_material`,`id_basurero`)
VALUES
  ('Botella PET 500ml','Botella de bebida plástica', 10, 'Ana Pereza', 1, 1),
  ('Frasco de vidrio','Frasco de conserva 250ml', 5, 'Luis R', 2, 2),
  ('Caja de cartón','Caja plegable mediana', 20, 'Ana Pereza', 3, 3),
  ('Lata de bebida','Lata de aluminio 350ml', 15, 'María G', 4, 1);

-- -----------------------------
-- INSERT: pagos (incentivos)
-- -----------------------------
INSERT INTO `pagos` (`monto`,`fec_pago`,`comentario`,`created_by`,`id_objeto`)
VALUES
  (1.50, NOW(), 'Pago por entrega Botellas PET', 'system', 1),
  (0.80, NOW(), 'Pago por frascos vidrio', 'system', 2),
  (2.00, NOW(), 'Pago por cartones', 'system', 3),
  (1.20, NOW(), 'Pago por latas', 'system', 4);

-- -----------------------------
-- Consultas de verificación básicas
-- -----------------------------
-- 1) Ver todos los registros (por tabla)
SELECT * FROM roles;

SELECT * FROM usuarios;

SELECT * FROM basureros;

SELECT * FROM materiales;

SELECT * FROM objetos;

SELECT * FROM pagos;

-- 2) Mostrar solo registros activos (deleted = 0)
SELECT * FROM usuarios WHERE deleted = 0;
SELECT * FROM objetos WHERE deleted = 0;

-- 3) Validar relaciones: mostrar objetos con su material y basurero
SELECT
  o.id_objeto,
  o.nombre AS objeto,
  o.cantidad,
  m.nombre AS material,
  m.unidad_medida,
  b.ubicacion AS basurero
FROM objetos o
JOIN materiales m ON o.id_material = m.id_material
JOIN basureros b ON o.id_basurero = b.id_basurero
WHERE o.deleted = 0;

-- 4) Sumar cantidad de objetos por basurero
SELECT
  b.id_basurero,
  b.ubicacion,
  SUM(o.cantidad) AS total_unidades_registradas
FROM basureros b
LEFT JOIN objetos o ON b.id_basurero = o.id_basurero AND o.deleted = 0
GROUP BY b.id_basurero, b.ubicacion;

-- 5) Total pagado por objeto (y validación: monto >= 0)
SELECT
  o.id_objeto,
  o.nombre,
  IFNULL(SUM(p.monto),0) AS total_pagado
FROM objetos o
LEFT JOIN pagos p ON o.id_objeto = p.id_objeto AND p.deleted = 0
GROUP BY o.id_objeto, o.nombre;

-- 6) Validaciones de CHECK (consultas que deberían devolver 0 filas si CHECKs se cumplen)
-- materiales con precio negativo (debe ser 0 filas)
SELECT * FROM materiales WHERE precio_unidad < 0;

-- basureros con capacidad negativa (debe ser 0 filas)
SELECT * FROM basureros WHERE capacidad_kg < 0;

-- registros con deleted no en (0,1) (debe ser 0 filas)
SELECT * FROM roles WHERE deleted NOT IN (0,1);
SELECT * FROM usuarios WHERE deleted NOT IN (0,1);

-- 7) Ejemplo de SELECT que muestra pagos con el objeto y su material
SELECT
  p.id_pago,
  p.monto,
  p.fec_pago,
  o.nombre AS objeto,
  m.nombre AS material,
  p.comentario
FROM pagos p
JOIN objetos o ON p.id_objeto = o.id_objeto
JOIN materiales m ON o.id_material = m.id_material;
