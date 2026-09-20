## Modelo Entidad-Relación (Diccionario de Datos)

### 1. Entidades y Atributos

**Entidades Principales (Jerarquía de Personas)**

* **Persona**:

  * `id_persona` (Clave Primaria)

  * `nombre_persona`

  * `apellido_persona`

  * `dni_persona`

  * `direccion_persona`

  * `telefono_persona`

  * `correo_persona`

* **Cliente**:

  * `id_cliente` (Clave Primaria)

* **Usuario**:

  * `id_usuario` (Clave Primaria)

  * `contrasenia_usuario`

* **Proveedor**:

  * `id_proveedor` (Clave Primaria)

**Entidades de Gestión y Configuración**

* **Rol**:

  * `id_rol` (Clave Primaria)

  * `rol_descripcion`

* **Categoria**:

  * `id_categoria` (Clave Primaria)

  * `nombre_categoria`

* **Metodo_Pago**:

  * `id_metodoPago` (Clave Primaria)

  * `nombre`

**Entidades de Catálogo**

* **Producto**:

  * `id_Producto` (Clave Primaria)

  * `nombre_producto`

  * `descripcion_producto`

  * `precioUnitario_producto`

  * `precio_producto`

  * `stock_producto`

  * `stock_minimo`

**Entidades de Transacciones (Ventas y Compras)**

* **Venta**:

  * `id_venta` (Clave Primaria)

  * `fecha_venta`

  * `total_venta`

* **Detalle_Venta**:

  * `id_venta`

  * `cantidad`

  * `precio`

  * `subtotal_venta`

* **Compra_Proveedor**:

  * `id_compra` (Clave Primaria)

  * `fecha_compra`

  * `monto_compra`

* **Detalle_Compra**:

  * `id_DetalleCompra` (Clave Primaria)

  * `cantidad`

  * `precio_unitario`

  * `subtotal_compra`

### 2. Relaciones

* **Herencia (Es un/a):** Las entidades `Cliente`, `Usuario` y `Proveedor` heredan los atributos de la entidad `Persona`.

* **Usuario - Rol:** Un Usuario *tiene* un Rol asignado (Administrador, Vendedor).

* **Ventas:**

  * Un Cliente *tiene* Ventas.

  * Un Usuario (empleado) *tiene* (gestiona) Ventas.

  * Una Venta *tiene* un Metodo_Pago.

  * Una Venta *tiene* múltiples Detalles_Venta.

* **Compras:**

  * Un Proveedor *tiene* (realiza) una Compra_Proveedor.

  * Una Compra_Proveedor *tiene* múltiples Detalles_Compra.

* **Productos:**

  * Un Producto *tiene* una Categoria.

  * Un Producto *tiene* Detalles_Venta (cuando se vende).

  * Un Producto *tiene* Detalles_Compra (cuando se reabastece el stock).