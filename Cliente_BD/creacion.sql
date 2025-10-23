-- ===============================================
-- SCRIPT 1: Creación de la base de datos eco_trash
-- ===============================================

-- Desactivamos validaciones temporales para crear las tablas sin conflictos
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Creación del esquema principal
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `eco_trash` 
DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `eco_trash`;

-- -----------------------------------------------------
-- Tabla: basureros
-- Contiene los puntos de recolección y su capacidad máxima
-- -----------------------------------------------------
CREATE TABLE `basureros` (
  `id_basurero` INT NOT NULL AUTO_INCREMENT,
  `ubicacion` VARCHAR(150) NOT NULL,
  `capacidad_kg` INT NOT NULL CHECK (capacidad_kg > 0),
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(100) NULL,
  `updated_at` DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(100) NULL,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0 CHECK (deleted IN (0,1)),
  PRIMARY KEY (`id_basurero`)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Tabla: materiales
-- Define los tipos de materiales reciclables
-- -----------------------------------------------------
CREATE TABLE `materiales` (
  `id_material` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `composicion` VARCHAR(255) NOT NULL,
  `precio_unidad` DECIMAL(10,2) NOT NULL DEFAULT 0.00 CHECK (precio_unidad >= 0),
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(100) NULL,
  `updated_at` DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(100) NULL,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0 CHECK (deleted IN (0,1)),
  PRIMARY KEY (`id_material`)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Tabla: objetos
-- Contiene los objetos reciclables con su material y basurero asociado
-- -----------------------------------------------------
CREATE TABLE `objetos` (
  `id_objetos` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(150) NOT NULL,
  `descripcion` VARCHAR(200) NULL,
  `id_material` INT NOT NULL,
  `id_basurero` INT NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(100) NULL,
  `updated_at` DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(100) NULL,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0 CHECK (deleted IN (0,1)),
  PRIMARY KEY (`id_objetos`),
  FOREIGN KEY (`id_material`) REFERENCES `materiales` (`id_material`),
  FOREIGN KEY (`id_basurero`) REFERENCES `basureros` (`id_basurero`)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Tabla: roles
-- Define los distintos roles de usuario (admin, técnico, recolector, etc.)
-- -----------------------------------------------------
CREATE TABLE `roles` (
  `id_roles` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `descripcion` VARCHAR(200) NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(100) NULL,
  `updated_at` DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(100) NULL,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0 CHECK (deleted IN (0,1)),
  PRIMARY KEY (`id_roles`)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Tabla: usuarios
-- Almacena los datos de los usuarios del sistema
-- -----------------------------------------------------
CREATE TABLE `usuarios` (
  `id_usuario` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `apellido` VARCHAR(45) NOT NULL,
  `num_contacto` VARCHAR(45) NULL,
  `roles_id_roles` INT NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(100) NULL,
  `updated_at` DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(100) NULL,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0 CHECK (deleted IN (0,1)),
  PRIMARY KEY (`id_usuario`),
  FOREIGN KEY (`roles_id_roles`) REFERENCES `roles` (`id_roles`)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Tabla: metodos_pago
-- Lista los métodos de pago disponibles
-- -----------------------------------------------------
CREATE TABLE `metodos_pago` (
  `id_metodo_pago` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `otros_detalles` VARCHAR(200) NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(100) NULL,
  `updated_at` DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(100) NULL,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0 CHECK (deleted IN (0,1)),
  PRIMARY KEY (`id_metodo_pago`)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Tabla: pagos
-- Registra los pagos realizados por los usuarios
-- -----------------------------------------------------
CREATE TABLE `pagos` (
  `id_pago` INT NOT NULL AUTO_INCREMENT,
  `monto` DECIMAL(12,2) NOT NULL CHECK (monto >= 0),
  `fec_pago` DATETIME NOT NULL,
  `id_objetos` INT NOT NULL,
  `id_usuario` INT NOT NULL,
  `id_metodo_pago` INT NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(100) NULL,
  `updated_at` DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(100) NULL,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0 CHECK (deleted IN (0,1)),
  PRIMARY KEY (`id_pago`),
  FOREIGN KEY (`id_objetos`) REFERENCES `objetos` (`id_objetos`),
  FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`),
  FOREIGN KEY (`id_metodo_pago`) REFERENCES `metodos_pago` (`id_metodo_pago`)
) ENGINE=InnoDB;

-- Restauramos configuraciones originales
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
