# Pruebas de Validación



## Ingreso de datos válidos para las tablas categoría, producto y persona:



* Ingreso de datos válidos en la tabla categoria con nombre y estado.



**Código SQL:**

INSERT INTO CATEGORIA (nombre\_categoria, estado\_categoria)

VALUES 

&#x09;('Accesorios', 1),

&#x09;('Alimentos', 0);



* Ingreso de una fecha en nombre\_categoria, hay una conversión automática de valores date a varchar.



**Código SQL:**

INSERT INTO CATEGORIA (nombre\_categoria, estado\_categoria)

VALUES ('2026-09-30', 1);



* Ingreso manual de fecha de creación en categoría.



**Código SQL:**

INSERT INTO CATEGORIA (nombre\_categoria, estado\_categoria, fechaCreacion\_categoria)

VALUES ('Alimetos secos', 1, '2026-09-15');



* Ingreso de un valor int en nombre\_categoria, hay una conversión automática de int a varchar.



**Código SQL:**

INSERT INTO CATEGORIA (nombre\_categoria, estado\_categoria)

VALUES (26, 1);



* Ingreso de datos válidos en la tabla producto.



INSERT INTO PRODUCTO(nombre\_producto, descripcion\_producto, precio\_producto, stock\_producto, stock\_minimo, 

precioUnitario\_producto, estado\_producto, id\_categoria)

VALUES

&#x09;('Collar rojo', 'Collar rojo con cascabel para gato', 6000, 10, 2, 4800, 1, 1);



* Ingreso de datos válidos en la tabla persona.



INSERT INTO PERSONA(nombre\_persona, apellido\_persona, correo\_persona, telefono\_persona, dni\_persona, estado\_persona, id\_direccion)

VALUES ('Juan', 'Mesa', 'juanmesa@gmail.com', '3794-483864', 39458726, 1, 1);



## Carga de datos inválidos y sus respectivos errores.



### Error de tipo de dato



* Se trata de cargar un valor para id\_categoria que está definido como identity.



**Código SQL:**

INSERT INTO CATEGORIA (id\_categoria, nombre\_categoria, estado\_categoria)

VALUES (4, 'Juguetes', 1);



**Mensaje de error**: No se puede insertar un valor explícito en la columna de identidad de la tabla 'CATEGORIA' cuando IDENTITY\_INSERT es OFF.



* Se trata de ingresa un valor Null en nombre aunque sea un dato NOT NULL.



**Código SQL:**

INSERT INTO CATEGORIA (nombre\_categoria, estado\_categoria)

VALUES  (NULL, 1);



**Mensaje de error**: No se puede insertar el valor NULL en la columna 'nombre\_categoria', tabla 'PETSHOPDELLITORAL.dbo.CATEGORIA'. La columna no admite valores NULL. Error de INSERT.



* Se trata de ingresar un estado que no es 1 o 0.



**Código SQL:**

INSERT INTO CATEGORIA (nombre\_categoria, estado\_categoria)

VALUES ('Salud', 5);



**Mensaje de error**: Instrucción INSERT en conflicto con la restricción CHECK 'CK\_ESTADO\_CATEGORIA'. El conflicto ha aparecido en la base de datos 'PETSHOPDELLITORAL', tabla 'dbo.CATEGORIA', column 'estado\_categoria'.



* Se trata de ingresar un valor int en fecha de creación.



**Código SQL:**

INSERT INTO CATEGORIA (nombre\_categoria, estado\_categoria, fechaCreacion\_categoria)

VALUES ('Alimetos húmedos', 1, 2026);



**Mensaje de error**: Conflicto de tipos de operandos: int es incompatible con date.



* Se trata de ingresar un producto con una categoría que no existe.



### Error de clave foránea (FK)



**Código SQL:**

INSERT INTO PRODUCTO(nombre\_producto, descripcion\_producto, precio\_producto, stock\_producto, stock\_minimo, 

precioUnitario\_producto, estado\_producto, id\_categoria)

VALUES

&#x09;('Collar azul', 'Collar azul con cascabel para gato', 6000, 10, 2, 4800, 1, 14);



**Mensaje de error**: Instrucción INSERT en conflicto con la restricción FOREIGN KEY 'FK\_CATEGORIA'. El conflicto ha aparecido en la base de datos 'PETSHOPDELLITORAL', tabla 'dbo.CATEGORIA', column 'id\_categoria'.



* Se trata de ingresar un precio unitario menor o igual que cero.



### Error de check



**Código SQL:**

INSERT INTO PRODUCTO(nombre\_producto, descripcion\_producto, precio\_producto, stock\_producto, stock\_minimo, 

precioUnitario\_producto, estado\_producto, id\_categoria)

VALUES

&#x09;('Collar amarillo', 'Collar amarillo con cascabel para gato', 6000, 10, 2, -800, 1, 1);



**Mensaje de error**: Instrucción INSERT en conflicto con la restricción CHECK 'CK\_PRECIO\_UNIT'. El conflicto ha aparecido en la base de datos 'PETSHOPDELLITORAL', tabla 'dbo.PRODUCTO', column 'precioUnitario\_producto'.



* Se trata de ingresar un stock mínimo negativo.



**Código SQL:**

INSERT INTO PRODUCTO(nombre\_producto, descripcion\_producto, precio\_producto, stock\_producto, stock\_minimo, 

precioUnitario\_producto, estado\_producto, id\_categoria)

VALUES

&#x09;('Collar verde', 'Collar verde con cascabel para gato', 6000, 10, -4, 4800, 1, 1);



**Mensaje de error:** Instrucción INSERT en conflicto con la restricción CHECK 'CK\_STOCK\_MIN'. El conflicto ha aparecido en la base de datos 'PETSHOPDELLITORAL', tabla 'dbo.PRODUCTO', column 'stock\_minimo'.



* Se trata de ingresar un registro con un correo ya utilizado en otra fila.



### Error de unicidad



**Código SQL:**

INSERT INTO PERSONA(nombre\_persona, apellido\_persona, correo\_persona, telefono\_persona, dni\_persona, estado\_persona, id\_direccion)

VALUES ('Maria', 'Ramirez', 'juanmesa@gmail.com', '3795-483864', 28458777, 1, 1);



**Mensaje de error:** Infracción de la restricción UNIQUE KEY 'UQ\_CORREO\_PERSONA'. No se puede insertar una clave duplicada en el objeto 'dbo.PERSONA'. El valor de la clave duplicada es (juanmesa@gmail.com).



* Se trata de ingresar un registro con un teléfono ya utilizado en otra fila.



**Código SQL:**

INSERT INTO PERSONA(nombre\_persona, apellido\_persona, correo\_persona, telefono\_persona, dni\_persona, estado\_persona, id\_direccion)

VALUES ('Maria', 'Ramirez', 'mariaRamirez@gmail.com', '3794-483864', 27458888, 1, 1);



**Mensaje de error:** Infracción de la restricción UNIQUE KEY 'UQ\_TELEFONO\_PERSONA'. No se puede insertar una clave duplicada en el objeto 'dbo.PERSONA'. El valor de la clave duplicada es (3794-483864).



* Se trata de ingresar un registro con un dni ya utilizado en otra fila.



**Código SQL:**

INSERT INTO PERSONA(nombre\_persona, apellido\_persona, correo\_persona, telefono\_persona, dni\_persona, estado\_persona, id\_direccion)

VALUES ('Maria', 'Ramirez', 'mariaRamirez@gmail.com', '3795-483864', 39458726, 1, 1);



**Mensaje de error:** Infracción de la restricción UNIQUE KEY 'UQ\_DNI\_PERSONA'. No se puede insertar una clave duplicada en el objeto 'dbo.PERSONA'. El valor de la clave duplicada es (39458726).

