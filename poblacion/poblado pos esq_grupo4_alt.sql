-- =====================================================================
-- Laboratorio de Bases de Datos - TP1 - Grupo 4
-- Sistema de Gestion de Socios, Club Deportivo Rio Negro
-- Script de poblado (INSERTs) para esq_grupo4_alt
-- =====================================================================

SET search_path TO esq_grupo4_alt;

-- Las 10 personas del esquema. DNI en el rango 20000000 a 29999999.
-- Gabriel Quiroga y Silvina Paz son profesores que ademas son socios.
INSERT INTO persona (tipo_dni, nro_dni, nombre, apellido, telefono, fecha_nacimiento, mail) VALUES
    ('DNI',       '20000001', 'Gabriel',   'Quiroga',    '2984300001', '1982-06-18', 'gabriel.quiroga@rionegroclub.com'),
    ('DNI',       '20000002', 'Silvina',   'Paz',        '2984300002', '1990-02-27', 'silvina.paz@rionegroclub.com'),
    ('LC',        '20000003', 'Emiliano',  'Vega',       '2984300003', '1987-10-03', 'emiliano.vega@rionegroclub.com'),
    ('CI',        '20000004', 'Marisol',   'Aguirre',    '2984300004', '1993-08-14', 'marisol.aguirre@rionegroclub.com'),
    ('DNI',       '20000005', 'Tomas',     'Ledesma',    NULL,         '2014-09-05', NULL),
    ('DNI',       '20000006', 'Julieta',   'Barros',     NULL,         '2010-12-11', NULL),
    ('DNI',       '20000007', 'Ramiro',    'Cabrera',    '2984300007', '1998-04-22', 'ramiro.cabrera@mail.com'),
    ('LE',        '20000008', 'Florencia', 'Godoy',      '2984300008', '1979-07-30', 'florencia.godoy@mail.com'),
    ('DNI',       '20000009', 'Ivan',      'Peralta',    '2984300009', '1995-11-08', 'ivan.peralta@mail.com'),
    ('PASAPORTE', '20000010', 'Andrea',    'Maldonado',  '2984300010', '1984-01-19', 'andrea.maldonado@mail.com');

-- Los 4 profesores, cada uno referencia su fila de persona
INSERT INTO profesor (tipo_dni, nro_dni, fecha_ingreso) VALUES
    ('DNI', '20000001', '2017-02-15'),
    ('DNI', '20000002', '2019-05-20'),
    ('LC',  '20000003', '2021-08-02'),
    ('CI',  '20000004', '2023-03-13');

-- Los 8 socios. Tomas (11) y Julieta (15) son menores, el resto son adultos
INSERT INTO socio (tipo_dni, nro_dni, es_federado, ddj_salud, fecha_inscripcion_club, ausencias_consecutivas) VALUES
    ('DNI',       '20000001', TRUE,  TRUE,  '2017-03-01', 0),
    ('DNI',       '20000002', TRUE,  TRUE,  '2019-06-01', 0),
    ('DNI',       '20000005', FALSE, TRUE,  '2025-03-20', 1),
    ('DNI',       '20000006', TRUE,  TRUE,  '2022-08-10', 0),
    ('DNI',       '20000007', FALSE, TRUE,  '2024-02-05', 4),
    ('LE',        '20000008', TRUE,  TRUE,  '2023-09-01', 0),
    ('DNI',       '20000009', FALSE, FALSE, '2025-04-01', 2),
    ('PASAPORTE', '20000010', TRUE,  TRUE,  '2021-11-15', 0);

-- Una cuenta por persona activa en el sistema, 4 profesores y 2 socios administrativos
INSERT INTO usuario (nombre_usuario, contrasenia, tipo_dni, nro_dni) VALUES
    ('gquiroga', 'hash$prof$1001',  'DNI', '20000001'),
    ('spaz',     'hash$prof$1002',  'DNI', '20000002'),
    ('evega',    'hash$prof$1003',  'LC',  '20000003'),
    ('maguirre', 'hash$prof$1004',  'CI',  '20000004'),
    ('rcabrera', 'hash$socio$1007', 'DNI', '20000007'),
    ('fgodoy',   'hash$socio$1008', 'LE',  '20000008');

-- Los 5 roles fijos del sistema
INSERT INTO rol (nombre_rol, permisos) VALUES
    ('Socio',                  'Consulta de cuotas, clases y datos propios'),
    ('Profesor',               'Gestion de planillas y asistencia de sus clases'),
    ('Administrativa General', 'Gestion administrativa general del club'),
    ('Tesorero',               'Gestion de cuotas, pagos y finanzas'),
    ('Recepcionista',          'Atencion al socio y gestion de inscripciones');

-- Rol base de cada usuario segun su funcion
INSERT INTO tiene_rol (nombre_rol, nombre_usuario, fecha) VALUES
    ('Profesor',               'gquiroga', '2017-02-15'),
    ('Profesor',               'spaz',     '2019-05-20'),
    ('Profesor',               'evega',    '2021-08-02'),
    ('Profesor',               'maguirre', '2023-03-13'),
    ('Tesorero',               'rcabrera', '2024-02-01'),
    ('Administrativa General', 'fgodoy',   '2023-09-01');

-- id_notificacion se inserta explicito porque es una de las 5 columnas SERIAL
-- a resincronizar al final, aunque ninguna otra tabla la referencie
INSERT INTO notificacion (id_notificacion, tipo, mensaje, fecha, nombre_usuario) VALUES
    (1, 'Aviso',        'Cambio de horario en la clase de Mayores', '2026-04-02 09:00:00', 'gquiroga'),
    (2, 'Recordatorio', 'Cuota de abril impaga',                    '2026-04-10 11:30:00', 'rcabrera'),
    (3, 'Alerta',       'Socio con ausencias consecutivas',         '2026-04-12 16:45:00', 'fgodoy'),
    (4, 'Confirmacion', 'Seguro dado de alta',                      '2026-04-15 10:20:00', 'fgodoy'),
    (5, 'Aviso',        'Certificado medico vencido',               '2026-04-18 08:15:00', 'maguirre');

-- Tomas tiene Padre y Madre, distintos parentescos, hasta 2 tutores por socio.
-- Julieta tiene un solo tutor cargado. Los tutores son personas ya existentes en el esquema.
INSERT INTO tiene_tutor (tipo_dni_socio, nro_dni_socio, parentesco, tipo_dni_tutor, nro_dni_tutor) VALUES
    ('DNI', '20000005', 'Padre', 'DNI',       '20000009'),
    ('DNI', '20000005', 'Madre', 'PASAPORTE', '20000010'),
    ('DNI', '20000006', 'Madre', 'LE',        '20000008');

-- Un estado de alta por socio, cargado por alguna cuenta administrativa
INSERT INTO estado_socio (tipo_dni, nro_dni, fecha_modificacion, estado, modificado_por) VALUES
    ('DNI',       '20000001', '2017-03-01 10:00:00', 'Activo',     'fgodoy'),
    ('DNI',       '20000002', '2019-06-01 10:00:00', 'Activo',     'fgodoy'),
    ('DNI',       '20000005', '2025-03-20 10:00:00', 'Activo',     'fgodoy'),
    ('DNI',       '20000006', '2022-08-10 10:00:00', 'Activo',     'fgodoy'),
    ('DNI',       '20000007', '2026-03-01 15:00:00', 'Suspendido', 'rcabrera'),
    ('LE',        '20000008', '2023-09-01 10:00:00', 'Activo',     'fgodoy'),
    ('DNI',       '20000009', '2025-04-01 10:00:00', 'Activo',     'fgodoy'),
    ('PASAPORTE', '20000010', '2021-11-15 10:00:00', 'Activo',     'fgodoy');

-- Las dos disciplinas del club
INSERT INTO disciplina (nombre_disciplina) VALUES
    ('Voley'),
    ('Handball');

-- 3 categorias por disciplina, edades sin solaparse
INSERT INTO categoria (nombre_categoria, nombre_disciplina, edad_min, edad_max, enfoque) VALUES
    ('Mini',    'Voley',    6,  11, 'Recreativo'),
    ('Cadetes', 'Voley',    12, 17, 'Formativo'),
    ('Mayores', 'Voley',    18, 65, 'Competitivo'),
    ('Mini',    'Handball', 6,  11, 'Recreativo'),
    ('Cadetes', 'Handball', 12, 17, 'Formativo'),
    ('Mayores', 'Handball', 18, 65, 'Competitivo');

-- Cada socio en su disciplina. La edad de cada uno cae en el rango de su categoria
INSERT INTO pertenece (tipo_dni, nro_dni, nombre_disciplina, fecha_inscripcion) VALUES
    ('DNI',       '20000001', 'Voley',    '2017-03-05'),
    ('DNI',       '20000002', 'Handball', '2019-06-05'),
    ('DNI',       '20000005', 'Voley',    '2025-03-25'),
    ('DNI',       '20000006', 'Handball', '2022-08-15'),
    ('DNI',       '20000007', 'Voley',    '2024-02-10'),
    ('LE',        '20000008', 'Handball', '2023-09-05'),
    ('DNI',       '20000009', 'Voley',    '2025-04-05'),
    ('PASAPORTE', '20000010', 'Handball', '2021-11-20');

-- Director Tecnico y Preparador Fisico por combinacion disciplina/categoria,
-- nunca se repite el mismo rol en la misma categoria
INSERT INTO a_cargo (nombre_disciplina, nombre_categoria, rol_profesor, tipo_dni, nro_dni) VALUES
    ('Voley',    'Mini',    'Director Tecnico',  'DNI', '20000001'),
    ('Voley',    'Mini',    'Preparador Fisico', 'LC',  '20000003'),
    ('Voley',    'Cadetes', 'Director Tecnico',  'LC',  '20000003'),
    ('Voley',    'Cadetes', 'Preparador Fisico', 'DNI', '20000001'),
    ('Voley',    'Mayores', 'Director Tecnico',  'DNI', '20000001'),
    ('Handball', 'Mini',    'Director Tecnico',  'DNI', '20000002'),
    ('Handball', 'Mini',    'Preparador Fisico', 'CI',  '20000004'),
    ('Handball', 'Cadetes', 'Director Tecnico',  'CI',  '20000004'),
    ('Handball', 'Mayores', 'Director Tecnico',  'DNI', '20000002'),
    ('Handball', 'Mayores', 'Preparador Fisico', 'CI',  '20000004');

-- id_planilla se inserta explicito porque clase la referencia despues
INSERT INTO planilla_asistencia (id_planilla, tipo_dni, nro_dni) VALUES
    (1, 'DNI', '20000001'),
    (2, 'LC',  '20000003'),
    (3, 'DNI', '20000001'),
    (4, 'DNI', '20000002'),
    (5, 'CI',  '20000004'),
    (6, 'DNI', '20000002');

-- Las 4 canchas del club. id_cancha es IDENTITY, no se inserta explicito
INSERT INTO cancha (s_nombre) VALUES
    ('Gimnasio Cubierto A'),
    ('Gimnasio Cubierto B'),
    ('Cancha Exterior Norte'),
    ('Cancha Exterior Sur');

-- Una clase por combinacion disciplina/categoria, cada una con su planilla unica
-- y su cancha asignada segun disciplina (id_cancha 1-2 Voley, 3-4 Handball)
INSERT INTO clase (nombre_disciplina, nombre_categoria, fecha, hora_inicio, hora_fin, id_planilla, id_cancha) VALUES
    ('Voley',    'Mini',    '2026-04-07', '17:00', '19:00', 1, 1),
    ('Voley',    'Cadetes', '2026-04-08', '17:00', '19:00', 2, 2),
    ('Voley',    'Mayores', '2026-04-09', '19:00', '21:00', 3, 1),
    ('Handball', 'Mini',    '2026-04-07', '17:00', '19:00', 4, 3),
    ('Handball', 'Cadetes', '2026-04-08', '17:00', '19:00', 5, 4),
    ('Handball', 'Mayores', '2026-04-09', '19:00', '21:00', 6, 3);

-- Asistencia solo de socios que pertenecen a la disciplina de cada clase
INSERT INTO detalle_asistencia (id_planilla, tipo_dni_socio, nro_dni_socio, estado_asistencia) VALUES
    (1, 'DNI',       '20000005', 'Presente'),
    (3, 'DNI',       '20000001', 'Presente'),
    (3, 'DNI',       '20000007', 'Ausente'),
    (3, 'DNI',       '20000009', 'Presente'),
    (5, 'DNI',       '20000006', 'Presente'),
    (6, 'DNI',       '20000002', 'Presente'),
    (6, 'LE',        '20000008', 'Presente'),
    (6, 'PASAPORTE', '20000010', 'Ausente');

-- Los 2 medicos que emiten los certificados
INSERT INTO medico (matricula, nombre, apellido, telefono) VALUES
    ('MP20111', 'Hernan',  'Cabezas', '2984400001'),
    ('MP20478', 'Lucrecia', 'Ordoñez', '2984400002');

-- Certificados vigentes o vencidos, siempre con emision antes que vencimiento
INSERT INTO certificado_medico (tipo_dni, nro_dni, fecha_emision, fecha_vencimiento, es_apto, matricula) VALUES
    ('DNI',       '20000001', '2025-04-01', '2026-04-01', TRUE,  'MP20111'),
    ('DNI',       '20000002', '2025-05-10', '2026-05-10', TRUE,  'MP20478'),
    ('DNI',       '20000005', '2025-09-01', '2026-09-01', TRUE,  'MP20111'),
    ('DNI',       '20000006', '2025-10-15', '2026-10-15', TRUE,  'MP20478'),
    ('DNI',       '20000007', '2025-02-20', '2026-02-20', FALSE, 'MP20111'),
    ('LE',        '20000008', '2025-11-01', '2026-11-01', TRUE,  'MP20478'),
    ('DNI',       '20000009', '2025-06-15', '2025-12-15', FALSE, 'MP20111'),
    ('PASAPORTE', '20000010', '2025-12-01', '2026-12-01', TRUE,  'MP20478');

-- Polizas de seguro, fecha_baja y fecha_vencimiento siempre posteriores o iguales al alta
INSERT INTO seguro (nro_poliza, tipo_dni_socio, nro_dni_socio, fecha_alta, fecha_vencimiento, fecha_baja, tipo) VALUES
    ('POL-2001', 'DNI',       '20000001', '2017-03-10', NULL,         NULL,         'Responsabilidad Civil'),
    ('POL-2002', 'DNI',       '20000002', '2019-06-10', NULL,         NULL,         'Responsabilidad Civil'),
    ('POL-2003', 'DNI',       '20000007', '2024-02-15', '2026-02-15', '2026-03-01', 'Accidentes Personales'),
    ('POL-2004', 'LE',        '20000008', '2023-09-10', '2026-09-10', NULL,         'Accidentes Personales'),
    ('POL-2005', 'PASAPORTE', '20000010', '2021-11-25', '2026-11-25', NULL,         'Responsabilidad Civil');

-- id_cuota se inserta explicito porque pago la referencia despues
INSERT INTO cuota (id_cuota, fecha, monto, estado_de_pago, periodo, tipo_dni, nro_dni) VALUES
    (1, '2026-03-01', 18000.00, 'Pagada',    '2026-03', 'DNI',       '20000001'),
    (2, '2026-03-01', 18000.00, 'Pagada',    '2026-03', 'DNI',       '20000002'),
    (3, '2026-03-01', 10500.00, 'Pagada',    '2026-03', 'DNI',       '20000005'),
    (4, '2026-03-01', 12500.00, 'Pendiente', '2026-03', 'DNI',       '20000006'),
    (5, '2026-03-01', 16000.00, 'Pendiente', '2026-03', 'DNI',       '20000007'),
    (6, '2026-03-01', 16000.00, 'Pagada',    '2026-03', 'LE',        '20000008'),
    (7, '2026-04-01', 17500.00, 'Pendiente', '2026-04', 'DNI',       '20000009'),
    (8, '2026-04-01', 17500.00, 'Pagada',    '2026-04', 'PASAPORTE', '20000010');

-- id_pago se inserta explicito; una fila por cada cuota Pagada, id_cuota nunca se repite
INSERT INTO pago (id_pago, fecha_pago, monto, id_cuota) VALUES
    (1, '2026-03-04', 18000.00, 1),
    (2, '2026-03-05', 18000.00, 2),
    (3, '2026-03-07', 10500.00, 3),
    (4, '2026-03-09', 16000.00, 6),
    (5, '2026-04-06', 17500.00, 8);

-- id_cargo se inserta explicito porque tiene_cargo lo referencia despues
INSERT INTO cargo_administrativo (id_cargo, descripcion) VALUES
    (1, 'Tesorero'),
    (2, 'Recepcionista'),
    (3, 'Administrativo General');

-- Un cargo por socio administrativo, con su periodo de ejercicio
INSERT INTO tiene_cargo (tipo_dni, nro_dni, id_cargo, fecha_inicio_cargo, fecha_fin_cargo) VALUES
    ('DNI', '20000007', 1, '2024-02-01', '2026-01-31'),
    ('DNI', '20000009', 2, '2025-04-01', '2026-03-31'),
    ('LE',  '20000008', 3, '2023-09-01', '2025-08-31');

-- Resincronizar las 5 secuencias SERIAL que se cargaron con valor explicito
SELECT setval(pg_get_serial_sequence('cuota', 'id_cuota'), (SELECT MAX(id_cuota) FROM cuota));
SELECT setval(pg_get_serial_sequence('pago', 'id_pago'), (SELECT MAX(id_pago) FROM pago));
SELECT setval(pg_get_serial_sequence('planilla_asistencia', 'id_planilla'), (SELECT MAX(id_planilla) FROM planilla_asistencia));
SELECT setval(pg_get_serial_sequence('cargo_administrativo', 'id_cargo'), (SELECT MAX(id_cargo) FROM cargo_administrativo));
SELECT setval(pg_get_serial_sequence('notificacion', 'id_notificacion'), (SELECT MAX(id_notificacion) FROM notificacion));
