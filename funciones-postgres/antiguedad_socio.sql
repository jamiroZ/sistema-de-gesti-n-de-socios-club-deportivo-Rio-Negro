CREATE OR REPLACE FUNCTION antiguedad_socio(
    p_tipo_dni tipo_dni_dominio,
    p_nro_dni  VARCHAR
)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    v_fecha_inscripcion DATE;
    v_anios             INTEGER;
    v_meses             INTEGER;
    v_dias              INTEGER;
BEGIN
    SELECT fecha_inscripcion_club INTO v_fecha_inscripcion
    FROM socio
    WHERE tipo_dni = p_tipo_dni
      AND nro_dni  = p_nro_dni;

    IF v_fecha_inscripcion IS NULL THEN
        RETURN 'Registro no encontrado';
    END IF;

    v_anios := EXTRACT(YEAR  FROM AGE(CURRENT_DATE, v_fecha_inscripcion));
    v_meses := EXTRACT(MONTH FROM AGE(CURRENT_DATE, v_fecha_inscripcion));
    v_dias  := EXTRACT(DAY   FROM AGE(CURRENT_DATE, v_fecha_inscripcion));

    RETURN v_anios || ' años, ' || v_meses || ' meses, ' || v_dias || ' días';
END;
$$;

