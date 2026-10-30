# Informe de Implementación: Auditoría de Modificaciones en Productos mediante Triggers

> **Proyecto:** PetShopDelLitoral - Sistema de Ventas para Tienda de Mascotas
>
> **Materia:** Base de Datos I
>
> **Etapa:** V - triggers de auditoría

---

## 1. Definición del Tema

Los **triggers (disparadores)** en SQL Server son objetos de base de datos que permiten ejecutar automáticamente un conjunto de instrucciones SQL como respuesta a determinados eventos que ocurren sobre una tabla o vista.

En esta implementación, utilizamos un **Trigger DML de tipo AFTER UPDATE**, que se ejecuta automáticamente después de realizar una modificación sobre la tabla `PRODUCTO`.

Para desarrollar esta funcionalidad, trabajamos con tres conceptos fundamentales:

- **Tablas lógicas INSERTED y DELETED:** Son estructuras temporales administradas por SQL Server que permiten acceder a los registros nuevos y anteriores, respectivamente, durante una operación de actualización.
- **Auditoría de datos:** Consiste en almacenar información sobre las modificaciones realizadas, conservando tanto los valores anteriores como los nuevos.
- **SUSER_SNAME():** Función que permite identificar el inicio de sesión de SQL Server asociado a la operación, registrando quién realizó la modificación desde el punto de vista del motor de base de datos.

---

## 2. ¿Por qué este script y para qué nos sirve?

A medida que **PetShopDelLitoral** opere diariamente, se realizarán numerosas modificaciones sobre los productos, principalmente relacionadas con la actualización de precios y la gestión del stock.

Estas modificaciones pueden originarse por diferentes operaciones del sistema, como registrar una venta, ingresar mercadería de un proveedor o realizar ajustes manuales por parte de un administrador.

### El problema (Sin auditoría)

- No existiría un registro histórico de los precios anteriores de los productos, dificultando el seguimiento de sus variaciones.
- Las modificaciones de stock no podrían rastrearse posteriormente para conocer cuáles eran los valores previos.
- Ante una inconsistencia en el inventario, resultaría difícil reconstruir qué valores fueron modificados y desde qué inicio de sesión se realizó la operación.
- **Resultado:** Pérdida de trazabilidad sobre los cambios realizados en información importante para el funcionamiento comercial y dificultad (o imposibilidad) para realizar estadísticas de negocio.

### La solución (Con auditoría)

**Trazabilidad automática de las modificaciones.**

Se implementó una tabla denominada `AuditoriaProductos`, destinada a almacenar un historial de las modificaciones realizadas sobre el stock y el precio unitario de cada producto.

Mediante el trigger `trg_Productos_Auditoria`, cada vez que se actualiza alguno de estos valores, SQL Server registra automáticamente:

- Id del producto afectado.
- Fecha y hora de la modificación.
- Inicio de sesión de SQL Server asociado a la operación.
- Stock anterior y stock nuevo.
- Precio anterior y precio nuevo.

Además, mediante la comparación entre las tablas lógicas `INSERTED` y `DELETED`, se garantiza que los valores registrados correspondan al mismo producto antes y después de la actualización.

Se incorporó una condición para evitar generar registros cuando se modifican columnas ajenas al stock y al precio.

---

## 3. Resultados Obtenidos

Para verificar el funcionamiento del trigger, se realizaron diferentes pruebas de actualización sobre la tabla `PRODUCTO`, comprobando los registros generados automáticamente en `AuditoriaProductos`.

| Escenario de Prueba | Comportamiento Esperado | Resultado |
|:---|:---|:---|
| **Modificación de stock y precio** | Registra los valores anteriores y nuevos de ambos atributos. | Auditoría generada correctamente. |
| **Modificación solamente del stock** | Registra el stock anterior y nuevo, conservando los valores del precio. | Auditoría generada correctamente. |
| **Modificación solamente del precio** | Registra el precio anterior y nuevo, conservando los valores del stock. | Auditoría generada correctamente. |
| **Actualización de múltiples productos** | Genera un registro de auditoría por cada producto afectado. | Permite procesar múltiples filas en una misma sentencia. |
| **Modificación de otra columna** | No genera registros si no se modifica el stock ni el precio. | Se evita almacenar información irrelevante. |
| **UPDATE sin coincidencias** | No genera registros porque no existen filas afectadas. | Comportamiento esperado. |

### Verificación de los datos registrados

Durante las pruebas se comprobó que el trigger obtiene correctamente los valores mediante las tablas lógicas `INSERTED` y `DELETED`.

Por ejemplo, si un producto tenía un stock de 15 unidades y un precio de $25.000, y posteriormente se actualiza a 20 unidades y $27.000, el historial conserva ambos estados:

- Stock anterior: 15.
- Stock nuevo: 20.
- Precio anterior: $25.000.
- Precio nuevo: $27.000.

De esta manera, la información original no se pierde después de ejecutar la actualización.

> **Nota sobre el alcance de la auditoría:** El trigger registra modificaciones del stock y del precio unitario, independientemente de que se originen por una venta, una compra o una intervención manual. Actualmente, no identifica el motivo específico de cada modificación, sino que conserva los valores anteriores y nuevos junto con el inicio de sesión asociado a la operación.

---

## 4. Conclusión

La implementación del trigger de auditoría en la base de datos de **PetShopDelLitoral** representa una mejora importante en materia de control y trazabilidad de la información.

Mediante la utilización de las tablas lógicas `INSERTED` y `DELETED`, logramos conservar automáticamente un historial de las modificaciones realizadas sobre atributos fundamentales de los productos, sin necesidad de incorporar instrucciones adicionales en cada operación de actualización del sistema.

También comprobamos que los triggers de SQL Server permiten trabajar con operaciones que afectan múltiples registros simultáneamente, garantizando que cada producto modificado genere su correspondiente entrada en el historial.

En conclusión, esta implementación proporciona una herramienta de seguimiento que facilita la detección de inconsistencias, el análisis de variaciones de precios y el control de movimientos de stock. De esta manera, fortalecemos la integridad operativa y la capacidad de supervisión de la base de datos, incorporando un mecanismo de auditoría centralizado y automatizado.