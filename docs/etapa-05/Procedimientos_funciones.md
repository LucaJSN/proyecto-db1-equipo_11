# Informe de Implementación: Procedimientos y funciones

## 1\. Definición del Tema

Un procedimiento almacenado es un código SQL precompilado que se puede guardar y reutilizar. Si se necesita realizar una operación repetidas veces es más sencillo llamar un procedimiento que volver a escribir todo lo que necesitamos. Un procedimiento también puede recibir parámetros que luego son utilizados en las operaciones.

En esta implementación, se crearon en un primer momento tres procedimientos almacenado:

* **AltaProducto:** para crear un producto a partir de los parámetros recibidos.
* **EliminarProducto**: para eliminar lógicamente (cambiando el campo estado) un producto a partir de su identificador.
* **ModificarPrecioProducto**: para modificar el precio de venta de un producto a partir del número de identificación del artículo, su precio de costo y un incremento a ese costo para el precio de venta.

Una función almacenada es una rutina que recibe parámetros y devuelve un valor o una tabla, no puede modificar los registros de la base de datos. Para nuestro proyecto se crearon las siguientes funciones:

* **ProductosMasVendidos:** a partir de una fecha de inicio, una fecha de finalización y una cantidad devuelve una tabla con los productos más vendidos en ese plazo, la cantidad determina si se devuelven los primeros tres productos, los primeros cinco, etc.
* **TotalVentasRango**: a partir de un intervalo de fechas, devuelve el monto total generado por todas las ventas.
* **CantVentasDelDia**: devuelve la cantidad de ventas en una fecha particular que se pasa como parámetro.

## 2\. ¿Por qué creamos estos scripts y para qué nos sirven?

Se identificaron operaciones complejas que serán utilizadas continuamente por nuestro sistema, por ejemplo se necesita una manera rápida de calcular el total de ventas en una semana o mes para realizar un presupuesto adecuado.

Además con estas herramientas mejoramos la mantenibilidad del código porque para modificarlo solo lo hacemos una vez y no múltiples. También facilita la seguridad de los datos, por ejemplo una de las reglas del negocio solo permite al administrador del local modificar el precio de un producto y para concretar este requerimiento es necesario crear un procedimiento que será autorizado para el administrador y negado para el vendedor.


## 3\. Resultados Obtenidos

Para verificar la eficiencia de las operación directas versus el uso de procedimientos y funciones se realizaron casos de prueba en los cuales se utilizaron las mismas instrucciones SQL. Luego se comprobó, usando el plan de ejecución estimado en SQL Server, la eficiencia de cada

enfoque. El resultado final fue el mismo rendimiento en ambos casos pues los sistemas de gestión de bases de datos modernos optimizan de la misma manera las dos alternativas.

En términos de seguridad se encontraron diferencias, como lo explicado en la sección anterior, es mucho más simple y legible utilizar un procedimiento almacenado para asegurar las acciones permitidas para cada tipo de usuario en nuestro sistema.

Con respecto a las funciones, las mismas ofrecen mayor legibilidad y mantenibilidad del código y son especialmente útiles cuando devuelven tablas que pueden almacenarse temporalmente o mostrarse directamente como el ejemplo de ProductosMasVendidos.


## 4\. Conclusión

La implementación de procedimientos y funciones almacenadas en la base de datos de **PetShopDelLitoral** permite la reutilización código mantenible y centralizando las reglas del negocio en componentes particulares. Asimismo facilita la seguridad de los datos en el caso de un sistema con roles para diferentes usuarios.

