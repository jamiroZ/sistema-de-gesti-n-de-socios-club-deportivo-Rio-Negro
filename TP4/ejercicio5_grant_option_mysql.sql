-- =============================================================================
-- Ejercicio 5 - WITH GRANT OPTION en MySQL

DROP VIEW IF EXISTS grupo4_clubrn.v_cuotas_impagas_anio;
DROP USER IF EXISTS 'jamiro'@'localhost', 'guille'@'localhost', 'leo'@'localhost',
                    'uli'@'localhost',    'roman'@'localhost';

CREATE USER 'jamiro'@'%' IDENTIFIED BY '1234';
CREATE USER 'guille'@'%' IDENTIFIED BY '1234';
CREATE USER 'leo'@'%'    IDENTIFIED BY '1234';
CREATE USER 'uli'@'%'    IDENTIFIED BY '1234';
CREATE USER 'roman'@'%'  IDENTIFIED BY '1234';

GRANT SELECT ON grupo4_clubrn.cuota TO 'jamiro'@'%';

CREATE DEFINER = 'jamiro'@'%' VIEW grupo4_clubrn.v_cuotas_impagas_anio AS
SELECT *
FROM grupo4_clubrn.cuota
WHERE estado_de_pago = 'No saldada'
  AND fecha >= MAKEDATE(YEAR(CURDATE()), 1);


-- SELECT con grant option sobre la vista.
GRANT SELECT ON grupo4_clubrn.v_cuotas_impagas_anio TO 'jamiro'@'%' WITH GRANT OPTION;


-- ============================ 1) PROPAGACION ==================================
-- ---- usuario: jamiro ----
GRANT SELECT ON grupo4_clubrn.v_cuotas_impagas_anio TO 'guille'@'%' WITH GRANT OPTION;

-- ---- usuario: guille ----
SHOW GRANTS;                                                   -- solo lectura, con grant option
DELETE FROM grupo4_clubrn.v_cuotas_impagas_anio;               -- ERROR esperado: DELETE command denied
GRANT SELECT ON grupo4_clubrn.v_cuotas_impagas_anio TO 'leo'@'%' WITH GRANT OPTION;

-- ---- usuario: leo ----
GRANT SELECT ON grupo4_clubrn.v_cuotas_impagas_anio TO 'uli'@'%';   -- SIN grant option

-- ---- usuario: uli ----
SELECT * FROM grupo4_clubrn.v_cuotas_impagas_anio;             -- funciona
SELECT * FROM grupo4_clubrn.cuota;                             -- ERROR esperado: SELECT command denied (solo tiene la vista)
GRANT SELECT ON grupo4_clubrn.v_cuotas_impagas_anio TO 'roman'@'%';  -- ERROR esperado: acceso denegado (sin grant option)


-- ============================ 2) VER LA CADENA (usuario: root) ================
SHOW GRANTS FOR 'jamiro'@'%';
SHOW GRANTS FOR 'guille'@'%';
SHOW GRANTS FOR 'leo'@'%';
SHOW GRANTS FOR 'uli'@'%';

-- Registro de privilegios sobre tablas/vistas. La columna Grantor deberia indicar
-- quien otorgo cada privilegio 
SELECT User, Host, Table_name, Grantor, Table_priv
FROM mysql.tables_priv
WHERE Db = 'grupo4_clubrn' AND Table_name = 'v_cuotas_impagas_anio';


-- ============================ 3) REVOCACION ===================================
-- ---- 3.1 Quitar solo la capacidad de propagar (usuario: jamiro) ----
REVOKE GRANT OPTION ON grupo4_clubrn.v_cuotas_impagas_anio FROM 'guille'@'%';

-- ---- usuario: root ---- (comprobar que leo y uli NO fueron afectados)
SHOW GRANTS FOR 'guille'@'%';     
SHOW GRANTS FOR 'leo'@'%';        
SHOW GRANTS FOR 'uli'@'%';       

-- ---- usuario: guille ---- (ya no puede propagar)
GRANT SELECT ON grupo4_clubrn.v_cuotas_impagas_anio TO 'roman'@'%';   -- ERROR esperado

-- ---- 3.2 Revocar la lectura (usuario: jamiro) ----
REVOKE SELECT ON grupo4_clubrn.v_cuotas_impagas_anio FROM 'guille'@'%';



-- ---- usuario: uli ----
SELECT * FROM grupo4_clubrn.v_cuotas_impagas_anio;  



