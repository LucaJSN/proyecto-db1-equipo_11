-- Elimina un producto pasando el id del mismo

CREATE PROCEDURE Dbo.EliminarProducto
(
    @id_producto INT
)
AS
BEGIN
    -- Evita que el motor de BD envíe mensaje con el número de filas afectadas, ayuda al rendimiento
    SET NOCOUNT ON 
    
    UPDATE PRODUCTO 
    SET  estado_producto = 0 
    WHERE id_producto = @id_producto 
END
GO

-- Pruebas
-- Procedimiento almacenado
EXECUTE Dbo.EliminarProducto 6

-- Update del estado de un producto
UPDATE PRODUCTO 
SET  estado_producto = 0 
WHERE id_producto = 8

-- Ambas sentencias tieenen el mismo rendimiento al ejecutarse