# Implementación Física de la Base de Datos

Este documento detalla las decisiones tomadas durante la fase de implementación física (Scripts SQL) para el sistema del Pet Shop del Litoral.

## 1. Definición de Tipos de Datos (DDL)
Durante la creación de las tablas mediante el script DDL, se establecieron las siguientes políticas para la asignación de tipos de datos, buscando garantizar la integridad, precisión y eficiencia del almacenamiento:

*   **Identificadores (PRIMARY KEY):** Se utilizó el tipo `INT` para todas las claves primarias (como `id_producto`, `id_cliente`, `id_venta`), garantizando una indexación rápida y un rendimiento óptimo en las relaciones.
*   **Datos Monetarios:** Para atributos críticos como `precio_unitario`, `subtotal`, se seleccionó explícitamente el tipo `DECIMAL(10,2)`. Esto previene la pérdida de precisión y los errores de redondeo asociados a tipos de punto flotante como FLOAT o DOUBLE.
*   **Cadenas de Texto:** Se implementó `VARCHAR` para atributos de longitud variable (`nombre_producto`, `correo_persona`, `direccion_persona`), optimizando el espacio en disco. Se definieron límites máximos acordes a cada campo (por ejemplo, `VARCHAR(100)` para correos y `VARCHAR(255)` para descripciones).
*   **Fechas y Tiempos:** Se empleó el tipo `DATE` para campos como `fecha_venta` y `fecha_compra`, permitiendo un registro cronológico exacto de las operaciones comerciales.

## 2. Integridad Referencial y Restricciones
*   **Restricciones de Dominio:** Se implementaron cláusulas `NOT NULL` en campos obligatorios para el negocio y `UNIQUE` en atributos que no pueden repetirse, como el DNI o el correo electrónico de los usuarios.
