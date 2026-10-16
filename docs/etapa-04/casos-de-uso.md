## Consulta 3: Consulta de Negocio Avanzada (Producto más Vendido)
*(Combinación de 3 tablas con JOIN, agregación y filtro dinámico mediante Subconsulta en HAVING)*

### Descripción del Caso de Uso
Permite a la administración identificar en tiempo real cuál o cuáles productos son los más vendidos ("productos estrella") del Pet Shop en términos de volumen de unidades físicas comercializadas, indicando su categoría y el impacto económico total generado.

A diferencia de un filtro rígido, esta consulta implementa una subconsulta dinámica que calcula automáticamente el récord actual de unidades vendidas en la base de datos, garantizando que el reporte permanezca actualizado sin importar cuánto cambien los datos.

### Tablas Involucradas (JOINs)
1. **`PRODUCTO (p)`**: Proporciona el nombre del producto (`nombre_producto`).
2. **`CATEGORIA (c)`**: Proporciona la categoría a la que pertenece (`nombre_categoria`).
3. **`DETALLE_VENTA (dv)`**: Proporciona las unidades físicas vendidas (`cantidad`) y el monto facturado (`subtotal_venta`).

### Explicación Técnica de la Consulta

1. **Unión de Tablas y Agrupación:**  
   Se unen las tres tablas requeridas mediante `INNER JOIN`. La cláusula `GROUP BY p.nombre_producto, c.nombre_categoria` permite aplicar funciones de agregación (`SUM`) para calcular el total de unidades vendidas y los ingresos por producto.

2. **Subconsulta Dinámica en `HAVING`:**  
   ```sql
   SELECT TOP 1 SUM(dve.cantidad)
   FROM DETALLE_VENTA AS dve
   GROUP BY dve.id_Producto
   ORDER BY SUM(dve.cantidad) DESC
   ```  
   Esta subconsulta agrupa todas las ventas registradas por producto, suma las cantidades y extrae únicamente el valor más alto (`TOP 1`).

3. **Evaluación de Condición:**  
   El `HAVING SUM(dv.cantidad) = (...)` de la consulta principal compara las unidades totales de cada producto contra el valor máximo devuelto por la subconsulta. De esta manera, solo se muestran el producto o productos que compartan la posición número 1 en ventas.
