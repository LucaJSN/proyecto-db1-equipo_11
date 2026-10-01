# Restricciones de integridad



## Clave Primaria



Cada tabla de nuestra base de datos tiene una clave primaria (PK) simple para identificar cada registro de la misma, para seleccionarla se siguió el diseño lógico realizado en la etapa anterior. La misma es definida luego que son creadas todas las columnas de la tabla, como toda restricción en una nueva linea, la misma recibe un nombre con la sentencia CONSTRAINT.  



# Not Null



Todos los atributos de nuestra tabla, al momento de la creación de la BD, son obligatorios. Para garantizar que se cumpla esta regla de negocio usamos la instrucción NOT NULL.



El siguiente extracto de código SQL demuestra estás dos primeras restricciones.



```

CREATE TABLE CALLE

(

&#x20; id\_calle INT IDENTITY(1,1) **NOT NULL**,

&#x20; nombre\_calle VARCHAR(50) NOT NULL,

&#x20; CONSTRAINT PK\_CALLE **PRIMARY KEY** (id\_calle)

);

```



## Default



La mayor parte de los atributos de tipo DATE en nuestro sistema tienen como predeterminado la fecha actual debido a que hablamos de un campo que almacena la fecha de creación del registro.



## Unicidad



Para garantizar que en ningún registro tenga valores duplicados en un cierto campo, usamos esta restricción. Por ejemplo para los valores dni y correo electrónico en persona.



## Check



Para obligar que un campo pueda tener solo valores válidos usamos check. Por ejemplo, que el stock mínimo de un producto sea mayor o igual a cero; o que el estado de un registro sea cero para inactivo o uno para activo.



## Clave Foránea



Para unir dos tablas y garantizar la integridad referencial de los datos, se utiliza está restricción. En nuestro caso, cada vez que la usamos nombramos las dos tablas involucradas con un CONSTRAINT a fin de que sea más sencillo leer los posibles errores que aparecen.



El siguiente extracto de código SQL ilustra estás últimas restricciones.

```

CREATE TABLE DETALLE\_VENTA

(

&#x20; id\_detalleVenta INT IDENTITY(1,1) NOT NULL,

&#x20; cantidad INT NOT NULL DEFAULT 1,

&#x20; precio DECIMAL (10,2) NOT NULL,

&#x20; subtotal\_venta DECIMAL (10,2) NOT NULL,

&#x20; fechaCreacion\_detalleVenta DATE NOT NULL **DEFAULT** GETDATE(),

&#x20; id\_venta INT NOT NULL,

&#x20; id\_Producto INT NOT NULL,

&#x20; CONSTRAINT PK\_DETALLE\_VENTA PRIMARY KEY (id\_detalleVenta),

&#x20; CONSTRAINT FK\_VENTA **FOREIGN KEY** (id\_venta) REFERENCES VENTA(id\_venta),

&#x20; CONSTRAINT FK\_DETALLEVENTA\_PRODUCTO FOREIGN KEY (id\_Producto) REFERENCES PRODUCTO(id\_Producto),

&#x20; CONSTRAINT CK\_CANTIDAD\_VENTA **CHECK** (cantidad > 0),

&#x20; CONSTRAINT UQ\_PRODUCTO\_VENTA **UNIQUE**(id\_Producto, id\_venta)

);

```

