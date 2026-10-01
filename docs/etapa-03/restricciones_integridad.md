# Restricciones de integridad



## Clave Primaria



Cada tabla de nuestra base de datos tiene una clave primaria (PK) simple para identificar cada registro de la misma, para seleccionarla se siguió el diseño lógico realizado en la etapa anterior. La misma es definida luego que son creadas todas las columnas de la tabla, como toda restricción en una nueva linea, la misma recibe un nombre con la sentencia CONSTRAINT.  



## Not Null



Todos los atributos de nuestra tabla, al momento de la creación de la BD, son obligatorios. Para garantizar que se cumpla esta regla de negocio usamos la instrucción NOT NULL.



El siguiente extracto de código SQL demuestra estás dos primeras restricciones.



```
CREATE TABLE CALLE(
  id_calle INT IDENTITY(1,1) NOT NULL,
  nombre_calle VARCHAR(50) NOT NULL,
  CONSTRAINT PK_CALLE PRIMARY KEY (id_calle)
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
CREATE TABLE DETALLE_VENTA(
  id_detalleVenta INT IDENTITY(1,1) NOT NULL,
  cantidad INT NOT NULL DEFAULT 1,
  precio DECIMAL (10,2) NOT NULL,
  subtotal_venta DECIMAL (10,2) NOT NULL,
  fechaCreacion_detalleVenta DATE NOT NULL DEFAULT GETDATE(),
  id_venta INT NOT NULL,
  id_Producto INT NOT NULL,
  CONSTRAINT PK_DETALLE_VENTA PRIMARY KEY (id_detalleVenta),
  CONSTRAINT FK_VENTA FOREIGN KEY (id_venta) REFERENCES VENTA(id_venta),
  CONSTRAINT FK_DETALLEVENTA_PRODUCTO FOREIGN KEY (id_Producto) REFERENCES PRODUCTO(id_Producto),
  CONSTRAINT CK_CANTIDAD_VENTA CHECK (cantidad > 0),
  CONSTRAINT UQ_PRODUCTO_VENTA UNIQUE (id_Producto, id_venta)
);
```

