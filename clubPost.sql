-- =========================================================
-- MODELO RELACIONAL - Club (Sistema de gestion de socios)
-- SGBD: PostgreSQL
-- Contiene DOS esquemas identicos dentro de la misma base:
--   esquema_grupo4
--   esquema_grupo4_alt
--
-- Ejecutar este script conectado a la base de datos ya creada,
-- por ejemplo:
--   CREATE DATABASE club_db;
--   \c club_db
--   luego correr este archivo.
-- =========================================================

-- CREATE DATABASE club_db;   -- descomentar si aun no existe
-- \c club_db


-- =========================================================
-- ESQUEMA: esquema_grupo4
-- =========================================================
CREATE SCHEMA IF NOT EXISTS esquema_grupo4;

-- ---------------------------------------------------------
-- dominios
-- ---------------------------------------------------------
-- dominio para "tipo_dni", solo permitimos los tipos de documento DNI, LE, LC, CI, PASAPORTE
CREATE DOMAIN esquema_grupo4.tipo_dni_dominio AS VARCHAR(10)
    CHECK (VALUE IN ('DNI', 'LE', 'LC', 'CI', 'PASAPORTE'));

-- dominio de monto: hasta 10 digitos, 2 decimales, no negativo
CREATE DOMAIN esquema_grupo4.monto_dominio AS NUMERIC(10,2)
    CHECK (VALUE >= 1 AND VALUE <= 99999999.99);

-- dominio de fecha, no admite fechas anteriores a la creacion del club
CREATE DOMAIN esquema_grupo4.fecha_dom AS DATE
    CHECK (VALUE >= DATE '2010-01-01');

-- ---------------------------------------------------------
-- persona
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4.persona (
    tipo_dni        esquema_grupo4.tipo_dni_dominio NOT NULL,
    nro_dni         VARCHAR(15)  NOT NULL,
    nombre          VARCHAR(60)  NOT NULL,
    apellido        VARCHAR(60)  NOT NULL,
    telefono        VARCHAR(20),
    fechaNacimiento DATE,
    mail            VARCHAR(100),
    CONSTRAINT pk_persona PRIMARY KEY (tipo_dni, nro_dni),
    CONSTRAINT uq_persona_nrodni UNIQUE (tipo_dni, nro_dni)  -- ver nota sobre esta decision
);

-- ---------------------------------------------------------
-- disciplina
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4.disciplina (
    nombre  VARCHAR(50) NOT NULL,
    enfoque VARCHAR(50),
    CONSTRAINT pk_disciplina PRIMARY KEY (nombre)
);

-- ---------------------------------------------------------
-- categoria
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4.categoria (
    nombreCategoria  VARCHAR(50) NOT NULL,
    nombreDisciplina VARCHAR(50) NOT NULL,
    edadMin          INT,
    edadMax          INT,
    CONSTRAINT pk_categoria PRIMARY KEY (nombreCategoria, nombreDisciplina),
    CONSTRAINT fk_categoria_disciplina FOREIGN KEY (nombreDisciplina)
        REFERENCES esquema_grupo4.disciplina (nombre)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_categoria_edades
        CHECK (edadMin <= edadMax)
);

-- ---------------------------------------------------------
-- profesor
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4.profesor (
    tipo_dni  VARCHAR(10)  NOT NULL,
    nro_dni   VARCHAR(15)  NOT NULL,
    fechaIngreso DATE,
    CONSTRAINT pk_profesor PRIMARY KEY (tipo_dni, nro_dni),
    CONSTRAINT fk_profesor_persona FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES esquema_grupo4.persona (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ---------------------------------------------------------
-- tutor
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4.tutor (
    tipo_dni  VARCHAR(10)  NOT NULL,
    nro_dni   VARCHAR(15)  NOT NULL,
    CONSTRAINT pk_tutor PRIMARY KEY (tipo_dni, nro_dni),
    CONSTRAINT fk_tutor_persona FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES esquema_grupo4.persona (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ---------------------------------------------------------
-- socio
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4.socio (
    tipo_dni  VARCHAR(10)  NOT NULL,
    nro_dni   VARCHAR(15)  NOT NULL,
    esFederado            BOOLEAN DEFAULT FALSE,
    ddjSalud              BOOLEAN DEFAULT FALSE,
    fechaInscripcion      esquema_grupo4.fecha_dom,
    ausenciasConsecutivas INT DEFAULT 0,
    nombreDisciplina      VARCHAR(50),
    nombreCategoria       VARCHAR(50),
    CONSTRAINT pk_socio PRIMARY KEY (tipo_dni, nro_dni),
    CONSTRAINT fk_socio_persona FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES esquema_grupo4.persona (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_socio_categoria FOREIGN KEY (nombreCategoria, nombreDisciplina)
        REFERENCES esquema_grupo4.categoria (nombreCategoria, nombreDisciplina)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ---------------------------------------------------------
-- usuario
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4.usuario (
    nombreUsuario VARCHAR(50)  NOT NULL,
    contrasenia   VARCHAR(255) NOT NULL,
    tipo_dni  VARCHAR(10)  NOT NULL,
    nro_dni   VARCHAR(15)  NOT NULL,
    CONSTRAINT pk_usuario PRIMARY KEY (nombreUsuario),
    CONSTRAINT fk_usuario_persona FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES esquema_grupo4.persona (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ---------------------------------------------------------
-- tieneTutor
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4.tieneTutor (
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
        REFERENCES esquema_grupo4.tutor (tipo_dni, nro_dni)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- ---------------------------------------------------------
-- estadoSocio
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4.estadoSocio (
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    fechaModificacion TIMESTAMP  NOT NULL,
    estado           VARCHAR(20) NOT NULL,
    modificadoPor    VARCHAR(50),
    CONSTRAINT pk_estadoSocio PRIMARY KEY (tipo_dni, nro_dni, fechaModificacion),
    CONSTRAINT fk_estadoSocio_socio FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES esquema_grupo4.socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_estadoSocio_usuario FOREIGN KEY (modificadoPor)
        REFERENCES esquema_grupo4.usuario (nombreUsuario)
        ON UPDATE CASCADE ON DELETE SET NULL
);

-- ---------------------------------------------------------
-- aCargo
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4.aCargo (
    nombreDisciplina VARCHAR(50) NOT NULL,
    nombreCategoria  VARCHAR(50) NOT NULL,
    rol              VARCHAR(30) NOT NULL,
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    CONSTRAINT pk_aCargo PRIMARY KEY (nombreDisciplina, nombreCategoria, tipo_dni, nro_dni, rol),
    CONSTRAINT fk_aCargo_categoria FOREIGN KEY (nombreCategoria, nombreDisciplina)
        REFERENCES esquema_grupo4.categoria (nombreCategoria, nombreDisciplina)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_aCargo_profesor FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES esquema_grupo4.profesor (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- ---------------------------------------------------------
-- planillaAsistencia
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4.planillaAsistencia (
    idPlanilla  SERIAL      NOT NULL,
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    CONSTRAINT pk_planillaAsistencia PRIMARY KEY (idPlanilla),
    CONSTRAINT fk_planilla_profesor FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES esquema_grupo4.profesor (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ---------------------------------------------------------
-- clase
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4.clase (
    nombreDisciplina VARCHAR(50) NOT NULL,
    nombreCategoria  VARCHAR(50) NOT NULL,
    fecha            DATE        NOT NULL,
    horaInicio       TIME        NOT NULL,
    horaFin          TIME,
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    idPlanilla       INT NOT NULL,
    rol VARCHAR(30) ,
    CONSTRAINT pk_clase PRIMARY KEY (nombreDisciplina, nombreCategoria, fecha, horaInicio),
    CONSTRAINT fk_clase_categoria FOREIGN KEY (nombreCategoria, nombreDisciplina)
        REFERENCES esquema_grupo4.categoria (nombreCategoria, nombreDisciplina)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_clase_profesor FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES esquema_grupo4.profesor (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_clase_planilla FOREIGN KEY (idPlanilla)
        REFERENCES esquema_grupo4.planillaAsistencia (idPlanilla)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT uq_clase_planilla UNIQUE (idPlanilla)
);

-- ---------------------------------------------------------
-- detalleAsistencia
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4.detalleAsistencia (
    idPlanilla       INT         NOT NULL,
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    estadoAsistencia VARCHAR(20),
    CONSTRAINT pk_detalleAsistencia PRIMARY KEY (idPlanilla, tipo_dni, nro_dni),
    CONSTRAINT fk_detalle_planilla FOREIGN KEY (idPlanilla)
        REFERENCES esquema_grupo4.planillaAsistencia (idPlanilla)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_detalle_socio FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES esquema_grupo4.socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- ---------------------------------------------------------
-- medico
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4.medico (
    matricula VARCHAR(20) NOT NULL,
    nombre    VARCHAR(60),
    apellido  VARCHAR(60),
    telefono  VARCHAR(20),
    CONSTRAINT pk_medico PRIMARY KEY (matricula)
);

-- ---------------------------------------------------------
-- certificadoMedico
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4.certificadoMedico (
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    fechaEmision     DATE        NOT NULL,
    fechaVencimiento DATE,
    matricula        VARCHAR(20) NOT NULL,
    CONSTRAINT pk_certificadoMedico PRIMARY KEY (tipo_dni, nro_dni, fechaEmision),
    CONSTRAINT fk_certificado_socio FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES esquema_grupo4.socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_certificado_medico FOREIGN KEY (matricula)
        REFERENCES esquema_grupo4.medico (matricula)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_certificado_fechas
        CHECK (fechaVencimiento IS NULL OR fechaEmision < fechaVencimiento)
);

-- ---------------------------------------------------------
-- seguro
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4.seguro (
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    numPoliza        VARCHAR(30) NOT NULL,
    fechaAlta        DATE,
    fechaVencimiento DATE,
    fechaBaja        DATE,
    tipo             VARCHAR(30),
    CONSTRAINT pk_seguro PRIMARY KEY (tipo_dni, nro_dni, numPoliza),
    CONSTRAINT fk_seguro_socio FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES esquema_grupo4.socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- ---------------------------------------------------------
-- cuota
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4.cuota (
    idCuota       SERIAL      NOT NULL,
    fecha         DATE        NOT NULL,
    monto esquema_grupo4.monto_dominio NOT NULL,
    estadoDePago  VARCHAR(20),
    periodo       VARCHAR(20),
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    CONSTRAINT pk_cuota PRIMARY KEY (idCuota),
    CONSTRAINT fk_cuota_socio FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES esquema_grupo4.socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ---------------------------------------------------------
-- pago
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4.pago (
    idPago     SERIAL      NOT NULL,
    fechaPago  DATE        NOT NULL,
    monto       esquema_grupo4.monto_dominio NOT NULL,
    idCuota    INT         NOT NULL,
    CONSTRAINT pk_pago PRIMARY KEY (idPago),
    CONSTRAINT fk_pago_cuota FOREIGN KEY (idCuota)
        REFERENCES esquema_grupo4.cuota (idCuota)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ---------------------------------------------------------
-- cargoAdministrativo
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4.cargoAdministrativo (
    idCargo     SERIAL NOT NULL,
    descripcion VARCHAR(100),
    CONSTRAINT pk_cargoAdministrativo PRIMARY KEY (idCargo)
);

-- ---------------------------------------------------------
-- tieneCargo
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4.tieneCargo (
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    idCargo         INT         NOT NULL,
    fechaInicioCargo DATE       NOT NULL,
    fechaFinCargo   DATE NOT NULL,
    CONSTRAINT pk_tieneCargo PRIMARY KEY (tipo_dni, nro_dni, idCargo, fechaInicioCargo,fechaFinCargo),
    CONSTRAINT fk_tieneCargo_socio FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES esquema_grupo4.socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_tieneCargo_cargo FOREIGN KEY (idCargo)
        REFERENCES esquema_grupo4.cargoAdministrativo (idCargo)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ---------------------------------------------------------
-- historialFinanciero
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4.historialFinanciero (
    idHistorial     SERIAL      NOT NULL,
    fechaGeneracion TIMESTAMP,
    tipoPeriodo     VARCHAR(20),
    periodo         VARCHAR(20),
    montoAdeudado   NUMERIC(10,2),
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    CONSTRAINT pk_historialFinanciero PRIMARY KEY (idHistorial),
    CONSTRAINT fk_historialFin_socio FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES esquema_grupo4.socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- ---------------------------------------------------------
-- historialAusenciasProlongadas
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4.historialAusenciasProlongadas (
    idHistorial      SERIAL      NOT NULL,
    fechaGeneracion  TIMESTAMP,
    tipoPeriodo      VARCHAR(20),
    umbralAusencias  INT,
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    CONSTRAINT pk_historialAusencias PRIMARY KEY (idHistorial),
    CONSTRAINT fk_historialAus_socio FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES esquema_grupo4.socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- ---------------------------------------------------------
-- notificacion
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4.notificacion (
    idNotificacion SERIAL      NOT NULL,
    tipo           VARCHAR(30),
    mensaje        TEXT,
    fecha          TIMESTAMP,
    nombreUsuario  VARCHAR(50) NOT NULL,
    CONSTRAINT pk_notificacion PRIMARY KEY (idNotificacion),
    CONSTRAINT fk_notificacion_usuario FOREIGN KEY (nombreUsuario)
        REFERENCES esquema_grupo4.usuario (nombreUsuario)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE esquema_grupo4.rol(
    nombre_rol VARCHAR(30) NOT NULL,
    permisos VARCHAR(100) NOT NULL,
    CONSTRAINT pk_rol
        PRIMARY KEY (nombre_rol)
);

CREATE TABLE esquema_grupo4.tiene_rol (
    nombre_rol     VARCHAR(50) NOT NULL,
    nombreUsuario  VARCHAR(50) NOT NULL,
    fecha          DATE NOT NULL,

    CONSTRAINT pk_tiene_rol
        PRIMARY KEY (nombre_rol, nombreUsuario),

    CONSTRAINT fk_tiene_rol_rol
        FOREIGN KEY (nombre_rol)
        REFERENCES esquema_grupo4.rol (nombre_rol)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_tiene_rol_usuario
        FOREIGN KEY (nombreUsuario)
        REFERENCES esquema_grupo4.usuario (nombreUsuario)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- =========================================================
-- ESQUEMA: esquema_grupo4_alt
-- (estructura identica a esquema_grupo4, mismos dominios)
-- =========================================================
CREATE SCHEMA IF NOT EXISTS esquema_grupo4_alt;

-- ---------------------------------------------------------
-- dominios
-- ---------------------------------------------------------
CREATE DOMAIN esquema_grupo4_alt.tipo_dni_dominio AS VARCHAR(10)
    CHECK (VALUE IN ('DNI', 'LE', 'LC', 'CI', 'PASAPORTE'));

CREATE DOMAIN esquema_grupo4_alt.monto_dominio AS NUMERIC(10,2)
    CHECK (VALUE >= 1 AND VALUE <= 99999999.99);

CREATE DOMAIN esquema_grupo4_alt.fecha_dom AS DATE
    CHECK (VALUE >= DATE '2010-01-01');

-- ---------------------------------------------------------
-- persona
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4_alt.persona (
    tipo_dni        esquema_grupo4_alt.tipo_dni_dominio NOT NULL,
    nro_dni         VARCHAR(15)  NOT NULL,
    nombre          VARCHAR(60)  NOT NULL,
    apellido        VARCHAR(60)  NOT NULL,
    telefono        VARCHAR(20),
    fechaNacimiento DATE,
    mail            VARCHAR(100),
    CONSTRAINT pk_persona PRIMARY KEY (tipo_dni, nro_dni),
    CONSTRAINT uq_persona_nrodni UNIQUE (tipo_dni, nro_dni)  -- ver nota sobre esta decision
);

-- ---------------------------------------------------------
-- disciplina
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4_alt.disciplina (
    nombre  VARCHAR(50) NOT NULL,
    enfoque VARCHAR(50),
    CONSTRAINT pk_disciplina PRIMARY KEY (nombre)
);

-- ---------------------------------------------------------
-- categoria
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4_alt.categoria (
    nombreCategoria  VARCHAR(50) NOT NULL,
    nombreDisciplina VARCHAR(50) NOT NULL,
    edadMin          INT,
    edadMax          INT,
    CONSTRAINT pk_categoria PRIMARY KEY (nombreCategoria, nombreDisciplina),
    CONSTRAINT fk_categoria_disciplina FOREIGN KEY (nombreDisciplina)
        REFERENCES esquema_grupo4_alt.disciplina (nombre)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_categoria_edades
        CHECK (edadMin <= edadMax)
);

-- ---------------------------------------------------------
-- profesor
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4_alt.profesor (
    tipo_dni  VARCHAR(10)  NOT NULL,
    nro_dni   VARCHAR(15)  NOT NULL,
    fechaIngreso DATE,
    CONSTRAINT pk_profesor PRIMARY KEY (tipo_dni, nro_dni),
    CONSTRAINT fk_profesor_persona FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES esquema_grupo4_alt.persona (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ---------------------------------------------------------
-- tutor
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4_alt.tutor (
    tipo_dni  VARCHAR(10)  NOT NULL,
    nro_dni   VARCHAR(15)  NOT NULL,
    CONSTRAINT pk_tutor PRIMARY KEY (tipo_dni, nro_dni),
    CONSTRAINT fk_tutor_persona FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES esquema_grupo4_alt.persona (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ---------------------------------------------------------
-- socio
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4_alt.socio (
    tipo_dni  VARCHAR(10)  NOT NULL,
    nro_dni   VARCHAR(15)  NOT NULL,
    esFederado            BOOLEAN DEFAULT FALSE,
    ddjSalud              BOOLEAN DEFAULT FALSE,
    fechaInscripcion      esquema_grupo4_alt.fecha_dom,
    ausenciasConsecutivas INT DEFAULT 0,
    nombreDisciplina      VARCHAR(50),
    nombreCategoria       VARCHAR(50),
    CONSTRAINT pk_socio PRIMARY KEY (tipo_dni, nro_dni),
    CONSTRAINT fk_socio_persona FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES esquema_grupo4_alt.persona (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_socio_categoria FOREIGN KEY (nombreCategoria, nombreDisciplina)
        REFERENCES esquema_grupo4_alt.categoria (nombreCategoria, nombreDisciplina)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ---------------------------------------------------------
-- usuario
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4_alt.usuario (
    nombreUsuario VARCHAR(50)  NOT NULL,
    contrasenia   VARCHAR(255) NOT NULL,
    tipo_dni  VARCHAR(10)  NOT NULL,
    nro_dni   VARCHAR(15)  NOT NULL,
    CONSTRAINT pk_usuario PRIMARY KEY (nombreUsuario),
    CONSTRAINT fk_usuario_persona FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES esquema_grupo4_alt.persona (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ---------------------------------------------------------
-- tieneTutor
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4_alt.tieneTutor (
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
        REFERENCES esquema_grupo4_alt.socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_tieneTutor_tutor
        FOREIGN KEY (tipo_dni_tutor, nro_dni_tutor)
        REFERENCES esquema_grupo4_alt.tutor (tipo_dni, nro_dni)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- ---------------------------------------------------------
-- estadoSocio
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4_alt.estadoSocio (
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    fechaModificacion TIMESTAMP  NOT NULL,
    estado           VARCHAR(20) NOT NULL,
    modificadoPor    VARCHAR(50),
    CONSTRAINT pk_estadoSocio PRIMARY KEY (tipo_dni, nro_dni, fechaModificacion),
    CONSTRAINT fk_estadoSocio_socio FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES esquema_grupo4_alt.socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_estadoSocio_usuario FOREIGN KEY (modificadoPor)
        REFERENCES esquema_grupo4_alt.usuario (nombreUsuario)
        ON UPDATE CASCADE ON DELETE SET NULL
);

-- ---------------------------------------------------------
-- aCargo
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4_alt.aCargo (
    nombreDisciplina VARCHAR(50) NOT NULL,
    nombreCategoria  VARCHAR(50) NOT NULL,
    rol              VARCHAR(30) NOT NULL,
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    CONSTRAINT pk_aCargo PRIMARY KEY (nombreDisciplina, nombreCategoria, tipo_dni, nro_dni, rol),
    CONSTRAINT fk_aCargo_categoria FOREIGN KEY (nombreCategoria, nombreDisciplina)
        REFERENCES esquema_grupo4_alt.categoria (nombreCategoria, nombreDisciplina)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_aCargo_profesor FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES esquema_grupo4_alt.profesor (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- ---------------------------------------------------------
-- planillaAsistencia
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4_alt.planillaAsistencia (
    idPlanilla  SERIAL      NOT NULL,
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    CONSTRAINT pk_planillaAsistencia PRIMARY KEY (idPlanilla),
    CONSTRAINT fk_planilla_profesor FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES esquema_grupo4_alt.profesor (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ---------------------------------------------------------
-- clase
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4_alt.clase (
    nombreDisciplina VARCHAR(50) NOT NULL,
    nombreCategoria  VARCHAR(50) NOT NULL,
    fecha            DATE        NOT NULL,
    horaInicio       TIME        NOT NULL,
    horaFin          TIME,
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    idPlanilla       INT NOT NULL,
    rol VARCHAR(30) ,
    CONSTRAINT pk_clase PRIMARY KEY (nombreDisciplina, nombreCategoria, fecha, horaInicio),
    CONSTRAINT fk_clase_categoria FOREIGN KEY (nombreCategoria, nombreDisciplina)
        REFERENCES esquema_grupo4_alt.categoria (nombreCategoria, nombreDisciplina)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_clase_profesor FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES esquema_grupo4_alt.profesor (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_clase_planilla FOREIGN KEY (idPlanilla)
        REFERENCES esquema_grupo4_alt.planillaAsistencia (idPlanilla)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT uq_clase_planilla UNIQUE (idPlanilla)
);

-- ---------------------------------------------------------
-- detalleAsistencia
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4_alt.detalleAsistencia (
    idPlanilla       INT         NOT NULL,
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    estadoAsistencia VARCHAR(20),
    CONSTRAINT pk_detalleAsistencia PRIMARY KEY (idPlanilla, tipo_dni, nro_dni),
    CONSTRAINT fk_detalle_planilla FOREIGN KEY (idPlanilla)
        REFERENCES esquema_grupo4_alt.planillaAsistencia (idPlanilla)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_detalle_socio FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES esquema_grupo4_alt.socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- ---------------------------------------------------------
-- medico
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4_alt.medico (
    matricula VARCHAR(20) NOT NULL,
    nombre    VARCHAR(60),
    apellido  VARCHAR(60),
    telefono  VARCHAR(20),
    CONSTRAINT pk_medico PRIMARY KEY (matricula)
);

-- ---------------------------------------------------------
-- certificadoMedico
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4_alt.certificadoMedico (
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    fechaEmision     DATE        NOT NULL,
    fechaVencimiento DATE,
    matricula        VARCHAR(20) NOT NULL,
    CONSTRAINT pk_certificadoMedico PRIMARY KEY (tipo_dni, nro_dni, fechaEmision),
    CONSTRAINT fk_certificado_socio FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES esquema_grupo4_alt.socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_certificado_medico FOREIGN KEY (matricula)
        REFERENCES esquema_grupo4_alt.medico (matricula)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_certificado_fechas
        CHECK (fechaVencimiento IS NULL OR fechaEmision < fechaVencimiento)
);

-- ---------------------------------------------------------
-- seguro
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4_alt.seguro (
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    numPoliza        VARCHAR(30) NOT NULL,
    fechaAlta        DATE,
    fechaVencimiento DATE,
    fechaBaja        DATE,
    tipo             VARCHAR(30),
    CONSTRAINT pk_seguro PRIMARY KEY (tipo_dni, nro_dni, numPoliza),
    CONSTRAINT fk_seguro_socio FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES esquema_grupo4_alt.socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- ---------------------------------------------------------
-- cuota
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4_alt.cuota (
    idCuota       SERIAL      NOT NULL,
    fecha         DATE        NOT NULL,
    monto esquema_grupo4_alt.monto_dominio NOT NULL,
    estadoDePago  VARCHAR(20),
    periodo       VARCHAR(20),
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    CONSTRAINT pk_cuota PRIMARY KEY (idCuota),
    CONSTRAINT fk_cuota_socio FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES esquema_grupo4_alt.socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ---------------------------------------------------------
-- pago
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4_alt.pago (
    idPago     SERIAL      NOT NULL,
    fechaPago  DATE        NOT NULL,
    monto       esquema_grupo4_alt.monto_dominio NOT NULL,
    idCuota    INT         NOT NULL,
    CONSTRAINT pk_pago PRIMARY KEY (idPago),
    CONSTRAINT fk_pago_cuota FOREIGN KEY (idCuota)
        REFERENCES esquema_grupo4_alt.cuota (idCuota)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ---------------------------------------------------------
-- cargoAdministrativo
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4_alt.cargoAdministrativo (
    idCargo     SERIAL NOT NULL,
    descripcion VARCHAR(100),
    CONSTRAINT pk_cargoAdministrativo PRIMARY KEY (idCargo)
);

-- ---------------------------------------------------------
-- tieneCargo
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4_alt.tieneCargo (
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    idCargo         INT         NOT NULL,
    fechaInicioCargo DATE       NOT NULL,
    fechaFinCargo   DATE NOT NULL,
    CONSTRAINT pk_tieneCargo PRIMARY KEY (tipo_dni, nro_dni, idCargo, fechaInicioCargo, fechaFinCargo),
    CONSTRAINT fk_tieneCargo_socio FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES esquema_grupo4_alt.socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_tieneCargo_cargo FOREIGN KEY (idCargo)
        REFERENCES esquema_grupo4_alt.cargoAdministrativo (idCargo)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ---------------------------------------------------------
-- historialFinanciero
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4_alt.historialFinanciero (
    idHistorial     SERIAL      NOT NULL,
    fechaGeneracion TIMESTAMP,
    tipoPeriodo     VARCHAR(20),
    periodo         VARCHAR(20),
    montoAdeudado   NUMERIC(10,2),
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    CONSTRAINT pk_historialFinanciero PRIMARY KEY (idHistorial),
    CONSTRAINT fk_historialFin_socio FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES esquema_grupo4_alt.socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- ---------------------------------------------------------
-- historialAusenciasProlongadas
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4_alt.historialAusenciasProlongadas (
    idHistorial      SERIAL      NOT NULL,
    fechaGeneracion  TIMESTAMP,
    tipoPeriodo      VARCHAR(20),
    umbralAusencias  INT,
    tipo_dni       VARCHAR(10) NOT NULL,
    nro_dni        VARCHAR(15) NOT NULL,
    CONSTRAINT pk_historialAusencias PRIMARY KEY (idHistorial),
    CONSTRAINT fk_historialAus_socio FOREIGN KEY (tipo_dni, nro_dni)
        REFERENCES esquema_grupo4_alt.socio (tipo_dni, nro_dni)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- ---------------------------------------------------------
-- notificacion
-- ---------------------------------------------------------
CREATE TABLE esquema_grupo4_alt.notificacion (
    idNotificacion SERIAL      NOT NULL,
    tipo           VARCHAR(30),
    mensaje        TEXT,
    fecha          TIMESTAMP,
    nombreUsuario  VARCHAR(50) NOT NULL,
    CONSTRAINT pk_notificacion PRIMARY KEY (idNotificacion),
    CONSTRAINT fk_notificacion_usuario FOREIGN KEY (nombreUsuario)
        REFERENCES esquema_grupo4_alt.usuario (nombreUsuario)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE esquema_grupo4_alt.rol(
    nombre_rol VARCHAR(30) NOT NULL,
    permisos VARCHAR(100) NOT NULL,
    CONSTRAINT pk_rol
        PRIMARY KEY (nombre_rol)
);

CREATE TABLE esquema_grupo4_alt.tiene_rol (
    nombre_rol     VARCHAR(50) NOT NULL,
    nombreUsuario  VARCHAR(50) NOT NULL,
    fecha          DATE NOT NULL,

    CONSTRAINT pk_tiene_rol
        PRIMARY KEY (nombre_rol, nombreUsuario),

    CONSTRAINT fk_tiene_rol_rol
        FOREIGN KEY (nombre_rol)
        REFERENCES esquema_grupo4_alt.rol (nombre_rol)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_tiene_rol_usuario
        FOREIGN KEY (nombreUsuario)
        REFERENCES esquema_grupo4_alt.usuario (nombreUsuario)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);
