CREATE TRIGGER trg_cantidad_clases_anio
AFTER INSERT ON detalle_asistencia
FOR EACH ROW
EXECUTE FUNCTION actualizar_cantidad_clases_anio();