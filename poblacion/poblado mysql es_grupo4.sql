-- Pararse en la base esq_grupo4 antes de correr esto.

-- Las 8 personas del esquema. DNI en el rango 30000000 a 39999999.
-- Martin Sosa y Laura Fernandez son profesores que ademas son socios.
INSERT INTO persona (tipo_dni, nro_dni, nombre, apellido, telefono, fecha_nacimiento, mail) VALUES
    ('DNI',       '30000001', 'Martin',   'Sosa',      '2984100001', '1985-04-12', 'martin.sosa@rionegroclub.com'),
    ('DNI',       '30000002', 'Laura',    'Fernandez', '2984100002', '1988-09-23', 'laura.fernandez@rionegroclub.com'),
    ('LC',        '30000003', 'Diego',    'Molina',    '2984100003', '1990-01-05', 'diego.molina@rionegroclub.com'),
    ('LE',        '30000004', 'Carla',    'Rios',      '2984100004', '1983-11-30', 'carla.rios@rionegroclub.com'),
    ('DNI',       '30000005', 'Bautista', 'Alvarez',   NULL,         '2016-03-15', NULL),
    ('DNI',       '30000006', 'Camila',   'Ferreyra',  NULL,         '2011-05-20', NULL),
    ('CI',        '30000007', 'Jorge',    'Alvarez',   '2984100007', '1996-01-10', 'jorge.alvarez@mail.com'),
    ('PASAPORTE', '30000008', 'Nicolas',  'Ferreyra',  '2984100008', '1986-03-09', 'nicolas.ferreyra@mail.com');

-- Los 4 profesores, cada uno referencia su fila de persona
INSERT INTO profesor (tipo_dni, nro_dni, fecha_ingreso) VALUES
    ('DNI', '30000001', '2016-03-01'),
    ('DNI', '30000002', '2018-07-15'),
    ('LC',  '30000003', '2020-02-10'),
    ('LE',  '30000004', '2022-09-01');

-- Los 6 socios. Bautista (10) y Camila (15) son menores, el resto son adultos
INSERT INTO socio (tipo_dni, nro_dni, es_federado, ddj_salud, fecha_inscripcion_club, ausencias_consecutivas) VALUES
    ('DNI',       '30000001', TRUE,  TRUE,  '2016-04-01', 0),
    ('DNI',       '30000002', FALSE, TRUE,  '2018-08-01', 1),
    ('DNI',       '30000005', FALSE, TRUE,  '2024-03-10', 0),
    ('DNI',       '30000006', TRUE,  TRUE,  '2023-05-15', 2),
    ('CI',        '30000007', FALSE, FALSE, '2025-01-15', 0),
    ('PASAPORTE', '30000008', TRUE,  TRUE,  '2024-06-01', 3);

-- Una cuenta por persona activa en el sistema, 3 profesores y 2 socios administrativos
INSERT INTO usuario (nombre_usuario, contrasenia, tipo_dni, nro_dni) VALUES
    ('msosa',      'hash$prof$0001',  'DNI',       '30000001'),
    ('lfernandez', 'hash$prof$0002',  'DNI',       '30000002'),
    ('dmolina',    'hash$prof$0003',  'LC',        '30000003'),
    ('jalvarez',   'hash$socio$0007', 'CI',        '30000007'),
    ('nferreyra',  'hash$socio$0008', 'PASAPORTE', '30000008');

-- Los 5 roles fijos del sistema
INSERT INTO rol (nombre_rol, permisos) VALUES
    ('Socio',                  'Consulta de cuotas, clases y datos propios'),
    ('Profesor',               'Gestion de planillas y asistencia de sus clases'),
    ('Administrativa General', 'Gestion administrativa general del club'),
    ('Tesorero',               'Gestion de cuotas, pagos y finanzas'),
    ('Recepcionista',          'Atencion al socio y gestion de inscripciones');

-- Rol base de cada usuario segun su funcion
INSERT INTO tiene_rol (nombre_rol, nombre_usuario, fecha) VALUES
    ('Profesor',      'msosa',      '2016-03-01'),
    ('Profesor',      'lfernandez', '2018-07-15'),
    ('Profesor',      'dmolina',    '2020-02-10'),
    ('Tesorero',      'jalvarez',   '2025-01-10'),
    ('Recepcionista', 'nferreyra',  '2025-02-01');

-- id_notificacion se inserta explicito, ya deja el AUTO_INCREMENT en el valor correcto
INSERT INTO notificacion (id_notificacion, tipo, mensaje, fecha, nombre_usuario) VALUES
    (1, 'Recordatorio', 'Su cuota de agosto vence pronto',      '2026-08-25 10:00:00', 'jalvarez'),
    (2, 'Aviso',        'Nueva clase agregada al cronograma',   '2026-08-01 08:00:00', 'msosa'),
    (3, 'Confirmacion', 'Pago registrado correctamente',        '2026-08-05 14:15:00', 'nferreyra'),
    (4, 'Aviso',        'Certificado medico proximo a vencer',  '2026-08-15 09:30:00', 'dmolina');

-- Bautista tiene Padre y Madre, distintos parentescos, hasta 2 tutores por socio.
-- Camila tiene un solo tutor cargado. Los tutores son personas ya existentes en el esquema.
INSERT INTO tiene_tutor (tipo_dni_socio, nro_dni_socio, parentesco, tipo_dni_tutor, nro_dni_tutor) VALUES
    ('DNI', '30000005', 'Padre', 'CI',  '30000007'),
    ('DNI', '30000005', 'Madre', 'DNI', '30000002'),
    ('DNI', '30000006', 'Padre', 'PASAPORTE', '30000008');

-- Un estado de alta por socio, cargado por alguna cuenta administrativa
INSERT INTO estado_socio (tipo_dni, nro_dni, fecha_modificacion, estado, modificado_por) VALUES
    ('DNI',       '30000001', '2016-04-01 10:00:00', 'Activo',     'nferreyra'),
    ('DNI',       '30000002', '2018-08-01 10:00:00', 'Activo',     'nferreyra'),
    ('DNI',       '30000005', '2024-03-10 10:00:00', 'Activo',     'nferreyra'),
    ('DNI',       '30000006', '2023-05-15 10:00:00', 'Activo',     'nferreyra'),
    ('CI',        '30000007', '2025-01-15 10:00:00', 'Activo',     'jalvarez'),
    ('PASAPORTE', '30000008', '2026-02-01 09:30:00', 'Suspendido', 'nferreyra');

-- Las dos disciplinas del club
INSERT INTO disciplina (nombre_disciplina) VALUES
    ('Voley'),
    ('Handball');

-- 3 categorias por disciplina, edades sin solaparse
INSERT INTO categoria (nombre_categoria, nombre_disciplina, edad_min, edad_max, enfoque) VALUES
    ('Infantiles', 'Voley',    6,  12, 'Recreativo'),
    ('Juveniles',  'Voley',    13, 17, 'Formativo'),
    ('Adultos',    'Voley',    18, 60, 'Competitivo'),
    ('Infantiles', 'Handball', 6,  12, 'Recreativo'),
    ('Juveniles',  'Handball', 13, 17, 'Formativo'),
    ('Adultos',    'Handball', 18, 60, 'Competitivo');

-- Cada socio en su disciplina. La edad de cada uno cae en el rango de su categoria
INSERT INTO pertenece (tipo_dni, nro_dni, nombre_disciplina, fecha_inscripcion) VALUES
    ('DNI',       '30000001', 'Voley',    '2016-04-05'),
    ('DNI',       '30000002', 'Handball', '2018-08-05'),
    ('DNI',       '30000005', 'Voley',    '2024-03-15'),
    ('DNI',       '30000006', 'Handball', '2023-05-20'),
    ('CI',        '30000007', 'Voley',    '2025-01-20'),
    ('PASAPORTE', '30000008', 'Handball', '2024-06-05');

-- Director Tecnico y Preparador Fisico por combinacion disciplina/categoria,
-- nunca se repite el mismo rol en la misma categoria
INSERT INTO a_cargo (nombre_disciplina, nombre_categoria, rol_profesor, tipo_dni, nro_dni) VALUES
    ('Voley',    'Infantiles', 'Director Tecnico',  'DNI', '30000001'),
    ('Voley',    'Infantiles', 'Preparador Fisico',  'LC', '30000003'),
    ('Voley',    'Juveniles',  'Director Tecnico',   'LC', '30000003'),
    ('Voley',    'Juveniles',  'Preparador Fisico',  'DNI', '30000001'),
    ('Voley',    'Adultos',    'Director Tecnico',  'DNI', '30000001'),
    ('Handball', 'Infantiles', 'Director Tecnico',  'DNI', '30000002'),
    ('Handball', 'Infantiles', 'Preparador Fisico',  'LE', '30000004'),
    ('Handball', 'Juveniles',  'Director Tecnico',   'LE', '30000004'),
    ('Handball', 'Adultos',    'Director Tecnico',  'DNI', '30000002'),
    ('Handball', 'Adultos',    'Preparador Fisico',  'LE', '30000004');

-- id_planilla se inserta explicito porque clase la referencia despues
INSERT INTO planilla_asistencia (id_planilla, tipo_dni, nro_dni) VALUES
    (1, 'DNI', '30000001'),
    (2, 'LC',  '30000003'),
    (3, 'DNI', '30000001'),
    (4, 'DNI', '30000002'),
    (5, 'LE',  '30000004'),
    (6, 'DNI', '30000002');

-- Una clase por combinacion disciplina/categoria, cada una con su planilla unica
INSERT INTO clase (nombre_disciplina, nombre_categoria, fecha, hora_inicio, hora_fin, id_planilla) VALUES
    ('Voley',    'Infantiles', '2026-03-10', '16:00', '18:00', 1),
    ('Voley',    'Juveniles',  '2026-03-11', '16:00', '18:00', 2),
    ('Voley',    'Adultos',    '2026-03-12', '18:00', '20:00', 3),
    ('Handball', 'Infantiles', '2026-03-10', '16:00', '18:00', 4),
    ('Handball', 'Juveniles',  '2026-03-11', '16:00', '18:00', 5),
    ('Handball', 'Adultos',    '2026-03-12', '18:00', '20:00', 6);

-- Asistencia solo de socios que pertenecen a la disciplina de cada clase
INSERT INTO detalle_asistencia (id_planilla, tipo_dni_socio, nro_dni_socio, estado_asistencia) VALUES
    (1, 'DNI',       '30000005', 'Presente'),
    (3, 'CI',        '30000007', 'Presente'),
    (3, 'DNI',       '30000001', 'Presente'),
    (5, 'DNI',       '30000006', 'Presente'),
    (6, 'PASAPORTE', '30000008', 'Presente'),
    (6, 'DNI',       '30000002', 'Ausente');

-- Los 2 medicos que emiten los certificados
INSERT INTO medico (matricula, nombre, apellido, telefono) VALUES
    ('MP10234', 'Sergio',  'Bianchi', '2984200001'),
    ('MP10567', 'Valeria', 'Pereyra', '2984200002');

-- Certificados vigentes o vencidos, siempre con emision antes que vencimiento
INSERT INTO certificado_medico (tipo_dni, nro_dni, fecha_emision, fecha_vencimiento, es_apto, matricula) VALUES
    ('DNI',       '30000001', '2025-02-01', '2026-02-01', TRUE,  'MP10234'),
    ('DNI',       '30000002', '2025-03-01', '2026-03-01', TRUE,  'MP10567'),
    ('DNI',       '30000005', '2025-06-01', '2026-06-01', TRUE,  'MP10234'),
    ('DNI',       '30000006', '2025-07-01', '2026-07-01', TRUE,  'MP10567'),
    ('CI',        '30000007', '2025-01-15', '2025-07-15', FALSE, 'MP10234'),
    ('PASAPORTE', '30000008', '2025-08-01', '2026-08-01', TRUE,  'MP10567');

-- Polizas de seguro, fecha_baja y fecha_vencimiento siempre posteriores o iguales al alta
INSERT INTO seguro (nro_poliza, tipo_dni_socio, nro_dni_socio, fecha_alta, fecha_vencimiento, fecha_baja, tipo) VALUES
    ('POL-3001', 'DNI',       '30000001', '2016-04-10', NULL,         NULL,         'Responsabilidad Civil'),
    ('POL-3002', 'CI',        '30000007', '2025-01-20', '2026-01-20', NULL,         'Accidentes Personales'),
    ('POL-3003', 'PASAPORTE', '30000008', '2024-06-05', '2026-06-05', NULL,         'Accidentes Personales'),
    ('POL-3004', 'DNI',       '30000002', '2018-08-10', NULL,         '2025-12-31', 'Responsabilidad Civil');

-- id_cuota se inserta explicito porque pago la referencia despues
INSERT INTO cuota (id_cuota, fecha, monto, estado_de_pago, periodo, tipo_dni, nro_dni) VALUES
    (1, '2026-07-01', 15000.00, 'Pagada',    '2026-07', 'DNI',       '30000001'),
    (2, '2026-07-01', 14000.00, 'Pendiente', '2026-07', 'DNI',       '30000002'),
    (3, '2026-07-01', 12000.00, 'Pagada',    '2026-07', 'CI',        '30000007'),
    (4, '2026-07-01', 13000.00, 'Pagada',    '2026-07', 'PASAPORTE', '30000008'),
    (5, '2026-07-01', 8000.00,  'Pagada',    '2026-07', 'DNI',       '30000005'),
    (6, '2026-08-01', 9000.00,  'Pendiente', '2026-08', 'DNI',       '30000006');

-- id_pago se inserta explicito; una fila por cada cuota Pagada, id_cuota nunca se repite
INSERT INTO pago (id_pago, fecha_pago, monto, id_cuota) VALUES
    (1, '2026-07-05', 15000.00, 1),
    (2, '2026-07-06', 12000.00, 3),
    (3, '2026-07-07', 13000.00, 4),
    (4, '2026-07-08', 8000.00,  5);

-- id_cargo se inserta explicito porque tiene_cargo lo referencia despues
INSERT INTO cargo_administrativo (id_cargo, descripcion) VALUES
    (1, 'Tesorero'),
    (2, 'Recepcionista'),
    (3, 'Administrativo General');

-- Dos cargos vigentes (fecha_fin_cargo NULL) y uno ya cerrado
INSERT INTO tiene_cargo (tipo_dni, nro_dni, id_cargo, fecha_inicio_cargo, fecha_fin_cargo) VALUES
    ('CI',        '30000007', 1, '2025-01-15', NULL),
    ('PASAPORTE', '30000008', 2, '2024-06-01', '2025-12-31'),
    ('DNI',       '30000002', 3, '2025-03-01', NULL);