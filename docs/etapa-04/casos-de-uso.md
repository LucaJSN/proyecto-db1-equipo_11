## Consulta 1: Comprobante o factura de una venta
*(Consulta que consolide el encabezado y detalle de una venta)*

### Descripción del Caso de Uso
Permite a la administración mostrar todos los datos de una venta especifica:
1.  Nro de venta, la fecha de venta, el cliente y el vendedor.
2.  El subtotal de cada renglón incluyendo el producto comprado y su precio.
3.  El total de la venta.

Posee un filtro rígido donde se debe aclarar el número de venta para mostrar los detalles correspondientes.

### Tablas Involucradas (JOINs)
1. **`VENTA (p)`**: Proporciona el número de venta, la fecha y los datos del cliente y del vendedor.
2. **`DETALLE_VENTA (dv)`**: Proporciona la cantidad y precio del producto comprado.

### Explicación Técnica de la Consulta

1. **Unión de Tablas y Selección con Where:**  
   Se unen las dos tablas mediante `INNER JOIN`. La cláusula `WHERE v.id_venta = ...` permite seleccionar la venta.

2. **Mostrar datos**  
Se muestran las columnas requeridas.<br><br>
La columna total, a diferencia de las demás muestra el total de la venta general por lo que se suma todos los subtotales con la cláusula `SUM` y se utiliza `OVER()` para mostrar el total de la venta pues hace la suma de todos los subtotales.<br><br>
En la consulta se mantuvo `OVER(PARTITION BY v.id_venta)` pues la misma consulta sin el where funciona para mostrar todas las ventas y sus detalles asociados y en este caso no influye en el rendimiento del sistema.

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
