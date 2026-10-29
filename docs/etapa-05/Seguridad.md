# Informe de Implementación: Seguridad, Usuarios y Roles


## 1. Definición del Tema

La **Seguridad en bases de datos** implica proteger la información contra accesos no autorizados y manipulaciones indebidas. En SQL Server, esto se gestiona mediante un modelo de dos capas:
*   **Autenticación (Logins):** Controla quién puede conectarse al servidor de base de datos.
*   **Autorización (Usuarios y Roles):** Define qué acciones (GRANT, DENY, REVOKE) puede realizar una identidad dentro de una base de datos específica.

El uso de **Roles** permite agrupar privilegios. En lugar de asignar permisos a cada usuario individualmente, se otorgan al rol, y luego los usuarios se añaden como miembros de dicho rol, facilitando enormemente la administración y cumpliendo con el **Principio de Mínimo Privilegio**.

## 2. ¿Por qué creamos este script y en qué nos sirve?

En el contexto de **PetShopDelLitoral**, el sistema será utilizado por distintos perfiles de empleados. No todos deben tener acceso a las mismas funciones:

*   **El Vendedor:** Su tarea principal es atender al cliente. Necesita ver el catálogo de productos y registrar ventas. Sin embargo, **no debe** poder alterar los precios de los alimentos o accesorios, ni eliminar registros de la base de datos, ya que esto podría dar lugar a fraudes o errores humanos severos.
*   **El Administrador:** Es el encargado de mantener el catálogo, agregar nuevas categorías y corregir descripciones. A pesar de su nivel jerárquico, la alteración de precios debe estar controlada por reglas de negocio estrictas (por ejemplo, para generar registros de auditoría), por lo que tampoco se le permite hacer un `UPDATE` directo al precio, sino que se le obliga a utilizar un procedimiento almacenado específico.

Este esquema protege la integridad financiera y operativa de la tienda de mascotas.

## 3. Resultados Esperados y No Esperados
Para validar la seguridad, se simuló el inicio de sesión con cada usuario ejecutando sentencias DML (Data Manipulation Language).

**Para el perfil Vendedor (usuario_vendedor):**

Prueba Correcta (Esperada): Se ejecuta un SELECT sobre el catálogo de productos. El motor procesa la consulta y devuelve los registros correctamente, ya que el vendedor tiene permiso de lectura.

Prueba Incorrecta (No esperada - Bloqueo exitoso): Se intenta ejecutar un UPDATE para cambiar el precio de un producto. SQL Server aborta la transacción y devuelve el error:

Msg 229, Level 14, State 5: The UPDATE permission was denied on the object 'PRODUCTO', database 'PetShopDelLitoral', schema 'dbo'.

**Para el perfil Administrador (usuario_admin):**

Prueba Correcta (Esperada): Se ejecuta un UPDATE para modificar la descripcion_producto de un registro. La operación es exitosa (1 row affected), ya que se le otorgó permiso explícito de modificación sobre esa columna específica.

Prueba Incorrecta (No esperada - Bloqueo exitoso): Se intenta ejecutar un UPDATE directo sobre la columna precio_producto (saltándose el procedimiento almacenado). La base de datos bloquea la operación y devuelve un error de permisos denegados, demostrando que la seguridad a nivel de columna funciona perfectamente.
## 4. Conclusión

La implementación de este modelo de seguridad robustece significativamente la base de datos de **PetShopDelLitoral**. 

Al trasladar la seguridad directamente al motor SQL Server mediante roles restrictivos y la denegación explícita de permisos (`DENY`), garantizamos que ninguna aplicación externa, vulnerabilidad del sistema o manipulación manual pueda corromper los datos críticos de la tienda. Los datos quedan protegidos por el propio motor, asegurando una operativa confiable y auditable a largo plazo.