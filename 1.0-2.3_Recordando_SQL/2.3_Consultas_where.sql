use mercado;

-- Consulta básica: Muestra  los usuarios activos (deleted = 'activo').
select nombre_usuario from usuarios
where deleted = 0;

-- Consulta con condición múltiple: Muestra los usuarios cuyo tipo de usuario sea "Administrador"
select nombre_usuario from usuarios
join tipos_usuarios on tipo_usuario_id = id_tipo_usuario
where nombre_tipo = 'Administrador'