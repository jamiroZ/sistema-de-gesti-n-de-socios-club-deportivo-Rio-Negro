--INDICES


-- Hash sobre persona (igualdad)
CREATE INDEX hash_mail ON persona USING HASH (mail);

-- B-tree sobre socio (rango)
CREATE INDEX idx_socio_inscripcion ON socio USING BTREE (fecha_inscripcion_club);


-- CASOS QUE MAXIMIZAN EL USO DE LOS INDICES

--HASH
EXPLAIN ANALYZE SELECT * FROM persona WHERE mail = 'icosta@clubrn.com';

--BTREE
EXPLAIN ANALYZE SELECT * FROM socio
WHERE fecha_inscripcion_club BETWEEN '2020-01-01' AND '2020-01-31';

-- CASOS QUE NO MAXIMIZAN EL USO DE LOS INDICES

-- persona (hash): búsqueda que NO es por igualdad, el hash no sirve
EXPLAIN ANALYZE SELECT * FROM persona WHERE mail LIKE '%@clubrn.com';

-- socio (B-tree): rango muy amplio, casi toda la tabla
EXPLAIN ANALYZE SELECT * FROM socio
WHERE fecha_inscripcion_club BETWEEN '2016-01-01' AND '2026-01-01';