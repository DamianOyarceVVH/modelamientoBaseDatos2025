# Proyecto: Gestión de Base de Datos SQL

Este repositorio contiene el desarrollo de un proyecto de base de datos SQL, centrado en el diseño, la manipulación y la consulta de datos. Está diseñado con fines educativos para aplicar buenas prácticas en la escritura de scripts SQL, incluyendo **DDL (Lenguaje de Definición de Datos)** para la creación de tablas con restricciones y campos de auditoría, **DML (Lenguaje de Manipulación de Datos)** para la inserción de información, y **DQL (Lenguaje de Consulta de Datos) para la recuperación de datos.**

**Correo de contacto:** damianoyarce@liceovvh.cl

---

## Temática a trabajar
La temática principal de este proyecto es la **Creación y gestión de una base de datos relacional denominada ejemploSelect.**
Esta base de datos está diseñada para organizar información relacionada con:
- Tipos de Usuarios: Define los roles o categorías de usuarios dentro del sistema.
- Usuarios: Almacena los datos de acceso y credenciales de los usuarios.
- Ciudades: Contiene información geográfica de diversas ciudades.
- Personas: Guarda datos personales detallados, vinculando a los usuarios con su información de contacto y ubicación.

La implementación incluye campos de auditoría (created_at, updated_at, created_by, updated_by, deleted) y restricciones CHECK específicas para asegurar la integridad y la calidad de los datos.

---

## Objetivo del proyecto
El objetivo general es que el estudiante pueda redactar y completar correctamente scripts SQL, incorporando restricciones, campos de auditoría y consultas, aplicando buenas prácticas de modelamiento y documentación.

Herramientas y tecnologías utilizadas
Base de Datos: MySQL

Modelado y Reverse Engineering: MySQL Workbench

Lenguaje de Consulta: SQL

Control de versiones: Git y GitHub

---

## Estructura del proyecto
El repositorio incluye los siguientes archivos y directorios:

- 2.5_Estructura.sql/Insercion.sql: Contiene el script SQL completo para la creación de la base de datos ejemploSelect, la definición de todas las tablas (incluyendo campos de auditoría y restricciones CHECK con sus comentarios), y la inserción de datos de ejemplo.

- 2.5_Consultas.sql: Contiene el script SQL con las consultas SELECT completas, utilizando la cláusula WHERE para filtrar y recuperar información específica de la base de datos.

- 2.5.png: Una imagen del Diagrama Entidad-Relación (ERD) de la base de datos ejemploSelect, generado mediante la función de reverse engineering de MySQL Workbench.

- Consultas.png: Un directorio que contiene las capturas de pantalla de los resultados obtenidos al ejecutar cada una de las consultas SELECT.

- README.md: Este archivo, que proporciona una explicación detallada del proyecto, su temática, objetivos y la estructura del repositorio.