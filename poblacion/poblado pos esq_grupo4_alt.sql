-- =====================================================================
-- Laboratorio de Bases de Datos - TP1 - Grupo 4
-- Sistema de Gestion de Socios, Club Deportivo Rio Negro
-- Script de poblado (INSERTs) para esq_grupo4_alt, esquema de testing
-- =====================================================================

SET search_path TO esq_grupo4_alt;

-- Las dos disciplinas del club
INSERT INTO disciplina (nombre_disciplina) VALUES
    ('Voley'),
    ('Handball');

-- Las 18 personas del esquema: 8 socios, 4 tutores externos y 6 profesores.
-- DNI en el rango 20000000 a 29999999, distinto del rango de produccion.
INSERT INTO persona (tipo_dni, nro_dni, nombre, apellido, telefono, fecha_nacimiento, mail) VALUES
    ('DNI', '20000001', 'Bruno',     'Sosa',      '1123450001', '2016-03-15', 'bruno.sosa@example.com'),
    ('DNI', '20000002', 'Martina',   'Paz',       '1123450002', '2015-11-02', 'martina.paz@example.com'),
    ('DNI', '20000003', 'Lucas',     'Fernandez', '1123450003', '2011-05-20', 'lucas.fernandez@example.com'),
    ('DNI', '20000004', 'Sofia',     'Gimenez',   '1123450004', '2010-09-10', 'sofia.gimenez@example.com'),
    ('DNI', '20000005', 'Agustin',   'Rojas',     '1123450005', '1995-04-12', 'agustin.rojas@example.com'),
    ('DNI', '20000006', 'Camila',    'Acosta',    '1123450006', '1998-07-25', 'camila.acosta@example.com'),
    ('DNI', '20000007', 'Nicolas',   'Benitez',   '1123450007', '1990-01-30', 'nicolas.benitez@example.com'),
    ('DNI', '20000008', 'Valentina', 'Herrera',   '1123450008', '2013-02-18', 'valentina.herrera@example.com'),
    ('DNI', '20000101', 'Marcelo',   'Sosa',      '1123450101', '1985-06-10', 'marcelo.sosa@example.com'),
    ('DNI', '20000102', 'Silvia',    'Duarte',    '1123450102', '1987-09-22', 'silvia.duarte@example.com'),
    ('DNI', '20000103', 'Diego',     'Paz',       '1123450103', '1983-12-01', 'diego.paz@example.com'),
    ('DNI', '20000104', 'Gabriela',  'Nunez',     '1123450104', '1988-03-14', 'gabriela.nunez@example.com'),
    ('DNI', '20000201', 'Martin',    'Ledesma',   '1123450201', '1988-02-11', 'martin.ledesma@example.com'),
    ('DNI', '20000202', 'Laura',     'Vazquez',   '1123450202', '1990-05-19', 'laura.vazquez@example.com'),
    ('DNI', '20000203', 'Fernando',  'Quiroga',   '1123450203', '1985-10-03', 'fernando.quiroga@example.com'),
    ('DNI', '20000204', 'Daniela',   'Correa',    '1123450204', '1992-01-27', 'daniela.correa@example.com'),
    ('DNI', '20000205', 'Ricardo',   'Molina',    '1123450205', '1983-08-08', 'ricardo.molina@example.com'),
    ('DNI', '20000206', 'Paula',     'Escobar',   '1123450206', '1991-11-30', 'paula.escobar@example.com');

-- Los 6 profesores, cada uno referencia su fila de persona
INSERT INTO profesor (tipo_dni, nro_dni, fecha_ingreso) VALUES
    ('DNI', '20000201', '2025-02-01'),
    ('DNI', '20000202', '2025-03-01'),
    ('DNI', '20000203', '2025-04-15'),
    ('DNI', '20000204', '2025-05-01'),
    ('DNI', '20000205', '2025-06-01'),
    ('DNI', '20000206', '2025-07-01');

-- Los 8 socios, dos menores (Bruno y Martina) y seis adultos
INSERT INTO socio (tipo_dni, nro_dni, es_federado, ddj_salud, fecha_inscripcion_club, ausencias_consecutivas) VALUES
    ('DNI', '20000001', FALSE, TRUE,  '2026-01-05', 0),
    ('DNI', '20000002', FALSE, TRUE,  '2026-01-06', 0),
    ('DNI', '20000003', TRUE,  TRUE,  '2025-08-10', 0),
    ('DNI', '20000004', TRUE,  TRUE,  '2025-09-15', 1),
    ('DNI', '20000005', TRUE,  TRUE,  '2025-06-01', 0),
    ('DNI', '20000006', TRUE,  TRUE,  '2025-07-01', 0),
    ('DNI', '20000007', FALSE, TRUE,  '2025-05-20', 2),
    ('DNI', '20000008', FALSE, FALSE, '2026-02-01', 0);

-- Los 3 medicos que emiten los certificados
INSERT INTO medico (matricula, nombre, apellido, telefono) VALUES
    ('MP20001', 'Hector',  'Aguero', '1145670001'),
    ('MP20002', 'Rosana',  'Ibarra', '1145670002'),
    ('MP20003', 'Ezequiel', 'Farias', '1145670003');

-- 3 categorias por disciplina, edades sin solaparse
INSERT INTO categoria (nombre_categoria, nombre_disciplina, edad_min, edad_max, enfoque) VALUES
    ('Mini',    'Voley',    6,  11, 'Recreativo'),
    ('Cadetes', 'Voley',    12, 17, 'Formativo'),
    ('Mayores', 'Voley',    18, 99, 'Competitivo'),
    ('Mini',    'Handball', 6,  11, 'Recreativo'),
    ('Cadetes', 'Handball', 12, 17, 'Formativo'),
    ('Mayores', 'Handball', 18, 99, 'Competitivo');

-- Los 5 roles fijos del sistema
INSERT INTO rol (nombre_rol, permisos) VALUES
    ('Socio',                   'Consulta de cuotas, clases y datos propios'),
    ('Profesor',                'Gestion de planillas y asistencia de sus clases'),
    ('Administrativa General',  'Gestion administrativa general del club'),
    ('Tesorero',                'Gestion de cuotas, pagos y finanzas'),
    ('Recepcionista',           'Atencion al socio y gestion de inscripciones');

-- Una cuenta por persona activa en el sistema, socios y profesores
INSERT INTO usuario (nombre_usuario, contrasenia, tipo_dni, nro_dni) VALUES
    ('bsosa',      'hash$socio$0001', 'DNI', '20000001'),
    ('mpaz',       'hash$socio$0002', 'DNI', '20000002'),
    ('lfernandez', 'hash$socio$0003', 'DNI', '20000003'),
    ('sgimenez',   'hash$socio$0004', 'DNI', '20000004'),
    ('arojas',     'hash$socio$0005', 'DNI', '20000005'),
    ('cacosta',    'hash$socio$0006', 'DNI', '20000006'),
    ('nbenitez',   'hash$socio$0007', 'DNI', '20000007'),
    ('vherrera',   'hash$socio$0008', 'DNI', '20000008'),
    ('mledesma',   'hash$prof$0201',  'DNI', '20000201'),
    ('lvazquez',   'hash$prof$0202',  'DNI', '20000202'),
    ('fquiroga',   'hash$prof$0203',  'DNI', '20000203'),
    ('dcorrea',    'hash$prof$0204',  'DNI', '20000204'),
    ('rmolina',    'hash$prof$0205',  'DNI', '20000205'),
    ('pescobar',   'hash$prof$0206',  'DNI', '20000206');

-- Rol base de cada usuario, mas 3 socios con un rol administrativo extra
INSERT INTO tiene_rol (nombre_rol, nombre_usuario, fecha) VALUES
    ('Socio', 'bsosa',      '2026-01-05'),
    ('Socio', 'mpaz',       '2026-01-06'),
    ('Socio', 'lfernandez', '2025-08-10'),
    ('Socio', 'sgimenez',   '2025-09-15'),
    ('Socio', 'arojas',     '2025-06-01'),
    ('Socio', 'cacosta',    '2025-07-01'),
    ('Socio', 'nbenitez',   '2025-05-20'),
    ('Socio', 'vherrera',   '2026-02-01'),
    ('Profesor', 'mledesma', '2025-02-01'),
    ('Profesor', 'lvazquez', '2025-03-01'),
    ('Profesor', 'fquiroga', '2025-04-15'),
    ('Profesor', 'dcorrea',  '2025-05-01'),
    ('Profesor', 'rmolina',  '2025-06-01'),
    ('Profesor', 'pescobar', '2025-07-01'),
    ('Tesorero',               'arojas',   '2025-06-01'),
    ('Recepcionista',          'cacosta',  '2025-07-01'),
    ('Administrativa General', 'nbenitez', '2025-05-20');

-- id_notificacion se inserta explicito porque no hay otra tabla que lo referencie,
-- pero igual queda entre las 5 columnas SERIAL a resincronizar al final
INSERT INTO notificacion (id_notificacion, tipo, mensaje, fecha, nombre_usuario) VALUES
    (1, 'Recordatorio',  'Tu cuota de agosto vence pronto',       '2026-08-25 10:00:00', 'lfernandez'),
    (2, 'Aviso',         'Certificado medico proximo a vencer',   '2026-08-20 09:30:00', 'arojas'),
    (3, 'Confirmacion',  'Pago registrado correctamente',         '2026-08-05 14:15:00', 'sgimenez'),
    (4, 'Aviso',         'Nueva clase agregada al cronograma',    '2026-08-01 08:00:00', 'fquiroga'),
    (5, 'Recordatorio',  'Actualizar declaracion jurada de salud','2026-08-15 11:45:00', 'vherrera');

-- Los dos socios menores (Bruno y Martina) con sus dos tutores cada uno
INSERT INTO tiene_tutor (tipo_dni_socio, nro_dni_socio, parentesco, tipo_dni_tutor, nro_dni_tutor) VALUES
    ('DNI', '20000001', 'Padre', 'DNI', '20000101'),
    ('DNI', '20000001', 'Madre', 'DNI', '20000102'),
    ('DNI', '20000002', 'Padre', 'DNI', '20000103'),
    ('DNI', '20000002', 'Madre', 'DNI', '20000104');

-- Un estado de alta por socio, cargado por alguna cuenta administrativa
INSERT INTO estado_socio (tipo_dni, nro_dni, fecha_modificacion, estado, modificado_por) VALUES
    ('DNI', '20000001', '2026-01-05 09:00:00', 'Activo', 'cacosta'),
    ('DNI', '20000002', '2026-01-06 09:10:00', 'Activo', 'cacosta'),
    ('DNI', '20000003', '2025-08-10 10:00:00', 'Activo', 'nbenitez'),
    ('DNI', '20000004', '2025-09-15 10:00:00', 'Activo', 'nbenitez'),
    ('DNI', '20000005', '2025-06-01 11:00:00', 'Activo', 'arojas'),
    ('DNI', '20000006', '2025-07-01 11:30:00', 'Activo', 'arojas'),
    ('DNI', '20000007', '2025-05-20 12:00:00', 'Activo', 'cacosta'),
    ('DNI', '20000008', '2026-02-01 09:45:00', 'Activo', 'nbenitez');

-- Cada socio en su disciplina; Agustin Rojas practica las dos
INSERT INTO pertenece (tipo_dni, nro_dni, nombre_disciplina, fecha_inscripcion) VALUES
    ('DNI', '20000001', 'Voley',    '2026-01-05'),
    ('DNI', '20000002', 'Handball', '2026-01-06'),
    ('DNI', '20000003', 'Voley',    '2025-08-10'),
    ('DNI', '20000004', 'Handball', '2025-09-15'),
    ('DNI', '20000005', 'Voley',    '2025-06-01'),
    ('DNI', '20000005', 'Handball', '2025-06-15'),
    ('DNI', '20000006', 'Handball', '2025-07-01'),
    ('DNI', '20000007', 'Voley',    '2025-05-20'),
    ('DNI', '20000008', 'Handball', '2026-02-01');

-- Director Tecnico y Preparador Fisico para las 6 combinaciones disciplina/categoria
INSERT INTO a_cargo (nombre_disciplina, nombre_categoria, rol_profesor, tipo_dni, nro_dni) VALUES
    ('Voley',    'Mini',    'Director Tecnico',  'DNI', '20000201'),
    ('Voley',    'Mini',    'Preparador Fisico',  'DNI', '20000202'),
    ('Voley',    'Cadetes', 'Director Tecnico',  'DNI', '20000203'),
    ('Voley',    'Cadetes', 'Preparador Fisico',  'DNI', '20000201'),
    ('Voley',    'Mayores', 'Director Tecnico',  'DNI', '20000204'),
    ('Voley',    'Mayores', 'Preparador Fisico',  'DNI', '20000202'),
    ('Handball', 'Mini',    'Director Tecnico',  'DNI', '20000205'),
    ('Handball', 'Mini',    'Preparador Fisico',  'DNI', '20000206'),
    ('Handball', 'Cadetes', 'Director Tecnico',  'DNI', '20000203'),
    ('Handball', 'Cadetes', 'Preparador Fisico',  'DNI', '20000205'),
    ('Handball', 'Mayores', 'Director Tecnico',  'DNI', '20000206'),
    ('Handball', 'Mayores', 'Preparador Fisico',  'DNI', '20000204');

-- id_planilla se inserta explicito porque clase la referencia despues
INSERT INTO planilla_asistencia (id_planilla, tipo_dni, nro_dni) VALUES
    (1, 'DNI', '20000201'),
    (2, 'DNI', '20000203'),
    (3, 'DNI', '20000204'),
    (4, 'DNI', '20000205'),
    (5, 'DNI', '20000203'),
    (6, 'DNI', '20000206');

-- Una clase por combinacion disciplina/categoria, cada una con su planilla unica
INSERT INTO clase (nombre_disciplina, nombre_categoria, fecha, hora_inicio, hora_fin, id_planilla) VALUES
    ('Voley',    'Mini',    '2026-08-03', '16:00', '17:00', 1),
    ('Voley',    'Cadetes', '2026-08-04', '17:00', '18:30', 2),
    ('Voley',    'Mayores', '2026-08-05', '18:30', '20:00', 3),
    ('Handball', 'Mini',    '2026-08-03', '16:00', '17:00', 4),
    ('Handball', 'Cadetes', '2026-08-04', '17:00', '18:30', 5),
    ('Handball', 'Mayores', '2026-08-05', '18:30', '20:00', 6);

-- Asistencia solo de socios que pertenecen a la disciplina de cada clase
INSERT INTO detalle_asistencia (id_planilla, tipo_dni_socio, nro_dni_socio, estado_asistencia) VALUES
    (1, 'DNI', '20000001', 'Presente'),
    (2, 'DNI', '20000003', 'Presente'),
    (3, 'DNI', '20000005', 'Presente'),
    (3, 'DNI', '20000007', 'Ausente'),
    (4, 'DNI', '20000002', 'Presente'),
    (5, 'DNI', '20000004', 'Presente'),
    (5, 'DNI', '20000008', 'Presente'),
    (6, 'DNI', '20000006', 'Presente'),
    (6, 'DNI', '20000005', 'Presente');

-- Certificados vigentes o vencidos, siempre con emision antes que vencimiento
INSERT INTO certificado_medico (tipo_dni, nro_dni, fecha_emision, fecha_vencimiento, es_apto, matricula) VALUES
    ('DNI', '20000001', '2026-02-10', '2026-08-10', TRUE,  'MP20001'),
    ('DNI', '20000002', '2026-01-15', '2026-07-15', TRUE,  'MP20002'),
    ('DNI', '20000003', '2025-09-01', '2026-03-01', TRUE,  'MP20001'),
    ('DNI', '20000004', '2026-03-20', '2026-09-20', TRUE,  'MP20003'),
    ('DNI', '20000005', '2025-11-05', '2026-05-05', FALSE, 'MP20002'),
    ('DNI', '20000006', '2026-04-12', '2026-10-12', TRUE,  'MP20003');

-- Polizas de seguro, fecha_baja y fecha_vencimiento siempre posteriores o iguales al alta
INSERT INTO seguro (nro_poliza, tipo_dni_socio, nro_dni_socio, fecha_alta, fecha_vencimiento, fecha_baja, tipo) VALUES
    ('POL-20001', 'DNI', '20000001', '2026-01-01', '2026-12-31', NULL,         'Accidentes Personales'),
    ('POL-20002', 'DNI', '20000003', '2025-06-01', '2026-06-01', NULL,         'Accidentes Personales'),
    ('POL-20003', 'DNI', '20000005', '2025-08-15', NULL,         NULL,         'Responsabilidad Civil'),
    ('POL-20004', 'DNI', '20000006', '2026-02-20', '2026-08-20', '2026-08-25', 'Accidentes Personales');

-- id_cuota se inserta explicito porque pago la referencia despues
INSERT INTO cuota (id_cuota, fecha, monto, estado_de_pago, periodo, tipo_dni, nro_dni) VALUES
    (1, '2026-08-01', 15000.00, 'Pagada',    '2026-08', 'DNI', '20000001'),
    (2, '2026-08-01', 15000.00, 'Pagada',    '2026-08', 'DNI', '20000002'),
    (3, '2026-08-01', 18000.00, 'Pendiente', '2026-08', 'DNI', '20000003'),
    (4, '2026-08-01', 18000.00, 'Pagada',    '2026-08', 'DNI', '20000004'),
    (5, '2026-07-01', 22000.00, 'Pagada',    '2026-07', 'DNI', '20000005'),
    (6, '2026-07-01', 22000.00, 'Pendiente', '2026-07', 'DNI', '20000006'),
    (7, '2026-08-01', 22000.00, 'Pagada',    '2026-08', 'DNI', '20000007'),
    (8, '2026-07-01', 18000.00, 'Vencida',   '2026-07', 'DNI', '20000008');

-- id_pago se inserta explicito; una fila por cada cuota marcada Pagada, id_cuota nunca se repite
INSERT INTO pago (id_pago, fecha_pago, monto, id_cuota) VALUES
    (1, '2026-08-02', 15000.00, 1),
    (2, '2026-08-03', 15000.00, 2),
    (3, '2026-08-05', 18000.00, 4),
    (4, '2026-07-05', 22000.00, 5),
    (5, '2026-08-04', 22000.00, 7);

-- id_cargo se inserta explicito porque tiene_cargo lo referencia despues
INSERT INTO cargo_administrativo (id_cargo, descripcion) VALUES
    (1, 'Tesorero'),
    (2, 'Recepcionista'),
    (3, 'Administrativo General');

-- Tres cargos vigentes (fecha_fin_cargo NULL) y uno ya cerrado
INSERT INTO tiene_cargo (tipo_dni, nro_dni, id_cargo, fecha_inicio_cargo, fecha_fin_cargo) VALUES
    ('DNI', '20000005', 1, '2025-06-01', NULL),
    ('DNI', '20000006', 2, '2025-07-01', NULL),
    ('DNI', '20000007', 3, '2025-01-10', NULL),
    ('DNI', '20000005', 2, '2025-01-01', '2025-05-30');

-- Resincronizar las 5 secuencias SERIAL que se cargaron con valor explicito
SELECT setval(pg_get_serial_sequence('cuota', 'id_cuota'), (SELECT MAX(id_cuota) FROM cuota));
SELECT setval(pg_get_serial_sequence('pago', 'id_pago'), (SELECT MAX(id_pago) FROM pago));
SELECT setval(pg_get_serial_sequence('planilla_asistencia', 'id_planilla'), (SELECT MAX(id_planilla) FROM planilla_asistencia));
SELECT setval(pg_get_serial_sequence('cargo_administrativo', 'id_cargo'), (SELECT MAX(id_cargo) FROM cargo_administrativo));
SELECT setval(pg_get_serial_sequence('notificacion', 'id_notificacion'), (SELECT MAX(id_notificacion) FROM notificacion));