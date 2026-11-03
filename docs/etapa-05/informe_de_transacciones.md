# Informe de Implementación: Manejo de Transacciones

> **Proyecto:** PetShopDelLitoral - Sistema de Ventas para Tienda de Mascotas
>
> **Materia:** Base de Datos 
>
> **Etapa:** V - Manejo de Transacciones 

## 1. Definición del Tema

Una **transacción** en SQL Server es un conjunto de operaciones SQL que se ejecutan como una única unidad lógica de trabajo. Si alguna de las operaciones falla dentro del bloque, se revierten todos los cambios realizados hasta ese momento; si todas tienen éxito, los cambios se confirman en la base de datos de forma permanente.

El manejo de transacciones garantiza las propiedades fundamentales **ACID**:

* **Atomicidad (Atomicity):** Todo o nada. Si la venta se registra, el stock debe actualizarse obligatoriamente. Si no hay stock, nada se inserta.

* **Consistencia (Consistency):** La base de datos pasa de un estado válido a otro, respetando restricciones de clave, stock y tipos de datos.

* **Aislamiento (Isolation):** Las operaciones dentro de la transacción se mantienen aisladas de otras consultas concurrentes hasta que se confirme la transacción.

* **Durabilidad (Durability):** Una vez que se ejecuta el `COMMIT`, los cambios persisten de manera permanente en el motor de base de datos.

En nuestro desarrollo utilizamos construcciones avanzadas como `TRY...CATCH`, `XACT_ABORT ON` y la función `XACT_STATE()` para asegurar la reversión explícita (`ROLLBACK`) en caso de errores en tiempo de ejecución.

## 2. ¿Por qué este script y para qué nos sirve?

En el modelo comercial de **PetShopDelLitoral**, el proceso de registrar una venta requiere modificar múltiples tablas en simultáneo (`VENTA`, `DETALLE_VENTA` y `PRODUCTO`).

### El problema (Sin control transaccional)

* Si el sistema inserta la cabecera de la venta pero ocurre una falla de red antes de descontar el stock, se genera una inconsistencia grave.

* Si un cliente intenta comprar 50 unidades de alimento y solo quedan 10 en stock, podrían crearse registros de venta sin respaldo real de mercadería.

* **Resultado:** Inconsistencias contables, pérdida de trazabilidad de stock y ventas cobradas sin stock disponible.

### La solución (Con el Stored Procedure `dbo.RegistrarVenta`)

**Atomicidad e integridad de negocio garantizadas.** Todo el flujo de validación de cantidad, verificación de existencia y precio del producto, descuento de stock e inserción de venta y detalle ocurre dentro de un bloque `BEGIN TRANSACTION ... COMMIT TRANSACTION`. Ante cualquier anomalía, el bloque `CATCH` ejecuta `ROLLBACK TRANSACTION`.

## 3. El Script de Implementación

A continuación, el código SQL del procedimiento almacenado `dbo.RegistrarVenta` implementado para gestionar transacciones atómicas:

```
USE PetShopDelLitoral;
GO

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
        FROM dbo.PRODUCTO
        WHERE id_Producto = @id_producto
          AND estado_producto = 1;

        IF @precioUnitario IS NULL
            THROW 50001, 'El producto no existe, no está activo o no tiene precio válido.', 1;

        -- 3. Descontar el stock si hay cantidad suficiente
        UPDATE dbo.PRODUCTO
        SET stock_producto = stock_producto - @cantidad
        WHERE id_Producto = @id_producto
          AND estado_producto = 1
          AND stock_producto >= @cantidad;

        IF @@ROWCOUNT = 0
            THROW 50002, 'Stock insuficiente para concretar la venta.', 1;

        -- 4. Registrar la cabecera de la venta
        INSERT INTO dbo.VENTA
            (fecha_venta, estado_venta, id_usuario,
             id_metodoPago, id_cliente)
        VALUES
            (GETDATE(), 1, @id_usuario,
             @id_metodoPago, @id_cliente);

        -- 5. Obtener el ID de la venta generada
        DECLARE @id_venta INT;
        SET @id_venta = SCOPE_IDENTITY();

        -- 6. Registrar el detalle de la venta
        INSERT INTO dbo.DETALLE_VENTA
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

```

## 4. Casos de Prueba

Para verificar el cumplimiento de las reglas transaccionales se realizaron los siguientes casos de prueba en SQL Server Management Studio:

```
USE PetShopDelLitoral;
GO

-- CASO 1: Venta Exitosa (Stock suficiente)
-- Intentamos comprar 2 unidades del Producto 1 (Alimento Balanceado) con stock disponible.
EXEC dbo.RegistrarVenta 
    @id_producto = 1, 
    @cantidad = 2, 
    @id_usuario = 2, 
    @id_metodoPago = 1, 
    @id_cliente = 1;

-- CASO 2: Venta Fallida por Stock Insuficiente (Garantía de ROLLBACK)
-- Intentamos comprar 999 unidades del Producto 1, sobrepasando el stock actual.
EXEC dbo.RegistrarVenta 
    @id_producto = 1, 
    @cantidad = 999, 
    @id_usuario = 2, 
    @id_metodoPago = 1, 
    @id_cliente = 1;

-- CASO 3: Venta Fallida por Cantidad Inválida
-- Intentamos enviar una cantidad negativa o igual a cero.
EXEC dbo.RegistrarVenta 
    @id_producto = 1, 
    @cantidad = 0, 
    @id_usuario = 2, 
    @id_metodoPago = 1, 
    @id_cliente = 1;

```

## 5. Resultados Obtenidos

Al ejecutar los casos de prueba sobre la base de datos, se observaron los siguientes comportamientos:

| Escenario de Prueba | Resultado en Transacción | Estado del Stock | Estado de Tablas (`VENTA` / `DETALLE_VENTA`) | 
| ----- | ----- | ----- | ----- | 
| **Caso 1: Stock Suficiente** | **`COMMIT TRANSACTION`** exitoso. | Descontó exactamente las unidades solicitadas. | Registros creados correctamente en ambas tablas. | 
| **Caso 2: Stock Insuficiente** | **`ROLLBACK TRANSACTION`** por captura de `THROW 50002`. | Permanece intacto sin sufrir modificaciones. | No se creó ningún registro parcial (0 registros añadidos). | 
| **Caso 3: Cantidad Invalida (**$\le 0$**)** | **`THROW 50003`** previo a apertura de transacción. | Sin cambios. | No se inició ninguna transacción ni inserción. | 

> **Nota sobre la prueba de consistencia:** En el Caso 2 se verificó que, aunque las sentencias se procesan secuencialmente dentro del procedimiento, al ejecutarse el `ROLLBACK` debido al `THROW 50002`, los cambios en la memoria del motor son totalmente descartados, reestableciendo el estado original.

## 6. Conclusión

La implementación de transacciones estructuradas mediante `dbo.RegistrarVenta` garantiza la integridad operativa de **PetShopDelLitoral**.

Gracias a la utilización del bloque `TRY...CATCH` y al control riguroso de errores (`THROW` y `XACT_STATE()`), aseguramos que ninguna venta quede a medio procesar ni que el stock quede desfasado. Este mecanismo otorga máxima confiabilidad al sistema comercial ante imprevistos, concurrencia o errores en tiempo de ejecución.