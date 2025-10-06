-- Usa la base de datos que prefieras
CREATE DATABASE IF NOT EXISTS eco_trash CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE eco_trash;

-- Tabla de materiales
CREATE TABLE materiales (
  id_material INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  composicion VARCHAR(255) DEFAULT NULL, -- p.ej. 'Plástico PET'
  precio_unidad DECIMAL(10,2) NOT NULL DEFAULT 0.00, -- precio por unidad (ej: por kg)
  
  -- Auditoría
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by VARCHAR(100) DEFAULT NULL,
  updated_at DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  updated_by VARCHAR(100) DEFAULT NULL,
  deleted BOOLEAN DEFAULT FALSE
);

-- Tabla de objetos (tipo de objeto)
CREATE TABLE objetos (
  id_objetos INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(150) NOT NULL,
  descripcion VARCHAR(200),

  -- Auditoría
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by VARCHAR(100) DEFAULT NULL,
  updated_at DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  updated_by VARCHAR(100) DEFAULT NULL,
  deleted BOOLEAN DEFAULT FALSE
);

-- Tabla de basureros / bins (ubicaciones)
CREATE TABLE basureros (
  id_basurero INT AUTO_INCREMENT PRIMARY KEY,
  ubicacion VARCHAR(150) DEFAULT NULL, -- nombre amigable
  capacidad_kg INT DEFAULT NULL, -- capacidad física aproximada

  -- Auditoría
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by VARCHAR(100) DEFAULT NULL,
  updated_at DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  updated_by VARCHAR(100) DEFAULT NULL,
  deleted BOOLEAN DEFAULT FALSE
);

-- Tabla de pagos asociados (movimientos financieros)
CREATE TABLE pagos (
  id_pago BIGINT AUTO_INCREMENT PRIMARY KEY,
  event_id BIGINT NOT NULL,
  monto DECIMAL(12,2) NOT NULL,
  fec_pago DATETIME DEFAULT NULL,


  -- Auditoría
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by VARCHAR(100) DEFAULT NULL,
  updated_at DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  updated_by VARCHAR(100) DEFAULT NULL,
  deleted BOOLEAN DEFAULT FALSE
);