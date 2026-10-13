INSERT INTO socio (tipo_dni, nro_dni, es_federado, ddj_salud, fecha_inscripcion_club, ausencias_consecutivas)
SELECT
    tipo_dni,
    nro_dni,
    random() < 0.3,                                                          -- ~30% federados
    random() < 0.9,                                                          -- ~90% con DDJ de salud
    date '2015-05-07' + (random() * (CURRENT_DATE - date '2015-05-07'))::int, -- entre la fundación y hoy
    (random() * 5)::int                                                      -- 0 a 5 ausencias
FROM persona
WHERE nro_dni BETWEEN '40000001' AND '40500000';
