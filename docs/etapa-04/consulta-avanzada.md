```sql
/* Mostrar el producto mas vendido con su nombre, cantidad de venta, total generado y su categoría. */

SELECT 
    p.nombre_producto AS producto, 
    c.nombre_categoria AS categoria, 
    SUM(dv.cantidad) AS unidades_vendidas, 
    SUM(dv.subtotal_venta) AS total_generado
FROM PRODUCTO AS p
INNER JOIN CATEGORIA AS c 
    ON p.id_categoria = c.id_categoria
INNER JOIN DETALLE_VENTA AS dv 
    ON p.id_Producto = dv.id_Producto
GROUP BY 
    p.nombre_producto, 
    c.nombre_categoria
HAVING SUM(dv.cantidad) = (
    SELECT TOP 1 SUM(dve.cantidad)
    FROM DETALLE_VENTA AS dve
    GROUP BY dve.id_Producto
    ORDER BY SUM(dve.cantidad) DESC
)
ORDER BY unidades_vendidas DESC;
```
