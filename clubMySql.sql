-- =========================================================
-- MODELO RELACIONAL - Club (Sistema de gestion de socios)
-- SGBD: MySQL
--
-- NOTA DE DISENO:
-- La entidad persona tiene clave primaria compuesta
-- (tipo_dni, nro_dni). Para simplificar las referencias desde
-- profesor, socio, tutor y usuario (que solo guardan un DNI),
-- se agrego una restriccion UNIQUE sobre nro_dni y esas tablas
-- referencian unicamente ese atributo (misma decision que en
-- la version PostgreSQL, para mantener ambos modelos equivalentes).
-- =========================================================

CREATE DATABASE IF NOT EXISTS club_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_spanish_ci;

USE club_db;

-- ---------------------------------------------------------
-- persona
-- ---------------------------------------------------------
CREATE TABLE persona (
    tipo_dni        VARCHAR(10)  NOT NULL,
    nro_dni         VARCHAR(15)  NOT NULL,
    nombre          VARCHAR(60)  NOT NULL,
    apellido        VARCHAR(60)  NOT NULL,
    telefono        VARCHAR(20),
    fechaNacimiento DATE,
    mail            VARCHAR(100),
    PRIMARY KEY (tipo_dni, nro_dni),
    UNIQUE KEY uq_persona_nrodni (nro_dni)
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- disciplina
-- ---------------------------------------------------------
CREATE TABLE disciplina (
    nombre  VARCHAR(50) NOT NULL,
    PRIMARY KEY (nombre)
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- categoria
-- ---------------------------------------------------------
CREATE TABLE categoria (
    nombreCategoria  VARCHAR(50) NOT NULL,
    nombreDisciplina VARCHAR(50) NOT NULL,
    edadMin          INT,
    edadMax          INT,
    enfoque VARCHAR(50),
    PRIMARY KEY (nombreCategoria, nombreDisciplina),
    CONSTRAINT fk_categoria_disciplina FOREIGN KEY (nombreDisciplina)
        REFERENCES disciplina (nombre)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- profesor
-- ---------------------------------------------------------
CREATE TABLE profesor (
    tipo_dni  VARCHAR(10)  NOT NULL,
    nro_dni   VARCHAR(15)  NOT NULL,
    fechaIngreso DATE,
    CONSTRAINT pk_profesor PRIMARY KEY (tipo_dni, nro_dni),
    CONSTRAINT fk_profesor_persona FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES esquema_grupo4.persona (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- tutor
-- ---------------------------------------------------------
CREATE TABLE tieneTutor (
    tipo_dni_socio   VARCHAR(10) NOT NULL,
    nro_dni_socio    VARCHAR(15) NOT NULL,

    tipo_dni_tutor   VARCHAR(10) NOT NULL,
    nro_dni_tutor    VARCHAR(15) NOT NULL,

    parentesco       VARCHAR(30),

    CONSTRAINT pk_tieneTutor
        PRIMARY KEY (
            tipo_dni_socio,
            nro_dni_socio,
            tipo_dni_tutor,
            nro_dni_tutor
        ),

    CONSTRAINT fk_tieneTutor_socio
        FOREIGN KEY (tipo_dni_socio, nro_dni_socio)
        REFERENCES esquema_grupo4.socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_tieneTutor_tutor
        FOREIGN KEY (tipo_dni_tutor, nro_dni_tutor)
        REFERENCES esquema_grupo4.persona (tipo_dni, nro_dni)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- socio
-- ---------------------------------------------------------
CREATE TABLE socio (
    tipo_dni  VARCHAR(10)  NOT NULL,
    nro_dni   VARCHAR(15)  NOT NULL,
    esFederado            BOOLEAN DEFAULT FALSE,
    ddjSalud              BOOLEAN DEFAULT FALSE,
    fechaInscripcion      DATE,
    ausenciasConsecutivas INT DEFAULT 0,
    nombreDisciplina      VARCHAR(50),
    nombreCategoria       VARCHAR(50),
    PRIMARY KEY (tipo_dni, nro_dni),
    CONSTRAINT fk_socio_persona FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES persona (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_socio_categoria FOREIGN KEY (nombreCategoria, nombreDisciplina)
        REFERENCES categoria (nombreCategoria, nombreDisciplina)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- usuario
-- ---------------------------------------------------------
CREATE TABLE usuario (
    nombreUsuario VARCHAR(50)  NOT NULL,
    contrasenia   VARCHAR(255) NOT NULL,
    tipo_dni  VARCHAR(10)  NOT NULL,
    nro_dni   VARCHAR(15)  NOT NULL,
    PRIMARY KEY (nombreUsuario),
    CONSTRAINT fk_usuario_persona FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES persona (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- tieneTutor
-- ---------------------------------------------------------
CREATE TABLE tieneTutor (
    tipo_dni  VARCHAR(10)  NOT NULL,
    nro_dni   VARCHAR(15)  NOT NULL,
    tipo_dni_tutor  VARCHAR(10)  NOT NULL,
    nro_dni_tutor   VARCHAR(15)  NOT NULL,
    CONSTRAINT pk_tieneTutor PRIMARY KEY (tipo_dni, nro_dni, tipo_dni_tutor, nro_dni_tutor),
    CONSTRAINT fk_tieneTutor_socio FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_tieneTutor_tutor FOREIGN KEY (tipo_dni_tutor, nro_dni_tutor)
        REFERENCES tutor (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- estadoSocio
-- ---------------------------------------------------------
CREATE TABLE estadoSocio (
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    fechaModificacion DATETIME    NOT NULL,
    estado            VARCHAR(20) NOT NULL,
    modificadoPor     VARCHAR(50),
    PRIMARY KEY (tipo_dni, nro_dni, fechaModificacion),
    CONSTRAINT fk_estadoSocio_socio FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_estadoSocio_usuario FOREIGN KEY (modificadoPor)
        REFERENCES usuario (nombreUsuario)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- aCargo
-- ---------------------------------------------------------
CREATE TABLE aCargo (
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    nombreDisciplina VARCHAR(50) NOT NULL,
    nombreCategoria  VARCHAR(50) NOT NULL,
    rol              VARCHAR(30) NOT NULL,
    PRIMARY KEY (nombreDisciplina, nombreCategoria, tipo_dni, nro_dni, rol),
    CONSTRAINT fk_aCargo_categoria FOREIGN KEY (nombreCategoria, nombreDisciplina)
        REFERENCES categoria (nombreCategoria, nombreDisciplina)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_aCargo_profesor FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES profesor (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- planillaAsistencia
-- ---------------------------------------------------------
CREATE TABLE planillaAsistencia (
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    idPlanilla  INT AUTO_INCREMENT,
    PRIMARY KEY (idPlanilla),
    CONSTRAINT fk_planilla_profesor FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES profesor (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- clase
-- ---------------------------------------------------------
CREATE TABLE clase (
    nombreDisciplina VARCHAR(50) NOT NULL,
    nombreCategoria  VARCHAR(50) NOT NULL,
    fecha            DATE        NOT NULL,
    horaInicio       TIME        NOT NULL,
    horaFin          TIME,
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    idPlanilla       INT NOT NULL,
    PRIMARY KEY (nombreDisciplina, nombreCategoria, fecha, horaInicio),
    CONSTRAINT fk_clase_categoria FOREIGN KEY (nombreCategoria, nombreDisciplina)
        REFERENCES categoria (nombreCategoria, nombreDisciplina)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_clase_profesor FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES profesor (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_clase_planilla FOREIGN KEY (idPlanilla)
        REFERENCES planillaAsistencia (idPlanilla)
        ON UPDATE CASCADE ON DELETE SET NULL,
    UNIQUE KEY uq_clase_planilla (idPlanilla)
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- detalleAsistencia
-- ---------------------------------------------------------
CREATE TABLE detalleAsistencia (
    idPlanilla       INT         NOT NULL,
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    estadoAsistencia VARCHAR(20),
    PRIMARY KEY (idPlanilla, tipo_dni, nro_dni),
    CONSTRAINT fk_detalle_planilla FOREIGN KEY (idPlanilla)
        REFERENCES planillaAsistencia (idPlanilla)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_detalle_socio FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- medico
-- ---------------------------------------------------------
CREATE TABLE medico (
    matricula VARCHAR(20) NOT NULL,
    nombre    VARCHAR(60),
    apellido  VARCHAR(60),
    telefono  VARCHAR(20),
    PRIMARY KEY (matricula)
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- certificadoMedico
-- ---------------------------------------------------------
CREATE TABLE certificadoMedico (
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    fechaEmision     DATE        NOT NULL,
    fechaVencimiento DATE,
    matricula        VARCHAR(20) NOT NULL,
    PRIMARY KEY (tipo_dni, nro_dni, fechaEmision),
    CONSTRAINT fk_certificado_socio FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES socio (dniSocio)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_certificado_medico FOREIGN KEY (matricula)
        REFERENCES medico (matricula)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- seguro
-- ---------------------------------------------------------
CREATE TABLE seguro (
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    numPoliza        VARCHAR(30) NOT NULL,
    fechaAlta        DATE,
    fechaVencimiento DATE,
    fechaBaja        DATE,
    tipo             VARCHAR(30),
    PRIMARY KEY (tipo_dni, nro_dni, numPoliza),
    CONSTRAINT fk_seguro_socio FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- cuota
-- ---------------------------------------------------------
CREATE TABLE cuota (
    idCuota      INT AUTO_INCREMENT,
    fecha        DATE NOT NULL,
    monto        DECIMAL(10,2) NOT NULL,
    estadoDePago VARCHAR(20),
    periodo      VARCHAR(20),
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    PRIMARY KEY (idCuota),
    CONSTRAINT fk_cuota_socio FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- pago
-- ---------------------------------------------------------
CREATE TABLE pago (
    idPago    INT AUTO_INCREMENT,
    fechaPago DATE NOT NULL,
    monto     DECIMAL(10,2) NOT NULL,--valor aceptado hasta xxxxxxxx.xx
    idCuota   INT NOT NULL,
    PRIMARY KEY (idPago),
    CONSTRAINT fk_pago_cuota FOREIGN KEY (idCuota)
        REFERENCES cuota (idCuota)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- cargoAdministrativo
-- ---------------------------------------------------------
CREATE TABLE cargoAdministrativo (
    idCargo     INT AUTO_INCREMENT,
    descripcion VARCHAR(100),
    PRIMARY KEY (idCargo)
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- tieneCargo
-- ---------------------------------------------------------
CREATE TABLE tieneCargo (
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    idCargo          INT         NOT NULL,
    fechaInicioCargo DATE        NOT NULL,
    fechaFinCargo    DATE,
    PRIMARY KEY (tipo_dni, nro_dni, idCargo, fechaInicioCargo),
    CONSTRAINT fk_tieneCargo_socio FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_tieneCargo_cargo FOREIGN KEY (idCargo)
        REFERENCES cargoAdministrativo (idCargo)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- historialFinanciero
-- ---------------------------------------------------------
CREATE TABLE historialFinanciero (
    idHistorial     INT AUTO_INCREMENT,--incrementa solo por nuevo historial
    fechaGeneracion DATETIME,
    tipoPeriodo     VARCHAR(20),
    periodo         VARCHAR(20),
    montoAdeudado   DECIMAL(10,2),
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    PRIMARY KEY (idHistorial),
    CONSTRAINT fk_historialFin_socio FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- historialAusenciasProlongadas
-- ---------------------------------------------------------
CREATE TABLE historialAusenciasProlongadas (
    idHistorial     INT AUTO_INCREMENT,--incrementa solo por nuevo historial
    fechaGeneracion DATETIME,
    tipoPeriodo     VARCHAR(20),
    umbralAusencias INT,
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    PRIMARY KEY (idHistorial),
    CONSTRAINT fk_historialAus_socio FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- notificacion
-- ---------------------------------------------------------
CREATE TABLE notificacion (
    idNotificacion INT AUTO_INCREMENT,
    tipo           VARCHAR(30),
    mensaje        TEXT,
    fecha          DATETIME,
    nombreUsuario  VARCHAR(50) NOT NULL,
    PRIMARY KEY (idNotificacion),
    CONSTRAINT fk_notificacion_usuario FOREIGN KEY (nombreUsuario)
        REFERENCES usuario (nombreUsuario)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE rol(
    nombre_rol VARCHAR(30) NOT NULL,
    permisos VARCHAR(100) NOT NULL,
    CONSTRAINT pk_rol
        PRIMARY KEY (nombre_rol)
)ENGINE=InnoDB;

CREATE TABLE tiene_rol (
    nombre_rol     VARCHAR(50) NOT NULL,
    nombre_usuario VARCHAR(50) NOT NULL,
    fecha          DATETIME,

    CONSTRAINT pk_tiene_rol
        PRIMARY KEY (nombre_rol, nombre_usuario),

    CONSTRAINT fk_tiene_rol_rol
        FOREIGN KEY (nombre_rol)
        REFERENCES rol (nombre_rol)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_tiene_rol_usuario
        FOREIGN KEY (nombre_usuario)
        REFERENCES usuario (nombre_usuario)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
)ENGINE=InnoDB;