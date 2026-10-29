/* Actualiza el precio de costo. Además calcula y actualiza el precio de venta a partir del anterior 
y el porcentaje de incremento o ganancia */

CREATE PROCEDURE Dbo.ModificarPrecioProducto
(
    @id_producto INT,
    @precio_venta DECIMAL(10,2), 
    @incremento DECIMAL(10,2)
)
AS
BEGIN
    -- Evita que el motor de BD envíe mensaje con el número de filas afectadas, ayuda al rendimiento
    SET NOCOUNT ON

    UPDATE PRODUCTO 
    SET  precio_producto = @precio_venta,
    precioUnitario_producto = @precio_venta + @precio_venta * (@incremento / 100)
    WHERE id_producto = @id_producto
END
GO

-- Prueba
SELECT id_Producto, nombre_producto, descripcion_producto, precio_producto, stock_producto, 
       stock_minimo, precioUnitario_producto, fechaCreacion_producto, estado_producto, id_categoria 
FROM PRODUCTO;

-- Procedimiento almacenado
EXECUTE Dbo.ModificarPrecioProducto 1,25000,20

-- Update del estado de un producto
UPDATE producto 
SET precio_producto =  5000, 
    precioUnitario_producto = 5000 * 1.2
WHERE id_Producto = 2

-- Ambas sentencias tieenen el mismo rendimiento al ejecutarse