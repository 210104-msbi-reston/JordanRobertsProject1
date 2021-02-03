--View all products and some simple information
select * from vw_allproducts

--View product distribution across all channels, including returns and sales
select * from vw_ProductDistribution

--View total production costs by country (and production house)
select * from vw_productionCosts order by [production house id]

--View total warehouse shipping costs by warehouse
select * from vw_warehouseshipping order by [Costs in USD] desc

--View total revenue from distributors
select * from vw_distributorrevenue order by country

--View total revenue from subdistributors
select * from vw_subdistributorrevenue order by country

--View total revenue from channel partners
select * from vw_channelrevenue order by [Partner ID]

--View total revenue from retail locations
select * from vw_retailrevenue order by [Retail Store ID]

--View total revenue from end customers
select * from vw_TotalRevenue order by country

		--Can also view countrywide data for any of these entities
select Country, sum([Total Revenue from Sales]) [Total Sales Revenue] from vw_totalrevenue group by country order by [Total Sales Revenue]

		--We can check profit percentages too, by country or by single components of the supply chain
select dr.Country, dbo.f_clean_percentage(sum([Revenue from Distributors]),sum([Total Warehouse Shipping Costs] + [Total Manufacturing Costs])) [% Profit]
from vw_distributorrevenue dr join vw_warehouseshipping ws on dr.country = ws.country join vw_productioncosts pc on dr.country = pc.country
group by dr.country order by dr.country
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--View stock currently in warehouses by category
select * from vw_warehousestockbycategory order by country, [Warehouse ID], category
		--Can be used to aggregate products at the country level
select Country, Category, avg([Products in Warehouse Stock]) [Average Stock in Warehouses] from vw_warehousestockbycategory group by country, category order by country, category
select Country, sum([Products in Warehouse Stock]) [Total Stock in Warehouses] from vw_warehousestockbycategory group by country order by country

--Can also be applied to other entities in the supply chain
select * from vw_subdistributorstockbycategory order by Country, [Subdistributor ID], Product
select * from vw_channelstockbycategory order by Country, [Channel Partner ID], Product
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--View full life for a product ultimately sold to an end customer (MEGATABLE)
select * from vw_productlife order by [Serial Number]

--We can use this to just view the orders that a product was a part of
select [Serial Number],
[Warehouse Order Number],
[Distributor Order Number],
[Subdistributor Order Number],
[Channel Partner Order Number],
[Store Order Number],
[Customer Order Number]
from vw_ProductLife where [Serial Number] = 12170839

--We can also check to see if any products are yet to be delivered to customers
--Some have been shipped, but never arrived, do we need to fix this?
select * from vw_undelivered order by [Serial Number]

--View return trip for a product returned by a customer
select * from vw_returns order by [Serial Number]

--View a product's FULL life, from creation to ultimate arrival back at production house for dismantling
select * from vw_productlifewithreturn
		--Useful for viewing any sort of lifetime data
select [Serial Number], DATEDIFF(day, [Created On], [Received at Production House]) [Days from Creation to Dismantling] from vw_productlifewithreturn
		--Like time between events in a product's life
select [Serial Number], DATEDIFF(hour, [Ordered by Customer], [Shipped to Customer]) [Days from Warehouse Arrival to Shipment] from vw_productlifewithreturn
		--And even group by category, warehouse ID, or anything else
select Product, avg(DATEDIFF(hour, [Ordered by Store], [Shipped to Store])) [Average Hours Between Customer Order and Shipment] from vw_ProductLife group by Product order by Product

--View returned items and their replacements
select * from vw_returnreplace order by [Customer Order], [Return Status] desc

select [Customer Order], count([Customer Order]) [Number of Products Returned from Customer Order] from vw_returnreplace where [Return Status] = 'Returned' group by [Customer Order]