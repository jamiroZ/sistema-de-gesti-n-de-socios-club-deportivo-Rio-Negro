INSERT INTO persona (tipo_dni, nro_dni, nombre, apellido, telefono, fecha_nacimiento, mail)
SELECT 'DNI', (40000000 + gs)::text,
       substr(md5(random()::text), 1, 8),
       substr(md5(random()::text), 1, 8),
       '299-' || lpad((random() * 9999999)::int::text, 7, '0'),
       date '1950-01-01' + (random() * 25550)::int,
       md5(random()::text) || '@example.com'
FROM generate_series(1, 500000) AS gs;
