--Listado de Productos Top por Rango de Fechas

CREATE FUNCTION dbo.fn_ProductosMasVendidos
(
    @fecha_inicio DATE,
    @fecha_fin DATE,
    @cantidad INT
)
RETURNS TABLE 
AS
RETURN (
    SELECT TOP (@cantidad)
    p.nombre_producto, SUM(dv.cantidad) AS cantidad
    FROM PRODUCTO AS p
    INNER JOIN DETALLE_VENTA AS dv
    ON p.id_producto = dv.id_producto
    INNER JOIN VENTA AS v
    ON v.id_venta = dv.id_venta
    WHERE fecha_venta between @fecha_inicio and @fecha_fin
    GROUP BY p.nombre_producto
    ORDER BY cantidad DESC
);

SELECT *  from PRODUCTO
SELECT *  from DETALLE_VENTA
SELECT SUM(subtotal_venta) from DETALLE_VENTA

-- La funcion devuelve una tabla que puede ser mostrada en un select
SELECT nombre_producto, cantidad FROM dbo.fn_ProductosMasVendidos('2026-10-16', '2026-10-21', 6) AS TotalVentas; 