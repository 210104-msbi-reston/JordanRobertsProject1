drop trigger trg_WareOrder
on WarehouseOrders
after insert
as
begin
	declare @sno int
	declare @orderid int = (select i.OrderID from inserted i)
	declare @country varchar(35) = (select w.Country from inserted i join Warehouses w on i.WarehouseID = w.WarehouseID)
	declare @cont varchar(13) = (select Continent from Countries where Country = @country)
	
	declare @randnum decimal = RAND()
	while @randnum < 0.5
	begin
		set @randnum = RAND()
		set @sno = (select top 1 SerialNo from CreatedProducts c
					join ProductionHouse p on c.ProductionHouseID = p.ProductionHouseID
					join Countries co on p.Country = co.Country
					where Continent = @cont and WarehouseOrderID IS NULL order by NEWID())
		update CreatedProducts
		set WarehouseOrderID = @orderid where SerialNo = @sno
	end
	set @sno = (select top 1 SerialNo from CreatedProducts c
					join ProductionHouse p on c.ProductionHouseID = p.ProductionHouseID
					join Countries co on p.Country = co.Country
					where Continent = @cont and WarehouseOrderID IS NULL order by NEWID())
		update CreatedProducts
		set WarehouseOrderID = @orderid where SerialNo = @sno
end

drop trigger trg_DistOrder
on DistributorOrders
after insert
as
begin
	declare @total numeric(18,2) = 0
	declare @orderid int = (select i.OrderID from inserted i)
	declare @country varchar(35) = (select d.Country from inserted i join Distributors d on i.DistributorID = d.DistributorID)
	declare @sno int
	declare @randnum decimal = RAND()
	while @randnum < 0.5
	begin
		set @randnum = RAND()
		set @sno = (select top 1 SerialNo from CreatedProducts c
							join WarehouseOrders wo on c.WarehouseOrderID = wo.OrderID
							join Warehouses w on wo.WarehouseID = w.WarehouseID
							join Countries co on w.Country = co.Country
							where w.Country = @country and DistributorOrderID IS NULL and WarehouseOrderID IS NOT NULL and Received IS NOT NULL order by NEWID())
		set @total = @total + (select BasePrice from ProductInfo join CreatedProducts on ProductInfo.ProductID = CreatedProducts.ProductID where SerialNo = @sno)
		update CreatedProducts
		set DistributorOrderID = @orderid where SerialNo = @sno
	end
	set @sno = (select top 1 SerialNo from CreatedProducts c
						join WarehouseOrders wo on c.WarehouseOrderID = wo.OrderID
						join Warehouses w on wo.WarehouseID = w.WarehouseID
						join Countries co on w.Country = co.Country
						where w.Country = @country and DistributorOrderID IS NULL and WarehouseOrderID IS NOT NULL and Received IS NOT NULL order by NEWID())
	set @total = @total + (select BasePrice from ProductInfo join CreatedProducts on ProductInfo.ProductID = CreatedProducts.ProductID where SerialNo = @sno)
	update CreatedProducts
	set DistributorOrderID = @orderid where SerialNo = @sno
	if @total IS NOT NULL
	begin
		update DistributorOrders set TotalCost = @total where OrderID = @orderid
	end
end

drop trigger trg_SubDistOrder
on SubdistributorOrders
after insert
as
begin
	declare @total numeric(18,2) = 0
	declare @orderid int = (select i.OrderID from inserted i)
	declare @country varchar(35) = (select s.Country from inserted i join Subdistributors s on i.SubdistributorID = s.SubdistributorID)
	declare @cont varchar(13) = (select Continent from Countries where Country = @country)
	declare @sno int
	
	declare @randnum decimal = RAND()
	while @randnum < 0.5
	begin
		set @randnum = RAND()
		set @sno = (select top 1 SerialNo from CreatedProducts c
							join DistributorOrders do on c.DistributorOrderID = do.OrderID
							join Distributors d on d.DistributorID = do.DistributorID
							join Countries co on d.Country = co.Country
							where d.Country = @country and SubdistributorOrderID IS NULL and DistributorOrderID IS NOT NULL and Received IS NOT NULL order by NEWID())
		set @total = @total + (select BasePrice from ProductInfo join CreatedProducts on ProductInfo.ProductID = CreatedProducts.ProductID where SerialNo = @sno)
		update CreatedProducts
		set SubdistributorOrderID = @orderid where SerialNo = @sno
	end
	set @sno = (select top 1 SerialNo from CreatedProducts c
							join DistributorOrders do on c.DistributorOrderID = do.OrderID
							join Distributors d on d.DistributorID = do.DistributorID
							join Countries co on d.Country = co.Country
							where d.Country = @country and SubdistributorOrderID IS NULL and DistributorOrderID IS NOT NULL and Received IS NOT NULL order by NEWID())
	set @total = @total + (select BasePrice from ProductInfo join CreatedProducts on ProductInfo.ProductID = CreatedProducts.ProductID where SerialNo = @sno)
	update CreatedProducts
	set SubdistributorOrderID = @orderid where SerialNo = @sno

	if @total IS NOT NULL
	begin
	update SubdistributorOrders set TotalCost = @total where OrderID = @orderid
	end
end

drop trigger trg_ChannelOrder
on ChannelOrders
after insert
as
begin
	declare @total numeric(18,2) = 0
	declare @orderid int = (select i.OrderID from inserted i)
	declare @country varchar(35) = (select s.Country from inserted i join ChannelPartners s on i.ChannelID = s.ChannelID)
	declare @cont varchar(13) = (select Continent from Countries where Country = @country)
	declare @sno int
	
	declare @randnum numeric(18,2) = RAND()
	while @randnum < 0.5
	begin
		set @randnum = RAND()
		set @sno = (select top 1 SerialNo from CreatedProducts c
							join SubdistributorOrders so on c.SubdistributorOrderID = so.OrderID
							join Subdistributors s on s.SubdistributorID = so.SubdistributorID
							join Countries co on s.Country = co.Country
							where s.Country = @country and ChannelOrderID IS NULL and SubdistributorOrderID IS NOT NULL and Received IS NOT NULL order by NEWID())
		set @total = @total + (select BasePrice from ProductInfo join CreatedProducts on ProductInfo.ProductID = CreatedProducts.ProductID where SerialNo = @sno)
		update CreatedProducts
		set ChannelOrderID = @orderid where SerialNo = @sno
	end
	set @sno = (select top 1 SerialNo from CreatedProducts c
							join SubdistributorOrders so on c.SubdistributorOrderID = so.OrderID
							join Subdistributors s on s.SubdistributorID = so.SubdistributorID
							join Countries co on s.Country = co.Country
							where s.Country = @country and ChannelOrderID IS NULL and SubdistributorOrderID IS NOT NULL and Received IS NOT NULL order by NEWID())
	set @total = @total + (select BasePrice from ProductInfo join CreatedProducts on ProductInfo.ProductID = CreatedProducts.ProductID where SerialNo = @sno)
	update CreatedProducts
	set ChannelOrderID = @orderid where SerialNo = @sno

	if @total IS NOT NULL
	begin
	update ChannelOrders set TotalCost = @total where OrderID = @orderid
	end
end

drop trigger trg_RetailOrder
on RetailOrders
after insert
as
begin
	declare @total numeric(18,2) = 0
	declare @orderid int = (select i.OrderID from inserted i)
	declare @zone int = (select s.ZoneID from inserted i join RetailSellers s on i.SellerID = s.SellerID)
	declare @sno int
	declare @randnum decimal = RAND()

	while @randnum < 0.5
	begin
		set @randnum = RAND()
		set @sno = (select top 1 SerialNo from CreatedProducts c
							join ChannelOrders co on c.ChannelOrderID = co.OrderID
							join ChannelPartners cp on cp.ChannelID = co.ChannelID
							join Zones z on cp.ChannelID = z.ChannelID
							where z.ZoneID = @zone and SellerOrderID IS NULL and ChannelOrderID IS NOT NULL and Received IS NOT NULL order by NEWID())
		set @total = @total + (select BasePrice from ProductInfo join CreatedProducts on ProductInfo.ProductID = CreatedProducts.ProductID where SerialNo = @sno)
		update CreatedProducts
		set SellerOrderID = @orderid where SerialNo = @sno
	end

	set @sno = (select top 1 SerialNo from CreatedProducts c
							join ChannelOrders co on c.ChannelOrderID = co.OrderID
							join ChannelPartners cp on cp.ChannelID = co.ChannelID
							join Zones z on cp.ChannelID = z.ChannelID
							where z.ZoneID = @zone and SellerOrderID IS NULL and ChannelOrderID IS NOT NULL and Received IS NOT NULL order by NEWID())
	set @total = @total + (select BasePrice from ProductInfo join CreatedProducts on ProductInfo.ProductID = CreatedProducts.ProductID where SerialNo = @sno)
	update CreatedProducts
	set SellerOrderID = @orderid where SerialNo = @sno

	if @total IS NOT NULL
	begin
	update RetailOrders set TotalCost = @total where OrderID = @orderid
	end
end

drop trigger trg_CustomerOrder
on CustomerOrders
after insert
as
begin
	declare @total numeric(18,2) = 0
	declare @orderid int = (select i.OrderID from inserted i)
	declare @country varchar(35) = (select s.Country from inserted i join Customers s on i.CustomerID = s.CustomerID)
	declare @sno int
	declare @randnum decimal = RAND()
	while @randnum < 0.5
	begin
		set @randnum = RAND()
		set @sno = (select top 1 SerialNo from CreatedProducts c
							join RetailOrders so on c.SellerOrderID = so.OrderID
							join RetailSellers s on s.SellerID = so.SellerID
							join Countries co on s.Country = co.Country
							where s.Country = @country and CustomerOrderID IS NULL and SellerOrderID IS NOT NULL and Received IS NOT NULL order by NEWID())
		set @total = @total + (select BasePrice from ProductInfo join CreatedProducts on ProductInfo.ProductID = CreatedProducts.ProductID where SerialNo = @sno)
		update CreatedProducts
		set CustomerOrderID = @orderid where SerialNo = @sno
	end
	set @sno = (select top 1 SerialNo from CreatedProducts c
							join RetailOrders so on c.SellerOrderID = so.OrderID
							join RetailSellers s on s.SellerID = so.SellerID
							join Countries co on s.Country = co.Country
							where s.Country = @country and CustomerOrderID IS NULL and SellerOrderID IS NOT NULL and Received IS NOT NULL order by NEWID())
	set @total = @total + (select BasePrice from ProductInfo join CreatedProducts on ProductInfo.ProductID = CreatedProducts.ProductID where SerialNo = @sno)
	update CreatedProducts
	set CustomerOrderID = @orderid where SerialNo = @sno

	if @total IS NOT NULL
	begin
	update CustomerOrders set TotalCost = @total where OrderID = @orderid
	end
end

alter trigger trg_Returns
on Returns
after insert
as
begin
	declare @pid int = (select ProductID from inserted i join CreatedProducts c on i.SerialNo = c.SerialNo)
	declare @sno int = (select i.SerialNo from inserted i)
	declare @phid int = (select ProductionHouseID from CreatedProducts where SerialNo = @sno)
	declare @newsno int = (select top 1 SerialNo from CreatedProducts where ProductID = @pid and WarehouseOrderID is null and CustomerOrderID is null and ProductionHouseID = @phid order by NEWID())
	declare @custorder int = (select CustomerOrderID from CreatedProducts where SerialNo = @sno)

	update CreatedProducts set CustomerOrderID = @custorder where SerialNo = @newsno
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
