/* ====================================================================
   TAREA: PROCEDIMIENTOS ALMACENADOS PARA LA BASE DE DATOS 'eco_trash'
   ==================================================================== */

USE `eco_trash`;

-- Cambiar delimitador para permitir la creación de procedimientos
DELIMITER //

/* ----------------------------------------------------------------
   PROCEDIMIENTOS PARA LA TABLA 'roles'
   ---------------------------------------------------------------- */

-- 1. Insertar roles
DROP PROCEDURE IF EXISTS sp_roles_insertar//
CREATE PROCEDURE sp_roles_insertar(
  IN p_nombre VARCHAR(45),
  IN p_descripcion VARCHAR(200),
  IN p_created_by VARCHAR(100)
)
BEGIN
  INSERT INTO roles (nombre, descripcion, created_by, deleted)
  VALUES (p_nombre, p_descripcion, p_created_by, 0);
END//

-- 2. Borrado lógico de roles
DROP PROCEDURE IF EXISTS sp_roles_borrado_logico//
CREATE PROCEDURE sp_roles_borrado_logico(
  IN p_id_roles INT,
  IN p_updated_by VARCHAR(100)
)
BEGIN
  UPDATE roles
  SET deleted = 1,
      updated_by = p_updated_by,
      updated_at = CURRENT_TIMESTAMP
  WHERE id_roles = p_id_roles;
END//

-- 3. Mostrar roles activos
DROP PROCEDURE IF EXISTS sp_roles_listar_activos//
CREATE PROCEDURE sp_roles_listar_activos()
BEGIN
  SELECT id_roles, nombre, descripcion, created_at, created_by
  FROM roles
  WHERE deleted = 0
  ORDER BY nombre;
END//

-- 4. Mostrar todos los roles
DROP PROCEDURE IF EXISTS sp_roles_listar_todo//
CREATE PROCEDURE sp_roles_listar_todo()
BEGIN
  SELECT id_roles, nombre, descripcion, created_at, created_by, deleted
  FROM roles
  ORDER BY nombre;
END//

/* ----------------------------------------------------------------
   PROCEDIMIENTOS PARA LA TABLA 'usuarios'
   ---------------------------------------------------------------- */

-- 1. Insertar usuarios
DROP PROCEDURE IF EXISTS sp_usuarios_insertar//
CREATE PROCEDURE sp_usuarios_insertar(
  IN p_nombre VARCHAR(45),
  IN p_apellido VARCHAR(45),
  IN p_num_contacto VARCHAR(45),
  IN p_roles_id_roles INT,
  IN p_created_by VARCHAR(100)
)
BEGIN
  INSERT INTO usuarios (nombre, apellido, num_contacto, roles_id_roles, created_by, deleted)
  VALUES (p_nombre, p_apellido, p_num_contacto, p_roles_id_roles, p_created_by, 0);
END//

-- 2. Borrado lógico de usuarios
DROP PROCEDURE IF EXISTS sp_usuarios_borrado_logico//
CREATE PROCEDURE sp_usuarios_borrado_logico(
  IN p_id_usuario INT,
  IN p_updated_by VARCHAR(100)
)
BEGIN
  UPDATE usuarios
  SET deleted = 1,
      updated_by = p_updated_by,
      updated_at = CURRENT_TIMESTAMP
  WHERE id_usuario = p_id_usuario;
END//

-- 3. Mostrar usuarios activos (con nombre de rol)
DROP PROCEDURE IF EXISTS sp_usuarios_listar_activos//
CREATE PROCEDURE sp_usuarios_listar_activos()
BEGIN
  SELECT
    u.id_usuario,
    u.nombre,
    u.apellido,
    u.num_contacto,
    r.nombre AS rol_nombre,
    u.created_at
  FROM usuarios u
  INNER JOIN roles r ON u.roles_id_roles = r.id_roles
  WHERE u.deleted = 0
  ORDER BY u.apellido, u.nombre;
END//

-- 4. Mostrar todos los usuarios (activos y borrados)
DROP PROCEDURE IF EXISTS sp_usuarios_listar_todo//
CREATE PROCEDURE sp_usuarios_listar_todo()
BEGIN
  SELECT
    u.id_usuario,
    u.nombre,
    u.apellido,
    u.num_contacto,
    r.nombre AS rol_nombre,
    u.deleted,
    u.created_at
  FROM usuarios u
  INNER JOIN roles r ON u.roles_id_roles = r.id_roles
  ORDER BY u.apellido, u.nombre;
END//

/* ----------------------------------------------------------------
   PROCEDIMIENTOS PARA LA TABLA 'basureros'
   ---------------------------------------------------------------- */

-- 1. Insertar basureros
DROP PROCEDURE IF EXISTS sp_basureros_insertar//
CREATE PROCEDURE sp_basureros_insertar(
  IN p_ubicacion VARCHAR(150),
  IN p_capacidad_kg INT,
  IN p_created_by VARCHAR(100)
)
BEGIN
  INSERT INTO basureros (ubicacion, capacidad_kg, created_by, deleted)
  VALUES (p_ubicacion, p_capacidad_kg, p_created_by, 0);
END//

-- 2. Borrado lógico de basureros
DROP PROCEDURE IF EXISTS sp_basureros_borrado_logico//
CREATE PROCEDURE sp_basureros_borrado_logico(
  IN p_id_basurero INT,
  IN p_updated_by VARCHAR(100)
)
BEGIN
  UPDATE basureros
  SET deleted = 1,
      updated_by = p_updated_by,
      updated_at = CURRENT_TIMESTAMP
  WHERE id_basurero = p_id_basurero;
END//

-- 3. Mostrar basureros activos
DROP PROCEDURE IF EXISTS sp_basureros_listar_activos//
CREATE PROCEDURE sp_basureros_listar_activos()
BEGIN
  SELECT id_basurero, ubicacion, capacidad_kg, created_at
  FROM basureros
  WHERE deleted = 0
  ORDER BY ubicacion;
END//

-- 4. Mostrar todos los basureros
DROP PROCEDURE IF EXISTS sp_basureros_listar_todo//
CREATE PROCEDURE sp_basureros_listar_todo()
BEGIN
  SELECT id_basurero, ubicacion, capacidad_kg, created_at, deleted
  FROM basureros
  ORDER BY ubicacion;
END//

/* ----------------------------------------------------------------
   PROCEDIMIENTOS PARA LA TABLA 'materiales'
   ---------------------------------------------------------------- */

-- 1. Insertar materiales
DROP PROCEDURE IF EXISTS sp_materiales_insertar//
CREATE PROCEDURE sp_materiales_insertar(
  IN p_nombre VARCHAR(100),
  IN p_composicion VARCHAR(255),
  IN p_precio_unidad DECIMAL(10,2),
  IN p_created_by VARCHAR(100)
)
BEGIN
  INSERT INTO materiales (nombre, composicion, precio_unidad, created_by, deleted)
  VALUES (p_nombre, p_composicion, p_precio_unidad, p_created_by, 0);
END//

-- 2. Borrado lógico de materiales
DROP PROCEDURE IF EXISTS sp_materiales_borrado_logico//
CREATE PROCEDURE sp_materiales_borrado_logico(
  IN p_id_material INT,
  IN p_updated_by VARCHAR(100)
)
BEGIN
  UPDATE materiales
  SET deleted = 1,
      updated_by = p_updated_by,
      updated_at = CURRENT_TIMESTAMP
  WHERE id_material = p_id_material;
END//

-- 3. Mostrar materiales activos
DROP PROCEDURE IF EXISTS sp_materiales_listar_activos//
CREATE PROCEDURE sp_materiales_listar_activos()
BEGIN
  SELECT id_material, nombre, composicion, precio_unidad, created_at
  FROM materiales
  WHERE deleted = 0
  ORDER BY nombre;
END//

-- 4. Mostrar todos los materiales
DROP PROCEDURE IF EXISTS sp_materiales_listar_todo//
CREATE PROCEDURE sp_materiales_listar_todo()
BEGIN
  SELECT id_material, nombre, composicion, precio_unidad, deleted, created_at
  FROM materiales
  ORDER BY nombre;
END//

/* ----------------------------------------------------------------
   PROCEDIMIENTOS PARA LA TABLA 'objetos'
   ---------------------------------------------------------------- */

-- 1. Insertar objetos
DROP PROCEDURE IF EXISTS sp_objetos_insertar//
CREATE PROCEDURE sp_objetos_insertar(
  IN p_nombre VARCHAR(150),
  IN p_descripcion VARCHAR(200),
  IN p_id_material INT,
  IN p_id_basurero INT,
  IN p_created_by VARCHAR(100)
)
BEGIN
  INSERT INTO objetos (nombre, descripcion, id_material, id_basurero, created_by, deleted)
  VALUES (p_nombre, p_descripcion, p_id_material, p_id_basurero, p_created_by, 0);
END//

-- 2. Borrado lógico de objetos
DROP PROCEDURE IF EXISTS sp_objetos_borrado_logico//
CREATE PROCEDURE sp_objetos_borrado_logico(
  IN p_id_objeto INT,
  IN p_updated_by VARCHAR(100)
)
BEGIN
  UPDATE objetos
  SET deleted = 1,
      updated_by = p_updated_by,
      updated_at = CURRENT_TIMESTAMP
  WHERE id_objetos = p_id_objeto;
END//

-- 3. Mostrar objetos activos (con material y ubicación)
DROP PROCEDURE IF EXISTS sp_objetos_listar_activos//
CREATE PROCEDURE sp_objetos_listar_activos()
BEGIN
  SELECT
    o.id_objetos,
    o.nombre AS objeto,
    o.descripcion,
    m.nombre AS material,
    b.ubicacion AS basurero_ubicacion,
    o.created_at
  FROM objetos o
  INNER JOIN materiales m ON o.id_material = m.id_material
  INNER JOIN basureros b ON o.id_basurero = b.id_basurero
  WHERE o.deleted = 0
  ORDER BY o.created_at DESC;
END//

-- 4. Mostrar todos los objetos
DROP PROCEDURE IF EXISTS sp_objetos_listar_todo//
CREATE PROCEDURE sp_objetos_listar_todo()
BEGIN
  SELECT
    o.id_objetos,
    o.nombre AS objeto,
    o.descripcion,
    m.nombre AS material,
    b.ubicacion AS basurero_ubicacion,
    o.deleted,
    o.created_at
  FROM objetos o
  INNER JOIN materiales m ON o.id_material = m.id_material
  INNER JOIN basureros b ON o.id_basurero = b.id_basurero
  ORDER BY o.created_at DESC;
END//

/* ----------------------------------------------------------------
   PROCEDIMIENTOS PARA LA TABLA 'metodos_pago'
   ---------------------------------------------------------------- */

-- 1. Insertar métodos de pago
DROP PROCEDURE IF EXISTS sp_metodos_pago_insertar//
CREATE PROCEDURE sp_metodos_pago_insertar(
  IN p_nombre VARCHAR(45),
  IN p_otros_detalles VARCHAR(200),
  IN p_created_by VARCHAR(100)
)
BEGIN
  INSERT INTO metodos_pago (nombre, otros_detalles, created_by, deleted)
  VALUES (p_nombre, p_otros_detalles, p_created_by, 0);
END//

-- 2. Borrado lógico de métodos de pago
DROP PROCEDURE IF EXISTS sp_metodos_pago_borrado_logico//
CREATE PROCEDURE sp_metodos_pago_borrado_logico(
  IN p_id_metodo_pago INT,
  IN p_updated_by VARCHAR(100)
)
BEGIN
  UPDATE metodos_pago
  SET deleted = 1,
      updated_by = p_updated_by,
      updated_at = CURRENT_TIMESTAMP
  WHERE id_metodo_pago = p_id_metodo_pago;
END//

-- 3. Mostrar métodos de pago activos
DROP PROCEDURE IF EXISTS sp_metodos_pago_listar_activos//
CREATE PROCEDURE sp_metodos_pago_listar_activos()
BEGIN
  SELECT id_metodo_pago, nombre, otros_detalles, created_at
  FROM metodos_pago
  WHERE deleted = 0
  ORDER BY nombre;
END//

-- 4. Mostrar todos los métodos de pago
DROP PROCEDURE IF EXISTS sp_metodos_pago_listar_todo//
CREATE PROCEDURE sp_metodos_pago_listar_todo()
BEGIN
  SELECT id_metodo_pago, nombre, otros_detalles, deleted, created_at
  FROM metodos_pago
  ORDER BY nombre;
END//

/* ----------------------------------------------------------------
   PROCEDIMIENTOS PARA LA TABLA 'pagos'
   ---------------------------------------------------------------- */

-- 1. Insertar pagos
DROP PROCEDURE IF EXISTS sp_pagos_insertar//
CREATE PROCEDURE sp_pagos_insertar(
  IN p_monto DECIMAL(12,2),
  IN p_fec_pago DATETIME,
  IN p_id_objetos INT,
  IN p_id_usuario INT,
  IN p_id_metodo_pago INT,
  IN p_created_by VARCHAR(100)
)
BEGIN
  INSERT INTO pagos (monto, fec_pago, id_objetos, id_usuario, id_metodo_pago, created_by, deleted)
  VALUES (p_monto, p_fec_pago, p_id_objetos, p_id_usuario, p_id_metodo_pago, p_created_by, 0);
END//

-- 2. Borrado lógico de pagos
DROP PROCEDURE IF EXISTS sp_pagos_borrado_logico//
CREATE PROCEDURE sp_pagos_borrado_logico(
  IN p_id_pago INT,
  IN p_updated_by VARCHAR(100)
)
BEGIN
  UPDATE pagos
  SET deleted = 1,
      updated_by = p_updated_by,
      updated_at = CURRENT_TIMESTAMP
  WHERE id_pago = p_id_pago;
END//

-- 3. Mostrar pagos activos (con objeto, usuario y método)
DROP PROCEDURE IF EXISTS sp_pagos_listar_activos//
CREATE PROCEDURE sp_pagos_listar_activos()
BEGIN
  SELECT
    p.id_pago,
    p.monto,
    p.fec_pago,
    o.nombre AS objeto_asociado,
    u.nombre AS usuario_nombre,
    mp.nombre AS metodo_pago,
    p.created_at
  FROM pagos p
  INNER JOIN objetos o ON p.id_objetos = o.id_objetos
  INNER JOIN usuarios u ON p.id_usuario = u.id_usuario
  INNER JOIN metodos_pago mp ON p.id_metodo_pago = mp.id_metodo_pago
  WHERE p.deleted = 0
  ORDER BY p.fec_pago DESC;
END//

-- 4. Mostrar todos los pagos
DROP PROCEDURE IF EXISTS sp_pagos_listar_todo//
CREATE PROCEDURE sp_pagos_listar_todo()
BEGIN
  SELECT
    p.id_pago,
    p.monto,
    p.fec_pago,
    o.nombre AS objeto_asociado,
    u.nombre AS usuario_nombre,
    mp.nombre AS metodo_pago,
    p.deleted,
    p.created_at
  FROM pagos p
  INNER JOIN objetos o ON p.id_objetos = o.id_objetos
  INNER JOIN usuarios u ON p.id_usuario = u.id_usuario
  INNER JOIN metodos_pago mp ON p.id_metodo_pago = mp.id_metodo_pago
  ORDER BY p.fec_pago DESC;
END//

-- Restaurar delimitador por defecto
DELIMITER ;



/* ----------------------------------------------------------------
   PRUEBA DE TODOS LOS PROCEDIMIENTOS (EJEMPLOS)
   Ejecuta estas llamadas para validar que los procedimientos funcionan.
   Ajusta parámetros si lo deseas.
   ---------------------------------------------------------------- */

-- 1. Roles
CALL sp_roles_insertar('Supervisor', 'Monitorea operaciones', 'system_admin');
CALL sp_roles_listar_activos();
CALL sp_roles_listar_todo();
-- Ejemplo borrar lógico (si id_roles = 3 existe)
-- CALL sp_roles_borrado_logico(3, 'tester');

-- 2. Usuarios
CALL sp_usuarios_insertar('Juan', 'Pérez', '555-1234', 1, 'system');
CALL sp_usuarios_listar_activos();
CALL sp_usuarios_listar_todo();
-- CALL sp_usuarios_borrado_logico(3, 'system');

-- 3. Basureros
CALL sp_basureros_insertar('Entrada Principal, Bloque C', 100, 'system');
CALL sp_basureros_listar_activos();
CALL sp_basureros_listar_todo();
-- CALL sp_basureros_borrado_logico(2, 'system');

-- 4. Materiales
CALL sp_materiales_insertar('Papel', 'Fibras de celulosa', 0.01, 'system');
CALL sp_materiales_listar_activos();
CALL sp_materiales_listar_todo();
-- CALL sp_materiales_borrado_logico(1, 'system');

-- 5. Objetos
-- Asegúrate de que existan id_material y id_basurero referenciados antes de insertar
CALL sp_objetos_insertar('Botella Agua 1.5L', 'Botella de plástico transparente', 1, 1, 'usuario_registro');
CALL sp_objetos_listar_activos();
CALL sp_objetos_listar_todo();
-- CALL sp_objetos_borrado_logico(2, 'system');

-- 6. Métodos de pago
CALL sp_metodos_pago_insertar('Transferencia', 'Banco Estado', 'system');
CALL sp_metodos_pago_listar_activos();
CALL sp_metodos_pago_listar_todo();
-- CALL sp_metodos_pago_borrado_logico(1, 'system');

-- 7. Pagos
-- Asegúrate de que existan id_objetos, id_usuario, id_metodo_pago antes de insertar pagos
CALL sp_pagos_insertar(1000.00, NOW(), 1, 1, 1, 'cajero_1');
CALL sp_pagos_listar_activos();
CALL sp_pagos_listar_todo();
-- CALL sp_pagos_borrado_logico(1, 'system');