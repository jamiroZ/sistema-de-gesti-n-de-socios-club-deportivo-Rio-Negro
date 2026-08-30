-- Correr primero las dos lineas de abajo, despues pararse en la base
-- esq_grupo4 y recien ahi correr el resto, porque phpMyAdmin

DROP DATABASE IF EXISTS esq_grupo4;
CREATE DATABASE esq_grupo4;

CREATE TABLE persona (
    tipo_dni         ENUM('DNI','LE','LC','CI','PASAPORTE'),
    nro_dni          VARCHAR(15),
    nombre           VARCHAR(60) NOT NULL,
    apellido         VARCHAR(60) NOT NULL,
    telefono         VARCHAR(20),
    fecha_nacimiento DATE NOT NULL,
    mail             VARCHAR(100),
    PRIMARY KEY (tipo_dni, nro_dni)
);

CREATE TABLE profesor (
    tipo_dni      ENUM('DNI','LE','LC','CI','PASAPORTE'),
    nro_dni       VARCHAR(15),
    fecha_ingreso DATE CHECK (fecha_ingreso >= '2015-05-07'),
    PRIMARY KEY (tipo_dni, nro_dni),
    FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES persona (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE socio (
    tipo_dni               ENUM('DNI','LE','LC','CI','PASAPORTE'),
    nro_dni                VARCHAR(15),
    es_federado            BOOLEAN DEFAULT FALSE,
    ddj_salud              BOOLEAN DEFAULT FALSE,
    fecha_inscripcion_club DATE CHECK (fecha_inscripcion_club >= '2015-05-07'),
    ausencias_consecutivas INT DEFAULT 0,
    PRIMARY KEY (tipo_dni, nro_dni),
    FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES persona (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT
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
    nombre_rol     VARCHAR(30),
    nombre_usuario VARCHAR(50),
    fecha DATE CHECK (fecha >= '2015-05-07'),
    PRIMARY KEY (nombre_rol, nombre_usuario, fecha),
    FOREIGN KEY (nombre_rol)
        REFERENCES rol (nombre_rol)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (nombre_usuario)
        REFERENCES usuario (nombre_usuario)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE notificacion (
    id_notificacion INT AUTO_INCREMENT PRIMARY KEY,
    tipo            VARCHAR(30),
    mensaje         TEXT,
    fecha DATE CHECK (fecha >= '2015-05-07'),
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
    estado             VARCHAR(20) NOT NULL,
    modificado_por     VARCHAR(50),
    PRIMARY KEY (tipo_dni, nro_dni, fecha_modificacion),
    FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE disciplina (
    nombre_disciplina VARCHAR(50) PRIMARY KEY
);

CREATE TABLE categoria (
    nombre_categoria  VARCHAR(50),
    nombre_disciplina VARCHAR(50),
    edad_min          INT,
    edad_max          INT,
    enfoque           VARCHAR(50),
    PRIMARY KEY (nombre_categoria, nombre_disciplina),
    FOREIGN KEY (nombre_disciplina)
        REFERENCES disciplina (nombre_disciplina)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CHECK (edad_min <= edad_max)
);

CREATE TABLE pertenece (
    tipo_dni          ENUM('DNI','LE','LC','CI','PASAPORTE'),
    nro_dni           VARCHAR(15),
    nombre_disciplina VARCHAR(50),
    fecha_inscripcion DATE CHECK (fecha_inscripcion >= '2015-05-07'),
    PRIMARY KEY (tipo_dni, nro_dni, nombre_disciplina),
    FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (nombre_disciplina)
        REFERENCES disciplina (nombre_disciplina)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE a_cargo (
    nombre_disciplina VARCHAR(50),
    nombre_categoria  VARCHAR(50),
    rol_profesor      VARCHAR(30),
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
    fecha DATE CHECK (fecha >= '2015-05-07'),
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
    CHECK (hora_inicio < hora_fin)
);

CREATE TABLE detalle_asistencia (
    id_planilla       INT,
    tipo_dni_socio    ENUM('DNI','LE','LC','CI','PASAPORTE'),
    nro_dni_socio     VARCHAR(15),
    estado_asistencia VARCHAR(20),
    PRIMARY KEY (id_planilla, tipo_dni_socio, nro_dni_socio),
    FOREIGN KEY (id_planilla)
        REFERENCES planilla_asistencia (id_planilla)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (tipo_dni_socio, nro_dni_socio)
        REFERENCES socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE medico (
    matricula VARCHAR(20) PRIMARY KEY,
    nombre    VARCHAR(60),
    apellido  VARCHAR(60),
    telefono  VARCHAR(20)
);

CREATE TABLE certificado_medico (
    tipo_dni          ENUM('DNI','LE','LC','CI','PASAPORTE'),
    nro_dni           VARCHAR(15),
    fecha_emision DATE CHECK (fecha_emision >= '2015-05-07'),
    fecha_vencimiento DATE NOT NULL CHECK (fecha_vencimiento >= '2015-05-07'),
    es_apto           BOOLEAN NOT NULL,
    matricula         VARCHAR(20) NOT NULL,
    PRIMARY KEY (tipo_dni, nro_dni, fecha_emision),
    FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (matricula)
        REFERENCES medico (matricula)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CHECK (fecha_emision < fecha_vencimiento)
);

CREATE TABLE seguro (
    nro_poliza        VARCHAR(30) PRIMARY KEY,
    tipo_dni_socio    ENUM('DNI','LE','LC','CI','PASAPORTE') NOT NULL,
    nro_dni_socio     VARCHAR(15) NOT NULL,
    fecha_alta DATE NOT NULL CHECK (fecha_alta >= '2015-05-07'),
    fecha_vencimiento DATE CHECK (fecha_vencimiento >= '2015-05-07'),
    fecha_baja DATE CHECK (fecha_baja >= '2015-05-07'),
    tipo              VARCHAR(30),
    FOREIGN KEY (tipo_dni_socio, nro_dni_socio)
        REFERENCES socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CHECK (fecha_vencimiento IS NULL OR fecha_vencimiento >= fecha_alta),
    CHECK (fecha_baja IS NULL OR fecha_baja >= fecha_alta)
);

CREATE TABLE cuota (
    id_cuota       INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE NOT NULL CHECK (fecha >= '2015-05-07'),
    monto DECIMAL(10,2) NOT NULL CHECK (monto >= 1 AND monto <= 99999999.99),
    estado_de_pago VARCHAR(20),
    periodo        VARCHAR(20),
    tipo_dni       ENUM('DNI','LE','LC','CI','PASAPORTE') NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE pago (
    id_pago    INT AUTO_INCREMENT PRIMARY KEY,
    fecha_pago DATE NOT NULL CHECK (fecha_pago >= '2015-05-07'),
    monto DECIMAL(10,2) NOT NULL CHECK (monto >= 1 AND monto <= 99999999.99),
    id_cuota   INT NOT NULL,
    UNIQUE (id_cuota),
    FOREIGN KEY (id_cuota)
        REFERENCES cuota (id_cuota)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE cargo_administrativo (
    id_cargo    INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(100)
);

CREATE TABLE tiene_cargo (
    tipo_dni           ENUM('DNI','LE','LC','CI','PASAPORTE'),
    nro_dni            VARCHAR(15),
    id_cargo           INT,
    fecha_inicio_cargo DATE NOT NULL CHECK (fecha_inicio_cargo >= '2015-05-07'),
    fecha_fin_cargo DATE CHECK (fecha_fin_cargo >= '2015-05-07'),
    PRIMARY KEY (tipo_dni, nro_dni, id_cargo),
    FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_cargo)
        REFERENCES cargo_administrativo (id_cargo)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CHECK (fecha_fin_cargo IS NULL OR fecha_fin_cargo >= fecha_inicio_cargo)
);