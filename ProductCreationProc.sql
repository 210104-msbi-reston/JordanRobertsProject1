alter procedure p_product_creation @productid as int = null, @qty as int, @prodhouseid as int = null
as
begin
	declare @manufactdate datetime
	declare @lastdate datetime = (select top 1 ManufactDate from created_product order by ManufactDate desc)
	declare @cost numeric(18,2)
	declare @randmcost int
	declare @pno int = 0

	if @qty is null
	begin
		while @pno < 10000
		begin
			select @pno = @pno + 1
			set @cost = (select  RAND() * 500 + 80)
			set @manufactdate = DATEADD(mi, @pno + rand(), @lastdate)

				if @productid is null
				begin
					declare @pid int = (select top 1 ProductID from Product_Info order by NEWID())
				end
				else
				begin
					set @pid = @productid
				end

				if @prodhouseid is null
				begin
					declare @phid int = (select top 1 ProductionHouseID from Production_House order by NEWID())
				end
				else
				begin
					set @phid = @prodhouseid
				end

			insert into Created_Product(ProductID,ProductionHouseID,ManufactDate,ManufactCost) values(@pid,@phid,@manufactdate,@cost)
		end
	end
	else
	begin
		while @pno < @qty
		begin
			select @pno = @pno + 1
			set @cost = (select  RAND() * 500 + 80)
			set @manufactdate = DATEADD(mi, @pno + rand(), @lastdate)

				if @productid is null
				begin
					set @pid = (select top 1 ProductID from Product_Info order by NEWID())
				end
				else
				begin
					set @pid = @productid
				end

				if @prodhouseid is null
				begin
					set @phid = (select top 1 ProductionHouseID from Production_House order by NEWID())
				end
				else
				begin
					set @phid = @prodhouseid
				end

			insert into Created_Product(ProductID,ProductionHouseID,ManufactDate,ManufactCost) values(@pid,@phid,@manufactdate,@cost)
		end
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
alter procedure f_warehouse_creation @country varchar(35), @qty int
as
begin
	declare @cono int = 0
	if @qty = 1
	begin
		insert into warehouse values(@country)
	end
	else
	begin
		while @cono < @qty
		begin
			select @cono = @cono + 1
			insert into warehouse values(@country)
		end
	end
end

alter procedure f_distributor_creation @country varchar(35), @qty int
as
begin
	declare @cono int = 0
	while @cono < @qty
	begin
		select @cono = @cono + 1
		insert into distributor values(@country)
	end
end

create procedure f_subdistributor_creation @country varchar(35), @qty int
as
begin
	declare @cono int = 0
	while @cono < @qty
	begin
		select @cono = @cono + 1
		insert into subdistributor values(@country)
	end
end

create procedure f_channel_creation @sid int, @qty int
as
begin
	declare @cono int = 0
	declare @country varchar(35) = (select country from subdistributor where SubdistributorID = @sid)
	while @cono < @qty
	begin
		select @cono = @cono + 1
		insert into channel_partner values(@country)
	end
end

alter procedure f_zone_creation @channel int, @qty int
as
begin
	declare @cono int = 0
	while @cono < @qty
	begin
		select @cono = @cono + 1
		insert into zone values(@channel)
	end
end

create procedure f_retail_creation @zone int, @qty int
as
begin
	declare @cono int = 0
	declare @country varchar(35) = (select Country from zone z join channel_partner c on z.ChannelID = c.ChannelID where ZoneID = @zone)
	while @cono < @qty
	begin
		select @cono = @cono + 1
		insert into retail_seller values(@zone, @country)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
alter procedure f_customer_creation
@country varchar(35) = null,
@name varchar(30) = null,
@phone varchar(20) = null,
@email varchar(40) = null,
@qty int = null
as
begin
	declare @cono int = 0
	if @qty is null
	begin
		if @country = null
		begin
			set @country = (select top 1 Country from country order by NEWID())
		end
		insert into customer values(LEFT(NEWID(),18), @country, @name, @phone, @email)
	end
	else
	while @cono < @qty
	begin
		if @country = null
		begin
			set @country = (select top 1 Country from country order by NEWID())
		end
		select @cono = @cono + 1
		insert into customer values(LEFT(NEWID(),18), @country, @name, @phone, @email)
	end
end

alter procedure f_new_product @name varchar(25), @description varchar(50) = null, @category int, @price numeric(18,2) = null
as
begin
	if @price is null
	begin
	set @price = RAND() * 200 + 100
	end
	insert into product_info values(@name, @description, @price, @category)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
create sequence s_WarehouseOrderNumber as int
start with 100000
increment by 1

alter procedure f_warehouse_order @wid int = null, @pid int = null, @qty int
as
begin
	declare @cono int = 0
	declare @orderid int = next value for s_warehouseordernumber
	declare @prodid int = (select ISNULL((select ProductID from product_info where ProductID = @pid), (select top 1 ProductID from product_info order by NEWID())))
	declare @country varchar(35) = (select ISNULL((select country from warehouse where WarehouseID = @wid), (select top 1 Country from country order by NEWID())))
	declare @cont varchar(13) = (select Continent from country where Country = @country)
	declare @lastdate datetime = (select ISNULL((select top 1 Received from warehouse_order order by Received desc), DATEADD(hour, -60000+RAND()*6000, GETDATE())))
	set @wid = (select ISNULL(@wid, (select top 1 WarehouseID from warehouse where Country = @country order by NEWID())))
	insert into warehouse_order(OrderID, WarehouseID, Shipping, Ordered) values(@orderid, @wid, RAND()*100, DATEADD(mi, 600+RAND()*8, @lastdate))
	declare @count int = (select count(SerialNo) from created_product c
						join production_house p on c.ProductionHouseID = p.ProductionHouseID
						join country on p.Country = country.Country
						where ProductID = @prodid and Continent = @cont and WarehouseOrderID is null)
	declare @phid int = (select top 1 ProductionHouseID from production_house p
							join country c on p.Country = c.Country
							where Continent = @cont)
	if @count < @qty
	begin
		declare @reorderqty int = @qty * 2
		exec p_product_creation @prodid, @reorderqty, @phid
		exec f_warehouse_order @wid, @pid, @qty
	end
	while @cono < @qty
	begin
		select @cono = @cono + 1
		declare @sno int = (select top 1 SerialNo from created_product c
							join production_house p on c.ProductionHouseID = p.ProductionHouseID
							join country on p.Country = country.Country
							where ProductID = @prodid and Continent = @cont and WarehouseOrderID is null
							order by ManufactDate desc)
		update created_product set WarehouseOrderID = @orderid where SerialNo = @sno
	end
end

declare @in int = 0
while @in < 10000
begin
select @in = @in + 1
exec f_warehouse_order @qty=300
end
delete from Warehouse_Order
update Created_Product set WarehouseOrderID = null
select Country, count(*) from warehouse_order wo join warehouse w on wo.WarehouseID = w.WarehouseID group by country
select * from Warehouse_Order
select * from Created_Product where WarehouseOrderID IS not NULL and DistributorOrderID IS NULL

alter procedure f_warehouse_shipped
as
begin
	declare @cono int = 0
	declare @ord int = (select count(OrderID) from warehouse_order where ordered is not null and shipped is null)
	select @ord = @ord * 0.8
	while @cono < @ord
	begin
		select @cono = @cono + 1
		declare @orderid int = (select top 1 OrderID from warehouse_order where Shipped IS NULL and Ordered IS NOT NULL order by NEWID())
		update warehouse_order set Shipped = dateadd(hour, RAND()*100, Ordered) where OrderID = @orderid
	end
end

exec f_warehouse_shipped

alter procedure f_warehouse_received
as
begin
	declare @cono int = 0
	declare @ord int = (select count(OrderID) from warehouse_order where Received is null and Shipped is not null)
	select @ord = @ord * 0.9
	while @cono < @ord
	begin
		select @cono = @cono + 1
		declare @orderid int = (select top 1 OrderID from warehouse_order where Received IS NULL and Shipped IS NOT NULL order by NEWID())
		update warehouse_order set Received = dateadd(hour, RAND()*200, Shipped) where OrderID = @orderid
	end
end

exec f_warehouse_received
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
create sequence s_DistributorOrderNumber as int
start with 100000
increment by 1

alter procedure f_distributor_order @did int = null, @pid int = null, @qty int
as
begin
	declare @cono int = 0
	declare @orderid int = next value for s_distributorordernumber
	declare @prodid int = (select ISNULL((select ProductID from product_info where ProductID = @pid), (select top 1 p.ProductID from product_info p
																										join created_product c on p.ProductID = c.ProductID
																										where c.WarehouseOrderID is not null order by NEWID())))
	declare @country varchar(35) = (select ISNULL((select country from distributor where DistributorID = @did), (select top 1 Country from country order by NEWID())))
	declare @lastdate datetime = (select top 1 Received from warehouse_order order by Received desc)
	set @did = (select ISNULL(@did, (select top 1 DistributorID from distributor where Country = @country order by NEWID())))
	declare @cost numeric(18,2) = 0
	select @cost = (select @cost + (select BasePrice from product_info where ProductID = @prodid))
	declare @count int = (select count(SerialNo) from created_product c
						join warehouse_order wo on c.WarehouseOrderID = wo.OrderID
						join warehouse w on wo.WarehouseID = w.WarehouseID
						where ProductID = @prodid and Country = @country and WarehouseOrderID is not null and DistributorOrderID is null and Received is not null)
	if @count < @qty
	begin
		raiserror('Not enough in stock, sending reorder...',11,1)
		declare @wid int = (select top 1 warehouseid from warehouse where Country = @country order by NEWID())
		declare @reorderqty int = @qty*2
		exec f_warehouse_order @wid, @prodid, @reorderqty
		exec f_warehouse_shipped
		exec f_warehouse_received
		exec f_distributor_order @did, @prodid, @qty
	end
	else
	begin
		insert into distributor_order(OrderID, DistributorID, TotalCost, Ordered) values(@orderid, @did, @cost*@qty, DATEADD(mi, 600+RAND()*8, @lastdate))
		while @cono < @qty
		begin
			select @cono = @cono + 1
			declare @sno int = (select top 1 SerialNo from created_product c
								join warehouse_order wo on c.WarehouseOrderID = wo.OrderID
								join warehouse w on wo.WarehouseID = w.WarehouseID
								where ProductID = @prodid and Country = @country and WarehouseOrderID is not null and DistributorOrderID is null and Received is not null
								order by ManufactDate desc)
			update created_product set DistributorOrderID = @orderid where SerialNo = @sno
		end
	end
end

declare @in int = 0
while @in < 100
begin
select @in = @in + 1
exec f_distributor_order @qty=3
end
delete from Distributor_Order
update Created_Product set DistributorOrderID = null
select * from Distributor_Order
select * from Created_Product where DistributorOrderID IS not NULL and SubdistributorOrderID IS NULL

create procedure f_distributor_shipped
as
begin
	declare @cono int = 0
	declare @ord int = (select count(OrderID) from distributor_order where ordered is not null and shipped is null)
	select @ord = @ord * 0.8
	while @cono < @ord
	begin
		select @cono = @cono + 1
		declare @orderid int = (select top 1 OrderID from distributor_order where Shipped IS NULL and Ordered IS NOT NULL order by NEWID())
		update distributor_order set Shipped = dateadd(hour, RAND()*100, Ordered) where OrderID = @orderid
	end
end

exec f_distributor_shipped

alter procedure f_distributor_received
as
begin
	declare @cono int = 0
	declare @ord int = (select count(OrderID) from distributor_order where Received is null and Shipped is not null)
	select @ord = @ord * 0.9
	while @cono < @ord
	begin
		select @cono = @cono + 1
		declare @orderid int = (select top 1 OrderID from distributor_order where Received IS NULL and Shipped IS NOT NULL order by NEWID())
		update distributor_order set Received = dateadd(hour, RAND()*200, Shipped) where OrderID = @orderid
	end
end

exec f_distributor_received
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
create sequence s_SubdistributorOrderNumber as int
start with 100000
increment by 1

alter procedure f_subdistributor_order @sid int = null, @pid int = null, @qty int
as
begin
	declare @cono int = 0
	declare @orderid int = next value for s_subdistributorordernumber
	declare @prodid int = (select ISNULL((select ProductID from product_info where ProductID = @pid), (select top 1 p.ProductID from product_info p
																										join created_product c on p.ProductID = c.ProductID
																										where c.DistributorOrderID is not null order by NEWID())))
	declare @country varchar(35) = (select ISNULL((select country from subdistributor where SubdistributorID = @sid), (select top 1 Country from country order by NEWID())))
	declare @lastdate datetime = (select top 1 Received from distributor_order order by Received desc)
	set @sid = (select ISNULL(@sid, (select top 1 SubdistributorID from subdistributor where Country = @country order by NEWID())))
	declare @cost numeric(18,2) = 0
	select @cost = (select @cost + (select BasePrice from product_info where ProductID = @prodid))
	declare @count int = (select count(SerialNo) from created_product c
						join distributor_order do on c.DistributorOrderID = do.OrderID
						join distributor d on do.DistributorID = d.DistributorID
						where ProductID = @prodid and Country = @country and DistributorOrderID is not null and SubdistributorOrderID is null and Received is not null)
	if @count < @qty
	begin
		raiserror('Not enough in stock, sending reorder...',11,1)
		declare @did int = (select top 1 distributorid from distributor where Country = @country)
		declare @reorderqty int = @qty*2
		exec f_distributor_order @did, @prodid, @reorderqty
		exec f_distributor_shipped
		exec f_distributor_received
		exec f_subdistributor_order @sid, @pid, @qty
	end
	else
	begin
		insert into subdistributor_order(OrderID, SubdistributorID, TotalCost, Ordered) values(@orderid, @sid, @cost*@qty*1.08, DATEADD(mi, 600+RAND()*8, @lastdate))
		while @cono < @qty
		begin
			select @cono = @cono + 1
			declare @sno int = (select top 1 SerialNo from created_product c
								join distributor_order do on c.DistributorOrderID = do.OrderID
								join distributor d on do.DistributorID = d.DistributorID
								where ProductID = @prodid and Country = @country and DistributorOrderID is not null and SubdistributorOrderID is null and Received is not null
								order by ManufactDate desc)
			update created_product set SubdistributorOrderID = @orderid where SerialNo = @sno
		end
	end
end

declare @in int = 0
while @in < 10000
begin
select @in = @in + 1
exec f_subdistributor_order @qty=3
end
delete from Subdistributor_Order
update Created_Product set SubdistributorOrderID = null
select * from Subdistributor_Order
select * from Created_Product where SubdistributorOrderID IS not NULL and ChannelOrderID IS NULL

create procedure f_subdistributor_shipped
as
begin
	declare @cono int = 0
	declare @ord int = (select count(OrderID) from subdistributor_order where ordered is not null and shipped is null)
	select @ord = @ord * 0.8
	while @cono < @ord
	begin
		select @cono = @cono + 1
		declare @orderid int = (select top 1 OrderID from subdistributor_order where Shipped IS NULL and Ordered IS NOT NULL order by NEWID())
		update subdistributor_order set Shipped = dateadd(hour, RAND()*100, Ordered) where OrderID = @orderid
	end
end

exec f_subdistributor_shipped

alter procedure f_subdistributor_received
as
begin
	declare @cono int = 0
	declare @ord int = (select count(OrderID) from subdistributor_order where Received is null and Shipped is not null)
	select @ord = @ord * 0.9
	while @cono < @ord
	begin
		select @cono = @cono + 1
		declare @orderid int = (select top 1 OrderID from subdistributor_order where Received IS NULL and Shipped IS NOT NULL order by NEWID())
		update subdistributor_order set Received = dateadd(hour, RAND()*200, Shipped) where OrderID = @orderid
	end
end

exec f_subdistributor_received
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
create sequence s_ChannelOrderNumber as int
start with 100000
increment by 1

alter procedure f_channel_order @cid int = null, @pid int = null, @qty int
as
begin
	declare @cono int = 0
	declare @orderid int = next value for s_channelordernumber
	declare @prodid int = (select ISNULL((select ProductID from product_info where ProductID = @pid), (select top 1 p.ProductID from product_info p
																										join created_product c on p.ProductID = c.ProductID
																										where c.SubdistributorOrderID is not null order by NEWID())))
	declare @country varchar(35) = (select ISNULL((select country from channel_partner where ChannelID = @cid), (select top 1 Country from country order by NEWID())))
	declare @lastdate datetime = (select top 1 Received from subdistributor_order order by Received desc)
	set @cid = (select ISNULL(@cid, (select top 1 ChannelID from channel_partner where Country = @country order by NEWID())))
	declare @cost numeric(18,2) = 0
	select @cost = (select @cost + (select BasePrice from product_info where ProductID = @prodid))
	declare @count int = (select count(SerialNo) from created_product c
						join subdistributor_order so on c.SubdistributorOrderID = so.OrderID
						join subdistributor s on so.SubdistributorID = s.SubdistributorID
						where ProductID = @prodid and Country = @country and SubdistributorOrderID is not null and ChannelOrderID is null and Received is not null)
	if @count < @qty
	begin
		raiserror('Not enough in stock, sending reorder...',11,1)
		declare @sid int = (select top 1 subdistributorid from subdistributor where Country = @country order by NEWID())
		declare @reorderqty int = @qty*2
		exec f_subdistributor_order @sid, @prodid, @reorderqty
		exec f_subdistributor_shipped
		exec f_subdistributor_received
		exec f_channel_order @cid, @pid, @qty
	end
	else
	begin
		insert into channel_order(OrderID, ChannelID, TotalCost, Ordered) values(@orderid, @cid, @cost*@qty*1.16, DATEADD(mi, 600+RAND()*8, @lastdate))
		while @cono < @qty
		begin
			select @cono = @cono + 1
			declare @sno int = (select top 1 SerialNo from created_product c
								join subdistributor_order so on c.SubdistributorOrderID = so.OrderID
								join subdistributor s on so.SubdistributorID = s.SubdistributorID
								where ProductID = @prodid and Country = @country and SubdistributorOrderID is not null and ChannelOrderID is null and Received is not null
								order by ManufactDate desc)
			update created_product set ChannelOrderID = @orderid where SerialNo = @sno
		end
	end
end

declare @in int = 0
while @in < 100
begin
select @in = @in + 1
exec f_channel_order @qty=3
end
delete from Channel_Order
update Created_Product set ChannelOrderID = null
select * from channel_order
select * from Created_Product where channelOrderID IS not NULL and sellerOrderID IS NULL

create procedure f_channel_shipped
as
begin
	declare @cono int = 0
	declare @ord int = (select count(OrderID) from channel_order where ordered is not null and shipped is null)
	select @ord = @ord * 0.8
	while @cono < @ord
	begin
		select @cono = @cono + 1
		declare @orderid int = (select top 1 OrderID from channel_order where Shipped IS NULL and Ordered IS NOT NULL order by NEWID())
		update channel_order set Shipped = dateadd(hour, RAND()*100, Ordered) where OrderID = @orderid
	end
end

exec f_channel_shipped

alter procedure f_channel_received
as
begin
	declare @cono int = 0
	declare @ord int = (select count(OrderID) from channel_order where Received is null and Shipped is not null)
	select @ord = @ord * 0.9
	while @cono < @ord
	begin
		select @cono = @cono + 1
		declare @orderid int = (select top 1 OrderID from channel_order where Received IS NULL and Shipped IS NOT NULL order by NEWID())
		update channel_order set Received = dateadd(hour, RAND()*200, Shipped) where OrderID = @orderid
	end
end

exec f_channel_received
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
create sequence s_SellerOrderNumber as int
start with 100000
increment by 1

alter procedure f_seller_order @rid int = null, @pid int = null, @qty int
as
begin
	declare @cono int = 0
	declare @orderid int = next value for s_sellerordernumber
	declare @prodid int = (select ISNULL((select ProductID from product_info where ProductID = @pid), (select top 1 p.ProductID from product_info p
																										join created_product c on p.ProductID = c.ProductID
																										where c.ChannelOrderID is not null order by NEWID())))
	declare @country varchar(35) = (select ISNULL((select country from retail_seller where SellerID = @rid), (select top 1 Country from country order by NEWID())))
	declare @lastdate datetime = (select top 1 Received from channel_order order by Received desc)
	set @rid = (select ISNULL(@rid, (select top 1 SellerID from retail_seller where Country = @country order by NEWID())))
	declare @cost numeric(18,2) = 0
	select @cost = (select @cost + (select BasePrice from product_info where ProductID = @prodid))
	declare @count int = (select count(SerialNo) from created_product c
						join channel_order co on c.ChannelOrderID = co.OrderID
						join channel_partner cp on co.ChannelID = cp.ChannelID
						where ProductID = @prodid and Country = @country and ChannelOrderID is not null and SellerOrderID is null and Received is not null)
	if @count < @qty
	begin
		raiserror('Not enough in stock, sending reorder...',11,1)
		declare @cid int = (select top 1 channelid from channel_partner where Country = @country order by NEWID())
		declare @reorderqty int = @qty*2
		exec f_channel_order @cid, @prodid, @reorderqty
		exec f_channel_shipped
		exec f_channel_received
		exec f_seller_order @rid, @prodid, @qty
	end
	else
	begin
		insert into retail_order(OrderID, SellerID, TotalCost, Ordered) values(@orderid, @rid, @cost*@qty*1.24, DATEADD(mi, 600+RAND()*8, @lastdate))
		while @cono < @qty
		begin
			select @cono = @cono + 1
			declare @sno int = (select top 1 SerialNo from created_product c
								join channel_order co on c.ChannelOrderID = co.OrderID
								join channel_partner cp on co.ChannelID = cp.ChannelID
								where ProductID = @prodid and Country = @country and ChannelOrderID is not null and SellerOrderID is null and Received is not null
								order by ManufactDate desc)
			update created_product set SellerOrderID = @orderid where SerialNo = @sno
		end
	end
end

declare @in int = 0
while @in < 10000
begin
select @in = @in + 1
exec f_seller_order @qty = 5
end
delete from retail_Order
update Created_Product set sellerOrderID = null
select * from retail_order r join created_product c on r.OrderID = c.SellerOrderID join customer_order co on c.CustomerOrderID = co.OrderID
select * from Created_Product where sellerOrderID IS not NULL and customerOrderID IS NULL

create procedure f_seller_shipped
as
begin
	declare @cono int = 0
	declare @ord int = (select count(OrderID) from retail_order where ordered is not null and shipped is null)
	select @ord = @ord * 0.8
	while @cono < @ord
	begin
		select @cono = @cono + 1
		declare @orderid int = (select top 1 OrderID from retail_order where Shipped IS NULL and Ordered IS NOT NULL order by NEWID())
		update retail_order set Shipped = dateadd(hour, RAND()*100, Ordered) where OrderID = @orderid
	end
end

exec f_seller_shipped

alter procedure f_seller_received
as
begin
	declare @cono int = 0
	declare @ord int = (select count(OrderID) from retail_order where Received is null and Shipped is not null)
	select @ord = @ord * 0.9
	while @cono < @ord
	begin
		select @cono = @cono + 1
		declare @orderid int = (select top 1 OrderID from retail_order where Received IS NULL and Shipped IS NOT NULL order by NEWID())
		update retail_order set Received = dateadd(hour, RAND()*200, Shipped) where OrderID = @orderid
	end
end

exec f_seller_received
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
create sequence s_CustomerOrderNumber as int
start with 100000
increment by 1

alter procedure f_customer_order @custid int = null, @pid int = null, @qty int
as
begin
	declare @cono int = 0
	declare @orderid int = next value for s_customerordernumber
	declare @prodid int = (select ISNULL((select ProductID from product_info where ProductID = @pid), (select top 1 p.ProductID from product_info p
																										join created_product c on p.ProductID = c.ProductID
																										where c.SellerOrderID is not null order by NEWID())))
	declare @country varchar(35) = (select ISNULL((select country from customer where CustomerID = @custid), (select top 1 Country from country order by NEWID())))
	declare @lastdate datetime = (select top 1 Received from retail_order order by Received desc)
	set @custid = (select ISNULL(@custid, (select top 1 CustomerID from customer where Country = @country order by NEWID())))
	declare @cost numeric(18,2) = 0
	select @cost = (select @cost + (select BasePrice from product_info where ProductID = @prodid))
	declare @count int = (select count(SerialNo) from created_product c
						join retail_order ro on c.SellerOrderID = ro.OrderID
						join retail_seller r on ro.SellerID = r.SellerID
						where ProductID = @prodid and Country = @country and SellerOrderID is not null and CustomerOrderID is null and Received is not null)
	if @count < @qty
	begin
		raiserror('Not enough in stock, sending reorder...',11,1)
		declare @cid int = (select top 1 sellerid from retail_seller where Country = @country order by NEWID())
		declare @reorderqty int = @qty*2
		exec f_seller_order @cid, @prodid, @reorderqty
		exec f_seller_shipped
		exec f_seller_received
		exec f_customer_order @custid, @prodid, @qty
	end
	else
	begin
		insert into customer_order(OrderID, CustomerID, TotalCost, Ordered) values(@orderid, @custid, @cost*@qty*1.32, DATEADD(mi, 600+RAND()*8, @lastdate))
		while @cono < @qty
		begin
			select @cono = @cono + 1
			declare @sno int = (select top 1 SerialNo from created_product c
								join retail_order ro on c.SellerOrderID = ro.OrderID
								join retail_seller r on ro.SellerID = r.SellerID
								where ProductID = @prodid and Country = @country and SellerOrderID is not null and CustomerOrderID is null and Received is not null
								order by ManufactDate desc)
			update created_product set CustomerOrderID = @orderid where SerialNo = @sno
		end
	end
end

declare @in int = 0
while @in < 1000
begin
select @in = @in + 1
exec f_customer_order @qty=1
end
delete from customer_Order
update Created_Product set customerOrderID = null
select * from customer_order
select * from Created_Product where customerOrderID IS not NULL

alter procedure f_customer_shipped
as
begin
	declare @cono int = 0
	declare @ord int = (select count(OrderID) from customer_order where ordered is not null and shipped is null)
	select @ord = @ord * 0.95
	while @cono < @ord
	begin
		select @cono = @cono + 1
		declare @orderid int = (select top 1 OrderID from customer_order where Shipped IS NULL and Ordered IS NOT NULL order by NEWID())
		update customer_order set Shipped = dateadd(hour, RAND()*100, Ordered) where OrderID = @orderid
	end
end

exec f_customer_shipped

alter procedure f_customer_received
as
begin
	declare @cono int = 0
	declare @ord int = (select count(OrderID) from customer_order where Received is null and Shipped is not null)
	select @ord = @ord * 0.95
	while @cono < @ord
	begin
		select @cono = @cono + 1
		declare @orderid int = (select top 1 OrderID from customer_order where Received IS NULL and Shipped IS NOT NULL order by NEWID())
		update customer_order set Received = dateadd(hour, RAND()*200, Shipped) where OrderID = @orderid
	end
end

exec f_customer_received
--------------------------------------------------------------------------------------------------------------------------------------------------------------
alter procedure f_returns @sno int = null, @reason varchar(80) = null
as
begin
	if EXISTS (select SerialNo from created_product where CustomerOrderID is null and SerialNo = @sno)
	begin
		RAISERROR ('Product still in storage, cannot be returned', 11, 1)
		return
	end
	else
	begin
		if EXISTS(select SerialNo from product_return where SerialNo = @sno)
		begin
			RAISERROR ('Product has already been returned', 11,1)
			return
		end
		else
		begin
			set @sno = ISNULL(@sno, (select top 1 SerialNo from Created_Product cp
											join Customer_Order c on cp.CustomerOrderID = c.OrderID
											where Received is not null
											order by NEWID()))
			set @reason = ISNULL(@reason, 'broken')
			declare @returndate datetime = DATEADD(mi, rand()*50000, (select Received from Customer_Order co
																		join Created_Product c on co.OrderID = c.CustomerOrderID
																		where SerialNo = @sno))
			declare @retailship datetime = DATEADD(mi, rand()*500, @returndate)
			declare @channelrec datetime = DATEADD(mi, rand()*400, @retailship)
			declare @channelship datetime = DATEADD(mi, rand()*300, @channelrec)
			declare @subrec datetime = DATEADD(mi, rand()*350, @channelship)
			declare @subship datetime = DATEADD(mi, rand()*200, @subrec)
			declare @distrec datetime = DATEADD(mi, rand()*100, @subship)
			declare @distship datetime = DATEADD(mi, rand()*450, @distrec)
			declare @warerec datetime = DATEADD(mi, rand()*90, @distship)
			declare @wareship datetime = DATEADD(mi, rand()*100, @warerec)
			declare @prodrec datetime = DATEADD(mi, rand()*110, @wareship)
			insert into product_return values(@sno, @reason, @returndate, @retailship, @channelrec, @channelship, @subrec, @subship, @distrec, @distship, @warerec, @wareship, @prodrec)
		end
	end
end

declare @no int = 0
while @no < 1000
begin
select @no = @no + 1
exec f_returns
end
select * from created_product where SerialNo = 12240503
delete from product_return
select * from product_return r join Created_Product c on r.SerialNo = c.SerialNo
select * from Created_Product where WarehouseOrderID is null and CustomerOrderID is not null
update Created_Product set CustomerOrderID = NULL where WarehouseOrderID is null

alter trigger trg_Returns
on product_return
after insert
as
begin
	declare @pid int = (select ProductID from inserted i join Created_Product c on i.SerialNo = c.SerialNo)
	declare @sno int = (select i.SerialNo from inserted i)
	declare @newsno int = (select top 1 SerialNo from Created_Product where ProductID = @pid and WarehouseOrderID is null and CustomerOrderID is null order by NEWID())
	declare @custorder int = (select CustomerOrderID from Created_Product where SerialNo = @sno)

	update Created_Product set CustomerOrderID = @custorder where SerialNo = @newsno
end
-------------------------------------------------------------------------------------------------------------------------------------------------
alter function f_currency_convert(@country varchar(35), @amt numeric(18,2))
returns numeric(18,2)
as
begin
	declare @iso varchar(3) = (select ISO_code from country where country = @country)
	declare @rate float = (select CurrentRate from currency where [ISO Code] = @iso)
	return @amt * @rate
end

create function f_clean_percentage(@amt numeric, @amt2 numeric)
returns varchar(20)
as
begin
return concat(cast(round(@amt / @amt2, 2) as FLOAT), '%')
end