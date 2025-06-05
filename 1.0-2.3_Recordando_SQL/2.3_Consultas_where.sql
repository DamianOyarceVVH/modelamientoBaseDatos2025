use mercado;

-- Consulta básica: Muestra los usuarios activos (deleted = 0).
-- Esta consulta selecciona todas las columnas (*) de la tabla 'usuarios'
-- donde el valor de la columna 'deleted' es 0.
-- Asumimos que 'deleted = 0' indica que un usuario está activo y no ha sido "eliminado lógicamente".
select * from usuarios
where deleted = 0;

---

-- Consulta con condición múltiple: Muestra los usuarios cuyo tipo de usuario sea "Administrador".
-- Esta consulta también selecciona todas las columnas de la tabla 'usuarios'.
-- Filtra los resultados para mostrar solo aquellos usuarios cuyo 'tipo_usuario_id' es 1.
-- Es crucial saber el ID de 'Administrador' de la tabla 'tipos_usuarios' para que funcione correctamente.
select * from usuarios
where tipo_usuario_id = 1;

---

-- Lista los nombres de usuario que comienzan con la letra "M".
-- Esta consulta selecciona únicamente la columna 'nombre_usuario' de la tabla 'usuarios'.
-- Utiliza el operador 'LIKE' con el patrón 'M%' para encontrar nombres que empiecen con la letra 'M'.
-- El '%' es un comodín que representa cualquier secuencia de cero o más caracteres.
select nombre_usuario from usuarios
where nombre_usuario like 'M%';

---

-- Muestra los registros de personas creadas entre dos fechas específicas.
-- Esta consulta selecciona todas las columnas de la tabla 'usuarios'.
-- Utiliza el operador 'BETWEEN' para filtrar registros basados en la fecha de creación ('created_at'),
-- mostrando solo aquellos que fueron creados dentro del rango especificado (inclusive ambas fechas).
select * from usuarios
where created_at between '2025-05-18' and '2025-05-21';

---

-- Crea cinco consultas propias

-- 1. Usuarios con el rol de "Vendedor"
-- Esta consulta selecciona el nombre de usuario, correo y el ID del tipo de usuario de la tabla 'usuarios'.
-- Filtra para mostrar solo los usuarios cuyo 'tipo_usuario_id' es 2, asumiendo que 2 es el ID para el rol 'Vendedor'.
select nombre_usuario, correo, tipo_usuario_id from usuarios
where tipo_usuario_id = 2;

---

-- 2. Usuarios creados por el primer administrador (ID 1)
-- Esta consulta selecciona el nombre de usuario, correo y el ID del usuario que creó el registro ('created_by').
-- Muestra los usuarios que fueron creados por el usuario con 'ID 1'.
-- Esto es útil para auditar quién añadió usuarios al sistema.
select nombre_usuario, correo, created_by from usuarios
where created_by = 1;

---

-- 3. Usuarios cuyos nombres de usuario contienen 'javier' o 'max'
-- Esta consulta selecciona el nombre de usuario y correo de la tabla 'usuarios'.
-- Utiliza el operador 'LIKE' con el comodín '%' para buscar nombres de usuario que contengan 'javier' o 'max' en cualquier parte de la cadena.
-- El operador 'OR' permite que se cumpla cualquiera de las dos condiciones.
select nombre_usuario, correo from usuarios
where nombre_usuario like '%javier%' or nombre_usuario like '%max%';

---

-- 4. Usuarios con un correo de Gmail
-- Esta consulta selecciona el nombre de usuario y correo de la tabla 'usuarios'.
-- Usa 'LIKE' con '%gmail.com%' para encontrar todos los usuarios cuya dirección de correo electrónico
-- termina con el dominio 'gmail.com'.
select nombre_usuario, correo from usuarios
where correo like '%gmail.com%';

---

-- 5. Usuarios cuyo nombre no contiene 'sistema'
-- Esta consulta selecciona el nombre de usuario y correo de la tabla 'usuarios'.
-- Emplea 'NOT LIKE' con '%sistema%' para excluir de los resultados a cualquier usuario
-- cuyo 'nombre_usuario' contenga la palabra 'sistema'. Ideal para filtrar cuentas de servicio o internas.
select nombre_usuario, correo from usuarios
where nombre_usuario not like '%sistema%';