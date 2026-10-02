DELIMITER //
CREATE PROCEDURE esq_grupo4.proceso_bajasdeservicios()
BEGIN
    DECLARE v_fin BOOLEAN DEFAULT FALSE;

    -- Variables para almacenar los datos del cursor
    DECLARE v_nro_poliza VARCHAR(50);
    DECLARE v_fecha_vencimiento DATE;
    DECLARE v_fecha_baja DATE;

    -- Declaración del cursor
    DECLARE cursor_BajaSeguros CURSOR FOR
        SELECT nro_poliza, fecha_vencimiento, fecha_baja
        FROM esq_grupo4.seguro
        WHERE fecha_vencimiento < CURRENT_DATE
          AND fecha_baja IS NULL;

    -- Handler para detectar cuando no quedan registros
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_fin = TRUE;

    OPEN cursor_BajaSeguros;

    LOOP
        FETCH cursor_BajaSeguros
        INTO v_nro_poliza, v_fecha_vencimiento, v_fecha_baja;

        IF v_fin THEN
            LEAVE;
        END IF;

        SELECT CONCAT('Dando de baja a la poliza (', v_nro_poliza,') en ', v_fecha_vencimiento );

        UPDATE esq_grupo4.seguro
        SET fecha_baja = v_fecha_vencimiento
        WHERE nro_poliza = v_nro_poliza;

    END LOOP;

    CLOSE cursor_BajaSeguros;

END //
DELIMITER ;