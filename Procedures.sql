--Product ID, leave empty for random products
	declare @productid int = 1036
--Quantity, leave empty for default 10,000 units
	declare @qty int = 1
--Production House used for creation, leave empty for random production worldwide
	declare @prodhouseid int = 11
exec p_product_creation @productid, @qty, @prodhouseid

select * from vw_allproducts order by [Serial Number]

	declare @country varchar(35) = 
--Name, Phone number, and Email, can be left empty for now
	declare @name varchar(30) = 
	declare @phone varchar(20) = 
	declare @email varchar(40) = 
--Quantity, for mass customer record production
	declare @qty int = 
exec f_customer_creation @qty = 1, @country = 'United Kingdom', @name, @phone, @email

select * from customer
----------------------------------------------------------------------------------------------------------------------
--Country that needs more warehouses
	declare @country varchar(35) = 'Canada'
--Number of warehouses to add to @country
	declare @qty int = 1
exec f_warehouse_creation @country, @qty

select * from warehouse where Country = 'Canada'

--distributors
	declare @country varchar(35) = 'United States'
	declare @qty int = 1
exec f_distributor_creation @country, @qty

select * from distributor where Country = 'United States'

--subdistributors
	declare @country varchar(35) = 'Mexico'
	declare @qty int = 1
exec f_subdistributor_creation @country, @qty

select * from subdistributor where Country = 'Mexico'

--channel partners
	declare @country varchar(35) = 'Indonesia'
	declare @qty int = 1
exec f_channel_creation @country, @qty

select * from channel_partner where Country = 'Indonesia'

--zones, linked to individual channel partners
	declare @channel int = 5
	declare @qty int = 1
exec f_zone_creation @channel, @qty

select zone.ChannelID, ZoneID, Country from channel_partner join zone on channel_partner.ChannelID = zone.ChannelID where zone.ChannelID = 200

--retail stores, located in individual zones under control by channel partners
	declare @zone int = 5
	declare @qty int = 1
exec f_retail_creation @channel, @qty

select c.ChannelID, r.ZoneID, SellerID, c.Country from retail_seller r
join zone z on r.ZoneID = z.ZoneID
join channel_partner c on c.ChannelID = z.ChannelID
where z.ChannelID = 200
----------------------------------------------------------------------------------------------------------------------
--WAREHOUSE ORDERING
--For mass ordering, leave @wid empty to order from warehouses at random or @pid to order products at random (best with a loop)
--@wid is the ID of the Warehouse making the order, @pid is the ID of the ordered product
	declare @wid int = 5
	declare @pid int = 1036
	declare @qty int = 99
exec f_warehouse_order @wid, @pid, @qty
--These procedures finalize picking and shipping for most products that have been ordered (to simulate lag/errors in real life)
exec f_warehouse_shipped
exec f_warehouse_received
----------------------------------------------------------------------------------------------------------------------
--DISTRIBUTOR ORDERING
--If there isn't enough stock at any warehouse available to the distributor, an command is sent to a warehouse to order more immediately
--Mass ordering is the same as with warehouse orders (@did is the Distributor ID)
	declare @did int = 5
	declare @pid int = 1036
	declare @qty int = 99
exec f_distributor_order @did, @pid, @qty

exec f_distributor_shipped
exec f_distributor_received
----------------------------------------------------------------------------------------------------------------------
--SUBDISTRIBUTOR ORDERING
--If there isn't enough stock at the distributor available to the subdistributor, an command is sent to the distributor to order more immediately
--Mass ordering is the same as with warehouse orders (@sid is the Subdistributor ID)
	declare @sid int = 5
	declare @pid int = 1036
	declare @qty int = 99
exec f_subdistributor_order @sid, @pid, @qty

exec f_subdistributor_shipped
exec f_subdistributor_received
----------------------------------------------------------------------------------------------------------------------
--CHANNEL PARTNER ORDERING
--If there isn't enough stock at the subdistributor available to the partner, an command is sent to the subdistributor to order more immediately
--Mass ordering is the same as with warehouse orders (@cid is the Channel Partner ID)
	declare @cid int = 5
	declare @pid int = 1036
	declare @qty int = 99
exec f_channel_order @cid, @pid, @qty

exec f_channel_shipped
exec f_channel_received
----------------------------------------------------------------------------------------------------------------------
--RETAIL STORE ORDERING
--If there isn't enough stock at the channel partner available to the store, an command is sent to the channel partner to order more immediately
--Mass ordering is the same as with warehouse orders (@rid is the Channel Partner ID)
	declare @rid int = 5
	declare @pid int = 1036
	declare @qty int = 99
exec f_channel_order @rid, @pid, @qty

exec f_seller_shipped
exec f_seller_received
----------------------------------------------------------------------------------------------------------------------
--CUSTOMER ORDERING
--If there isn't enough stock at the store available to the customer, an command is sent to the store to order more immediately
--Mass ordering is the same as with warehouse orders (@custid is the Channel Partner ID)
	declare @custid int = 5
	declare @pid int = 1036
	declare @qty int = 99
exec f_customer_order @custid, @pid, @qty

exec f_customer_shipped
exec f_customer_received
----------------------------------------------------------------------------------------------------------------------
--RETURNS
--This procedure returns a item that has made its way to a customer
--For purposes of product simulation, leaving @sno (Serial Number) blank will choose a random sold product, and leaving @reason blank will designate the item as simply "broken"
	declare @sno int = 
	declare @reason varchar(80) = 
exec f_returns @sno, @reason