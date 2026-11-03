
CREATE OR ALTER PROCEDURE dbo.RegistrarVenta
    @id_producto INT,
    @cantidad INT,
    @id_usuario INT,
    @id_metodoPago INT,
    @id_cliente INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY

        -- 1. Validar que la cantidad sea positiva
        IF @cantidad <= 0
            THROW 50003, 'La cantidad debe ser mayor que cero.', 1;

        BEGIN TRANSACTION;

        -- 2. Obtener el precio del producto
        DECLARE @precioUnitario DECIMAL(10,2);

        SELECT @precioUnitario = precioUnitario_producto
        FROM dbo.Producto
        WHERE id_Producto = @id_producto
          AND estado_producto = 1;

        IF @precioUnitario IS NULL
            THROW 50001, 'El producto no existe, no está activo o no tiene precio válido.', 1;

        -- 3. Descontar el stock si hay cantidad suficiente
        UPDATE dbo.Producto
        SET stock_producto = stock_producto - @cantidad
        WHERE id_Producto = @id_producto
          AND estado_producto = 1
          AND stock_producto >= @cantidad;

        IF @@ROWCOUNT = 0
            THROW 50002, 'Stock insuficiente para concretar la venta.', 1;

        -- 4. Registrar la cabecera de la venta
        INSERT INTO dbo.Venta
            (fecha_venta, estado_venta, id_usuario,
             id_metodoPago, id_cliente)
        VALUES
            (GETDATE(), 1, @id_usuario,
             @id_metodoPago, @id_cliente);

        -- 5. Obtener el ID de la venta generada
        DECLARE @id_venta INT;
        SET @id_venta = SCOPE_IDENTITY();

        -- 6. Registrar el detalle de la venta
        INSERT INTO dbo.Detalle_Venta
            (cantidad, precio, subtotal_venta,
             id_venta, id_Producto)
        VALUES
            (@cantidad, @precioUnitario,
             @precioUnitario * @cantidad,
             @id_venta, @id_producto);

        -- 7. Confirmar todos los cambios
        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH

        -- 8. Deshacer los cambios si ocurre un error
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;
END;
GO
