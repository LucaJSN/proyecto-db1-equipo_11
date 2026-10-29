-- Devuelve la cantidad de ventas realizadas en un día

CREATE FUNCTION dbo.fn_CantVentasDelDia (
    @fecha DATE
)
RETURNS INT
AS
BEGIN
    DECLARE @Resultado INT;

    SELECT @Resultado = COUNT(id_venta)
    FROM VENTA
    WHERE fecha_venta = @fecha 
   
    RETURN @Resultado
END;

EXECUTE dbo.fn_CantVentasDelDia '2026-10-16'

-- Las funciones devuelven un valor que puede ser mostrado con un select
SELECT dbo.fn_CantVentasDelDia('2026-10-16') AS TotalVentas;