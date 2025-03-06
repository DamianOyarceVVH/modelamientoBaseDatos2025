-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`tipos_usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tipos_usuarios` (
  `id_tipo_usuario` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(16) NOT NULL,
  `descripcion` VARCHAR(150) NOT NULL,
  `create` DATETIME NOT NULL,
  `update` DATETIME NOT NULL,
  PRIMARY KEY (`id_tipo_usuario`));


-- -----------------------------------------------------
-- Table `mydb`.`usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`usuarios` (
  `id_usuario` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(16) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `contraseña` VARCHAR(32) NOT NULL,
  `create` DATETIME NOT NULL,
  `update` DATETIME NOT NULL,
  `id_tipo_usuario` INT NOT NULL,
  PRIMARY KEY (`id_usuario`),
  INDEX `fk_usuarios_tipos_usuarios_idx` (`id_tipo_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_usuarios_tipos_usuarios`
    FOREIGN KEY (`id_tipo_usuario`)
    REFERENCES `mydb`.`tipos_usuarios` (`id_tipo_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mydb`.`areas_medicas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`areas_medicas` (
  `id_area_medica` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `descripcion` VARCHAR(150) NOT NULL,
  `create` DATETIME NOT NULL,
  `update` DATETIME NOT NULL,
  PRIMARY KEY (`id_area_medica`));


-- -----------------------------------------------------
-- Table `mydb`.`doctores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`doctores` (
  `id_doctor` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(16) NOT NULL,
  `apellido` VARCHAR(16) NOT NULL,
  `especialidad` VARCHAR(45) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `contraseña` VARCHAR(45) NOT NULL,
  `telefono` INT NOT NULL,
  `fecha_contratacion` DATE NOT NULL,
  `create` DATETIME NOT NULL,
  `update` DATETIME NOT NULL,
  `id_area_medica` INT NOT NULL,
  `id_usuario` INT NOT NULL,
  PRIMARY KEY (`id_doctor`),
  INDEX `fk_doctores_areas_medicas1_idx` (`id_area_medica` ASC) VISIBLE,
  INDEX `fk_doctores_usuarios1_idx` (`id_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_doctores_areas_medicas1`
    FOREIGN KEY (`id_area_medica`)
    REFERENCES `mydb`.`areas_medicas` (`id_area_medica`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_doctores_usuarios1`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `mydb`.`usuarios` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mydb`.`tratamientos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tratamientos` (
  `id_tratamiento` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `descripcion` VARCHAR(150) NOT NULL,
  `create` DATETIME NOT NULL,
  `update` DATETIME NOT NULL,
  PRIMARY KEY (`id_tratamiento`))
COMMENT = '\n\n\n\n';


-- -----------------------------------------------------
-- Table `mydb`.`pacientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`pacientes` (
  `RUT` VARCHAR(12) NOT NULL,
  `nombre` VARCHAR(16) NOT NULL,
  `apellido_p` VARCHAR(16) NOT NULL,
  `apellido_m` VARCHAR(16) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `contraseña` VARCHAR(32) NOT NULL,
  `telefono` INT NOT NULL,
  `sexo` ENUM('m', 'f') NOT NULL,
  `create` DATETIME NOT NULL,
  `update` DATETIME NOT NULL,
  PRIMARY KEY (`RUT`));


-- -----------------------------------------------------
-- Table `mydb`.`citas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`citas` (
  `id_cita` INT NOT NULL AUTO_INCREMENT,
  `diagnostico` VARCHAR(150) NOT NULL,
  `fecha` DATE NOT NULL,
  `create` DATETIME NOT NULL,
  `update` DATETIME NOT NULL,
  `id_tratamiento` INT NOT NULL,
  `RUT` VARCHAR(12) NOT NULL,
  `id_doctor` INT NOT NULL,
  `id_usuario` INT NOT NULL,
  PRIMARY KEY (`id_cita`),
  INDEX `fk_citas_tratamientos1_idx` (`id_tratamiento` ASC) VISIBLE,
  INDEX `fk_citas_pacientes1_idx` (`RUT` ASC) VISIBLE,
  INDEX `fk_citas_doctores1_idx` (`id_doctor` ASC) VISIBLE,
  INDEX `fk_citas_usuarios1_idx` (`id_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_citas_tratamientos1`
    FOREIGN KEY (`id_tratamiento`)
    REFERENCES `mydb`.`tratamientos` (`id_tratamiento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_citas_pacientes1`
    FOREIGN KEY (`RUT`)
    REFERENCES `mydb`.`pacientes` (`RUT`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_citas_doctores1`
    FOREIGN KEY (`id_doctor`)
    REFERENCES `mydb`.`doctores` (`id_doctor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_citas_usuarios1`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `mydb`.`usuarios` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = '\n\n\n\n';


-- -----------------------------------------------------
-- Table `mydb`.`consultas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`consultas` (
  `id_consulta` INT NOT NULL AUTO_INCREMENT,
  `motivo` VARCHAR(150) NOT NULL,
  `fecha` DATE NOT NULL,
  `create` DATETIME NOT NULL,
  `update` DATETIME NOT NULL,
  `RUT` VARCHAR(12) NOT NULL,
  `id_doctor` INT NOT NULL,
  PRIMARY KEY (`id_consulta`),
  INDEX `fk_consultas_pacientes1_idx` (`RUT` ASC) VISIBLE,
  INDEX `fk_consultas_doctores1_idx` (`id_doctor` ASC) VISIBLE,
  CONSTRAINT `fk_consultas_pacientes1`
    FOREIGN KEY (`RUT`)
    REFERENCES `mydb`.`pacientes` (`RUT`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_consultas_doctores1`
    FOREIGN KEY (`id_doctor`)
    REFERENCES `mydb`.`doctores` (`id_doctor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = '\n\n\n\n';

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
