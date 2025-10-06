-- Script 1: Creación de la base de datos y tablas
-- MySQL (compatible 8.0+)
-- Incluye: constraints CHECK, valores DEFAULT y campos de auditoría.
-- -----------------------------------------------------
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- Crear esquema
CREATE SCHEMA IF NOT EXISTS `eco_trash` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ;
USE `eco_trash` ;

-- ----------------------------------------------------------------
-- Tabla: roles
-- Propósito: define roles de usuario del sistema (administrador, técnico, ciudadano, etc.)
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS `roles`;
CREATE TABLE IF NOT EXISTS `roles` (
  `id_roles` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `descripcion` VARCHAR(200) NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(100) NULL DEFAULT NULL,
  `updated_at` DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(100) NULL DEFAULT NULL,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_roles`),
  UNIQUE KEY `uq_roles_nombre` (`nombre`),
  CHECK (`deleted` IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------
-- Tabla: usuarios
-- Propósito: usuarios del sistema (administradores, técnicos, ciudadanos)
-- Nota: num_contacto es texto para permitir formatos internacionales.
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS `usuarios`;
CREATE TABLE IF NOT EXISTS `usuarios` (
  `id_usuario` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `apellido` VARCHAR(45) NOT NULL,
  `num_contacto` VARCHAR(45) NULL DEFAULT NULL,
  `email` VARCHAR(150) NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(100) NULL DEFAULT NULL,
  `updated_at` DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(100) NULL DEFAULT NULL,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0,
  `roles_id_roles` INT NOT NULL,
  PRIMARY KEY (`id_usuario`),
  INDEX `fk_usuarios_roles_idx` (`roles_id_roles`),
  CONSTRAINT `fk_usuarios_roles`
    FOREIGN KEY (`roles_id_roles`)
    REFERENCES `roles` (`id_roles`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CHECK (`deleted` IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------
-- Tabla: basureros
-- Propósito: ubicación física de contenedores / puntos de acopio
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS `basureros`;
CREATE TABLE IF NOT EXISTS `basureros` (
  `id_basurero` INT NOT NULL AUTO_INCREMENT,
  `ubicacion` VARCHAR(150) NOT NULL, -- dirección o descripción del punto
  `capacidad_kg` INT NOT NULL DEFAULT 50, -- capacidad estimada en kg
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(100) NULL DEFAULT NULL,
  `updated_at` DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(100) NULL DEFAULT NULL,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_basurero`),
  CHECK (`capacidad_kg` >= 0),
  CHECK (`deleted` IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------
-- Tabla: materiales
-- Propósito: catálogo de materiales reutilizables/reciclables con precio por unidad
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS `materiales`;
CREATE TABLE IF NOT EXISTS `materiales` (
  `id_material` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL, -- ej: "Plástico PET", "Vidrio", "Cartón"
  `composicion` VARCHAR(255) NULL DEFAULT NULL, -- descripción de composición
  `precio_unidad` DECIMAL(10,2) NOT NULL DEFAULT 0.00, -- precio por unidad o kg según dominio
  `unidad_medida` VARCHAR(20) NOT NULL DEFAULT 'unidad', -- 'unidad' o 'kg'
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(100) NULL DEFAULT NULL,
  `updated_at` DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(100) NULL DEFAULT NULL,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_material`),
  UNIQUE KEY `uq_materiales_nombre` (`nombre`),
  CHECK (`precio_unidad` >= 0.00),
  CHECK (`deleted` IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------
-- Tabla: objetos
-- Propósito: objetos recogidos o registrados en sistema (vínculo a material y basurero)
-- Observación: 'created_by' guarda nombre/usuario que registró; si se desea FK, migrar a id_usuario
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS `objetos`;
CREATE TABLE IF NOT EXISTS `objetos` (
  `id_objeto` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(150) NOT NULL, -- ej: "Botella PET 500ml"
  `descripcion` VARCHAR(300) NULL DEFAULT NULL,
  `cantidad` INT NOT NULL DEFAULT 1, -- cantidad de unidades registradas
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(100) NULL DEFAULT NULL,
  `updated_at` DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(100) NULL DEFAULT NULL,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0,
  `id_material` INT NOT NULL,
  `id_basurero` INT NOT NULL,
  PRIMARY KEY (`id_objeto`),
  INDEX `fk_objetos_materiales_idx` (`id_material`),
  INDEX `fk_objetos_basureros_idx` (`id_basurero`),
  CONSTRAINT `fk_objetos_materiales`
    FOREIGN KEY (`id_material`)
    REFERENCES `materiales` (`id_material`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_objetos_basureros`
    FOREIGN KEY (`id_basurero`)
    REFERENCES `basureros` (`id_basurero`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CHECK (`cantidad` >= 0),
  CHECK (`deleted` IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------
-- Tabla: pagos
-- Propósito: pagos o incentivos asociados a objetos (por ejemplo reembolso por material)
-- Nota: fec_pago por defecto timestamp si no se especifica.
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS `pagos`;
CREATE TABLE IF NOT EXISTS `pagos` (
  `id_pago` BIGINT NOT NULL AUTO_INCREMENT,
  `monto` DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `fec_pago` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `comentario` VARCHAR(255) NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(100) NULL DEFAULT NULL,
  `updated_at` DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(100) NULL DEFAULT NULL,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0,
  `id_objeto` INT NOT NULL,
  PRIMARY KEY (`id_pago`),
  INDEX `fk_pagos_objetos_idx` (`id_objeto`),
  CONSTRAINT `fk_pagos_objetos`
    FOREIGN KEY (`id_objeto`)
    REFERENCES `objetos` (`id_objeto`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CHECK (`monto` >= 0.00),
  CHECK (`deleted` IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Restaurar modos previos
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
