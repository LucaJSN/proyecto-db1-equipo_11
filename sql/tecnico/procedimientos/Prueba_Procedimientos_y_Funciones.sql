-- Carga de datos con operaciones directas

INSERT INTO PRODUCTO(nombre_producto, descripcion_producto, precio_producto, stock_producto, 
                    stock_minimo, precioUnitario_producto, id_categoria, estado_producto)
VALUES ('Bolsas eco', '30 unidades de bolsas 10x20cm', 6000, 10, 2, 8700, 2, 1);

INSERT INTO PRODUCTO(nombre_producto, descripcion_producto, precio_producto, stock_producto, 
                    stock_minimo, precioUnitario_producto, id_categoria, estado_producto)
VALUES ('Arnes Pechera', 'Medidas disponibles S, M, L', 25000, 5, 1, 37000, 2, 1);

INSERT INTO PRODUCTO(nombre_producto, descripcion_producto, precio_producto, stock_producto, 
                    stock_minimo, precioUnitario_producto, id_categoria, estado_producto)
VALUES ('Collar rosa', 'Diseñado con estampado', 8500, 5, 1, 15000, 2, 1);

INSERT INTO PRODUCTO(nombre_producto, descripcion_producto, precio_producto, stock_producto, 
                    stock_minimo, precioUnitario_producto, id_categoria, estado_producto)
VALUES ('Dispensador de bolsas', 'Tipo huesito, varios colores', 4500, 7, 2, 6000, 2, 1);

INSERT INTO PRODUCTO(nombre_producto, descripcion_producto, precio_producto, stock_producto, 
                    stock_minimo, precioUnitario_producto, id_categoria, estado_producto)
VALUES ('Correa gris', 'Largo 1,2 mts', 9000, 3, 1, 10500, 2, 1);

-- Carga de datos con el procedimielto AltaProducto
EXECUTE Dbo.AltaProducto 'Vara para gato', 'Vara resistente con pluma', 5000, 15, 3, 7500, 4;
EXECUTE Dbo.AltaProducto 'Capnip Helado', 'Juguete en forma de helado celeste', 3200, 10, 1, 4000, 4;
EXECUTE Dbo.AltaProducto 'Pelota pluma', 'Pelota azul resistente', 19000, 15, 1, 24000, 4;
EXECUTE Dbo.AltaProducto 'Juguete pollito', 'Pollito a cuerda', 18000, 5, 1, 25000, 4;
EXECUTE Dbo.AltaProducto 'Set pelotas de caucho', '4 pelotas colores surtidos', 6000, 20, 2, 7500, 4;

-- Borrado lógico de productos con operaciones directas

-- Update del estado de un producto
UPDATE PRODUCTO 
SET  estado_producto = 0 
WHERE id_producto = 8;

-- Procedimiento almacenado
EXECUTE Dbo.EliminarProducto 6;

/* Actualizar el precio costo (precio_producto) y el precio de venta (precio_unitario) 
a partir del anterior y un incremento */

-- Operación directa
UPDATE PRODUCTO 
SET  precio_producto = 3000,
precioUnitario_producto = 3000 * 1.20
WHERE id_producto = 4;

-- Procedimiento almacenado
EXECUTE Dbo.ModificarPrecioProducto 3, 11000, 20

-- Carga de datos de ventas utilizando operaciones directas y transacciones

EXECUTE RegistrarVenta 2, 4, 3, 1, 5;
EXECUTE RegistrarVenta 2, 4, 4, 1, 4;
EXECUTE RegistrarVenta 2, 4, 5, 1, 2;

DECLARE @fecha_prueba DATE;
SET @fecha_prueba = '2026-10-23';

DECLARE @id_venta_actual INT;

INSERT INTO VENTA(fecha_venta, estado_venta, id_usuario, id_metodoPago, id_cliente)
VALUES (@fecha_prueba, 1, 2, 1, 6);

SET @id_venta_actual = SCOPE_IDENTITY();

INSERT INTO DETALLE_VENTA(cantidad, precio, subtotal_venta, id_venta, id_Producto, fechaCreacion_detalleVenta)
VALUES 
(2, 7500, 15000, @id_venta_actual, 18, @fecha_prueba),
(2, 25000, 50000, @id_venta_actual, 17, @fecha_prueba),
(2, 24000, 48000, @id_venta_actual, 16, @fecha_prueba);

-- Ejecutar las funciones, se utiliza un select para mostrar los resultados

-- Muestra los 6 productos más vendidos entre el '2026-10-23' y el dia de hoy
SELECT nombre_producto AS 'Producto', cantidad AS 'Cantidad' 
FROM dbo.fn_ProductosMasVendidos('2026-10-23', GETDATE(), 6); 

-- Muestra la cantidad de ventas realizadas en la fecha de prueba
SELECT dbo.fn_CantVentasDelDia('2026-10-23') AS 'Cantidad ventas de la fecha prueba';

-- Muestra el total generado en las ventas realizadas entre la fecha de prueba y la de hoy
SELECT dbo.fn_TotalVentasRango('2026-10-23', GETDATE()) AS 'Total generado'; 