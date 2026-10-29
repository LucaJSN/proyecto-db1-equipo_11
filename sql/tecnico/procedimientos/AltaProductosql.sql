-- Inserta un producto a la BD

CREATE PROCEDURE Dbo.AltaProducto
(
    @nombre VARCHAR(100),
    @descripcion VARCHAR(255),
    @precio_costo DECIMAL(10,2),
    @stock_actual INT,
    @stock_minimo INT,
    @precio_venta DECIMAL(10,2), 
    @id_categoria INT
)
AS
BEGIN
    -- Evita que el motor de BD envíe mensaje con el número de filas afectadas, ayuda al rendimiento
    SET NOCOUNT ON

    INSERT INTO PRODUCTO(nombre_producto, descripcion_producto, precio_producto, stock_producto, 
                stock_minimo, precioUnitario_producto, id_categoria, estado_producto)
    VALUES (@nombre, @descripcion, @precio_costo, @stock_actual,
                @stock_minimo, @precio_venta, @id_categoria, 1)
END
GO