USE clinica_veterinaria;

-- Consulta el nombre de la mascota, la fecha de su consulta y el motivo de atención.
SELECT 
    m.nombre_mascota,
    c.fecha_consulta,
    c.motivo
FROM mascotas m
JOIN consultas c ON m.id_mascota = c.id_mascota;

-- Agrega ahora la descripción del diagnóstico asociado a cada consulta.
SELECT 
    m.nombre_mascota,
    c.fecha_consulta,
    c.motivo,
    d.descripcion_diagnostico
FROM mascotas m
JOIN consultas c ON m.id_mascota = c.id_mascota
JOIN diagnosticos d ON c.id_diagnostico = d.id_diagnostico;

-- Queremos saber a qué dueño pertenece cada mascota que fue atendida.
SELECT 
    m.nombre_mascota,
    dño.nombre_dueño,
    c.fecha_consulta,
    c.motivo,
    d.descripcion_diagnostico
FROM mascotas m
JOIN dueños dño ON m.id_dueño = dño.id_dueño
JOIN consultas c ON m.id_mascota = c.id_mascota
JOIN diagnosticos d ON c.id_diagnostico = d.id_diagnostico;

-- Modifica la consulta para mostrar solo las consultas con motivo que contenga la palabra “urgencia”.
SELECT 
    m.nombre_mascota,
    dño.nombre_dueño,
    c.fecha_consulta,
    c.motivo,
    d.descripcion_diagnostico
FROM mascotas m
JOIN dueños dño ON m.id_dueño = dño.id_dueño
JOIN consultas c ON m.id_mascota = c.id_mascota
JOIN diagnosticos d ON c.id_diagnostico = d.id_diagnostico
WHERE c.motivo LIKE '%urgencia%';
