-- =============================================================================
-- Club Deportivo Rio Negro - Poblacion PostgreSQL - esq_grupo4 (Sede Centro)
-- =============================================================================

SET search_path TO esq_grupo4, public;

-- -----------------------------------------------------------------------------
-- Personas
-- -----------------------------------------------------------------------------
-- Dos casos deliberados que muestran cómo quedó la especialización.
--   Martin Sosa (DNI 30000001) es profesor Y socio a la vez -> solapada.
--   Carla Ponce (DNI 30000009) no es ni socio ni profesor, solo tutora -> parcial.

INSERT INTO persona (tipo_dni, nro_dni, nombre, apellido, telefono, fecha_nacimiento, mail) VALUES
    ('DNI',       '30000001', 'Martin',  'Sosa',      '299-4001001', '1990-03-15', 'msosa@clubrn.com'),
    ('DNI',       '30000002', 'Laura',   'Fernandez', '299-4001002', '1988-07-22', 'lfernandez@clubrn.com'),
    ('LC',        '30000003', 'Diego',   'Molina',    '299-4001003', '1985-11-30', 'dmolina@clubrn.com'),
    ('DNI',       '30000004', 'Ana',     'Ferreyra',  '299-4001004', '1992-05-10', 'nferreyra@clubrn.com'),
    ('DNI',       '30000005', 'Tomas',   'Ruiz',      NULL,          '2015-04-20', 'truiz@clubrn.com'),
    ('DNI',       '30000006', 'Sofia',   'Vera',      NULL,          '2011-09-05', 'svera@clubrn.com'),
    ('CI',        '30000007', 'Jorge',   'Alvarez',   '299-4001007', '1980-01-12', 'jalvarez@clubrn.com'),
    ('PASAPORTE', '30000008', 'Marina',  'Duarte',    '299-4001008', '1983-06-18', 'mduarte@clubrn.com'),
    ('DNI',       '30000009', 'Carla',   'Ponce',     '299-4001009', '1986-02-25', 'cponce@clubrn.com'),
    ('DNI',       '30000010', 'Pablo',   'Ledesma',   '299-4001010', '1995-08-08', 'pledesma@clubrn.com'),
    ('DNI',       '30000011', 'Nicolas', 'Ibarra',    '299-4001011', '1997-12-03', 'nibarra@clubrn.com');

INSERT INTO profesor (tipo_dni, nro_dni, fecha_ingreso) VALUES
    ('DNI', '30000001', '2016-03-01'),
    ('LC',  '30000003', '2018-07-15');

-- Marina llega a 5 ausencias consecutivas, que es el umbral fijado
-- para que el Tesorero evalúe la baja del seguro. Su póliza figura dada de baja.
INSERT INTO socio (tipo_dni, nro_dni, es_federado, ddj_salud, fecha_inscripcion_club, ausencias_consecutivas) VALUES
    ('DNI',       '30000001', TRUE,  TRUE,  '2016-03-10', 0),
    ('DNI',       '30000002', FALSE, TRUE,  '2018-08-01', 1),
    ('DNI',       '30000004', FALSE, TRUE,  '2019-02-05', 2),
    ('DNI',       '30000005', TRUE,  TRUE,  '2024-03-10', 0),
    ('DNI',       '30000006', FALSE, TRUE,  '2023-05-15', 0),
    ('CI',        '30000007', TRUE,  TRUE,  '2017-04-20', 0),
    ('PASAPORTE', '30000008', FALSE, TRUE,  '2020-06-01', 5),
    ('DNI',       '30000010', FALSE, TRUE,  '2022-09-12', 3),
    ('DNI',       '30000011', FALSE, FALSE, '2026-08-20', 0);

-- El nombre de usuario se arma concatenando tipo y número de documento, por
-- ejemplo DNI30000001, para que identifique la cuenta sin ambigüedad entre
-- tipos de documento distintos.
-- La contraseña se guarda hasheada, nunca en claro. Las de acá son un hash de
-- ejemplo, todas de la misma clave de prueba.
INSERT INTO usuario (nombre_usuario, contrasenia, tipo_dni, nro_dni) VALUES
    ('DNI30000001', '$2b$12$eXaMpLeHaShClUbRn0000000uJ8kQvZ1rT4wY6bN9cD2fG5hK7mP', 'DNI', '30000001'),
    ('DNI30000002', '$2b$12$eXaMpLeHaShClUbRn0000000uJ8kQvZ1rT4wY6bN9cD2fG5hK7mP', 'DNI', '30000002'),
    ('LC30000003',  '$2b$12$eXaMpLeHaShClUbRn0000000uJ8kQvZ1rT4wY6bN9cD2fG5hK7mP', 'LC',  '30000003'),
    ('DNI30000004', '$2b$12$eXaMpLeHaShClUbRn0000000uJ8kQvZ1rT4wY6bN9cD2fG5hK7mP', 'DNI', '30000004'),
    ('CI30000007',  '$2b$12$eXaMpLeHaShClUbRn0000000uJ8kQvZ1rT4wY6bN9cD2fG5hK7mP', 'CI',  '30000007'),
    ('DNI30000010', '$2b$12$eXaMpLeHaShClUbRn0000000uJ8kQvZ1rT4wY6bN9cD2fG5hK7mP', 'DNI', '30000010');

INSERT INTO rol (nombre_rol, permisos) VALUES
    ('Socio',                  'Consulta de su perfil, asistencias, certificado y cuotas'),
    ('Profesor',               'Toma de asistencia de sus categorias y alta de socio potencial'),
    ('Administrativa general', 'Alta de socios, certificados, seguros y clasificacion'),
    ('Tesorero',               'Listado de deudores, registro de pagos y baja de seguros'),
    ('Recepcionista',          'Registro de socios potenciales y listado de no aptos');

-- Todo rol se otorga por un período cerrado, igual que los cargos. Las dos
-- fechas integran la clave, así que el mismo usuario puede recuperar el mismo
-- rol en otro período.
-- El usuario DNI30000010 queda a propósito sin ningún rol.
INSERT INTO tiene_rol (nombre_rol, nombre_usuario, fecha_inicio_rol, fecha_fin_rol) VALUES
    ('Profesor',               'DNI30000001', '2026-01-01', '2026-12-31'),
    ('Socio',                  'DNI30000001', '2026-01-01', '2026-12-31'),
    ('Profesor',               'LC30000003',  '2026-01-01', '2026-12-31'),
    ('Administrativa general', 'DNI30000004', '2026-01-01', '2026-12-31'),
    ('Tesorero',               'CI30000007',  '2026-01-01', '2026-12-31'),
    ('Socio',                  'CI30000007',  '2026-01-01', '2026-12-31'),
    ('Socio',                  'DNI30000002', '2026-01-01', '2026-12-31');

INSERT INTO notificacion (id_notificacion, tipo, mensaje, fecha, nombre_usuario) VALUES
    (1, 'Recordatorio', 'Hay 2 registros pendientes de alta',        '2026-08-20 09:00:00', 'DNI30000004'),
    (2, 'Aviso',        'Marina Duarte alcanzo 5 ausencias seguidas','2026-08-18 11:30:00', 'CI30000007'),
    (3, 'Confirmacion', 'Se registro el pago de la cuota de julio',  '2026-07-05 14:15:00', 'DNI30000001'),
    (4, 'Recordatorio', 'Su cuota de julio figura impaga',           '2026-08-01 10:00:00', 'DNI30000010'),
    (5, 'Aviso',        'Su certificado medico vence en 30 dias',    '2026-08-10 16:45:00', 'DNI30000010');

-- Tomas es menor y tiene los 2 tutores que admite el modelo. Sofia tiene 1.
INSERT INTO tiene_tutor (tipo_dni_socio, nro_dni_socio, parentesco, tipo_dni_tutor, nro_dni_tutor) VALUES
    ('DNI', '30000005', 'Padre', 'CI',        '30000007'),
    ('DNI', '30000005', 'Madre', 'DNI',       '30000009'),
    ('DNI', '30000006', 'Madre', 'PASAPORTE', '30000008');

-- Historial de estados. Martin, Laura y Marina tienen más de una fila, que es
-- lo que justifica que esto sea una entidad y no un atributo de socio.
INSERT INTO estado_socio (tipo_dni, nro_dni, fecha_modificacion, estado, modificado_por) VALUES
    ('DNI',       '30000001', '2016-03-05 10:00:00', 'Pendiente de alta', 'DNI30000004'),
    ('DNI',       '30000001', '2016-03-10 10:00:00', 'Activo',            'DNI30000004'),
    ('DNI',       '30000002', '2018-08-01 10:00:00', 'Activo',            'DNI30000004'),
    ('DNI',       '30000002', '2026-06-01 10:00:00', 'Becado',            'DNI30000004'),
    ('DNI',       '30000004', '2019-02-05 10:00:00', 'Activo',            'DNI30000004'),
    ('DNI',       '30000005', '2024-03-10 10:00:00', 'Activo',            'DNI30000004'),
    ('DNI',       '30000006', '2026-04-10 10:00:00', 'Pendiente de alta', 'DNI30000004'),
    ('CI',        '30000007', '2017-04-20 10:00:00', 'Activo',            'DNI30000004'),
    ('PASAPORTE', '30000008', '2020-06-01 10:00:00', 'Activo',            'DNI30000004'),
    ('PASAPORTE', '30000008', '2026-06-15 10:00:00', 'No activo',         'CI30000007'),
    ('DNI',       '30000010', '2022-09-12 10:00:00', 'Activo',            'DNI30000004'),
    ('DNI',       '30000011', '2026-08-20 10:00:00', 'Socio potencial',   'DNI30000004');

-- -----------------------------------------------------------------------------
-- Actividades
-- -----------------------------------------------------------------------------

INSERT INTO disciplina (nombre_disciplina) VALUES
    ('Voley'),
    ('Handball');

INSERT INTO categoria (nombre_categoria, nombre_disciplina, edad_min, edad_max, enfoque) VALUES
    ('Infantiles', 'Voley',    6,  12, 'Recreativo'),
    ('Juveniles',  'Voley',    13, 17, 'Competitivo'),
    ('Adultos',    'Voley',    18, 60, 'Competitivo'),
    ('Infantiles', 'Handball', 6,  12, 'Recreativo'),
    ('Juveniles',  'Handball', 13, 17, 'Competitivo'),
    ('Adultos',    'Handball', 18, 60, 'Competitivo');

-- Jorge está anotado en las dos disciplinas, que es lo que habilita tener la
-- disciplina dentro de la clave.
INSERT INTO pertenece (tipo_dni, nro_dni, nombre_disciplina, fecha_inscripcion) VALUES
    ('DNI',       '30000001', 'Voley',    '2016-03-10'),
    ('DNI',       '30000002', 'Handball', '2018-08-01'),
    ('DNI',       '30000004', 'Voley',    '2019-02-05'),
    ('DNI',       '30000005', 'Voley',    '2024-03-10'),
    ('DNI',       '30000006', 'Handball', '2023-05-15'),
    ('CI',        '30000007', 'Voley',    '2017-04-20'),
    ('CI',        '30000007', 'Handball', '2017-04-20'),
    ('PASAPORTE', '30000008', 'Handball', '2020-06-01'),
    ('DNI',       '30000010', 'Voley',    '2022-09-12');

-- La clave impide dos profesores con el mismo rol en la misma categoria.
INSERT INTO a_cargo (nombre_disciplina, nombre_categoria, rol_profesor, tipo_dni, nro_dni) VALUES
    ('Voley',    'Infantiles', 'Director Tecnico',  'DNI', '30000001'),
    ('Voley',    'Infantiles', 'Preparador Fisico', 'LC',  '30000003'),
    ('Voley',    'Juveniles',  'Director Tecnico',  'LC',  '30000003'),
    ('Voley',    'Adultos',    'Director Tecnico',  'DNI', '30000001'),
    ('Handball', 'Infantiles', 'Director Tecnico',  'LC',  '30000003'),
    ('Handball', 'Juveniles',  'Director Tecnico',  'DNI', '30000001'),
    ('Handball', 'Adultos',    'Director Tecnico',  'LC',  '30000003');

INSERT INTO planilla_asistencia (id_planilla, tipo_dni, nro_dni) VALUES
    (1, 'DNI', '30000001'),
    (2, 'LC',  '30000003'),
    (3, 'DNI', '30000001'),
    (4, 'LC',  '30000003'),
    (5, 'DNI', '30000001'),
    (6, 'LC',  '30000003');

INSERT INTO clase (nombre_disciplina, nombre_categoria, fecha, hora_inicio, hora_fin, id_planilla) VALUES
    ('Voley',    'Infantiles', '2026-08-03', '17:00', '18:30', 1),
    ('Voley',    'Juveniles',  '2026-08-03', '18:30', '20:00', 2),
    ('Voley',    'Adultos',    '2026-08-04', '20:00', '21:30', 3),
    ('Handball', 'Infantiles', '2026-08-05', '17:00', '18:30', 4),
    ('Handball', 'Juveniles',  '2026-08-05', '18:30', '20:00', 5),
    ('Handball', 'Adultos',    '2026-08-06', '20:00', '21:30', 6);

-- Se usan los tres estados de asistencia.
INSERT INTO detalle_asistencia (id_planilla, tipo_dni_socio, nro_dni_socio, estado_asistencia) VALUES
    (1, 'DNI',       '30000005', 'Presente'),
    (3, 'DNI',       '30000001', 'Presente'),
    (3, 'DNI',       '30000004', 'Ausente'),
    (3, 'CI',        '30000007', 'Presente'),
    (3, 'DNI',       '30000010', 'Ausente justificado'),
    (5, 'DNI',       '30000006', 'Presente'),
    (6, 'DNI',       '30000002', 'Presente'),
    (6, 'PASAPORTE', '30000008', 'Ausente'),
    (6, 'CI',        '30000007', 'Presente');

-- -----------------------------------------------------------------------------
-- Salud y seguro
-- -----------------------------------------------------------------------------

INSERT INTO medico (matricula, nombre, apellido, telefono) VALUES
    ('MP-1001', 'Silvana', 'Rios',   '299-4002001'),
    ('MP-1002', 'Ernesto', 'Vidal',  '299-4002002');

-- El de Ana es no apto, y el de Marina está vencido. La vigencia no se guarda,
-- se deduce comparando la fecha de vencimiento con la fecha actual.
INSERT INTO certificado_medico (tipo_dni, nro_dni, fecha_emision, fecha_vencimiento, es_apto, matricula) VALUES
    ('DNI',       '30000001', '2026-03-01', '2027-03-01', TRUE,  'MP-1001'),
    ('DNI',       '30000002', '2026-05-05', '2027-05-05', TRUE,  'MP-1002'),
    ('DNI',       '30000004', '2026-03-20', '2027-03-20', FALSE, 'MP-1001'),
    ('DNI',       '30000005', '2026-02-15', '2027-02-15', TRUE,  'MP-1001'),
    ('DNI',       '30000006', '2026-04-10', '2027-04-10', TRUE,  'MP-1002'),
    ('CI',        '30000007', '2026-01-20', '2027-01-20', TRUE,  'MP-1002'),
    ('PASAPORTE', '30000008', '2025-06-01', '2026-06-01', TRUE,  'MP-1001');

-- La póliza de Marina es la única con fecha de baja. En el resto ese NULL
-- significa seguro vigente, no dato desconocido.
INSERT INTO seguro (nro_poliza, tipo_dni_socio, nro_dni_socio, fecha_alta, fecha_vencimiento, fecha_baja, tipo) VALUES
    ('POL-3001', 'DNI',       '30000001', '2026-03-05', '2027-03-05', NULL,         'Responsabilidad Civil'),
    ('POL-3002', 'DNI',       '30000005', '2026-02-20', '2027-02-20', NULL,         'Accidentes Personales'),
    ('POL-3003', 'CI',        '30000007', '2026-01-25', '2027-01-25', NULL,         'Accidentes Personales'),
    ('POL-3004', 'PASAPORTE', '30000008', '2025-06-10', '2026-06-10', '2026-06-15', 'Responsabilidad Civil'),
    ('POL-3005', 'DNI',       '30000006', '2026-04-15', '2027-04-15', NULL,         'Accidentes Personales');

-- -----------------------------------------------------------------------------
-- Finanzas
-- -----------------------------------------------------------------------------
-- Laura no tiene cuotas porque está becada, y ser becado es una condición de
-- pago.

INSERT INTO cuota (id_cuota, fecha, monto, estado_de_pago, periodo, tipo_dni, nro_dni) VALUES
    (1, '2026-07-01', 15000.00, 'Saldada',    '2026-07', 'DNI',       '30000001'),
    (2, '2026-07-01', 15000.00, 'Saldada',    '2026-07', 'DNI',       '30000004'),
    (3, '2026-07-01', 12000.00, 'Saldada',    '2026-07', 'DNI',       '30000005'),
    (4, '2026-07-01', 12000.00, 'No saldada', '2026-07', 'DNI',       '30000006'),
    (5, '2026-07-01', 15000.00, 'Saldada',    '2026-07', 'CI',        '30000007'),
    (6, '2026-07-01', 15000.00, 'No saldada', '2026-07', 'PASAPORTE', '30000008'),
    (7, '2026-07-01', 15000.00, 'No saldada', '2026-07', 'DNI',       '30000010'),
    (8, '2026-08-01', 15000.00, 'No saldada', '2026-08', 'DNI',       '30000001');

-- Un pago por cuota, y solo las cuotas saldadas lo tienen.
INSERT INTO pago (id_pago, fecha_pago, monto, id_cuota) VALUES
    (1, '2026-07-05', 15000.00, 1),
    (2, '2026-07-06', 15000.00, 2),
    (3, '2026-07-04', 12000.00, 3),
    (4, '2026-07-08', 15000.00, 5);

-- -----------------------------------------------------------------------------
-- Cargos
-- -----------------------------------------------------------------------------

INSERT INTO cargo_administrativo (id_cargo, descripcion) VALUES
    (1, 'Tesorero'),
    (2, 'Recepcionista'),
    (3, 'Administrativo General');

-- El cargo 1 queda ocupado por Jorge.
INSERT INTO tiene_cargo (tipo_dni, nro_dni, id_cargo, fecha_inicio_cargo, fecha_fin_cargo) VALUES
    ('CI',  '30000007', 1, '2026-01-01', '2026-12-31'),
    ('DNI', '30000004', 3, '2026-01-01', '2026-12-31');


-- -----------------------------------------------------------------------------
-- Reinicio de los contadores
-- -----------------------------------------------------------------------------
-- Los cinco identificadores autonumerados se cargaron a mano, asi que el
-- contador interno del motor no avanzo y sigue en 1. Sin estas lineas, la
-- primera alta que no indique el identificador falla por clave duplicada.
-- Cada numero es el ultimo cargado mas uno.

ALTER TABLE notificacion         ALTER COLUMN id_notificacion RESTART WITH 6;
ALTER TABLE planilla_asistencia  ALTER COLUMN id_planilla     RESTART WITH 7;
ALTER TABLE cuota                ALTER COLUMN id_cuota        RESTART WITH 9;
ALTER TABLE pago                 ALTER COLUMN id_pago         RESTART WITH 5;
ALTER TABLE cargo_administrativo ALTER COLUMN id_cargo        RESTART WITH 4;
