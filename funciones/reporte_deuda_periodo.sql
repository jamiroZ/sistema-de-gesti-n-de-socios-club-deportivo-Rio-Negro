CREATE OR REPLACE FUNCTION reporte_deuda_periodo(
    p_fecha_desde DATE,
    p_fecha_hasta DATE
)
RETURNS TABLE (
    formato TEXT
)
LANGUAGE SQL
AS $$
    SELECT
        'El socio ' || p.nombre || ' ' || p.apellido ||
        ' (' || c.tipo_dni || ' ' || c.nro_dni || ')' ||
        ' acumula ' || COUNT(*) ||
        ' cuotas impagas entre el ' ||
        TO_CHAR(p_fecha_desde, 'YYYY-MM-DD') ||
        ' y el ' ||
        TO_CHAR(p_fecha_hasta, 'YYYY-MM-DD') ||
        ', por un monto total adeudado de $' ||
        TO_CHAR(SUM(c.monto), 'FM999999999.00')
        AS formato
    FROM cuota c
    JOIN socio s
        ON s.tipo_dni = c.tipo_dni
        AND s.nro_dni = c.nro_dni
    JOIN persona p
        ON p.tipo_dni = c.tipo_dni
        AND p.nro_dni = c.nro_dni
    WHERE c.fecha BETWEEN p_fecha_desde AND p_fecha_hasta
      AND c.estado_de_pago = 'No saldada'
    GROUP BY
        c.tipo_dni,
        c.nro_dni,
        p.nombre,
        p.apellido
$$;

