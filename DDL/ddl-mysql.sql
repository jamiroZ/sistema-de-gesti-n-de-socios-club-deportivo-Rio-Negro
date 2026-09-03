-- =============================================================================
-- Club Deportivo Rio Negro - DDL MySQL - Grupo 4
-- =============================================================================

CREATE DATABASE IF NOT EXISTS esq_grupo4;
USE esq_grupo4;

-- -----------------------------------------------------------------------------
-- Personas y especializacion
-- -----------------------------------------------------------------------------

CREATE TABLE persona (
    tipo_dni         ENUM('DNI','LE','LC','CI','PASAPORTE'),
    nro_dni          VARCHAR(15),
    nombre           VARCHAR(60) NOT NULL,
    apellido         VARCHAR(60) NOT NULL,
    telefono         VARCHAR(20),
    fecha_nacimiento DATE NOT NULL,
    mail             VARCHAR(100) NOT NULL,
    PRIMARY KEY (tipo_dni, nro_dni)
);

CREATE TABLE profesor (
    tipo_dni      ENUM('DNI','LE','LC','CI','PASAPORTE'),
    nro_dni       VARCHAR(15),
    fecha_ingreso DATE NOT NULL,
    PRIMARY KEY (tipo_dni, nro_dni),
    FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES persona (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CHECK (fecha_ingreso >= '2015-05-07')
);

CREATE TABLE socio (
    tipo_dni               ENUM('DNI','LE','LC','CI','PASAPORTE'),
    nro_dni                VARCHAR(15),
    es_federado            BOOLEAN NOT NULL DEFAULT FALSE,
    ddj_salud              BOOLEAN NOT NULL DEFAULT FALSE,
    fecha_inscripcion_club DATE NOT NULL,
    ausencias_consecutivas SMALLINT NOT NULL DEFAULT 0,
    PRIMARY KEY (tipo_dni, nro_dni),
    FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES persona (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CHECK (fecha_inscripcion_club >= '2015-05-07'),
    CHECK (ausencias_consecutivas >= 0)
);

CREATE TABLE usuario (
    nombre_usuario VARCHAR(50),
    contrasenia    VARCHAR(255) NOT NULL,
    tipo_dni       ENUM('DNI','LE','LC','CI','PASAPORTE') NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    PRIMARY KEY (nombre_usuario),
    UNIQUE (tipo_dni, nro_dni),
    FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES persona (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE rol (
    nombre_rol VARCHAR(30) PRIMARY KEY,
    permisos   VARCHAR(100) NOT NULL
);

CREATE TABLE tiene_rol (
    nombre_rol       VARCHAR(30),
    nombre_usuario   VARCHAR(50),
    fecha_inicio_rol DATE,
    fecha_fin_rol    DATE,
    PRIMARY KEY (nombre_rol, nombre_usuario, fecha_inicio_rol, fecha_fin_rol),
    FOREIGN KEY (nombre_rol)
        REFERENCES rol (nombre_rol)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (nombre_usuario)
        REFERENCES usuario (nombre_usuario)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CHECK (fecha_inicio_rol >= '2015-05-07'),
    CHECK (fecha_fin_rol >= '2015-05-07'),
    CHECK (fecha_fin_rol >= fecha_inicio_rol)
);

CREATE TABLE notificacion (
    id_notificacion INT AUTO_INCREMENT PRIMARY KEY,
    tipo            VARCHAR(30) NOT NULL,
    mensaje         TEXT NOT NULL,
    fecha           DATETIME NOT NULL,
    nombre_usuario  VARCHAR(50) NOT NULL,
    FOREIGN KEY (nombre_usuario)
        REFERENCES usuario (nombre_usuario)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE tiene_tutor (
    tipo_dni_socio ENUM('DNI','LE','LC','CI','PASAPORTE'),
    nro_dni_socio  VARCHAR(15),
    parentesco     VARCHAR(30),
    tipo_dni_tutor ENUM('DNI','LE','LC','CI','PASAPORTE') NOT NULL,
    nro_dni_tutor  VARCHAR(15) NOT NULL,
    PRIMARY KEY (tipo_dni_socio, nro_dni_socio, parentesco),
    FOREIGN KEY (tipo_dni_socio, nro_dni_socio)
        REFERENCES socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (tipo_dni_tutor, nro_dni_tutor)
        REFERENCES persona (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE estado_socio (
    tipo_dni           ENUM('DNI','LE','LC','CI','PASAPORTE'),
    nro_dni            VARCHAR(15),
    fecha_modificacion DATETIME,
    estado             ENUM('Socio potencial','Pendiente de alta','Activo','Becado','No activo') NOT NULL,
    modificado_por     VARCHAR(50) NOT NULL,
    PRIMARY KEY (tipo_dni, nro_dni, fecha_modificacion),
    FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (modificado_por)
        REFERENCES usuario (nombre_usuario)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- -----------------------------------------------------------------------------
-- Actividades
-- -----------------------------------------------------------------------------

CREATE TABLE disciplina (
    nombre_disciplina VARCHAR(50) PRIMARY KEY
);

CREATE TABLE categoria (
    nombre_categoria  VARCHAR(50),
    nombre_disciplina VARCHAR(50),
    edad_min          SMALLINT NOT NULL,
    edad_max          SMALLINT NOT NULL,
    enfoque           ENUM('Recreativo','Competitivo') NOT NULL,
    PRIMARY KEY (nombre_categoria, nombre_disciplina),
    FOREIGN KEY (nombre_disciplina)
        REFERENCES disciplina (nombre_disciplina)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CHECK (edad_min <= edad_max),
    CHECK (edad_min >= 0)
);

CREATE TABLE pertenece (
    tipo_dni          ENUM('DNI','LE','LC','CI','PASAPORTE'),
    nro_dni           VARCHAR(15),
    nombre_disciplina VARCHAR(50),
    fecha_inscripcion DATE NOT NULL,
    PRIMARY KEY (tipo_dni, nro_dni, nombre_disciplina),
    FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (nombre_disciplina)
        REFERENCES disciplina (nombre_disciplina)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CHECK (fecha_inscripcion >= '2015-05-07')
);

CREATE TABLE a_cargo (
    nombre_disciplina VARCHAR(50),
    nombre_categoria  VARCHAR(50),
    rol_profesor      ENUM('Director Tecnico','Preparador Fisico'),
    tipo_dni          ENUM('DNI','LE','LC','CI','PASAPORTE') NOT NULL,
    nro_dni           VARCHAR(15) NOT NULL,
    PRIMARY KEY (nombre_disciplina, nombre_categoria, rol_profesor),
    FOREIGN KEY (nombre_categoria, nombre_disciplina)
        REFERENCES categoria (nombre_categoria, nombre_disciplina)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES profesor (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE planilla_asistencia (
    id_planilla INT AUTO_INCREMENT PRIMARY KEY,
    tipo_dni    ENUM('DNI','LE','LC','CI','PASAPORTE') NOT NULL,
    nro_dni     VARCHAR(15) NOT NULL,
    FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES profesor (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE clase (
    nombre_disciplina VARCHAR(50),
    nombre_categoria  VARCHAR(50),
    fecha             DATE,
    hora_inicio       TIME,
    hora_fin          TIME,
    id_planilla       INT NOT NULL,
    PRIMARY KEY (nombre_disciplina, nombre_categoria, fecha, hora_inicio, hora_fin),
    UNIQUE (id_planilla),
    FOREIGN KEY (nombre_categoria, nombre_disciplina)
        REFERENCES categoria (nombre_categoria, nombre_disciplina)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (id_planilla)
        REFERENCES planilla_asistencia (id_planilla)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CHECK (fecha >= '2015-05-07'),
    CHECK (hora_inicio < hora_fin)
);

CREATE TABLE detalle_asistencia (
    id_planilla       INT,
    tipo_dni_socio    ENUM('DNI','LE','LC','CI','PASAPORTE'),
    nro_dni_socio     VARCHAR(15),
    estado_asistencia ENUM('Presente','Ausente','Ausente justificado') NOT NULL,
    PRIMARY KEY (id_planilla, tipo_dni_socio, nro_dni_socio),
    FOREIGN KEY (id_planilla)
        REFERENCES planilla_asistencia (id_planilla)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (tipo_dni_socio, nro_dni_socio)
        REFERENCES socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- -----------------------------------------------------------------------------
-- Salud y seguro
-- -----------------------------------------------------------------------------

CREATE TABLE medico (
    matricula VARCHAR(20) PRIMARY KEY,
    nombre    VARCHAR(60) NOT NULL,
    apellido  VARCHAR(60) NOT NULL,
    telefono  VARCHAR(20) NOT NULL
);

CREATE TABLE certificado_medico (
    tipo_dni          ENUM('DNI','LE','LC','CI','PASAPORTE'),
    nro_dni           VARCHAR(15),
    fecha_emision     DATE,
    fecha_vencimiento DATE NOT NULL,
    es_apto           BOOLEAN NOT NULL,
    matricula         VARCHAR(20) NOT NULL,
    PRIMARY KEY (tipo_dni, nro_dni, fecha_emision),
    FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (matricula)
        REFERENCES medico (matricula)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CHECK (fecha_emision >= '2015-05-07'),
    CHECK (fecha_vencimiento >= '2015-05-07'),
    CHECK (fecha_vencimiento >= fecha_emision)
);

CREATE TABLE seguro (
    nro_poliza        VARCHAR(30) PRIMARY KEY,
    tipo_dni_socio    ENUM('DNI','LE','LC','CI','PASAPORTE') NOT NULL,
    nro_dni_socio     VARCHAR(15) NOT NULL,
    fecha_alta        DATE NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    fecha_baja        DATE,
    tipo              VARCHAR(30) NOT NULL,
    FOREIGN KEY (tipo_dni_socio, nro_dni_socio)
        REFERENCES socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CHECK (fecha_alta >= '2015-05-07'),
    CHECK (fecha_vencimiento >= fecha_alta),
    CHECK (fecha_baja IS NULL OR fecha_baja >= fecha_alta)
);

-- -----------------------------------------------------------------------------
-- Finanzas
-- -----------------------------------------------------------------------------

CREATE TABLE cuota (
    id_cuota       INT AUTO_INCREMENT PRIMARY KEY,
    fecha          DATE NOT NULL,
    monto          DECIMAL(10,2) NOT NULL,
    estado_de_pago ENUM('Saldada','No saldada') NOT NULL,
    periodo        VARCHAR(20) NOT NULL,
    tipo_dni       ENUM('DNI','LE','LC','CI','PASAPORTE') NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CHECK (fecha >= '2015-05-07'),
    CHECK (monto >= 0 AND monto <= 99999999.99)
);

CREATE TABLE pago (
    id_pago    INT AUTO_INCREMENT PRIMARY KEY,
    fecha_pago DATE NOT NULL,
    monto      DECIMAL(10,2) NOT NULL,
    id_cuota   INT NOT NULL,
    UNIQUE (id_cuota),
    FOREIGN KEY (id_cuota)
        REFERENCES cuota (id_cuota)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CHECK (fecha_pago >= '2015-05-07'),
    CHECK (monto >= 0 AND monto <= 99999999.99)
);

-- -----------------------------------------------------------------------------
-- Cargos
-- -----------------------------------------------------------------------------

CREATE TABLE cargo_administrativo (
    id_cargo    INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(100) NOT NULL
);

CREATE TABLE tiene_cargo (
    tipo_dni           ENUM('DNI','LE','LC','CI','PASAPORTE'),
    nro_dni            VARCHAR(15),
    id_cargo           INT,
    fecha_inicio_cargo DATE NOT NULL,
    fecha_fin_cargo    DATE NOT NULL,
    PRIMARY KEY (tipo_dni, nro_dni, id_cargo, fecha_inicio_cargo, fecha_fin_cargo),
    FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_cargo)
        REFERENCES cargo_administrativo (id_cargo)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CHECK (fecha_inicio_cargo >= '2015-05-07'),
    CHECK (fecha_fin_cargo >= fecha_inicio_cargo)
);
