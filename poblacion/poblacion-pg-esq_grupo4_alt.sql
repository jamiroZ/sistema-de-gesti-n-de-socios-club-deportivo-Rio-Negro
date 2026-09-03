-- =============================================================================
-- Club Deportivo Rio Negro - Poblacion PostgreSQL - esq_grupo4_alt (Sede Roca)
-- =============================================================================
-- Los datos son distintos a los de esq_grupo4.
-- Cambian las personas, las categorias que dicta cada sede y los
-- montos de las cuotas.
-- =============================================================================

SET search_path TO esq_grupo4_alt, public;

-- -----------------------------------------------------------------------------
-- Personas
-- -----------------------------------------------------------------------------
-- Igual que en la otra sede, se incluyen los dos casos que muestran la
-- especializacion. Hector Bravo (LE 40000003) es profesor Y socio, y Elena
-- Suarez (DNI 40000006) no es ninguna de las dos cosas, solo tutora.

INSERT INTO persona (tipo_dni, nro_dni, nombre, apellido, telefono, fecha_nacimiento, mail) VALUES
    ('DNI', '40000001', 'Ruben',  'Paz',     '298-4004001', '1982-04-11', 'rpaz@clubrn.com'),
    ('DNI', '40000002', 'Silvia', 'Roldan',  '298-4004002', '1991-10-02', 'sroldan@clubrn.com'),
    ('LE',  '40000003', 'Hector', 'Bravo',   '298-4004003', '1987-01-25', 'hbravo@clubrn.com'),
    ('DNI', '40000004', 'Nadia',  'Ocampo',  '298-4004004', '1994-08-19', 'nocampo@clubrn.com'),
    ('DNI', '40000005', 'Ivan',   'Costa',   NULL,          '2013-03-07', 'icosta@clubrn.com'),
    ('DNI', '40000006', 'Elena',  'Suarez',  '298-4004006', '1984-11-14', 'esuarez@clubrn.com'),
    ('CI',  '40000007', 'Gaston', 'Mieres',  '298-4004007', '1996-06-30', 'gmieres@clubrn.com');

INSERT INTO profesor (tipo_dni, nro_dni, fecha_ingreso) VALUES
    ('DNI', '40000001', '2017-08-01'),
    ('LE',  '40000003', '2019-03-12');

INSERT INTO socio (tipo_dni, nro_dni, es_federado, ddj_salud, fecha_inscripcion_club, ausencias_consecutivas) VALUES
    ('DNI', '40000002', FALSE, TRUE, '2021-04-03', 0),
    ('LE',  '40000003', TRUE,  TRUE, '2019-03-20', 1),
    ('DNI', '40000004', FALSE, TRUE, '2022-02-14', 0),
    ('DNI', '40000005', TRUE,  TRUE, '2025-03-01', 2),
    ('CI',  '40000007', FALSE, TRUE, '2020-09-09', 0);

-- El nombre de usuario se arma concatenando tipo y número de documento, por
-- ejemplo DNI40000001, para que identifique la cuenta sin ambigüedad entre
-- tipos de documento distintos.
INSERT INTO usuario (nombre_usuario, contrasenia, tipo_dni, nro_dni) VALUES
    ('DNI40000001', '$2b$12$eXaMpLeHaShClUbRn0000000uJ8kQvZ1rT4wY6bN9cD2fG5hK7mP', 'DNI', '40000001'),
    ('DNI40000002', '$2b$12$eXaMpLeHaShClUbRn0000000uJ8kQvZ1rT4wY6bN9cD2fG5hK7mP', 'DNI', '40000002'),
    ('LE40000003',  '$2b$12$eXaMpLeHaShClUbRn0000000uJ8kQvZ1rT4wY6bN9cD2fG5hK7mP', 'LE',  '40000003'),
    ('DNI40000004', '$2b$12$eXaMpLeHaShClUbRn0000000uJ8kQvZ1rT4wY6bN9cD2fG5hK7mP', 'DNI', '40000004'),
    ('CI40000007',  '$2b$12$eXaMpLeHaShClUbRn0000000uJ8kQvZ1rT4wY6bN9cD2fG5hK7mP', 'CI',  '40000007');

INSERT INTO rol (nombre_rol, permisos) VALUES
    ('Socio',                  'Consulta de su perfil, asistencias, certificado y cuotas'),
    ('Profesor',               'Toma de asistencia de sus categorias y alta de socio potencial'),
    ('Administrativa general', 'Alta de socios, certificados, seguros y clasificacion'),
    ('Tesorero',               'Listado de deudores, registro de pagos y baja de seguros'),
    ('Recepcionista',          'Registro de socios potenciales y listado de no aptos');

INSERT INTO tiene_rol (nombre_rol, nombre_usuario, fecha_inicio_rol, fecha_fin_rol) VALUES
    ('Profesor',               'DNI40000001', '2026-01-01', '2026-12-31'),
    ('Profesor',               'LE40000003',  '2026-01-01', '2026-12-31'),
    ('Socio',                  'LE40000003',  '2026-01-01', '2026-12-31'),
    ('Administrativa general', 'DNI40000004', '2026-01-01', '2026-12-31'),
    ('Socio',                  'DNI40000002', '2026-01-01', '2026-12-31'),
    ('Tesorero',               'CI40000007',  '2026-01-01', '2026-12-31');

INSERT INTO notificacion (id_notificacion, tipo, mensaje, fecha, nombre_usuario) VALUES
    (1, 'Recordatorio', 'Hay 1 registro pendiente de alta',        '2026-08-22 09:30:00', 'DNI40000004'),
    (2, 'Aviso',        'Cierre de cuotas de julio pendiente',     '2026-08-05 12:00:00', 'CI40000007'),
    (3, 'Confirmacion', 'Se registro el pago de la cuota de julio','2026-07-10 15:20:00', 'DNI40000002');

INSERT INTO tiene_tutor (tipo_dni_socio, nro_dni_socio, parentesco, tipo_dni_tutor, nro_dni_tutor) VALUES
    ('DNI', '40000005', 'Madre', 'DNI', '40000006'),
    ('DNI', '40000005', 'Padre', 'CI',  '40000007');

INSERT INTO estado_socio (tipo_dni, nro_dni, fecha_modificacion, estado, modificado_por) VALUES
    ('DNI', '40000002', '2021-04-03 10:00:00', 'Activo',            'DNI40000004'),
    ('LE',  '40000003', '2019-03-20 10:00:00', 'Activo',            'DNI40000004'),
    ('DNI', '40000004', '2022-02-14 10:00:00', 'Activo',            'DNI40000004'),
    ('DNI', '40000005', '2025-03-01 10:00:00', 'Pendiente de alta', 'DNI40000004'),
    ('CI',  '40000007', '2020-09-09 10:00:00', 'Activo',            'DNI40000004'),
    ('CI',  '40000007', '2026-03-01 10:00:00', 'Becado',            'DNI40000004');

-- -----------------------------------------------------------------------------
-- Actividades
-- -----------------------------------------------------------------------------
-- Esta sede dicta menos categorias que la otra, que es parte de lo que hace que
-- los datos sean distintos entre esquemas.

INSERT INTO disciplina (nombre_disciplina) VALUES
    ('Voley'),
    ('Handball');

INSERT INTO categoria (nombre_categoria, nombre_disciplina, edad_min, edad_max, enfoque) VALUES
    ('Infantiles', 'Voley',    6,  12, 'Recreativo'),
    ('Juveniles',  'Voley',    13, 17, 'Competitivo'),
    ('Adultos',    'Voley',    18, 60, 'Competitivo'),
    ('Adultos',    'Handball', 18, 60, 'Competitivo');

INSERT INTO pertenece (tipo_dni, nro_dni, nombre_disciplina, fecha_inscripcion) VALUES
    ('DNI', '40000002', 'Voley',    '2021-04-03'),
    ('LE',  '40000003', 'Voley',    '2019-03-20'),
    ('DNI', '40000004', 'Handball', '2022-02-14'),
    ('DNI', '40000005', 'Voley',    '2025-03-01'),
    ('CI',  '40000007', 'Handball', '2020-09-09');

INSERT INTO a_cargo (nombre_disciplina, nombre_categoria, rol_profesor, tipo_dni, nro_dni) VALUES
    ('Voley',    'Infantiles', 'Director Tecnico',  'DNI', '40000001'),
    ('Voley',    'Juveniles',  'Director Tecnico',  'LE',  '40000003'),
    ('Voley',    'Adultos',    'Director Tecnico',  'DNI', '40000001'),
    ('Voley',    'Adultos',    'Preparador Fisico', 'LE',  '40000003'),
    ('Handball', 'Adultos',    'Director Tecnico',  'DNI', '40000001');

INSERT INTO planilla_asistencia (id_planilla, tipo_dni, nro_dni) VALUES
    (1, 'DNI', '40000001'),
    (2, 'LE',  '40000003'),
    (3, 'DNI', '40000001');

INSERT INTO clase (nombre_disciplina, nombre_categoria, fecha, hora_inicio, hora_fin, id_planilla) VALUES
    ('Voley',    'Adultos',   '2026-08-10', '20:00', '21:30', 1),
    ('Voley',    'Juveniles', '2026-08-10', '18:30', '20:00', 2),
    ('Handball', 'Adultos',   '2026-08-11', '20:00', '21:30', 3);

INSERT INTO detalle_asistencia (id_planilla, tipo_dni_socio, nro_dni_socio, estado_asistencia) VALUES
    (1, 'DNI', '40000002', 'Presente'),
    (1, 'LE',  '40000003', 'Ausente justificado'),
    (2, 'DNI', '40000005', 'Presente'),
    (3, 'DNI', '40000004', 'Presente'),
    (3, 'CI',  '40000007', 'Ausente');

-- -----------------------------------------------------------------------------
-- Salud y seguro
-- -----------------------------------------------------------------------------

INSERT INTO medico (matricula, nombre, apellido, telefono) VALUES
    ('MP-2001', 'Roberto', 'Aguilar', '298-4005001');

INSERT INTO certificado_medico (tipo_dni, nro_dni, fecha_emision, fecha_vencimiento, es_apto, matricula) VALUES
    ('DNI', '40000002', '2026-05-01', '2027-05-01', TRUE, 'MP-2001'),
    ('LE',  '40000003', '2026-04-01', '2027-04-01', TRUE, 'MP-2001'),
    ('DNI', '40000004', '2026-03-15', '2027-03-15', TRUE, 'MP-2001'),
    ('DNI', '40000005', '2026-06-01', '2027-06-01', TRUE, 'MP-2001'),
    ('CI',  '40000007', '2026-02-01', '2027-02-01', TRUE, 'MP-2001');

INSERT INTO seguro (nro_poliza, tipo_dni_socio, nro_dni_socio, fecha_alta, fecha_vencimiento, fecha_baja, tipo) VALUES
    ('POL-4001', 'DNI', '40000002', '2026-05-05', '2027-05-05', NULL, 'Responsabilidad Civil'),
    ('POL-4002', 'DNI', '40000005', '2026-06-05', '2027-06-05', NULL, 'Accidentes Personales'),
    ('POL-4003', 'DNI', '40000004', '2026-03-20', '2027-03-20', NULL, 'Responsabilidad Civil');

-- -----------------------------------------------------------------------------
-- Finanzas
-- -----------------------------------------------------------------------------
-- Los montos de esta sede son distintos a los de la otra. Gaston no tiene
-- cuotas porque esta becado.

INSERT INTO cuota (id_cuota, fecha, monto, estado_de_pago, periodo, tipo_dni, nro_dni) VALUES
    (1, '2026-07-01', 18000.00, 'Saldada',    '2026-07', 'DNI', '40000002'),
    (2, '2026-07-01', 18000.00, 'No saldada', '2026-07', 'LE',  '40000003'),
    (3, '2026-07-01', 14000.00, 'Saldada',    '2026-07', 'DNI', '40000005'),
    (4, '2026-07-01', 18000.00, 'Saldada',    '2026-07', 'DNI', '40000004');

INSERT INTO pago (id_pago, fecha_pago, monto, id_cuota) VALUES
    (1, '2026-07-10', 18000.00, 1),
    (2, '2026-07-09', 14000.00, 3),
    (3, '2026-07-11', 18000.00, 4);

-- -----------------------------------------------------------------------------
-- Cargos
-- -----------------------------------------------------------------------------

INSERT INTO cargo_administrativo (id_cargo, descripcion) VALUES
    (1, 'Tesorero'),
    (2, 'Recepcionista'),
    (3, 'Administrativo General');

INSERT INTO tiene_cargo (tipo_dni, nro_dni, id_cargo, fecha_inicio_cargo, fecha_fin_cargo) VALUES
    ('CI',  '40000007', 1, '2026-01-01', '2026-12-31'),
    ('DNI', '40000004', 3, '2026-01-01', '2026-12-31');

-- -----------------------------------------------------------------------------
-- Reinicio de los contadores
-- -----------------------------------------------------------------------------

ALTER TABLE notificacion         ALTER COLUMN id_notificacion RESTART WITH 4;
ALTER TABLE planilla_asistencia  ALTER COLUMN id_planilla     RESTART WITH 4;
ALTER TABLE cuota                ALTER COLUMN id_cuota        RESTART WITH 5;
ALTER TABLE pago                 ALTER COLUMN id_pago         RESTART WITH 4;
ALTER TABLE cargo_administrativo ALTER COLUMN id_cargo        RESTART WITH 4;
