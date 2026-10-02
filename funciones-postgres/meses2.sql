CREATE OR REPLACE FUNCTION meses2(
    fecha1 DATE,
    fecha2 DATE
)
RETURNS INTEGER
LANGUAGE plpgsql
RETURNS NULL ON NULL INPUT
AS $$
DECLARE
    v_menor      DATE;
    v_mayor      DATE;
    anio_menor   INTEGER;
    mes_menor    INTEGER;
    dia_menor    INTEGER;
    anio_mayor   INTEGER;
    mes_mayor    INTEGER;
    dia_mayor    INTEGER;
meses_diff   INTEGER;
BEGIN
    IF fecha1 <= fecha2 THEN
        v_menor := fecha1;
        v_mayor := fecha2;
    ELSE
        v_menor := fecha2;
        v_mayor := fecha1;
    END IF;

    anio_menor := EXTRACT(YEAR FROM v_menor);
    mes_menor  := EXTRACT(MONTH FROM v_menor);
    dia_menor  := EXTRACT(DAY FROM v_menor);

    anio_mayor := EXTRACT(YEAR FROM v_mayor);
    mes_mayor  := EXTRACT(MONTH FROM v_mayor);
    dia_mayor  := EXTRACT(DAY FROM v_mayor);

    meses_diff := (anio_mayor - anio_menor) * 12 + (mes_mayor - mes_menor);

    -- Si el dia de la fecha mayor todavia no alcanzo al dia de la fecha menor, el ultimo mes no se completo.
    IF dia_mayor < dia_menor THEN
        meses_diff := meses_diff - 1;
    END IF;

    RETURN meses_diff;
END;
$$;
