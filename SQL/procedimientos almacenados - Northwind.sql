USE Northwind

create procedure producto_por_categoria
@categoria varchar(30)
as begin
    select ProductName
    from Products
    join Categories on Products.CategoryID = Categories.CategoryID
    where CategoryName = @categoria
end;
go;

execute producto_por_categoria 'Condiments'

--Cantidad de ordenes por shipper
create procedure sp_orders_by_shipper
@companyName nvarchar(40)
as
    begin
        select distinct CompanyName, count(*)
        from Shippers join orders on Shippers.ShipperID = Orders.ShipVia
        where CompanyName=@companyName
        group by CompanyName;
    end;


execute sp_orders_by_shipper 'Federal SHipping'


-- Otra forma de hacerlo con output y print
alter procedure sp_orders_by_shipper
    @companyName nvarchar(40),
    @Quantity int output
as
    begin
        select distinct @Quantity = count(OrderID)
        from Shippers join orders on Shippers.ShipperID = Orders.ShipVia
        where CompanyName=@companyName
        group by CompanyName;
    end;
go;

declare @Cant int;
exec sp_orders_by_shipper 'Federal Shipping', @Cant output;
-- Con SELECT
select @Cant;
-- Con PRINT
print @Cant;

--Aplicar un descuento en el precio para productos con un precio mayor a cierta cantidad
create procedure sp_update_productsPrice
    @Discount MONEY,
    @Price MONEY
as
        begin
            update Products
            set UnitPrice = UnitPrice - @Discount
            where UnitPrice > @Price
        end;
go;

exec sp_update_productsPrice 5, 100;


--Procedimiento almacenado que imprime el nombre del producto y su stock
--Luego, imprimir el total de productos

