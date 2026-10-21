CREATE OR REPLACE FUNCTION funcion_log_pago()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO LOG_planillaControl (operacion)
    VALUES (TG_OP);

    RETURN NULL;

END;
$$;