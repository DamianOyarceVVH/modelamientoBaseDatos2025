USE ejemploselect;

-- 1.-  Mostrar todos los usuarios de tipo Cliente
-- Seleccionar nombre de usuario, correo y tipo_usuario
SELECT u.username, u.email, t.nombre_tipo
FROM usuarios u, tipo_usuarios t
WHERE u.id_tipo_usuario = 2
AND u.id_tipo_usuario = t.id_tipo;

-- 2.-  Mostrar Personas nacidas despues del año 1990
-- Seleccionar Nombre, fecha de nacimiento y username.
SELECT p.nombre_completo, p.fecha_nac, u.username
FROM personas p, usuarios u
WHERE p.fecha_nac > '1990-12-31'
AND p.id_usuario = u.id_usuario;

-- 3.- Seleccionar nombres de personas que comiencen con la 
-- letra A - Seleccionar nombre y correo la persona.
SELECT p.nombre_completo, u.email
FROM personas p, usuarios u
WHERE p.nombre_completo LIKE 'A%'
AND p.id_usuario = u.id_usuario;

-- 4.- Mostrar usuarios cuyos dominios de correo sean
-- mail.commit LIKE '%mail.com%'
SELECT u.username, u.email
FROM usuarios u
WHERE u.email LIKE '%mail.com%';

-- 5.- Mostrar todas las personas que no viven en 
 -- Valparaiso y su usuario + ciudad.
 -- select * from ciudad; -- ID 2 VALPARAISO
SELECT p.nombre_completo, c.region, u.username, c.nombre_ciudad
FROM personas p, ciudad c,usuarios u
WHERE p.id_ciudad = c.id_ciudad
AND p.id_usuario = u.id_usuario
AND c.id_ciudad != 2;

-- 6.- Mostrar usuarios que contengan más de 7 
-- carácteres de longitud.
SELECT u.username
FROM usuarios u
WHERE LENGTH(username) > 7;

-- 7.- Mostrar username de personas nacidas entre
-- 1990 y 1995
SELECT u.username, p.fecha_nac
FROM usuarios u, personas p
WHERE fecha_nac BETWEEN '1990-01-01' AND '1995-12-31'
AND u.id_usuario = p.id_usuario;
