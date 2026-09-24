# Modelo Relacional 

## Diagrama

<img width="4512" height="1917" alt="Modelo Relacional - Diagrama" src="https://github.com/user-attachments/assets/67566690-9b17-4c36-b834-91c86a9c29d5" />

## 1. Tablas y Atributos

* **Persona**:

  * `id_persona` (Clave Primaria, INT)

  * `fechaCreacion_persona` (DATETIME)

  * `direccion_persona` (VARCHAR)

  * `nombre_persona` (VARCHAR)

  * `apellido_persona` (VARCHAR)

  * `correo_persona` (VARCHAR)

  * `telefono_persona` (VARCHAR)

  * `dni_persona` (VARCHAR, Unique)

  * `estado_persona` (VARCHAR)

  * `id_direccion` (Clave Foránea, INT)

* **Direccion**:

  * `id_direccion` (Clave Primaria, INT)

  * `altura` (INT)

  * `id_calle` (Clave Foránea, INT)

* **Calle**:

  * `id_calle` (Clave Primaria, INT)

  * `nombre_calle` (VARCHAR)

* **Cliente**:

  * `id_cliente` (Clave Primaria, INT)

  * `estado_cliente` (VARCHAR)

  * `id_persona` (Clave Foránea, INT)

* **Usuario**:

  * `id_usuario` (Clave Primaria, INT)

  * `estado_usuario` (VARCHAR)

  * `contrasenia_usuario` (VARCHAR)

  * `id_rol` (Clave Foránea, INT)

  * `id_persona` (Clave Foránea, INT)

* **Rol**:

  * `id_rol` (Clave Primaria, INT)

  * `fechaCreacion_rol` (DATETIME)

  * `rol_descripcion` (VARCHAR)

* **Proveedor**:

  * `id_proveedor` (Clave Primaria, INT)

  * `estado_proveedor` (VARCHAR)

  * `id_persona` (Clave Foránea, INT)

* **Categoria**:

  * `id_categoria` (Clave Primaria, INT)

  * `estado_categoria` (VARCHAR)

  * `fechaCreacion_categoria` (DATETIME)

  * `nombre_categoria` (VARCHAR)

* **Producto**:

  * `id_Producto` (Clave Primaria, INT)

  * `fechaCreacion_producto` (DATETIME)

  * `estado_producto` (VARCHAR)

  * `nombre_producto` (VARCHAR)

  * `descripcion_producto` (VARCHAR)

  * `precio_producto` (FLOAT)

  * `stock_producto` (INT)

  * `stock_minimo` (INT)

  * `precioUnitario_producto` (FLOAT)

  * `id_categoria` (Clave Foránea, INT)

* **Metodo_Pago**:

  * `id_metodoPago` (Clave Primaria, INT)

  * `estado_metodoPago` (VARCHAR)

  * `fechaCreacion_metodoPago` (DATETIME)

  * `nombre_metodo` (VARCHAR)

* **Venta**:

  * `id_venta` (Clave Primaria, INT)

  * `estado_venta` (VARCHAR)

  * `fecha_venta` (DATETIME)

  * `id_usuario` (Clave Foránea, INT)

  * `id_metodoPago` (Clave Foránea, INT)

  * `id_cliente` (Clave Foránea, INT)

* **Detalle_Venta**:

  * `id_detalleVenta` (Clave Primaria, INT)

  * `subtotal_venta` (FLOAT)

  * `fechaCreacion_detalleVenta` (DATETIME)

  * `cantidad` (INT)

  * `precio` (FLOAT)

  * `id_venta` (Clave Foránea, INT)

  * `id_Producto` (Clave Foránea, INT)

* **Compra_Proveedor**:

  * `id_compra` (Clave Primaria, INT)

  * `fechaCreacion_compra` (DATETIME)

  * `estado_compraProveedor` (VARCHAR)

  * `fecha_compra` (DATETIME)

  * `id_proveedor` (Clave Foránea, INT)

* **Detalle_Compra**:

  * `id_DetalleCompra` (Clave Primaria, INT)

  * `fechaCreacion_detalleCompra` (DATETIME)

  * `cantidad` (INT)

  * `precio_unitario` (FLOAT)

  * `subtotal_compra` (FLOAT)

  * `id_compra` (Clave Foránea, INT)

  * `id_Producto` (Clave Foránea, INT)

## 2. Relaciones del Modelo

* **Persona - Dirección - Calle:** Una `Persona` está asociada a una `Dirección`, y esta última se ubica en una `Calle`.

* **Herencia / Especialización:** Las entidades `Cliente`, `Usuario` y `Proveedor` extienden de la entidad `Persona` mediante una relación de 1 a 1 a través de sus claves foráneas.

* **Usuario - Rol:** Un `Usuario` tiene asignado un `Rol` determinado dentro del sistema.

* **Ventas:**

  * Un `Cliente` realiza una o más `Venta`s.

  * Un `Usuario` (empleado/administrador) gestiona y registra la `Venta`.

  * Una `Venta` se procesa utilizando un `Metodo_Pago`.

  * Una `Venta` contiene múltiples registros en `Detalle_Venta`.

  * Cada `Detalle_Venta` está vinculado a un `Producto` específico.

* **Compras:**

  * Un `Proveedor` es el destinatario o emisor de una `Compra_Proveedor`.

  * Una `Compra_Proveedor` contiene múltiples registros en `Detalle_Compra`.

  * Cada `Detalle_Compra` hace referencia a un `Producto` adquirido para reabastecer el stock.

* **Catálogo:**

  * Un `Producto` pertenece obligatoriamente a una `Categoria`.
