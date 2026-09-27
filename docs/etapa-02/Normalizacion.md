# **Normalización**



**1FN:** 

Se utilizaron tablas intermedias para romper relaciones de mucho a mucho, por ejemplo:

&#x20; - Compra\_Proveedor tiene muchos Productos en una compra y un Producto puede estar en muchas Compras. La tabla intermedia Detalle\_Compra corta la relación NaN y utiliza una PK compuesta de con las PK de ambas tablas.

&#x20; - Misma relación existe entre Venta y Producto, cuya tabla intermedia se denomina Venta\_Detalle.



**2FN:**

Se reemplazaron las instancias con PK compuesta por la utilización de una PK simple con la condición de que la combinación de ambas partes de la clave compuesta anterior (por ej: id\_Compra y id\_Producto en Detalle\_Compra) sea única en cada tabla. Ejemplos númericos:

&#x20; - 1º Registro: id\_Compra (04) y id\_Producto (06)

&#x20; - 2º Registro: id\_Compra (04) y id\_Producto (08)

&#x20; - Error: cuando se trata de insertar id\_Compra (04) y id\_Producto (06) de nuevo.



**3FN:**

Se separo datos repetidos en tablas distintas, por ejemplo: 

&#x20; - Rol de la tabla Usuario.

&#x20; - Categoria de la tabla Producto.

&#x20; - Método\_Pago de la tabla Venta.

