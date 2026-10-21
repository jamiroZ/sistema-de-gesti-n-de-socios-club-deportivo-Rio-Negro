CREATE OR REPLACE PROCEDURE esq_grupo4.proceso_bajasdeservicios(
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    cursor_BajaSeguros CURSOR FOR
        SELECT nro_poliza, fecha_vencimiento, fecha_baja
        FROM esq_grupo4.seguro
        WHERE fecha_vencimiento < CURRENT_DATE AND fecha_baja IS NULL
        FOR UPDATE;

    fila RECORD;
BEGIN
    OPEN cursor_BajaSeguros;
    LOOP
        FETCH cursor_BajaSeguros INTO fila;
        EXIT WHEN NOT FOUND; -- si no quedan filas, sale del loop

        RAISE NOTICE 'Dando de baja a la poliza(%%) en %', fila.nro_poliza, fila.fecha_vencimiento;

        -- modificamos en la fila que se detuvo el cursor el atributo fecha_baja
        UPDATE esq_grupo4.seguro
        SET fecha_baja = fecha_vencimiento
        WHERE CURRENT OF cursor_BajaSeguros;

    END LOOP;
    CLOSE cursor_BajaSeguros;
END;
$$;