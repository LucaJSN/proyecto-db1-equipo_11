
# Script de Carga Masiva y Pruebas de Índices
=======
/* ============================================================================== 
   PET SHOP DEL LITORAL ETAPA V - OPTIMIZACIÓN DE CONSULTAS A TRAVÉS DE ÍNDICES 
   Script: Carga Masiva y Casos de Prueba
   ============================================================================== */
A continuación se detalla el código SQL utilizado para la inserción masiva de datos (simulando operaciones diarias de la tienda y compras a proveedores) y la validación del rendimiento de las consultas mediante los índices en la base de datos `PetShopDelLitoral`.

## Script SQL Completo

```sql
USE PetShopDelLitoral;
GO

SET NOCOUNT ON;
GO

/* ============================================================================== 
   1. INSERCIÓN DE TABLAS PADRE (Catálogos y Proveedores)
   ============================================================================== */

-- Categorías
IF NOT EXISTS (SELECT 1 FROM dbo.CATEGORIA)
BEGIN
    INSERT INTO dbo.CATEGORIA (nombre_categoria, estado_categoria, fechaCreacion_categoria)
    VALUES 
    ('Alimentos', 1, GETDATE()),    
    ('Accesorios', 1, GETDATE()),    
    ('Juguetes', 1, GETDATE()),    
    ('Higiene y Salud', 1, GETDATE());
END
GO

-- Proveedores
IF NOT EXISTS (SELECT 1 FROM dbo.PROVEEDOR)
BEGIN
    INSERT INTO dbo.PROVEEDOR (estado_proveedor)
    VALUES (1), (1), (1);
END
GO

-- Métodos de Pago
IF NOT EXISTS (SELECT 1 FROM dbo.METODO_PAGO)
BEGIN
    INSERT INTO dbo.METODO_PAGO (nombre_metodo, estado_metodoPago, fechaCreacion_metodoPago) 
    VALUES ('Efectivo', 1, GETDATE()), ('Tarjeta de Crédito', 1, GETDATE());
END
GO

/* ============================================================================== 
   2. INSERCIÓN DE PRODUCTOS (50 registros distribuidos en categorías)
   ============================================================================== */

IF NOT EXISTS (SELECT 1 FROM dbo.PRODUCTO)
BEGIN
    DECLARE @i INT = 1;
    WHILE @i <= 50
    BEGIN
        INSERT INTO dbo.PRODUCTO (
            nombre_producto, descripcion_producto, precio_producto, 
            stock_producto, stock_minimo, precioUnitario_producto, 
            fechaCreacion_producto, estado_producto, id_categoria
        )
        VALUES (
            'Producto ' + CAST(@i AS VARCHAR),
            'Descripción del producto ' + CAST(@i AS VARCHAR),
            CAST((RAND(CHECKSUM(NEWID())) * 5000 + 100) AS DECIMAL(10,2)),
            CAST((RAND(CHECKSUM(NEWID())) * 100 + 10) AS INT),
            5,
            CAST((RAND(CHECKSUM(NEWID())) * 5000 + 100) AS DECIMAL(10,2)),
            GETDATE(),
            1,            
            (@i % 4) + 1
        );
        SET @i = @i + 1;
    END
END
GO

/* ============================================================================== 
   3. INSERCIÓN DE DATOS DE USUARIO Y CLIENTE (Requeridos por Venta)
   ============================================================================== */

IF NOT EXISTS (SELECT 1 FROM dbo.PERSONA)
BEGIN
    INSERT INTO dbo.PERSONA (nombre_persona, apellido_persona, correo_persona, telefono_persona, dni_persona, estado_persona, fechaCreacion_persona) 
    VALUES ('Juan', 'Pérez', 'juan@mail.com', '3794000000', '12345678', 1, GETDATE());
END

IF NOT EXISTS (SELECT 1 FROM dbo.CLIENTE)
BEGIN
    INSERT INTO dbo.CLIENTE (id_persona, estado_cliente) 
    VALUES (SCOPE_IDENTITY(), 1);
END

IF NOT EXISTS (SELECT 1 FROM dbo.ROL)
BEGIN
    INSERT INTO dbo.ROL (rol_descripcion, fechaCreacion_rol) 
    VALUES ('Administrador', GETDATE());
END

IF NOT EXISTS (SELECT 1 FROM dbo.USUARIO)
BEGIN
    INSERT INTO dbo.USUARIO (contrasenia_usuario, estado_usuario, id_rol, id_persona) 
    VALUES ('1234', 1, 1, 1);
END
GO

/* ============================================================================== 
   4. CARGA MASIVA: VENTA Y DETALLE_VENTA 
   ============================================================================== */

-- Limpiar detalles previos si quedaron con datos parciales
DELETE FROM dbo.DETALLE_VENTA;
DELETE FROM dbo.VENTA;
GO

-- Insertar 5,000 Ventas
WITH N AS (
    SELECT TOP (5000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects a CROSS JOIN sys.objects b
)
INSERT INTO dbo.VENTA (fecha_venta, estado_venta, id_usuario, id_metodoPago, id_cliente)
SELECT 
    DATEADD(DAY, - (n % 365), GETDATE()),
    1,
    1,    
    (n % 2) + 1,
    1
FROM N;
GO

-- Insertar Detalle Venta de forma segura (1 producto único por venta)
INSERT INTO dbo.DETALLE_VENTA (cantidad, precio, subtotal_venta, fechaCreacion_detalleVenta, id_venta, id_Producto)
SELECT     
    ((v.id_venta % 3) + 1) AS cantidad,
    p.precioUnitario_producto,    
    (((v.id_venta % 3) + 1) * p.precioUnitario_producto) AS subtotal_venta,
    GETDATE(),
    v.id_venta,
    p.id_Producto
FROM dbo.VENTA v
INNER JOIN dbo.PRODUCTO p ON p.id_Producto = ((v.id_venta - 1) % 50) + 1;
GO

/* ============================================================================== 
   5. CARGA MASIVA CORREGIDA: COMPRA_PROVEEDOR Y DETALLE_COMPRA
   ============================================================================== */

DELETE FROM dbo.DETALLE_COMPRA;
DELETE FROM dbo.COMPRA_PROVEEDOR;
GO

-- Insertar 500 Compras a Proveedor
WITH N AS (
    SELECT TOP (500) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects a CROSS JOIN sys.objects b
)
INSERT INTO dbo.COMPRA_PROVEEDOR (fecha_compra, fechaCreacion_compraProveedor, estado_compraProveedor, id_proveedor)
SELECT 
    DATEADD(DAY, - (n % 180), GETDATE()),
    GETDATE(),
    1,
    1
FROM N;
GO

-- Insertar Detalle Compra de forma segura
INSERT INTO dbo.DETALLE_COMPRA (cantidad, precio_unitario, subtotal_compra, fechaCreacion_detalleCompra, id_compra, id_Producto)
SELECT 
    10 AS cantidad,    
    (p.precio_producto * 0.7) AS precio_unitario,    
    (10 * (p.precio_producto * 0.7)) AS subtotal_compra,
    GETDATE(),
    c.id_compra,
    p.id_Producto
FROM dbo.COMPRA_PROVEEDOR c
INNER JOIN dbo.PRODUCTO p ON p.id_Producto = ((c.id_compra - 1) % 50) + 1;
GO

/* ============================================================================== 
   VERIFICACIÓN FINAL
   ============================================================================== */

SELECT 'VENTA' AS Tabla, COUNT(*) AS Total FROM dbo.VENTA
UNION ALL
SELECT 'DETALLE_VENTA', COUNT(*) FROM dbo.DETALLE_VENTA
UNION ALL
SELECT 'COMPRA_PROVEEDOR', COUNT(*) FROM dbo.COMPRA_PROVEEDOR
UNION ALL
SELECT 'DETALLE_COMPRA', COUNT(*) FROM dbo.DETALLE_COMPRA;
GO


/* ============================================================================== 
   CASOS DE PRUEBA
   ============================================================================== */

-- Activamos las estadísticas de rendimiento para medir IO y Tiempo
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

--------------------------------------------------------------------------------
-- CASO DE PRUEBA 1: Productos filtrados por categoría
--------------------------------------------------------------------------------

-- Salida esperada (Utiliza el índice IX_PRODUCTO_id_categoria):
SELECT id_Producto, nombre_producto, precioUnitario_producto, stock_producto
FROM dbo.PRODUCTO
WHERE id_categoria = 1;
GO

-- Salida no esperada (Filtra por un nombre de columna incorrecto o inexistente):
-- SELECT id_Producto, nombre_producto, precioUnitario_producto 
-- FROM dbo.PRODUCTO 
-- WHERE categoria = 1;
-- GO

--------------------------------------------------------------------------------
-- CASO DE PRUEBA 2: Detalles de una venta (Índice de Cobertura)
--------------------------------------------------------------------------------

-- Salida esperada (Utiliza el índice IX_DETALLE_VENTA_id_venta con INCLUDE):
SELECT id_detalleVenta, id_venta, id_Producto, cantidad, precio, subtotal_venta
FROM dbo.DETALLE_VENTA
WHERE id_venta = (SELECT TOP 1 id_venta FROM dbo.DETALLE_VENTA);
GO

-- Salida no esperada (Error tipográfico en el nombre de la tabla):
-- SELECT id_venta, id_Producto, cantidad, precio 
-- FROM dbo.DETALLE_VENTAS 
-- WHERE id_venta = 1;
-- GO

--------------------------------------------------------------------------------
-- CASO DE PRUEBA 3: Detalles de una compra a proveedor (Índice de Cobertura)
--------------------------------------------------------------------------------

-- Salida esperada (Utiliza el índice IX_DETALLE_COMPRA_id_compra con INCLUDE):
SELECT id_DetalleCompra, id_compra, id_Producto, cantidad, precio_unitario, subtotal_compra
FROM dbo.DETALLE_COMPRA
WHERE id_compra = (SELECT TOP 1 id_compra FROM dbo.DETALLE_COMPRA);
GO

