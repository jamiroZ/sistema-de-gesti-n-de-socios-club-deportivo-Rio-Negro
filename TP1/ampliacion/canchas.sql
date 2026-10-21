-- =============================================================================
-- Script para agregar canchas a la poblacion
-- =============================================================================

SET search_path TO esq_grupo4, public;

-- -----------------------------------------------------------------------------
-- Canchas
-- -----------------------------------------------------------------------------

INSERT INTO cancha (s_nombre) VALUES
    ('Cancha 1'),
    ('Cancha 2'),
    ('Polideportivo Cubierto');

-- Se asigna cancha a las clases ya cargadas. Voley Infantiles y Juveniles
-- comparten la Cancha 1 porque son el mismo dia; el resto se reparte entre
-- Cancha 2 y el Polideportivo Cubierto.
UPDATE clase SET id_cancha = (SELECT id_cancha FROM cancha WHERE s_nombre = 'Cancha 1')
    WHERE nombre_disciplina = 'Voley' AND nombre_categoria = 'Infantiles' AND fecha = '2026-08-03';

UPDATE clase SET id_cancha = (SELECT id_cancha FROM cancha WHERE s_nombre = 'Cancha 1')
    WHERE nombre_disciplina = 'Voley' AND nombre_categoria = 'Juveniles' AND fecha = '2026-08-03';

UPDATE clase SET id_cancha = (SELECT id_cancha FROM cancha WHERE s_nombre = 'Cancha 2')
    WHERE nombre_disciplina = 'Voley' AND nombre_categoria = 'Adultos' AND fecha = '2026-08-04';

UPDATE clase SET id_cancha = (SELECT id_cancha FROM cancha WHERE s_nombre = 'Cancha 2')
    WHERE nombre_disciplina = 'Handball' AND nombre_categoria = 'Infantiles' AND fecha = '2026-08-05';

UPDATE clase SET id_cancha = (SELECT id_cancha FROM cancha WHERE s_nombre = 'Polideportivo Cubierto')
    WHERE nombre_disciplina = 'Handball' AND nombre_categoria = 'Juveniles' AND fecha = '2026-08-05';

UPDATE clase SET id_cancha = (SELECT id_cancha FROM cancha WHERE s_nombre = 'Polideportivo Cubierto')
    WHERE nombre_disciplina = 'Handball' AND nombre_categoria = 'Adultos' AND fecha = '2026-08-06';

-- -----------------------------------------------------------------------------
-- fecha_alta de usuario
-- -----------------------------------------------------------------------------
-- La columna quedo con DEFAULT CURRENT_TIMESTAMP, asi que sin este UPDATE
-- todas las cuentas ya cargadas figurarian dadas de alta hoy. Se pisa con una
-- fecha coherente: poco antes de que la persona quedara inscripta como socio
-- o ingresara como profesor, segun corresponda.

UPDATE usuario SET fecha_alta = '2016-02-25 09:00:00' WHERE nombre_usuario = 'DNI30000001';
UPDATE usuario SET fecha_alta = '2018-07-25 09:00:00' WHERE nombre_usuario = 'DNI30000002';
UPDATE usuario SET fecha_alta = '2018-07-10 09:00:00' WHERE nombre_usuario = 'LC30000003';
UPDATE usuario SET fecha_alta = '2019-01-30 09:00:00' WHERE nombre_usuario = 'DNI30000004';
UPDATE usuario SET fecha_alta = '2017-04-15 09:00:00' WHERE nombre_usuario = 'CI30000007';
UPDATE usuario SET fecha_alta = '2022-09-08 09:00:00' WHERE nombre_usuario = 'DNI30000010';