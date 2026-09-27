CREATE DATABASE PETSHOPDELLITORAL;

CREATE TABLE CATEGORIA
(
  id_categoria INT NOT NULL,
  nombre_categoria INT NOT NULL,
  estado_categoria INT NOT NULL,
  fechaCreacion_categoria DATE NOT NULL,
  CONSTRAINT PK_CATEGORIA PRIMARY KEY (id_categoria)
);

CREATE TABLE PRODUCTO
(
  id_Producto INT NOT NULL,
  nombre_producto VARCHAR(100) NOT NULL,
  descripcion_producto VARCHAR(100) NOT NULL,
  precio_producto FLOAT NOT NULL,
  stock_producto INT NOT NULL,
  stock_minimo INT NOT NULL,
  precioUnitario_producto FLOAT NOT NULL,
  fechaCreacion_producto DATE NOT NULL,
  estado_producto INT NOT NULL,
  id_categoria INT NOT NULL,
  CONSTRAINT PK_PRODUCTO PRIMARY KEY (id_Producto)
 
);

CREATE TABLE Calle
(
  id_calle INT NOT NULL,
  nombre_calle INT NOT NULL,
  CONSTRAINT PK_CALLE PRIMARY KEY (id_Calle)
);

CREATE TABLE Dirección
(
  id_direccion INT NOT NULL,
  altura INT NOT NULL,
  id_calle INT NOT NULL,
  CONSTRAINT PK_DIRECCION PRIMARY KEY (id_direccion),
  
);

CREATE TABLE PERSONA
(
  id_persona INT NOT NULL,
  nombre_persona VARCHAR(100) NOT NULL,
  apellido_persona VARCHAR(100) NOT NULL,
  correo_persona VARCHAR(100) NOT NULL,
  telefono_persona INT NOT NULL,
  dni_persona INT NOT NULL,
  estado_persona INT NOT NULL,
  fechaCreacion_persona DATE NOT NULL,
  id_direccion INT NOT NULL,
  CONSTRAINT PK_PERSONA PRIMARY KEY (id_persona)
 
);

CREATE TABLE PROVEEDOR
(
  id_proveedor INT NOT NULL,
  estado_proveedor INT NOT NULL,
  id_persona INT NOT NULL,
  CONSTRAINT PK_PROVEEDOR PRIMARY KEY (id_proveedor)
 
);

CREATE TABLE COMPRA_PROVEEDOR
(
  id_compra INT NOT NULL,
  fecha_compra INT NOT NULL,
  fechaCreacion_compraProveedor DATE NOT NULL,
  estado_compraProveedor INT NOT NULL,
  id_proveedor INT NOT NULL,
  CONSTRAINT PK_COMPRA_PROVEEDOR PRIMARY KEY (id_compra)
  
);

CREATE TABLE DETALLE_COMPRA
(
  id_DetalleCompra INT NOT NULL,
  cantidad INT NOT NULL,
  precio_unitario FLOAT NOT NULL,
  subtotal_compra FLOAT NOT NULL,
  fechaCreacion_detalleCompra DATE NOT NULL,
  id_compra INT NOT NULL,
  id_Producto INT NOT NULL,
  CONSTRAINT PK_DETALLE_COMPRA PRIMARY KEY (id_DetalleCompra),

);

CREATE TABLE ROL
(
  id_rol INT NOT NULL,
  rol_descripcion INT NOT NULL,
  fechaCreacion_rol DATE NOT NULL,
  CONSTRAINT PK_ROL PRIMARY KEY (id_rol)
);

CREATE TABLE USUARIO
(
  id_usuario INT NOT NULL,
  contrasenia_usuario INT NOT NULL,
  estado_usuario INT NOT NULL,
  id_rol INT NOT NULL,
  id_persona INT NOT NULL,
  CONSTRAINT PK_USUARIO PRIMARY KEY (id_usuario)
 
);

CREATE TABLE CLIENTE
(
  id_cliente INT NOT NULL,
  estado_cliente INT NOT NULL,
  id_persona INT NOT NULL,
  CONSTRAINT PK_CLIENTE PRIMARY KEY (id_cliente)
 
);

CREATE TABLE METODO_PAGO
(
  id_metodoPago INT NOT NULL,
  nombre_metodo VARCHAR(100) NOT NULL,
  estado_metodoPago INT NOT NULL,
  fechaCreacion_metodoPago DATE NOT NULL,
  CONSTRAINT PK_METODO_PAGO PRIMARY KEY (id_metodoPago)
);

CREATE TABLE VENTA
(
  id_venta INT NOT NULL,
  fecha_venta INT NOT NULL,
  estado_venta INT NOT NULL,
  id_usuario INT NOT NULL,
  id_metodoPago INT NOT NULL,
  id_cliente INT NOT NULL,
  CONSTRAINT PK_VENTA PRIMARY KEY (id_venta)
);

CREATE TABLE DETALLE_VENTA
(
  id_detalleVenta INT NOT NULL,
  cantidad INT NOT NULL,
  precio FLOAT NOT NULL,
  subtotal_venta FLOAT NOT NULL,
  fechaCreacion_detalleVenta DATE NOT NULL,
  id_venta INT NOT NULL,
  id_Producto INT NOT NULL,
  CONSTRAINT PK_DETALLE_VENTA PRIMARY KEY (id_detalleVenta)
 
);