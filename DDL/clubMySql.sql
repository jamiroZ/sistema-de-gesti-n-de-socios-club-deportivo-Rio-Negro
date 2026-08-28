-- =====================================================================
-- Conversión de PostgreSQL a MySQL (8.0+)
-- Notas de la conversión:
--  * MySQL no soporta CREATE DOMAIN, así que cada dominio se reemplazó
--    por su tipo base + una restricción CHECK repetida en cada columna
--    que lo usaba (MySQL 8.0.16+ sí valida los CHECK).
--  * SERIAL se reemplazó por INT AUTO_INCREMENT (equivalente práctico
--    más usado en MySQL).
--  * Se agregó ENGINE=InnoDB (necesario para que las FOREIGN KEY
--    funcionen) y DEFAULT CHARSET=utf8mb4.
-- =====================================================================

SET FOREIGN_KEY_CHECKS = 0;

-- ---------------------------------------------------------------------
-- persona
-- ---------------------------------------------------------------------
CREATE TABLE persona (
    tipo_dni         VARCHAR(10) NOT NULL,
    nro_dni          VARCHAR(15) NOT NULL,
    nombre           VARCHAR(60) NOT NULL,
    apellido         VARCHAR(60) NOT NULL,
    telefono         VARCHAR(20),
    fecha_nacimiento DATE NOT NULL,
    mail             VARCHAR(100),
    PRIMARY KEY (tipo_dni, nro_dni),
    CONSTRAINT chk_persona_tipo_dni
        CHECK (tipo_dni IN ('DNI', 'LE', 'LC', 'CI', 'PASAPORTE'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- disciplina
-- ---------------------------------------------------------------------
CREATE TABLE disciplina (
    nombre  VARCHAR(50) PRIMARY KEY,
    enfoque VARCHAR(50)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- categoria
-- ---------------------------------------------------------------------
CREATE TABLE categoria (
    nombre_categoria  VARCHAR(50),
    nombre_disciplina VARCHAR(50),
    edad_min          INT,
    edad_max          INT,
    PRIMARY KEY (nombre_categoria, nombre_disciplina),
    FOREIGN KEY (nombre_disciplina)
        REFERENCES disciplina (nombre)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT chk_categoria_edades CHECK (edad_min <= edad_max)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- profesor
-- ---------------------------------------------------------------------
CREATE TABLE profesor (
    tipo_dni      VARCHAR(10) NOT NULL,
    nro_dni       VARCHAR(15) NOT NULL,
    fecha_ingreso DATE,
    PRIMARY KEY (tipo_dni, nro_dni),
    FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES persona (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_profesor_tipo_dni
        CHECK (tipo_dni IN ('DNI', 'LE', 'LC', 'CI', 'PASAPORTE'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- socio
-- ---------------------------------------------------------------------
CREATE TABLE socio (
    tipo_dni               VARCHAR(10) NOT NULL,
    nro_dni                VARCHAR(15) NOT NULL,
    es_federado            BOOLEAN DEFAULT FALSE,
    ddj_salud              BOOLEAN DEFAULT FALSE,
    fecha_inscripcion      DATE,
    ausencias_consecutivas INT DEFAULT 0,
    nombre_disciplina      VARCHAR(50),
    nombre_categoria       VARCHAR(50),
    PRIMARY KEY (tipo_dni, nro_dni),
    FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES persona (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (nombre_categoria, nombre_disciplina)
        REFERENCES categoria (nombre_categoria, nombre_disciplina)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_socio_tipo_dni
        CHECK (tipo_dni IN ('DNI', 'LE', 'LC', 'CI', 'PASAPORTE')),
    CONSTRAINT chk_socio_fecha_inscripcion
        CHECK (fecha_inscripcion >= '2010-01-01')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- usuario
-- ---------------------------------------------------------------------
CREATE TABLE usuario (
    nombre_usuario VARCHAR(50),
    contrasenia    VARCHAR(255) NOT NULL,
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    PRIMARY KEY (nombre_usuario),
    FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES persona (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_usuario_tipo_dni
        CHECK (tipo_dni IN ('DNI', 'LE', 'LC', 'CI', 'PASAPORTE'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- tiene_tutor
-- ---------------------------------------------------------------------
CREATE TABLE tiene_tutor (
    tipo_dni_socio VARCHAR(10) NOT NULL,
    nro_dni_socio  VARCHAR(15) NOT NULL,
    tipo_dni_tutor VARCHAR(10) NOT NULL,
    nro_dni_tutor  VARCHAR(15) NOT NULL,
    parentesco     VARCHAR(30) NOT NULL,
    PRIMARY KEY (tipo_dni_socio, nro_dni_socio),
    FOREIGN KEY (tipo_dni_socio, nro_dni_socio)
        REFERENCES socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (tipo_dni_tutor, nro_dni_tutor)
        REFERENCES persona (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_tutor_tipo_dni_socio
        CHECK (tipo_dni_socio IN ('DNI', 'LE', 'LC', 'CI', 'PASAPORTE')),
    CONSTRAINT chk_tutor_tipo_dni_tutor
        CHECK (tipo_dni_tutor IN ('DNI', 'LE', 'LC', 'CI', 'PASAPORTE'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- estado_socio
-- ---------------------------------------------------------------------
CREATE TABLE estado_socio (
    tipo_dni           VARCHAR(10) NOT NULL,
    nro_dni            VARCHAR(15) NOT NULL,
    fecha_modificacion TIMESTAMP,
    estado             VARCHAR(20) NOT NULL,
    modificado_por     VARCHAR(50),
    PRIMARY KEY (tipo_dni, nro_dni, fecha_modificacion),
    FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT chk_estado_socio_tipo_dni
        CHECK (tipo_dni IN ('DNI', 'LE', 'LC', 'CI', 'PASAPORTE'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- a_cargo
-- ---------------------------------------------------------------------
CREATE TABLE a_cargo (
    nombre_disciplina VARCHAR(50),
    nombre_categoria  VARCHAR(50),
    rol               VARCHAR(30),
    tipo_dni          VARCHAR(10) NOT NULL,
    nro_dni           VARCHAR(15) NOT NULL,
    PRIMARY KEY (nombre_disciplina, nombre_categoria, tipo_dni, nro_dni, rol),
    FOREIGN KEY (nombre_categoria, nombre_disciplina)
        REFERENCES categoria (nombre_categoria, nombre_disciplina)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES profesor (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT chk_a_cargo_tipo_dni
        CHECK (tipo_dni IN ('DNI', 'LE', 'LC', 'CI', 'PASAPORTE'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- planilla_asistencia
-- ---------------------------------------------------------------------
CREATE TABLE planilla_asistencia (
    id_planilla INT AUTO_INCREMENT PRIMARY KEY,
    tipo_dni    VARCHAR(10) NOT NULL,
    nro_dni     VARCHAR(15) NOT NULL,
    FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES profesor (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_planilla_tipo_dni
        CHECK (tipo_dni IN ('DNI', 'LE', 'LC', 'CI', 'PASAPORTE'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- clase
-- ---------------------------------------------------------------------
CREATE TABLE clase (
    nombre_disciplina VARCHAR(50),
    nombre_categoria  VARCHAR(50),
    fecha             DATE,
    hora_inicio       TIME,
    hora_fin          TIME,
    tipo_dni          VARCHAR(10) NOT NULL,
    nro_dni           VARCHAR(15) NOT NULL,
    id_planilla       INT NOT NULL,
    rol               VARCHAR(30),
    PRIMARY KEY (
        nombre_disciplina, nombre_categoria, fecha, hora_inicio, hora_fin
    ),
    FOREIGN KEY (nombre_categoria, nombre_disciplina)
        REFERENCES categoria (nombre_categoria, nombre_disciplina)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES profesor (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (id_planilla)
        REFERENCES planilla_asistencia (id_planilla)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    UNIQUE (id_planilla),
    CONSTRAINT chk_clase_tipo_dni
        CHECK (tipo_dni IN ('DNI', 'LE', 'LC', 'CI', 'PASAPORTE'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- detalle_asistencia
-- ---------------------------------------------------------------------
CREATE TABLE detalle_asistencia (
    id_planilla       INT,
    tipo_dni_socio    VARCHAR(10) NOT NULL,
    nro_dni_socio     VARCHAR(15) NOT NULL,
    estado_asistencia VARCHAR(20),
    PRIMARY KEY (id_planilla, tipo_dni_socio, nro_dni_socio),
    FOREIGN KEY (id_planilla)
        REFERENCES planilla_asistencia (id_planilla)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (tipo_dni_socio, nro_dni_socio)
        REFERENCES socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_detalle_asist_tipo_dni
        CHECK (tipo_dni_socio IN ('DNI', 'LE', 'LC', 'CI', 'PASAPORTE'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- medico
-- ---------------------------------------------------------------------
CREATE TABLE medico (
    matricula VARCHAR(20) PRIMARY KEY,
    nombre    VARCHAR(60),
    apellido  VARCHAR(60),
    telefono  VARCHAR(20)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- certificado_medico
-- ---------------------------------------------------------------------
CREATE TABLE certificado_medico (
    tipo_dni          VARCHAR(10) NOT NULL,
    nro_dni           VARCHAR(15) NOT NULL,
    fecha_emision     DATE,
    fecha_vencimiento DATE NOT NULL,
    matricula         VARCHAR(20) NOT NULL,
    PRIMARY KEY (tipo_dni, nro_dni, fecha_emision),
    FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (matricula)
        REFERENCES medico (matricula)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_certificado_tipo_dni
        CHECK (tipo_dni IN ('DNI', 'LE', 'LC', 'CI', 'PASAPORTE')),
    CONSTRAINT chk_certificado_fechas
        CHECK (fecha_emision < fecha_vencimiento)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- seguro
-- ---------------------------------------------------------------------
CREATE TABLE seguro (
    num_poliza        VARCHAR(30) PRIMARY KEY,
    tipo_dni_socio     VARCHAR(10) NOT NULL,
    nro_dni_socio      VARCHAR(15) NOT NULL,
    fecha_alta         DATE,
    fecha_vencimiento  DATE,
    fecha_baja         DATE,
    tipo               VARCHAR(30),
    FOREIGN KEY (tipo_dni_socio, nro_dni_socio)
        REFERENCES socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT chk_seguro_tipo_dni
        CHECK (tipo_dni_socio IN ('DNI', 'LE', 'LC', 'CI', 'PASAPORTE'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- cuota
-- ---------------------------------------------------------------------
CREATE TABLE cuota (
    id_cuota       INT AUTO_INCREMENT PRIMARY KEY,
    fecha          DATE NOT NULL,
    monto          NUMERIC(10,2) NOT NULL,
    estado_de_pago VARCHAR(20),
    periodo        VARCHAR(20),
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_cuota_tipo_dni
        CHECK (tipo_dni IN ('DNI', 'LE', 'LC', 'CI', 'PASAPORTE')),
    CONSTRAINT chk_cuota_monto
        CHECK (monto >= 1 AND monto <= 99999999.99)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- pago
-- ---------------------------------------------------------------------
CREATE TABLE pago (
    id_pago    INT AUTO_INCREMENT PRIMARY KEY,
    fecha_pago DATE NOT NULL,
    monto      NUMERIC(10,2) NOT NULL,
    id_cuota   INT NOT NULL,
    FOREIGN KEY (id_cuota)
        REFERENCES cuota (id_cuota)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_pago_monto
        CHECK (monto >= 1 AND monto <= 99999999.99)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- cargo_administrativo
-- ---------------------------------------------------------------------
CREATE TABLE cargo_administrativo (
    id_cargo    INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- tiene_cargo
-- ---------------------------------------------------------------------
CREATE TABLE tiene_cargo (
    tipo_dni           VARCHAR(10) NOT NULL,
    nro_dni            VARCHAR(15) NOT NULL,
    id_cargo           INT,
    fecha_inicio_cargo DATE,
    fecha_fin_cargo    DATE,
    PRIMARY KEY (tipo_dni, nro_dni, id_cargo, fecha_inicio_cargo, fecha_fin_cargo),
    FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_cargo)
        REFERENCES cargo_administrativo (id_cargo)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_tiene_cargo_tipo_dni
        CHECK (tipo_dni IN ('DNI', 'LE', 'LC', 'CI', 'PASAPORTE'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- notificacion
-- ---------------------------------------------------------------------
CREATE TABLE notificacion (
    id_notificacion INT AUTO_INCREMENT PRIMARY KEY,
    tipo            VARCHAR(30),
    mensaje         TEXT,
    fecha           TIMESTAMP,
    nombre_usuario  VARCHAR(50) NOT NULL,
    FOREIGN KEY (nombre_usuario)
        REFERENCES usuario (nombre_usuario)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- rol
-- ---------------------------------------------------------------------
CREATE TABLE rol (
    nombre_rol VARCHAR(30) PRIMARY KEY,
    permisos   VARCHAR(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- tiene_rol
-- ---------------------------------------------------------------------
CREATE TABLE tiene_rol (
    nombre_rol     VARCHAR(30),
    nombre_usuario VARCHAR(50),
    fecha          DATE NOT NULL,
    PRIMARY KEY (nombre_rol, nombre_usuario, fecha),
    FOREIGN KEY (nombre_rol)
        REFERENCES rol (nombre_rol)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (nombre_usuario)
        REFERENCES usuario (nombre_usuario)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;