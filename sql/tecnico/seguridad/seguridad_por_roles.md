# Script de Implementación y Pruebas: Seguridad

A continuación se detalla el código SQL utilizado para la creación de credenciales, asignación de roles y verificación práctica de permisos en la base de datos `PetShopDelLitoral`.

## Script SQL Completo

```sql
--Seguridad 

/* =====================================================   
   PET SHOP DEL LITORAL   
   SCRIPT A - LOGINS DE SQL SERVER   
   Contexto: SERVIDOR   
   ===================================================== */

/* Contexto: servidor */
CREATE LOGIN usuario_admin WITH PASSWORD = 'Admin123*';
CREATE LOGIN usuario_vendedor WITH PASSWORD = 'Vendedor123*';
GO

/* Contexto: base de datos PetShopDelLitoral */
USE PetShopDelLitoral;
GO
CREATE USER usuario_admin FOR LOGIN usuario_admin;
CREATE USER usuario_vendedor FOR LOGIN usuario_vendedor;
GO

/* Crear rol de administrador y vendedor */
CREATE ROLE rol_admin_petshop;
CREATE ROLE rol_vendedor_petshop;
GO

/* Asignar usuarios a sus roles */
ALTER ROLE rol_admin_petshop ADD MEMBER usuario_admin;
ALTER ROLE rol_vendedor_petshop ADD MEMBER usuario_vendedor;
GO


/* =====================================================
   PERMISOS DEL ADMINISTRADOR
   ===================================================== */
/* Consultar y agregar productos */
GRANT SELECT, INSERT ON OBJECT::dbo.PRODUCTO TO [rol_admin_petshop];

/* Modificar datos generales del producto, sin modificar directamente los precios ni el stock */
GRANT UPDATE (
    nombre_producto,
    descripcion_producto,
    estado_producto,
    id_Categoria
) ON OBJECT::dbo.PRODUCTO TO [rol_admin_petshop];

/* Administrar categorías */
GRANT SELECT, INSERT, UPDATE ON OBJECT::dbo.CATEGORIA TO [rol_admin_petshop];

/* Consultar ventas y detalles */
GRANT SELECT ON OBJECT::dbo.VENTA TO [rol_admin_petshop];
GRANT SELECT ON OBJECT::dbo.DETALLE_VENTA TO [rol_admin_petshop];

/* Modificar precios mediante el procedimiento */
GRANT EXECUTE ON OBJECT::dbo.ModificarPrecioProducto TO [rol_admin_petshop];
GO


/* =====================================================   
   2. PERMISOS DEL VENDEDOR   
   ===================================================== */
/* Consultar el catálogo */
GRANT SELECT ON OBJECT::dbo.PRODUCTO TO [rol_vendedor_petshop];
GRANT SELECT ON OBJECT::dbo.CATEGORIA TO [rol_vendedor_petshop];

/* Registrar ventas mediante el procedimiento */
GRANT EXECUTE ON OBJECT::dbo.RegistrarVenta TO [rol_vendedor_petshop];

/* Impedir modificaciones directas de productos */
DENY INSERT, UPDATE, DELETE ON OBJECT::dbo.PRODUCTO TO [rol_vendedor_petshop];

/* Impedir el uso del procedimiento que modifica precios */
DENY EXECUTE ON OBJECT::dbo.ModificarPrecioProducto TO [rol_vendedor_petshop];
GO


/* =====================================================   
   PRUEBAS TEÓRICAS (Verificación de metadatos)
   ===================================================== */
/* VENDEDOR */
EXECUTE AS USER = 'usuario_vendedor';
SELECT
    HAS_PERMS_BY_NAME('dbo.RegistrarVenta', 'OBJECT', 'EXECUTE') AS puede_registrar_ventas,
    HAS_PERMS_BY_NAME('dbo.ModificarPrecioProducto', 'OBJECT', 'EXECUTE') AS puede_modificar_precios,
    HAS_PERMS_BY_NAME('dbo.PRODUCTO', 'OBJECT', 'UPDATE') AS puede_actualizar_productos;
REVERT;
GO

/* ADMINISTRADOR */
EXECUTE AS USER = 'usuario_admin';
SELECT
    HAS_PERMS_BY_NAME('dbo.RegistrarVenta', 'OBJECT', 'EXECUTE') AS puede_registrar_ventas,
    HAS_PERMS_BY_NAME('dbo.ModificarPrecioProducto', 'OBJECT', 'EXECUTE') AS puede_modificar_precios,
    HAS_PERMS_BY_NAME('dbo.PRODUCTO', 'precio_producto', 'UPDATE') AS puede_actualizar_precio_directamente;
REVERT;
GO


/* =====================================================   
   PRUEBA 1: VERIFICACIÓN PRÁCTICA DEL VENDEDOR   
   ===================================================== */
EXECUTE AS USER = 'usuario_vendedor';
GO

-- 1A. Prueba Correcta: Consultar el catálogo de productos
-- Resultado esperado: Retorna los registros de la tabla (Éxito)
SELECT TOP 5 id_Producto, nombre_producto, precio_producto FROM dbo.PRODUCTO;
GO

-- 1B. Prueba Incorrecta: Intentar modificar el precio de un producto
-- Resultado esperado: Permiso denegado
UPDATE dbo.PRODUCTO SET precio_producto = 15000 WHERE id_Producto = 1;
GO

REVERT;
GO


/* =====================================================   
   PRUEBA 2: VERIFICACIÓN PRÁCTICA DEL ADMINISTRADOR   
   ===================================================== */
EXECUTE AS USER = 'usuario_admin';
GO

-- 2A. Prueba Correcta: Actualizar la descripción de un producto (Permitido)
-- Resultado esperado: 1 row(s) affected (Éxito)
UPDATE dbo.PRODUCTO SET descripcion_producto = 'Descripción actualizada por el administrador' WHERE id_Producto = 1;
GO

-- 2B. Prueba Incorrecta: Intentar actualizar el precio directamente (Denegado)
-- Resultado esperado: Permiso denegado
UPDATE dbo.PRODUCTO SET precio_producto = 25000 WHERE id_Producto = 1;
GO

REVERT;
GO
```