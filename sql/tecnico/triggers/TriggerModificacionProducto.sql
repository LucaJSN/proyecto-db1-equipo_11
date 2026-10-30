/* =====================================================
PET SHOP DEL LITORAL
AUDITORÍA DE PRODUCTOS
Script: Creación de Trigger y Casos de Prueba
===================================================== */

USE PetShopDelLitoral;


SET NOCOUNT ON; --Desactivo los mensajes de la consola de cuantas filas fueron afectadas, optimizando rendimiento

/* =====================================================
1. CREACIÓN DE LA TABLA DE AUDITORÍA
===================================================== */

IF OBJECT_ID('dbo.AuditoriaProductos', 'U') IS NULL --Solo crea la tabla si no existe ya una con ese nombre
BEGIN
    CREATE TABLE dbo.AuditoriaProductos (
        id_historialPrecios INT IDENTITY(1,1),
        fecha_modificacion DATETIME DEFAULT SYSDATETIME(),
        id_producto INT,
        bd_usuario VARCHAR(100),
        stock_nuevo INT,
        stock_antes INT,
        precio_antes DECIMAL(10,2),
        precio_nuevo DECIMAL(10,2),

        CONSTRAINT PK_HistorialPrecios
            PRIMARY KEY (id_historialPrecios),

        CONSTRAINT FK_HistorialPrecios_Producto
            FOREIGN KEY (id_producto)
            REFERENCES dbo.Producto (id_producto)
    );
END
GO --Separador de lotes 

/* =====================================================
2. CREACIÓN DEL TRIGGER DE AUDITORÍA
===================================================== */

CREATE OR ALTER TRIGGER dbo.trg_Productos_Auditoria
ON dbo.Producto
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.AuditoriaProductos
    (
        fecha_modificacion,
        id_producto,
        bd_usuario,
        stock_nuevo,
        stock_antes,
        precio_nuevo,
        precio_antes
    )
    SELECT
        SYSDATETIME(),
        i.id_producto,
        SUSER_SNAME(), --Guarda el usuario que hizo la modificación
        i.stock_producto,
        d.stock_producto,
        i.precioUnitario_producto,
        d.precioUnitario_producto
    FROM inserted AS i
    INNER JOIN deleted AS d
        ON i.id_producto = d.id_producto
    WHERE
        i.stock_producto <> d.stock_producto
        OR i.precioUnitario_producto <> d.precioUnitario_producto;
END;
GO

/* =====================================================
3. CASO DE PRUEBA 1: MODIFICACIÓN DE STOCK Y PRECIO
===================================================== */

-- Seleccionamos un producto existente para realizar la prueba.
DECLARE @idProducto INT;

SELECT TOP 1
    @idProducto = id_producto
FROM dbo.Producto
ORDER BY id_producto;

-- Consultamos los valores originales.
SELECT
    id_producto,
    stock_producto,
    precioUnitario_producto
FROM dbo.Producto
WHERE id_producto = @idProducto;
GO

-- Modificamos el stock y el precio del producto.
DECLARE @idProductoPrueba INT;

SELECT TOP 1
    @idProductoPrueba = id_producto
FROM dbo.Producto
ORDER BY id_producto;

UPDATE dbo.Producto
SET
    stock_producto = 20,
    precioUnitario_producto = 27000.00
WHERE id_producto = @idProductoPrueba;
GO

-- Verificamos el registro generado en la auditoría.
SELECT *
FROM dbo.AuditoriaProductos
WHERE id_producto = (
    SELECT MIN(id_producto)
    FROM dbo.Producto
);
GO

/* =====================================================
4. CASO DE PRUEBA 2: MODIFICACIÓN SOLAMENTE DEL STOCK
===================================================== */

DECLARE @idProductoStock INT;

SELECT TOP 1
    @idProductoStock = id_producto
FROM dbo.Producto
ORDER BY id_producto;

UPDATE dbo.Producto
SET stock_producto = stock_producto + 1
WHERE id_producto = @idProductoStock;
GO

-- Verificamos los cambios registrados.
SELECT *
FROM dbo.AuditoriaProductos
ORDER BY id_historialPrecios DESC;


/* =====================================================
5. CASO DE PRUEBA 3: MODIFICACIÓN SOLAMENTE DEL PRECIO
===================================================== */

DECLARE @idProductoPrecio INT;

SELECT TOP 1
    @idProductoPrecio = id_producto
FROM dbo.Producto
ORDER BY id_producto;

UPDATE dbo.Producto
SET precioUnitario_producto = precioUnitario_producto + 100
WHERE id_producto = @idProductoPrecio;


-- Verificamos los cambios registrados.
SELECT *
FROM dbo.AuditoriaProductos
ORDER BY id_historialPrecios DESC;


/* =====================================================
6. CASO DE PRUEBA 4: MODIFICACIÓN DE MÚLTIPLES PRODUCTOS
===================================================== */

-- Modificamos el stock de varios productos en una sola sentencia.
UPDATE dbo.Producto
SET stock_producto = stock_producto + 2
WHERE id_producto IN (
    SELECT TOP 3 id_producto
    FROM dbo.Producto
    ORDER BY id_producto
);


-- Verificamos que se registre una fila por cada producto afectado.
SELECT *
FROM dbo.AuditoriaProductos
ORDER BY id_historialPrecios DESC;


/* =====================================================
7. CASO DE PRUEBA 5: MODIFICACIÓN DE OTRA COLUMNA
===================================================== */

-- Modificamos una columna ajena al stock y al precio.
-- No debería generarse una nueva fila de auditoría.
-- Descomentar si se desea ejecutar la prueba.

/*
DECLARE @idProductoNombre INT;

SELECT TOP 1
    @idProductoNombre = id_producto
FROM dbo.Producto
ORDER BY id_producto;

UPDATE dbo.Producto
SET nombre_producto = nombre_producto
WHERE id_producto = @idProductoNombre;

*/

-- Verificamos los registros de auditoría.
SELECT *
FROM dbo.AuditoriaProductos
ORDER BY id_historialPrecios DESC;


/* =====================================================
8. VERIFICACIÓN FINAL DEL HISTORIAL
===================================================== */

SELECT
    id_historialPrecios,
    fecha_modificacion,
    id_producto,
    bd_usuario,
    stock_antes,
    stock_nuevo,
    precio_antes,
    precio_nuevo
FROM dbo.AuditoriaProductos
ORDER BY fecha_modificacion DESC;