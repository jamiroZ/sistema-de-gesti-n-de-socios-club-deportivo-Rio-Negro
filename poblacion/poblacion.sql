-- reemplazar nombreEsquema, con el esquema deseado, sino se usa public por defecto
SET search_path TO nombreEsquema, public;  

-- Inserción en persona (Profesores, Socios y Tutores)
INSERT INTO persona (tipo_dni, nro_dni, nombre, apellido, telefono, fecha_nacimiento, mail) VALUES
-- Profesores (6)
('DNI', '30000001', 'Carlos', 'Gomez', '2994000001', '1985-03-12', 'carlos@mail.com'),
('DNI', '30000002', 'Maria', 'Perez', '2994000002', '1990-07-22', 'maria@mail.com'),
('DNI', '30000003', 'Esteban', 'Quito', '2994000003', '1982-11-05', 'esteban@mail.com'),
('DNI', '30000004', 'Lucia', 'Fernandez', '2994000004', '1988-01-15', 'lucia@mail.com'),
('DNI', '30000005', 'Jorge', 'Lopez', '2994000005', '1975-09-30', 'jorge@mail.com'),
('DNI', '30000006', 'Ana', 'Martinez', '2994000006', '1992-05-18', 'ana@mail.com'),
-- Socios (12)
('DNI', '40000001', 'Juan', 'Perez', '2995000001', '2005-01-10', 'juan@mail.com'),
('DNI', '40000002', 'Sofia', 'Gomez', '2995000002', '2006-02-20', 'sofia@mail.com'),
('DNI', '40000003', 'Lucas', 'Diaz', '2995000003', '2004-03-30', 'lucas@mail.com'),
('DNI', '40000004', 'Camila', 'Ruiz', '2995000004', '2005-04-12', 'camila@mail.com'),
('DNI', '40000005', 'Mateo', 'Sosa', '2995000005', '2007-05-22', 'mateo@mail.com'),
('DNI', '40000006', 'Valentina', 'Torres', '2995000006', '2006-06-14', 'valen@mail.com'),
('DNI', '40000007', 'Joaquin', 'Ramirez', '2995000007', '2005-07-19', 'joaco@mail.com'),
('DNI', '40000008', 'Martina', 'Flores', '2995000008', '2008-08-25', 'martina@mail.com'),
('DNI', '40000009', 'Agustin', 'Acosta', '2995000009', '2004-09-05', 'agus@mail.com'),
('DNI', '40000010', 'Catalina', 'Medina', '2995000010', '2007-10-11', 'cata@mail.com'),
('DNI', '40000011', 'Nicolas', 'Castro', '2995000011', '2005-11-03', 'nico@mail.com'),
('DNI', '40000012', 'Florencia', 'Rios', '2995000012', '2006-12-28', 'flor@mail.com'),
-- Tutores (4) para los primeros 4 socios
('DNI', '50000001', 'Alberto', 'Perez', '2996000001', '1975-04-10', 'alberto.tutor@mail.com'),
('DNI', '50000002', 'Carmen', 'Gomez', '2996000002', '1978-08-12', 'carmen.tutor@mail.com'),
('DNI', '50000003', 'Roberto', 'Diaz', '2996000003', '1972-12-01', 'roberto.tutor@mail.com'),
('DNI', '50000004', 'Patricia', 'Ruiz', '2996000004', '1980-02-20', 'patricia.tutor@mail.com');

-- Disciplinas (Vóley y Handball)
INSERT INTO disciplina (nombre, enfoque) VALUES
('Vóley', 'Recreativo y Competitivo'),
('Handball', 'Competitivo');

-- Categorías
INSERT INTO categoria (nombre_categoria, nombre_disciplina, edad_min, edad_max) VALUES
('Juvenil', 'Vóley', 14, 18),
('Mayores', 'Vóley', 19, 40),
('Juvenil', 'Handball', 14, 18),
('Mayores', 'Handball', 19, 40);

-- Profesores (6)
INSERT INTO profesor (tipo_dni, nro_dni, fecha_ingreso) VALUES
('DNI', '30000001', '2020-03-01'),
('DNI', '30000002', '2021-03-01'),
('DNI', '30000003', '2019-05-15'),
('DNI', '30000004', '2022-01-10'),
('DNI', '30000005', '2018-08-20'),
('DNI', '30000006', '2023-02-15');

-- Socios (12)
INSERT INTO socio (tipo_dni, nro_dni, es_federado, ddj_salud, fecha_inscripcion, ausencias_consecutivas) VALUES
('DNI', '40000001', TRUE, TRUE, '2023-05-10', 0),
('DNI', '40000002', FALSE, TRUE, '2023-06-11', 1),
('DNI', '40000003', TRUE, TRUE, '2022-03-15', 0),
('DNI', '40000004', FALSE, FALSE, '2024-01-10', 2),
('DNI', '40000005', TRUE, TRUE, '2023-07-20', 0),
('DNI', '40000006', FALSE, TRUE, '2023-08-01', 0),
('DNI', '40000007', TRUE, TRUE, '2021-05-12', 0),
('DNI', '40000008', FALSE, TRUE, '2024-02-14', 1),
('DNI', '40000009', TRUE, TRUE, '2022-09-10', 0),
('DNI', '40000010', FALSE, TRUE, '2023-10-05', 0),
('DNI', '40000011', TRUE, TRUE, '2020-04-18', 0),
('DNI', '40000012', FALSE, FALSE, '2024-03-01', 3);

-- Pertenece 
INSERT INTO pertenece (tipo_dni, nro_dni, nombre_disciplina, nombre_categoria, fecha_inscripcion) VALUES
('DNI', '40000001', 'Vóley', 'Juvenil', '2023-05-10'),
('DNI', '40000002', 'Vóley', 'Juvenil', '2023-06-11'),
('DNI', '40000003', 'Vóley', 'Mayores', '2022-03-15'),
('DNI', '40000004', 'Vóley', 'Mayores', '2024-01-10'),
('DNI', '40000005', 'Handball', 'Juvenil', '2023-07-20'),
('DNI', '40000006', 'Handball', 'Juvenil', '2023-08-01'),
('DNI', '40000007', 'Handball', 'Mayores', '2021-05-12'),
('DNI', '40000008', 'Handball', 'Mayores', '2024-02-14'),
('DNI', '40000009', 'Vóley', 'Juvenil', '2022-09-10'),
('DNI', '40000010', 'Vóley', 'Mayores', '2023-10-05'),
('DNI', '40000011', 'Handball', 'Juvenil', '2020-04-18'),
('DNI', '40000012', 'Handball', 'Mayores', '2024-03-01');

-- Tutores para 4 de los 12 socios (1 tutor para cada uno de los 4)
INSERT INTO tiene_tutor (tipo_dni_socio, nro_dni_socio, tipo_dni_tutor, nro_dni_tutor, parentesco) VALUES
('DNI', '40000001', 'DNI', '50000001', 'Padre'),
('DNI', '40000002', 'DNI', '50000002', 'Madre'),
('DNI', '40000003', 'DNI', '50000003', 'Padre'),
('DNI', '40000004', 'DNI', '50000004', 'Madre');

-- Médicos
INSERT INTO medico (matricula, nombre, apellido, telefono) VALUES
('MP1234', 'Roberto', 'Sanchez', '2991111111'),
('MP5678', 'Clara', 'Mendoza', '2992222222');

-- Certificados médicos
INSERT INTO certificado_medico (tipo_dni, nro_dni, fecha_emision, fecha_vencimiento, matricula) VALUES
('DNI', '40000001', '2026-01-10', '2027-01-10', 'MP1234'),
('DNI', '40000002', '2026-02-15', '2027-02-15', 'MP5678'),
('DNI', '40000003', '2026-01-20', '2027-01-20', 'MP1234'),
('DNI', '40000004', '2026-03-01', '2027-03-01', 'MP5678'),
('DNI', '40000005', '2026-01-12', '2027-01-12', 'MP1234'),
('DNI', '40000006', '2026-02-10', '2027-02-10', 'MP5678'),
('DNI', '40000007', '2026-01-18', '2027-01-18', 'MP1234'),
('DNI', '40000008', '2026-02-22', '2027-02-22', 'MP5678'),
('DNI', '40000009', '2026-01-05', '2027-01-05', 'MP1234'),
('DNI', '40000010', '2026-02-28', '2027-02-28', 'MP5678'),
('DNI', '40000011', '2026-01-15', '2027-01-15', 'MP1234'),
('DNI', '40000012', '2026-03-05', '2027-03-05', 'MP5678');

-- Seguros
INSERT INTO seguro (num_poliza, tipo_dni_socio, nro_dni_socio, fecha_alta, fecha_vencimiento, tipo) VALUES
('POL-001', 'DNI', '40000001', '2026-01-01', '2026-12-31', 'Accidentes Personales'),
('POL-002', 'DNI', '40000002', '2026-01-01', '2026-12-31', 'Accidentes Personales'),
('POL-003', 'DNI', '40000003', '2026-01-01', '2026-12-31', 'Accidentes Personales'),
('POL-004', 'DNI', '40000004', '2026-01-01', '2026-12-31', 'Accidentes Personales'),
('POL-005', 'DNI', '40000005', '2026-01-01', '2026-12-31', 'Accidentes Personales'),
('POL-006', 'DNI', '40000006', '2026-01-01', '2026-12-31', 'Accidentes Personales'),
('POL-007', 'DNI', '40000007', '2026-01-01', '2026-12-31', 'Accidentes Personales'),
('POL-008', 'DNI', '40000008', '2026-01-01', '2026-12-31', 'Accidentes Personales'),
('POL-009', 'DNI', '40000009', '2026-01-01', '2026-12-31', 'Accidentes Personales'),
('POL-010', 'DNI', '40000010', '2026-01-01', '2026-12-31', 'Accidentes Personales'),
('POL-011', 'DNI', '40000011', '2026-01-01', '2026-12-31', 'Accidentes Personales'),
('POL-012', 'DNI', '40000012', '2026-01-01', '2026-12-31', 'Accidentes Personales');

-- Cuotas (3 cuotas por cada socio = 36 cuotas en total)
INSERT INTO cuota (fecha, monto, estado_de_pago, periodo, tipo_dni, nro_dni) VALUES
-- Socio 1 (40000001)
('2026-04-01', 15000.00, 'Pagado', 'Abril 2026', 'DNI', '40000001'),
('2026-05-01', 15000.00, 'Pagado', 'Mayo 2026', 'DNI', '40000001'),
('2026-06-01', 15000.00, 'Pagado', 'Junio 2026', 'DNI', '40000001'),
-- Socio 2 (40000002)
('2026-04-01', 15000.00, 'Pagado', 'Abril 2026', 'DNI', '40000002'),
('2026-05-01', 15000.00, 'Pagado', 'Mayo 2026', 'DNI', '40000002'),
('2026-06-01', 15000.00, 'Pagado', 'Junio 2026', 'DNI', '40000002'),
-- Socio 3 (40000003)
('2026-04-01', 15000.00, 'Pagado', 'Abril 2026', 'DNI', '40000003'),
('2026-05-01', 15000.00, 'Pagado', 'Mayo 2026', 'DNI', '40000003'),
('2026-06-01', 15000.00, 'Pagado', 'Junio 2026', 'DNI', '40000003'),
-- Socio 4 (40000004)
('2026-04-01', 15000.00, 'Pagado', 'Abril 2026', 'DNI', '40000004'),
('2026-05-01', 15000.00, 'Pagado', 'Mayo 2026', 'DNI', '40000004'),
('2026-06-01', 15000.00, 'Pagado', 'Junio 2026', 'DNI', '40000004'),
-- Socio 5 (40000005)
('2026-04-01', 15000.00, 'Pagado', 'Abril 2026', 'DNI', '40000005'),
('2026-05-01', 15000.00, 'Pagado', 'Mayo 2026', 'DNI', '40000005'),
('2026-06-01', 15000.00, 'Pagado', 'Junio 2026', 'DNI', '40000005'),
-- Socio 6 (40000006)
('2026-04-01', 15000.00, 'Pagado', 'Abril 2026', 'DNI', '40000006'),
('2026-05-01', 15000.00, 'Pagado', 'Mayo 2026', 'DNI', '40000006'),
('2026-06-01', 15000.00, 'Pagado', 'Junio 2026', 'DNI', '40000006'),
-- Socio 7 (40000007)
('2026-04-01', 15000.00, 'Pagado', 'Abril 2026', 'DNI', '40000007'),
('2026-05-01', 15000.00, 'Pagado', 'Mayo 2026', 'DNI', '40000007'),
('2026-06-01', 15000.00, 'Pagado', 'Junio 2026', 'DNI', '40000007'),
-- Socio 8 (40000008)
('2026-04-01', 15000.00, 'Pagado', 'Abril 2026', 'DNI', '40000008'),
('2026-05-01', 15000.00, 'Pagado', 'Mayo 2026', 'DNI', '40000008'),
('2026-06-01', 15000.00, 'Pagado', 'Junio 2026', 'DNI', '40000008'),
-- Socio 9 (40000009)
('2026-04-01', 15000.00, 'Pagado', 'Abril 2026', 'DNI', '40000009'),
('2026-05-01', 15000.00, 'Pagado', 'Mayo 2026', 'DNI', '40000009'),
('2026-06-01', 15000.00, 'Pagado', 'Junio 2026', 'DNI', '40000009'),
-- Socio 10 (40000010)
('2026-04-01', 15000.00, 'Pagado', 'Abril 2026', 'DNI', '40000010'),
('2026-05-01', 15000.00, 'Pagado', 'Mayo 2026', 'DNI', '40000010'),
('2026-06-01', 15000.00, 'Pagado', 'Junio 2026', 'DNI', '40000010'),
-- Socio 11 (40000011)
('2026-04-01', 15000.00, 'Pagado', 'Abril 2026', 'DNI', '40000011'),
('2026-05-01', 15000.00, 'Pagado', 'Mayo 2026', 'DNI', '40000011'),
('2026-06-01', 15000.00, 'Pagado', 'Junio 2026', 'DNI', '40000011'),
-- Socio 12 (40000012)
('2026-04-01', 15000.00, 'Pagado', 'Abril 2026', 'DNI', '40000012'),
('2026-05-01', 15000.00, 'Pagado', 'Mayo 2026', 'DNI', '40000012'),
('2026-06-01', 15000.00, 'Pagado', 'Junio 2026', 'DNI', '40000012');

-- Pagos correspondientes a cada una de las 36 cuotas
INSERT INTO pago (fecha_pago, monto, id_cuota)
SELECT fecha, monto, id_cuota FROM cuota;

-- Usuarios
INSERT INTO usuario (nombre_usuario, contrasenia, tipo_dni, nro_dni) VALUES
('cgomez', 'hashed_pass_1', 'DNI', '30000001'),
('mperez', 'hashed_pass_2', 'DNI', '30000002');

-- Roles y asignación de roles
INSERT INTO rol (nombre_rol, permisos) VALUES
('Profesor', 'Gestionar clases y asistencias'),
('Administrador', 'Gestion total del sistema');

INSERT INTO tiene_rol (nombre_rol, nombre_usuario, fecha) VALUES
('Profesor', 'cgomez', '2026-01-01'),
('Profesor', 'mperez', '2026-01-01');

-- Notificaciones
INSERT INTO notificacion (tipo, mensaje, fecha, nombre_usuario) VALUES
('Sistema', 'Bienvenido al sistema del club', '2026-01-02 10:00:00', 'cgomez');

-- Planilla de asistencia y clases
INSERT INTO planilla_asistencia (tipo_dni, nro_dni) VALUES
('DNI', '30000001'),
('DNI', '30000002');

INSERT INTO clase (nombre_disciplina, nombre_categoria, fecha, hora_inicio, hora_fin, tipo_dni, nro_dni, id_planilla, rol) VALUES
('Vóley', 'Juvenil', '2026-06-05', '18:00:00', '20:00:00', 'DNI', '30000001', 1, 'Profesor Principal'),
('Handball', 'Mayores', '2026-06-06', '20:00:00', '22:00:00', 'DNI', '30000002', 2, 'Profesor Principal');

-- Detalle de asistencia
INSERT INTO detalle_asistencia (id_planilla, tipo_dni_socio, nro_dni_socio, estado_asistencia) VALUES
(1, 'DNI', '40000001', 'Presente'),
(1, 'DNI', '40000002', 'Ausente'),
(2, 'DNI', '40000007', 'Presente');

-- Cargos administrativos
INSERT INTO cargo_administrativo (id_cargo, descripcion) VALUES
(1, 'Comisión Directiva');

INSERT INTO tiene_cargo (tipo_dni, nro_dni, id_cargo, fecha_inicio_cargo, fecha_fin_cargo) VALUES
('DNI', '40000001', 1, '2026-01-01', '2026-12-31');

-- Estado socio
INSERT INTO estado_socio (tipo_dni, nro_dni, fecha_modificacion, estado, modificado_por) VALUES
('DNI', '40000001', '2026-01-01 00:00:00', 'Activo', 'Admin');