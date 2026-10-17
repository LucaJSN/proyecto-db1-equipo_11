/* Consulta que consolide el encabezado y detalle de una venta, 
calculando sub-totales por renglón y el total acumulado.*/

SELECT v.id_venta AS 'Nro de venta', dv.id_detalleVenta AS 'Nro de renglon', v.fecha_venta AS 'Fecha', 
	   v.id_cliente AS 'Cliente', v.id_usuario AS 'Vendedor',
	   dv.id_Producto AS 'Producto', dv.cantidad AS 'Cantidad',
       dv.cantidad * dv.precio AS 'Subtotal',
	   SUM(dv.cantidad*dv.precio) OVER(PARTITION BY v.id_venta) AS 'Total'
FROM VENTA AS v
INNER JOIN DETALLE_VENTA AS dv
	ON v.id_venta = dv.id_venta
WHERE v.id_venta = 10
ORDER BY v.id_venta, dv.id_detalleVenta;
