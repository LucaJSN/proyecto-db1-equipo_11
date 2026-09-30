INSERT INTO CATEGORIA (nombre_categoria, estado_categoria) VALUES 
('Alimentos', 1),
('Accesorios', 1),
('Higiene y Cuidado', 1),
('Juguetes', 1),
('Indumentaria', 1),
('Farmacia y Salud', 1),
('Peceras y Acuarios', 1),
('Paseo y Viaje', 1);

INSERT INTO CALLE (nombre_calle) VALUES 
('9 de Julio'),
('San Martín'),
('Belgrano'),
('Junín'),
('España'),
('Bolívar'),
('Salta'),
('Mendoza');

INSERT INTO ROL (rol_descripcion) VALUES 
('Administrador'),
('Vendedor'),
('Encargado de Stock'),
('Cajero'),
('Supervisor'),
('Gerente'),
('Atención al Cliente'),
('Auditor');

INSERT INTO METODO_PAGO (nombre_metodo, estado_metodoPago) VALUES 
('Efectivo', 1),
('Tarjeta de Crédito', 1),
('Tarjeta de Débito', 1),
('Transferencia Bancaria', 1),
('Mercado Pago', 1),
('Cuenta DNI', 1),
('Modo', 1),
('Cheque', 0);

INSERT INTO DIRECCION (altura, id_calle) VALUES 
(1230, 1),
(450, 2),
(890, 3),
(1520, 4),
(310, 5),
(775, 6),
(2040, 7),
(99, 8);

INSERT INTO PERSONA (nombre_persona, apellido_persona, correo_persona, telefono_persona, dni_persona, estado_persona, id_direccion) VALUES 
('Juan', 'Pérez', 'juan.perez@email.com', '3794123456', '35123456', 1, 1),
('María', 'Gómez', 'maria.gomez@email.com', '3794654321', '32654321', 1, 2),
('Carlos', 'López', 'carlos.lopez@email.com', '3794789123', '28789123', 1, 3),
('Ana', 'Martínez', 'ana.martinez@email.com', '3794456789', '38456789', 1, 4),
('Luis', 'Rodríguez', 'luis.rodriguez@email.com', '3794321654', '27321654', 1, 5),
('Sofía', 'Fernández', 'sofia.fernandez@email.com', '3794987321', '40987321', 1, 6),
('Diego', 'Ramírez', 'diego.ramirez@email.com', '3794112233', '31112233', 1, 7),
('Lucía', 'Benítez', 'lucia.benitez@email.com', '3794556677', '36556677', 1, 8);

INSERT INTO PRODUCTO (nombre_producto, descripcion_producto, precio_producto, stock_producto, stock_minimo, precioUnitario_producto, estado_producto, id_categoria) VALUES 
('Alimento Balanceado Perro 15kg', 'Comida premium para perros adultos', 25000.00, 25, 5, 25000.00, 1, 1),
('Piedras Sanitarias 4kg', 'Absorbentes para gatos', 4500.00, 40, 10, 4500.00, 1, 3),
('Correa Extensible 5m', 'Correa retráctil resistente', 12000.00, 15, 3, 12000.00, 1, 2),
('Pelota de Goma con Soga', 'Juguete interactivo para perros', 3500.00, 30, 8, 3500.00, 1, 4),
('Abrigo Polar para Perros', 'Indumentaria de invierno talle M', 8500.00, 12, 4, 8500.00, 1, 5),
('Antiparasitario Pipeta', 'Protección contra pulgas y garrapatas', 6000.00, 50, 15, 6000.00, 1, 6),
('Pecera de Vidrio 30L', 'Kit inicial para peces de agua fría', 35000.00, 8, 2, 35000.00, 1, 7),
('Bolso Transportadora', 'Canil flexible para gatos y perros chicos', 28000.00, 10, 3, 28000.00, 1, 8);

INSERT INTO PROVEEDOR (estado_proveedor, id_persona) VALUES 
(1, 5),
(1, 6),
(1, 7),
(1, 8),
(1, 1),
(1, 2),
(1, 3),
(1, 4);

INSERT INTO CLIENTE (estado_cliente, id_persona) VALUES 
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6),
(1, 7),
(1, 8);

INSERT INTO USUARIO (contrasenia_usuario, estado_usuario, id_rol, id_persona) VALUES 
('admin123', 1, 1, 1),
('vende456', 1, 2, 2),
('stock789', 1, 3, 3),
('cajero111', 1, 4, 4),
('super222', 1, 5, 5),
('gerente33', 1, 6, 6),
('atencion44', 1, 7, 7),
('auditor55', 1, 8, 8);

INSERT INTO COMPRA_PROVEEDOR (estado_compraProveedor, id_proveedor) VALUES 
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6),
(1, 7),
(1, 8);

INSERT INTO VENTA (estado_venta, id_usuario, id_metodoPago, id_cliente) VALUES 
(1, 2, 1, 1),
(1, 2, 2, 2),
(1, 4, 3, 3),
(1, 4, 4, 4),
(1, 2, 5, 5),
(1, 4, 6, 6),
(1, 2, 7, 7),
(1, 4, 1, 8);

INSERT INTO DETALLE_COMPRA (cantidad, precio_unitario, subtotal_compra, id_compra, id_Producto) VALUES 
(10, 20000.00, 200000.00, 1, 1),
(15, 3500.00, 52500.00, 2, 2),
(10, 9000.00, 90000.00, 3, 3),
(20, 2500.00, 50000.00, 4, 4),
(5, 6000.00, 30000.00, 5, 5),
(25, 4500.00, 112500.00, 6, 6),
(3, 28000.00, 84000.00, 7, 7),
(6, 22000.00, 132000.00, 8, 8);

INSERT INTO DETALLE_VENTA (cantidad, precio, subtotal_venta, id_venta, id_Producto) VALUES 
(2, 25000.00, 50000.00, 1, 1),
(3, 4500.00, 13500.00, 2, 2),
(1, 12000.00, 12000.00, 3, 3),
(4, 3500.00, 14000.00, 4, 4),
(1, 8500.00, 8500.00, 5, 5),
(2, 6000.00, 12000.00, 6, 6),
(1, 35000.00, 35000.00, 7, 7),
(1, 28000.00, 28000.00, 8, 8);