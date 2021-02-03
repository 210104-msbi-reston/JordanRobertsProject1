select * from created_product where warehouseorderid is not null
select * from subdistributor_order where shipped is not null and received is null

--Total List of products with each entity
select * from created_product where WarehouseOrderID is null
select * from created_product where WarehouseOrderID is not null and DistributorOrderID is null
select * from created_product where DistributorOrderID is not null and SubdistributorOrderID is null
select * from created_product where SubdistributorOrderID is not null and ChannelOrderID is null
select * from created_product where ChannelOrderID is not null and SellerOrderID is null
select * from created_product where SellerOrderID is not null and CustomerOrderID is null
select * from created_product where CustomerOrderID is not null order by DistributorOrderID

--Count of products with each entity
select count(*) as [In Production Houses] from created_product where WarehouseOrderID is null
select count(*) as [In Warehouses] from created_product where WarehouseOrderID is not null and DistributorOrderID is null
select count(*) as [With Distributors] from created_product where DistributorOrderID is not null and SubdistributorOrderID is null
select count(*) as [With Subdistributors] from created_product where SubdistributorOrderID is not null and ChannelOrderID is null
select count(*) as [With Channel Partners] from created_product where ChannelOrderID is not null and SellerOrderID is null
select count(*) as [In Retail Locations] from created_product where SellerOrderID is not null and CustomerOrderID is null
select count(*) as [Sold] from created_product where CustomerOrderID is not null

select co.Country, count(SerialNo) from created_product c
join Production_House p on c.ProductionHouseID = p.ProductionHouseID
join Country co on co.Country = p.Country
group by co.Country order by co.Country

--Warehouse Order Individual Contents
select WarehouseOrderID, SerialNo, ProductID, Ordered, Shipped, Received from created_product c
join Warehouse_Order w on c.WarehouseOrderID = w.OrderID
order by OrderID

--Product's Trip from creation to customer
select SerialNo, WarehouseID, DistributorID, SubdistributorID, ChannelID, SellerID, CustomerID from created_product cp
join Warehouse_Order wo on cp.WarehouseOrderID = wo.OrderID
join Distributor_Order do on cp.DistributorOrderID = do.OrderID
join subdistributor_order so on cp.SubdistributorOrderID = so.OrderID
join Channel_Order co on cp.ChannelOrderID = co.OrderID
join Retail_Order ro on cp.SellerOrderID = ro.OrderID
join Customer_Order cust on cp.CustomerOrderID = cust.OrderID
order by SerialNo
------------------------------------------------------------------------------------------------------------------------------------------------
--Count by country - warehouses
select Country, count(*) as [Products in Warehouses] from Created_Product c
join Warehouse_Order w on c.WarehouseOrderID = w.OrderID
join Warehouse wa on w.WarehouseID = wa.WarehouseID
group by Country order by Country

--Warehouse stock
select Country, wa.WarehouseID as Warehouse, count(*) as [Current Stock] from created_product c
join warehouse_order w on c.WarehouseOrderID = w.OrderID
join Warehouse wa on w.WarehouseID = wa.WarehouseID
group by Country, wa.WarehouseID order by Country, wa.WarehouseID

--Stock in warehouses by Category
select c.Country, Category, count(SerialNo) as [Products in Warehouse Stock] from created_product cp
join warehouse_order wo on cp.WarehouseOrderID = wo.OrderID
join Warehouse w on w.WarehouseID = wo.WarehouseID
join Country c on w.Country = c.Country
join Product_Info p on cp.ProductID = p.ProductID
join category cat on p.CategoryID = cat.CategoryID
group by c.Country, Category order by c.Country, Category

--Stock in warehouses by category and warehouse
select c.Country, w.WarehouseID, Category, count(SerialNo) as [Products in Warehouse Stock] from created_product cp
join warehouse_order wo on cp.WarehouseOrderID = wo.OrderID
join Warehouse w on w.WarehouseID = wo.WarehouseID
join Country c on w.Country = c.Country
join Product_Info p on cp.ProductID = p.ProductID
join category cat on p.CategoryID = cat.CategoryID
group by c.Country, w.WarehouseID, Category order by c.Country, w.WarehouseID, Category

--Average time taken to fulfill orders, including picking and shipping
select c.Country,
avg(DATEDIFF(hour, Ordered, Shipped)) as [Average Hours for Warehouse Order Picking],
avg(DATEDIFF(hour, Shipped, Received)) as [Average Hours for Warehouse Delivery],
avg(DATEDIFF(hour, Ordered, Received)) as [Average Hours for Full Order Fulfillment]
from warehouse_order wo
join Warehouse w on wo.WarehouseID = w.WarehouseID
join Country c on w.Country = c.Country
group by c.Country order by c.Country
-----------------------------------------------------------------------------------------------------------------------------

--Count by country - distributors
select Country, count(*) as [Products with Distributors] from created_product c
join Distributor_Order do on c.DistributorOrderID = do.OrderID
join Distributor d on d.DistributorID = do.DistributorID
group by Country order by Country

--Count by country - subdistributors
select Country, count(*) as [Products with Subdistributors] from created_product c
join subdistributor_order so on c.SubdistributorOrderID = so.OrderID
join Subdistributor s on s.SubdistributorID = so.SubdistributorID
group by Country order by Country

--Subdistributor stock
select s.SubdistributorID, Country, count(*) as [Stock] from created_product c
join subdistributor_order so on c.SubdistributorOrderID = so.OrderID
join Subdistributor s on s.SubdistributorID = so.SubdistributorID
group by s.SubdistributorID, Country order by s.SubdistributorID, Country

--Count by country - channel partners
select Country, count(*) as [Products with Partners] from created_product c
join Channel_Order co on c.ChannelOrderID = co.OrderID
join Channel_Partner cp on cp.ChannelID = co.ChannelID
group by Country order by Country

--Channel partner stock
select cp.ChannelID, Country, count(*) as [Current Stock] from created_product c
join Channel_Order co on c.ChannelOrderID = co.OrderID
join Channel_Partner cp on cp.ChannelID = co.ChannelID
group by cp.ChannelID, Country order by cp.ChannelID, Country

--Count by country - retail
select Country, count(*) as [Products in Stores] from created_product c
join Retail_Order ro on c.SellerOrderID = ro.OrderID
join Retail_Seller r on r.SellerID = ro.SellerID
group by Country order by Country

--Stock in stores
select r.SellerID, Country, count(*) as [Products in Stores] from created_product c
join Retail_Order ro on c.SellerOrderID = ro.OrderID
join Retail_Seller r on r.SellerID = ro.SellerID
group by r.SellerID, Country order by r.SellerID, Country

--Number of stores by country
select Country.Country, count(SellerID) as [Retail Locations] from Retail_Seller
join Country on Retail_Seller.Country = Country.Country
group by Country.Country order by Country.Country

select z.ZoneID as [Sales Zone], Country, count(*) as [Zone Stock] from created_product c
join Retail_Order ro on c.SellerOrderID = ro.OrderID
join Retail_Seller r on r.SellerID = ro.SellerID
join Zone z on z.ZoneID = r.ZoneID
group by z.ZoneID, Country order by  z.ZoneID, Country

select zoneid, country from zone join Channel_Partner on zone.ChannelID = Channel_Partner.ChannelID

--Sales by country
select Country, count(*) as [Products Sold] from created_product c
join channel_order co on c.ChannelOrderID = co.OrderID
join Channel_Partner cp on cp.ChannelID = co.ChannelID
group by Country order by Country

-------------------------------------------------------------------------------------------------------------------------------------------------------------

--Displays returned items and the items used to replace them, sent to the same customer at no charge
select c.SerialNo as [Serial Number],
		p.Name as Product,
		CustomerOrderID as [Customer Order],
		case when WarehouseOrderID is null then 'Replacement'
			 when WarehouseOrderID is not null then 'Returned Item' end as [Return status]
			 from created_product c
			 join product_return r on c.SerialNo = r.SerialNo
			 join Product_Info p on c.ProductID = p.ProductID
UNION ALL
select c.SerialNo, p.Name, CustomerOrderID,
case when WarehouseOrderID is null then 'Replacement'
	 when WarehouseOrderID is not null then 'Returned Item' end as [Return status]
	 from created_product c
	 join Product_Info p on c.ProductID = p.ProductID where WarehouseOrderID is null and CustomerOrderID is not null order by CustomerOrderID, [Return status] desc