use pet_shop_Litoral

select c.nombre_categoria as 'Categoria', count(distinct(v.id_venta)) as 'ventas por categoría'
from venta as v
inner join detalle_venta as dv
on v.id_venta = dv.id_venta
inner join producto as p
on p.id_producto = dv.id_producto
inner join categoria as c
on c.id_categoria = p.id_categoria
group by c.id_categoria, c.nombre_categoria
