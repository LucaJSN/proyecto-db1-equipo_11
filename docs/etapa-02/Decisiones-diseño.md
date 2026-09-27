Las desiciones tomadas en la etapa de diseño lógico (DER) fueron las siguientes:

1) Separación de la información común y los roles del sistema
Se identificó que determinadas entidades del dominio comparten información correspondiente a una persona, como nombre, apellido, DNI, correo, teléfono y dirección. Para evitar la duplicación de estos datos, se centralizó dicha información en la relación “Persona”. A partir de ella se modelaron diferentes especializaciones, dado que cada una representa un rol diferente dentro del sistema y posee atributos y responsabilidades específicas.
2) Separación entre usuario y rol
Se decidió no almacenar la descripción del rol directamente en USUARIO, sino representarlo mediante una relación independiente. Esto permite centralizar la definición de los roles disponibles y asociar múltiples usuarios a un mismo rol sin repetir su descripción.
3) Separación de operaciones y sus detalles
Tanto las compras como las ventas fueron modeladas diferenciando la información general de la operación de los productos involucrados en ella.
4) Conservación del precio histórico de las operaciones
Se decidió almacenar el precio del producto utilizado en cada detalle de compra o venta, además del precio actualmente asociado al producto. Esto permite conservar el valor con el que se realizó una operación independientemente de posteriores modificaciones en el precio del producto.
5) Normalización
El modelo fue estructurado procurando alcanzar la Tercera Forma Normal (3FN), evitando grupos repetitivos, dependencias parciales y dependencias transitivas entre atributos no clave.
