-- Devuelve el total generado por las ventas en un rango de fechas

CREATE FUNCTION dbo.fn_TotalVentasRango
(
    @fecha_inicio DATE,
    @fecha_fin DATE
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Resultado DECIMAL(10,2);
    
    SELECT @Resultado = SUM(dv.subtotal_venta)
    FROM VENTA as v
    INNER JOIN DETALLE_VENTA AS dv
    ON v.id_venta = dv.id_venta
    WHERE fecha_venta between @fecha_inicio and @fecha_fin

    IF @Resultado IS NULL 
    BEGIN
        SET @Resultado = 0
    END

    RETURN @Resultado
END;

SELECT SUM(subtotal_venta) FROM DETALLE_VENTA

-- La funcion devuelve un numero decimal puede ser mostrada en un select
SELECT dbo.fn_TotalVentasRango('2026-10-16', '2026-10-21') AS TotalVentas; 