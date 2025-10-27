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
    SET deleted = 1, updated_by = p_updated_by
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

-- 4. Mostrar todos los roles (activos y borrados)
DROP PROCEDURE IF EXISTS sp_roles_listar_todo//
CREATE PROCEDURE sp_roles_listar_todo()
BEGIN
	SELECT id_roles, nombre, descripcion, created_at, created_by, deleted
    FROM roles
    ORDER BY nombre;
END//

-- 5. Restaurar roles
DROP PROCEDURE IF EXISTS sp_roles_restaurar//
CREATE PROCEDURE sp_roles_restaurar(
    IN p_id_roles INT,
    IN p_updated_by VARCHAR(100)
)
BEGIN
    UPDATE roles
    SET deleted = 0, updated_by = p_updated_by
    WHERE id_roles = p_id_roles;
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
    IN p_email VARCHAR(150),
    IN p_roles_id_roles INT,
    IN p_created_by VARCHAR(100)
)
BEGIN
	INSERT INTO usuarios (nombre, apellido, num_contacto, email, roles_id_roles, created_by, deleted)
    VALUES (p_nombre, p_apellido, p_num_contacto, p_email, p_roles_id_roles, p_created_by, 0);
END//

-- 2. Borrado lógico de usuarios
DROP PROCEDURE IF EXISTS sp_usuarios_borrado_logico//
CREATE PROCEDURE sp_usuarios_borrado_logico(
	IN p_id_usuario INT,
    IN p_updated_by VARCHAR(100)
)
BEGIN
	UPDATE usuarios
    SET deleted = 1, updated_by = p_updated_by
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
        u.email,
        r.nombre AS rol_nombre 
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
		u.email, 
		r.nombre AS rol_nombre, 
		u.deleted 
	FROM usuarios u
	INNER JOIN roles r ON u.roles_id_roles = r.id_roles
	ORDER BY u.apellido, u.nombre;
END//

-- 5. Restaurar usuarios
DROP PROCEDURE IF EXISTS sp_usuarios_restaurar//
CREATE PROCEDURE sp_usuarios_restaurar(
    IN p_id_usuario INT,
    IN p_updated_by VARCHAR(100)
)
BEGIN
    UPDATE usuarios
    SET deleted = 0, updated_by = p_updated_by
    WHERE id_usuario = p_id_usuario;
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
	SET deleted = 1, updated_by = p_updated_by
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

-- 4. Mostrar todos los basureros (activos y borrados)
DROP PROCEDURE IF EXISTS sp_basureros_listar_todo//
CREATE PROCEDURE sp_basureros_listar_todo()
BEGIN
	SELECT id_basurero, ubicacion, capacidad_kg, created_at, deleted
	FROM basureros
	ORDER BY ubicacion;
END//

-- 5. Restaurar basureros
DROP PROCEDURE IF EXISTS sp_basureros_restaurar//
CREATE PROCEDURE sp_basureros_restaurar(
    IN p_id_basurero INT,
    IN p_updated_by VARCHAR(100)
)
BEGIN
    UPDATE basureros
    SET deleted = 0, updated_by = p_updated_by
    WHERE id_basurero = p_id_basurero;
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
	IN p_unidad_medida VARCHAR(20),
	IN p_created_by VARCHAR(100)
)
BEGIN
	INSERT INTO materiales (nombre, composicion, precio_unidad, unidad_medida, created_by, deleted)
	VALUES (p_nombre, p_composicion, p_precio_unidad, p_unidad_medida, p_created_by, 0);
END//

-- 2. Borrado lógico de materiales
DROP PROCEDURE IF EXISTS sp_materiales_borrado_logico//
CREATE PROCEDURE sp_materiales_borrado_logico(
	IN p_id_material INT,
	IN p_updated_by VARCHAR(100)
)
BEGIN
	UPDATE materiales
	SET deleted = 1, updated_by = p_updated_by
	WHERE id_material = p_id_material;
END//

-- 3. Mostrar materiales activos
DROP PROCEDURE IF EXISTS sp_materiales_listar_activos//
CREATE PROCEDURE sp_materiales_listar_activos()
BEGIN
	SELECT id_material, nombre, composicion, precio_unidad, unidad_medida
	FROM materiales
	WHERE deleted = 0
	ORDER BY nombre;
END//

-- 4. Mostrar todos los materiales (activos y borrados)
DROP PROCEDURE IF EXISTS sp_materiales_listar_todo//
CREATE PROCEDURE sp_materiales_listar_todo()
BEGIN
	SELECT id_material, nombre, composicion, precio_unidad, unidad_medida, deleted
	FROM materiales
	ORDER BY nombre;
END//

DROP PROCEDURE IF EXISTS sp_materiales_restaurar//
CREATE PROCEDURE sp_materiales_restaurar(
    IN p_id_material INT,
    IN p_updated_by VARCHAR(100)
)
BEGIN
    UPDATE materiales
    SET deleted = 0, updated_by = p_updated_by
    WHERE id_material = p_id_material;
END//

/* ----------------------------------------------------------------
   PROCEDIMIENTOS PARA LA TABLA 'objetos'
   ---------------------------------------------------------------- */

-- 1. Insertar objetos
DROP PROCEDURE IF EXISTS sp_objetos_insertar//
CREATE PROCEDURE sp_objetos_insertar(
	IN p_nombre VARCHAR(150),
	IN p_descripcion VARCHAR(300),
	IN p_cantidad INT,
	IN p_id_material INT,
	IN p_id_basurero INT,
	IN p_created_by VARCHAR(100)
)
BEGIN
	INSERT INTO objetos (nombre, descripcion, cantidad, id_material, id_basurero, created_by, deleted)
	VALUES (p_nombre, p_descripcion, p_cantidad, p_id_material, p_id_basurero, p_created_by, 0);
END//

-- 2. Borrado lógico de objetos
DROP PROCEDURE IF EXISTS sp_objetos_borrado_logico//
CREATE PROCEDURE sp_objetos_borrado_logico(
	IN p_id_objeto INT,
	IN p_updated_by VARCHAR(100)
)
BEGIN
	UPDATE objetos
	SET deleted = 1, updated_by = p_updated_by
	WHERE id_objeto = p_id_objeto;
END//

-- 3. Mostrar objetos activos (con material y ubicación)
DROP PROCEDURE IF EXISTS sp_objetos_listar_activos//
CREATE PROCEDURE sp_objetos_listar_activos()
BEGIN
	SELECT
		o.id_objeto,
		o.nombre AS objeto,
		o.cantidad,
		m.nombre AS material,
		b.ubicacion AS basurero_ubicacion
	FROM objetos o
	INNER JOIN materiales m ON o.id_material = m.id_material
	INNER JOIN basureros b ON o.id_basurero = b.id_basurero
	WHERE o.deleted = 0
	ORDER BY o.created_at DESC;
END//

-- 4. Mostrar todos los objetos (activos y borrados)
DROP PROCEDURE IF EXISTS sp_objetos_listar_todo//
CREATE PROCEDURE sp_objetos_listar_todo()
BEGIN
	SELECT
		o.id_objeto,
		o.nombre AS objeto,
		o.cantidad,
		m.nombre AS material,
		b.ubicacion AS basurero_ubicacion,
		o.deleted
	FROM objetos o
	INNER JOIN materiales m ON o.id_material = m.id_material
	INNER JOIN basureros b ON o.id_basurero = b.id_basurero
	ORDER BY o.created_at DESC;
END//

-- 5. Restaurar objetos
DROP PROCEDURE IF EXISTS sp_objetos_restaurar//
CREATE PROCEDURE sp_objetos_restaurar(
    IN p_id_objeto INT,
    IN p_updated_by VARCHAR(100)
)
BEGIN
    UPDATE objetos
    SET deleted = 0, updated_by = p_updated_by
    WHERE id_objeto = p_id_objeto;
END//

/* ----------------------------------------------------------------
   PROCEDIMIENTOS PARA LA TABLA 'pagos'
   ---------------------------------------------------------------- */

-- 1. Insertar pagos
DROP PROCEDURE IF EXISTS sp_pagos_insertar//
CREATE PROCEDURE sp_pagos_insertar(
	IN p_monto DECIMAL(12,2),
	IN p_comentario VARCHAR(255),
	IN p_id_objeto INT,
	IN p_created_by VARCHAR(100)
)
BEGIN
	INSERT INTO pagos (monto, comentario, id_objeto, created_by, deleted)
	VALUES (p_monto, p_comentario, p_id_objeto, p_created_by, 0);
END//

-- 2. Borrado lógico de pagos
DROP PROCEDURE IF EXISTS sp_pagos_borrado_logico//
CREATE PROCEDURE sp_pagos_borrado_logico(
	IN p_id_pago BIGINT,
	IN p_updated_by VARCHAR(100)
)
BEGIN
	UPDATE pagos
	SET deleted = 1, updated_by = p_updated_by
	WHERE id_pago = p_id_pago;
END//

-- 3. Mostrar pagos activos (con objeto y material)
DROP PROCEDURE IF EXISTS sp_pagos_listar_activos//
CREATE PROCEDURE sp_pagos_listar_activos()
BEGIN
	SELECT
		p.id_pago,
		p.monto,
		p.fec_pago,
		o.nombre AS objeto_asociado,
		m.nombre AS material
		FROM pagos p
	INNER JOIN objetos o ON p.id_objeto = o.id_objeto
	INNER JOIN materiales m ON o.id_material = m.id_material
	WHERE p.deleted = 0
	ORDER BY p.fec_pago DESC;
END//

-- 4. Mostrar todos los pagos (activos y borrados)
DROP PROCEDURE IF EXISTS sp_pagos_listar_todo//
CREATE PROCEDURE sp_pagos_listar_todo()
BEGIN
	SELECT
		p.id_pago,
		p.monto,
		p.fec_pago,
		o.nombre AS objeto_asociado,
		m.nombre AS material,
		p.deleted
	FROM pagos p
	INNER JOIN objetos o ON p.id_objeto = o.id_objeto
	INNER JOIN materiales m ON o.id_material = m.id_material
	ORDER BY p.fec_pago DESC;
END//

-- 5. Restaurar pagos
DROP PROCEDURE IF EXISTS sp_pagos_restaurar//
CREATE PROCEDURE sp_pagos_restaurar(
    IN p_id_pago BIGINT,
    IN p_updated_by VARCHAR(100)
)
BEGIN
    UPDATE pagos
    SET deleted = 0, updated_by = p_updated_by
    WHERE id_pago = p_id_pago;
END//

-- Restaurar el delimitador por defecto
DELIMITER ;

/* ----------------------------------------------------------------
   PRUEBA DE TODOS LOS PROCEDIMIENTOS
   ---------------------------------------------------------------- */
 
-- 1. Roles
CALL sp_roles_insertar('Supervisor', 'Monitorea operaciones de basureros y rendimiento del personal técnico.', 'system_admin');
CALL sp_roles_borrado_logico(3, 'system');
CALL sp_roles_listar_activos();
CALL sp_roles_listar_todo();
CALL sp_roles_restaurar(3, 'system_restaurar'); -- <--- PRUEBA RESTAURAR
CALL sp_roles_listar_todo();

-- 2. Usuarios
CALL sp_usuarios_insertar('Juan', 'Pérez', '555-1234', 'juan.perez@email.com', 1, 'system');
CALL sp_usuarios_borrado_logico(3, 'system');
CALL sp_usuarios_listar_activos();
CALL sp_usuarios_listar_todo();
CALL sp_usuarios_restaurar(3, 'system_restaurar'); -- <--- PRUEBA RESTAURAR
CALL sp_usuarios_listar_todo();

-- 3. Basureros
CALL sp_basureros_insertar('Entrada Principal, Bloque C', 100, 'system');
CALL sp_basureros_borrado_logico(2, 'system');
CALL sp_basureros_listar_activos();
CALL sp_basureros_listar_todo();
CALL sp_basureros_restaurar(2, 'system_restaurar'); -- <--- PRUEBA RESTAURAR
CALL sp_basureros_listar_todo();

-- 4. Materiales
CALL sp_materiales_insertar('Papel', 'Fibras de celulosa', 0.01, 'kg', 'system');
CALL sp_materiales_borrado_logico(1, 'system');
CALL sp_materiales_listar_activos();
CALL sp_materiales_listar_todo();
CALL sp_materiales_restaurar(1, 'system_restaurar'); -- <--- PRUEBA RESTAURAR
CALL sp_materiales_listar_todo();

-- 5. Objetos
CALL sp_objetos_insertar('Botella Agua 1.5L', 'Botella de plástico transparente', 50, 1, 1, 'usuario_registro');
CALL sp_objetos_borrado_logico(2, 'system');
CALL sp_objetos_listar_activos();
CALL sp_objetos_listar_todo();
CALL sp_objetos_restaurar(2, 'system_restaurar'); -- <--- PRUEBA RESTAURAR
CALL sp_objetos_listar_todo();

-- 6. Pagos
CALL sp_pagos_insertar(25.50, 'Pago por reciclaje de plásticos', 1, 'cajero_1');
CALL sp_pagos_borrado_logico(200, 'system');
CALL sp_pagos_listar_activos();
CALL sp_pagos_listar_todo();
CALL sp_pagos_restaurar(200, 'system_restaurar'); -- <--- PRUEBA RESTAURAR
CALL sp_pagos_listar_todo();
