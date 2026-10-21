

CREATE ROLE jamiro LOGIN;
CREATE ROLE guille LOGIN;
CREATE ROLE leo    LOGIN;
CREATE ROLE uli    LOGIN;
CREATE ROLE roman    LOGIN;
GRANT USAGE ON SCHEMA esq_grupo4 TO jamiro, guille, leo, uli;

CREATE VIEW esq_grupo4.v_cuotas_impagas_anio AS
SELECT *
FROM esq_grupo4.cuota
WHERE estado_de_pago = 'No saldada'
  AND fecha >= '01-01-2026';

ALTER VIEW esq_grupo4.v_cuotas_impagas_anio OWNER TO jamiro;
GRANT SELECT ON esq_grupo4.cuota TO jamiro;

-- ---------------------------------------------------------------- PROPAGACION
SET ROLE jamiro;
GRANT SELECT ON esq_grupo4.v_cuotas_impagas_anio TO guille WITH GRANT OPTION;
RESET ROLE;

SET ROLE guille;
GRANT SELECT ON esq_grupo4.v_cuotas_impagas_anio TO leo WITH GRANT OPTION;
RESET ROLE;

SET ROLE leo;
GRANT SELECT ON esq_grupo4.v_cuotas_impagas_anio TO uli;        -- SIN grant option
RESET ROLE;

-- Cadena de privilegios: quien otorgo que a quien
SELECT grantor::regrole AS otorgante, grantee::regrole AS receptor,
       privilege_type, is_grantable AS puede_re_otorgar
FROM (SELECT (aclexplode(relacl)).* FROM pg_class
      WHERE oid = 'esq_grupo4.v_cuotas_impagas_anio'::regclass) a
WHERE grantee::regrole::text <> 'jamiro'
ORDER BY otorgante;


-- ---------------------------------------------------------------- 2) USO DE LOS PRIVILEGIOS
SET ROLE uli;
SELECT * FROM esq_grupo4.v_cuotas_impagas_anio;                  -- funciona
SELECT * FROM esq_grupo4.cuota;                              -- ERROR esperado: permission denied (solo tiene la vista)
RESET ROLE;



-- ERROR esperado: dependent privileges exist (leo y uli dependen de guille)
-- ---------------------------------------------------------------- 6) REVOCACION
SET ROLE jamiro;
REVOKE SELECT ON esq_grupo4.v_cuotas_impagas_anio FROM guille;
RESET ROLE;

SET ROLE jamiro;
REVOKE GRANT OPTION FOR SELECT ON esq_grupo4.v_cuotas_impagas_anio FROM guille CASCADE;
RESET ROLE;
-- guille conserva SELECT pero sin poder re-otorgar; leo y uli lo pierden en cascada
-- (repetir la consulta de la cadena del bloque 1 para verlo)

SET ROLE uli;
SELECT * FROM esq_grupo4.v_cuotas_impagas_anio;                  -- ERROR esperado: permission denied
RESET ROLE;


