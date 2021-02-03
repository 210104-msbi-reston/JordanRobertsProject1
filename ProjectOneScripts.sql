USE [master]
GO
/****** Object:  Database [ProjectOneDB]    Script Date: 2/3/2021 12:41:56 AM ******/
CREATE DATABASE [ProjectOneDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ProjectOneDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.TRAININGSERVER\MSSQL\DATA\ProjectOneDB.mdf' , SIZE = 663552KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'ProjectOneDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.TRAININGSERVER\MSSQL\DATA\ProjectOneDB_log.ldf' , SIZE = 1384448KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [ProjectOneDB] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ProjectOneDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ProjectOneDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ProjectOneDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ProjectOneDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ProjectOneDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ProjectOneDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [ProjectOneDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ProjectOneDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ProjectOneDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ProjectOneDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ProjectOneDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ProjectOneDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ProjectOneDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ProjectOneDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ProjectOneDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ProjectOneDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ProjectOneDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ProjectOneDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ProjectOneDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ProjectOneDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ProjectOneDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ProjectOneDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ProjectOneDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ProjectOneDB] SET RECOVERY FULL 
GO
ALTER DATABASE [ProjectOneDB] SET  MULTI_USER 
GO
ALTER DATABASE [ProjectOneDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ProjectOneDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ProjectOneDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ProjectOneDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [ProjectOneDB] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'ProjectOneDB', N'ON'
GO
ALTER DATABASE [ProjectOneDB] SET QUERY_STORE = OFF
GO
USE [ProjectOneDB]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
USE [ProjectOneDB]
GO
USE [ProjectOneDB]
GO
/****** Object:  Sequence [dbo].[s_ChannelOrderNumber]    Script Date: 2/3/2021 12:41:56 AM ******/
CREATE SEQUENCE [dbo].[s_ChannelOrderNumber] 
 AS [int]
 START WITH 100000
 INCREMENT BY 1
 MINVALUE -2147483648
 MAXVALUE 2147483647
 CACHE 
GO
USE [ProjectOneDB]
GO
/****** Object:  Sequence [dbo].[s_CustomerOrderNumber]    Script Date: 2/3/2021 12:41:56 AM ******/
CREATE SEQUENCE [dbo].[s_CustomerOrderNumber] 
 AS [int]
 START WITH 100000
 INCREMENT BY 1
 MINVALUE -2147483648
 MAXVALUE 2147483647
 CACHE 
GO
USE [ProjectOneDB]
GO
/****** Object:  Sequence [dbo].[s_DistributorOrderNumber]    Script Date: 2/3/2021 12:41:56 AM ******/
CREATE SEQUENCE [dbo].[s_DistributorOrderNumber] 
 AS [int]
 START WITH 100000
 INCREMENT BY 1
 MINVALUE -2147483648
 MAXVALUE 2147483647
 CACHE 
GO
USE [ProjectOneDB]
GO
/****** Object:  Sequence [dbo].[s_SellerOrderNumber]    Script Date: 2/3/2021 12:41:56 AM ******/
CREATE SEQUENCE [dbo].[s_SellerOrderNumber] 
 AS [int]
 START WITH 100000
 INCREMENT BY 1
 MINVALUE -2147483648
 MAXVALUE 2147483647
 CACHE 
GO
USE [ProjectOneDB]
GO
/****** Object:  Sequence [dbo].[s_SubdistributorOrderNumber]    Script Date: 2/3/2021 12:41:56 AM ******/
CREATE SEQUENCE [dbo].[s_SubdistributorOrderNumber] 
 AS [int]
 START WITH 100000
 INCREMENT BY 1
 MINVALUE -2147483648
 MAXVALUE 2147483647
 CACHE 
GO
USE [ProjectOneDB]
GO
/****** Object:  Sequence [dbo].[s_WarehouseOrderNumber]    Script Date: 2/3/2021 12:41:56 AM ******/
CREATE SEQUENCE [dbo].[s_WarehouseOrderNumber] 
 AS [int]
 START WITH 100000
 INCREMENT BY 1
 MINVALUE -2147483648
 MAXVALUE 2147483647
 CACHE 
GO
/****** Object:  UserDefinedFunction [dbo].[f_clean_percentage]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[f_clean_percentage](@amt numeric, @amt2 numeric)
returns varchar(20)
as
begin
return concat(cast(round(@amt / @amt2, 2) as FLOAT), '%')
end
GO
/****** Object:  UserDefinedFunction [dbo].[f_currency_convert]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[f_currency_convert](@country varchar(35), @amt numeric(18,2))
returns numeric(18,2)
as
begin
	declare @iso varchar(3) = (select ISO_code from country where country = @country)
	declare @rate float = (select CurrentRate from currency where [ISO Code] = @iso)
	return @amt * @rate
end
GO
/****** Object:  Table [dbo].[created_product]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[created_product](
	[SerialNo] [int] IDENTITY(10000000,1) NOT NULL,
	[ProductID] [int] NOT NULL,
	[ProductionHouseID] [int] NOT NULL,
	[ManufactDate] [datetime] NOT NULL,
	[ManufactCost] [numeric](18, 2) NOT NULL,
	[WarehouseOrderID] [int] NULL,
	[DistributorOrderID] [int] NULL,
	[SubdistributorOrderID] [int] NULL,
	[ChannelOrderID] [int] NULL,
	[SellerOrderID] [int] NULL,
	[CustomerOrderID] [int] NULL,
 CONSTRAINT [PK__Products__5E5A535FCC0D7A2F] PRIMARY KEY CLUSTERED 
(
	[SerialNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_ProductDistribution]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_ProductDistribution]
as
with total_products as (select count(serialno) as Total from created_product),
	 products_in_house as (select count(serialno) as ProductionHouse from created_product where CustomerOrderID is null and WarehouseOrderID is null),
	 products_in_warehouses as (select count(SerialNo) as Warehouse from created_product where WarehouseOrderID is not null and DistributorOrderID is null),
	 products_with_distributors as (select count(SerialNo) as Distributor from created_product where DistributorOrderID is not null and SubdistributorOrderID is null),
	 products_with_subdistributors as (select count(SerialNo) as Subdistributor from created_product where SubdistributorOrderID is not null and ChannelOrderID is null),
	 products_with_channels as (select count(SerialNo) as Channel from created_product where ChannelOrderID is not null and SellerOrderID is null),
	 products_in_stores as (select count(SerialNo) as Retail from created_product where SellerOrderID is not null and CustomerOrderID is null),
	 sold_products as (select count(SerialNo) as Sold from created_product where CustomerOrderID is not null and WarehouseOrderID is not null),
	 returned_products as (select count(SerialNo) as Returns from created_product, sold_products where CustomerOrderID is not null and WarehouseOrderID is null)
select Total [Total Number of Products],
CONCAT((ProductionHouse*100)/Total, '%') [Percentage in House],
CONCAT((Warehouse*100)/Total, '%') [Percentage in Warehouses],
CONCAT((Distributor*100)/Total, '%') [Percentage with Distributors],
CONCAT((Subdistributor*100)/Total, '%') [Percentage with Subdistributors],
CONCAT((Channel*100)/Total, '%') [Percentage with Channel Partners],
CONCAT((Retail*100)/Total, '%') [Percentage in Stores],
CONCAT((Sold*100)/Total, '%') [Percentage Sold to Customers],
CONCAT((Returns*100)/Sold, '%') [Percentage of Sold Products Returned]
from total_products, products_in_house, products_in_warehouses, products_with_distributors, products_with_subdistributors, products_with_channels, products_in_stores, sold_products, returned_products
GO
/****** Object:  Table [dbo].[country]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[country](
	[Country] [varchar](35) NOT NULL,
	[Continent] [varchar](13) NULL,
	[ISO_code] [varchar](3) NULL,
	[Population] [int] NULL,
	[Area] [int] NULL,
 CONSTRAINT [PK_Countries] PRIMARY KEY CLUSTERED 
(
	[Country] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[production_house]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[production_house](
	[ProductionHouseID] [int] IDENTITY(1,1) NOT NULL,
	[Country] [varchar](35) NOT NULL,
 CONSTRAINT [PK__Producti__132ACF74FFC8E436] PRIMARY KEY CLUSTERED 
(
	[ProductionHouseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_ProductionCosts]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vw_ProductionCosts] as
select c.Country Country, p.ProductionHouseID [Production House ID], dbo.f_currency_convert(c.Country, sum(Manufactcost)) [Total Manufacturing Costs],
ISO_code as Currency, sum(Manufactcost) [Costs in USD]
from Country c
join production_house p on c.Country = p.Country
join created_product cr on p.ProductionHouseID = cr.ProductionHouseID
group by c.Country, p.ProductionHouseID, ISO_code
GO
/****** Object:  Table [dbo].[warehouse_order]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[warehouse_order](
	[OrderID] [int] NOT NULL,
	[WarehouseID] [int] NOT NULL,
	[Shipping] [numeric](18, 2) NOT NULL,
	[Ordered] [datetime] NOT NULL,
	[Shipped] [datetime] NULL,
	[Received] [datetime] NULL,
 CONSTRAINT [PK__Warehous__C3905BAF79C8BC70] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[warehouse]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[warehouse](
	[WarehouseID] [int] IDENTITY(1,1) NOT NULL,
	[Country] [varchar](35) NOT NULL,
 CONSTRAINT [PK__Warehous__2608AFD922D8EB71] PRIMARY KEY CLUSTERED 
(
	[WarehouseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_WarehouseShipping]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vw_WarehouseShipping] as
select c.Country Country, w.WarehouseID [Warehouse ID], dbo.f_currency_convert(c.Country, sum(Shipping)) [Total Warehouse Shipping Costs],
ISO_code as Currency, sum(Shipping) [Costs in USD]
from Country c
join warehouse w on c.Country = w.Country
join warehouse_order wo on w.WarehouseID = wo.WarehouseID
--join distributor d on c.Country = d.Country
--join subdistributor s on c.Country = s.Country
--join channel_partner cp on c.Country = cp.Country
--join retail_seller r on c.Country = r.Country
--join customer cust on c.Country = cust.Country
group by c.Country, w.warehouseid, ISO_code
GO
/****** Object:  Table [dbo].[distributor_order]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[distributor_order](
	[OrderID] [int] NOT NULL,
	[DistributorID] [int] NOT NULL,
	[TotalCost] [numeric](18, 2) NULL,
	[Ordered] [datetime] NOT NULL,
	[Shipped] [datetime] NULL,
	[Received] [datetime] NULL,
 CONSTRAINT [PK__Distribu__C3905BAFF1684C49] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[distributor]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[distributor](
	[DistributorID] [int] IDENTITY(1,1) NOT NULL,
	[Country] [varchar](35) NOT NULL,
 CONSTRAINT [PK__Distribu__FD1AEBBEB8812759] PRIMARY KEY CLUSTERED 
(
	[DistributorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_DistributorRevenue]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vw_DistributorRevenue] as
select c.Country Country, d.DistributorID [Distributor ID], dbo.f_currency_convert(c.Country, sum(TotalCost)) [Revenue from Distributors],
ISO_code as Currency, sum(TotalCost) [Revenue in USD]
from Country c
join distributor d on c.Country = d.Country
join distributor_order do on d.DistributorID = do.DistributorID
--join subdistributor s on c.Country = s.Country
--join channel_partner cp on c.Country = cp.Country
--join retail_seller r on c.Country = r.Country
--join customer cust on c.Country = cust.Country
group by c.Country, d.distributorid, ISO_code
GO
/****** Object:  Table [dbo].[subdistributor_order]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[subdistributor_order](
	[OrderID] [int] NOT NULL,
	[SubdistributorID] [int] NOT NULL,
	[TotalCost] [numeric](18, 2) NULL,
	[Ordered] [datetime] NOT NULL,
	[Shipped] [datetime] NULL,
	[Received] [datetime] NULL,
 CONSTRAINT [PK__Subdistr__C3905BAF3FA44399] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[subdistributor]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[subdistributor](
	[SubdistributorID] [int] IDENTITY(1,1) NOT NULL,
	[Country] [varchar](35) NOT NULL,
 CONSTRAINT [PK__Subdistr__9BFE6E3617FD6983] PRIMARY KEY CLUSTERED 
(
	[SubdistributorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_SubdistributorRevenue]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vw_SubdistributorRevenue] as
select c.Country Country, s.subDistributorID [Subdistributor ID], dbo.f_currency_convert(c.Country, sum(TotalCost)) [Total Revenue from Subdistributors],
ISO_code as Currency, sum(TotalCost) [Revenue in USD]
from Country c
join subdistributor s on c.Country = s.Country
join subdistributor_order so on s.SubdistributorID = so.SubdistributorID
--join channel_partner cp on c.Country = cp.Country
--join retail_seller r on c.Country = r.Country
--join customer cust on c.Country = cust.Country
group by c.Country, s.subdistributorid, ISO_code
GO
/****** Object:  Table [dbo].[channel_order]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[channel_order](
	[OrderID] [int] NOT NULL,
	[ChannelID] [int] NOT NULL,
	[TotalCost] [numeric](18, 2) NULL,
	[Ordered] [datetime] NOT NULL,
	[Shipped] [datetime] NULL,
	[Received] [datetime] NULL,
 CONSTRAINT [PK__Channel___C3905BAFF3B70B2D] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[channel_partner]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[channel_partner](
	[ChannelID] [int] IDENTITY(1,1) NOT NULL,
	[Country] [varchar](35) NOT NULL,
 CONSTRAINT [PK__Channel___4DCBC5F1429908B9] PRIMARY KEY CLUSTERED 
(
	[ChannelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_ChannelRevenue]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vw_ChannelRevenue] as
select c.Country Country,
cp.ChannelID [Partner ID],
dbo.f_currency_convert(c.Country, sum(TotalCost))[Revenue from Channel Partners],
ISO_code as Currency, sum(totalcost) [Revenue in USD]
from Country c
join channel_partner cp on c.Country = cp.Country
join channel_order co on cp.ChannelID = co.ChannelID
--join retail_seller r on c.Country = r.Country
--join customer cust on c.Country = cust.Country
group by c.Country, cp.channelid, ISO_code
GO
/****** Object:  Table [dbo].[retail_order]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[retail_order](
	[OrderID] [int] NOT NULL,
	[SellerID] [int] NOT NULL,
	[TotalCost] [numeric](18, 2) NULL,
	[Ordered] [datetime] NOT NULL,
	[Shipped] [datetime] NULL,
	[Received] [datetime] NULL,
 CONSTRAINT [PK__Retail_O__C3905BAFCAA0DA15] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[retail_seller]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[retail_seller](
	[SellerID] [int] IDENTITY(1,1) NOT NULL,
	[ZoneID] [int] NULL,
	[Country] [varchar](35) NOT NULL,
 CONSTRAINT [PK__Retail_S__7FE3DBA14DE13FD0] PRIMARY KEY CLUSTERED 
(
	[SellerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_RetailRevenue]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vw_RetailRevenue] as
select c.Country Country,
r.SellerID [Retail Store ID],
dbo.f_currency_convert(c.Country,
sum(TotalCost)) [Total Revenue from Retail Locations],
ISO_code as Currency, sum(TotalCost) [Revenue in USD]
from Country c
join retail_seller r on c.Country = r.Country
join retail_order ro on r.SellerID = ro.SellerID
--join customer cust on c.Country = cust.Country
group by c.Country, r.sellerid, ISO_code
GO
/****** Object:  Table [dbo].[customer_order]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[customer_order](
	[OrderID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[TotalCost] [numeric](18, 2) NULL,
	[Ordered] [datetime2](7) NOT NULL,
	[Shipped] [datetime2](7) NULL,
	[Received] [datetime2](7) NULL,
 CONSTRAINT [PK__Customer__C3905BAFEAF57122] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[customer]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[customer](
	[CustomerID] [int] IDENTITY(1,1) NOT NULL,
	[NationalID] [varchar](18) NOT NULL,
	[Country] [varchar](35) NOT NULL,
	[Name] [varchar](30) NULL,
	[PhoneNumber] [varchar](20) NULL,
	[Email] [varchar](40) NULL,
 CONSTRAINT [PK__Customer__A4AE64B81E0E41B9] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_TotalRevenue]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_TotalRevenue] as
select c.Country Country,
cust.CustomerID [Customer ID],
dbo.f_currency_convert(c.Country,
sum(TotalCost)) [Total Revenue from Sales]
from Country c
join customer cust on c.Country = cust.Country
join customer_order co on cust.CustomerID = co.CustomerID
group by c.Country, cust.CustomerID
GO
/****** Object:  Table [dbo].[category]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[category](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[Category] [varchar](20) NULL,
 CONSTRAINT [PK_category] PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[product_info]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[product_info](
	[ProductID] [int] IDENTITY(1000,1) NOT NULL,
	[Name] [varchar](25) NOT NULL,
	[Description] [varchar](50) NULL,
	[BasePrice] [numeric](18, 2) NULL,
	[CategoryID] [int] NULL,
 CONSTRAINT [PK__Product___B40CC6EDAEC72864] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_ProductLife]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_ProductLife] as
select SerialNo [Serial Number], Name [Product], Category [Type of Product], ManufactDate [Created on], ProductionHouseID [In Production House],
WarehouseID [Warehouse ID], WarehouseOrderID [Warehouse Order Number], wo.Ordered [Ordered by Warehouse], wo.Shipped [Shipped to Warehouse], wo.Received [Arrived at Warehouse],
DistributorID [Distributor ID], DistributorOrderID [Distributor Order Number], do.Ordered [Ordered by Distributor], do.Shipped [Shipped to Distributor], do.Received [Arrived to Distributor],
SubdistributorID [Subdistributor ID], SubdistributorOrderID [Subdistributor Order Number], so.Ordered [Ordered by Subdistributor], so.Shipped [Shipped to Subdistributor], so.Received [Arrived to Subdistributor],
ChannelID [Channel Partner ID], ChannelOrderID [Channel Partner Order Number], co.Ordered [Ordered by Channel Partner], co.Shipped [Shipped to Channel Partner], co.Received [Arrived to Channel Partner],
SellerID [Store ID], SellerOrderID [Store Order Number], ro.Ordered [Ordered by Store], ro.Shipped [Shipped to Store], ro.Received [Arrived at Store],
CustomerID [Customer ID], CustomerOrderID [Customer Order Number], cust.Ordered [Ordered by Customer], cust.Shipped [Shipped to Customer], cust.Received [Final Delivery to Customer]
from created_product cp
join product_info p on cp.ProductID = p.ProductID
join category c on p.CategoryID = c.CategoryID
join Warehouse_Order wo on cp.WarehouseOrderID = wo.OrderID
join Distributor_Order do on cp.DistributorOrderID = do.OrderID
join subdistributor_order so on cp.SubdistributorOrderID = so.OrderID
join Channel_Order co on cp.ChannelOrderID = co.OrderID
join Retail_Order ro on cp.SellerOrderID = ro.OrderID
join Customer_Order cust on cp.CustomerOrderID = cust.OrderID
where cust.Received is not null
GO
/****** Object:  Table [dbo].[product_return]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[product_return](
	[SerialNo] [int] NOT NULL,
	[ReturnReason] [varchar](80) NOT NULL,
	[RetailReturnReceived] [datetime] NOT NULL,
	[RetailReturnShipped] [datetime] NULL,
	[ChannelReturnReceived] [datetime] NULL,
	[ChannelReturnShipped] [datetime] NULL,
	[SubdistributorReturnReceived] [datetime] NULL,
	[SubdistributorReturnShipped] [datetime] NULL,
	[DistributorReturnReceived] [datetime] NULL,
	[DistributorReturnShipped] [datetime] NULL,
	[WarehouseReturnReceived] [datetime] NULL,
	[WarehouseReturnShipped] [datetime] NULL,
	[ProductionHouseReturned] [datetime] NULL,
	[ReturnID] [int] IDENTITY(100000,1) NOT NULL,
 CONSTRAINT [PK_Returns_1] PRIMARY KEY CLUSTERED 
(
	[ReturnID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_Returns]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_Returns] as
select SerialNo [Serial Number],
ReturnID [Return ID],
ReturnReason [Reason for Return],
RetailReturnReceived [Returned to Store], RetailReturnShipped [Shipped back to Channel Partner],
ChannelReturnReceived [Received by Channel Partner], ChannelReturnShipped [Shipped back to Subdistributor],
SubdistributorReturnReceived [Received by Subdistributor], SubdistributorReturnShipped [Shipped back to Distributor],
DistributorReturnReceived [Received by Distributor], DistributorReturnShipped [Shipped back to Warehouse],
WarehouseReturnReceived [Received at Warehouse], WarehouseReturnShipped [Shipped back to Production House],
ProductionHouseReturned [Received at Production House]
from product_return
GO
/****** Object:  View [dbo].[vw_ProductLifeWithReturn]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_ProductLifeWithReturn] as
select r.[Serial Number], Product, [Type of Product], [Created on], [In Production House],
[Warehouse ID], [Warehouse Order Number], [Ordered by Warehouse], [Shipped to Warehouse], [Arrived at Warehouse],
[Distributor ID], [Distributor Order Number], [Ordered by Distributor], [Shipped to Distributor], [Arrived to Distributor],
[Subdistributor ID], [Subdistributor Order Number], [Ordered by Subdistributor], [Shipped to Subdistributor], [Arrived to Subdistributor],
[Channel Partner ID], [Channel Partner Order Number], [Ordered by Channel Partner], [Shipped to Channel Partner], [Arrived to Channel Partner],
[Store ID], [Store Order Number], [Ordered by Store], [Shipped to Store], [Arrived at Store],
[Customer ID], [Customer Order Number], [Ordered by Customer], [Shipped to Customer], [Final Delivery to Customer],
[Return ID], [Reason for Return], [Returned to Store], [Shipped back to Channel Partner],
[Received by Channel Partner], [Shipped back to Subdistributor], [Received by Subdistributor], [Shipped back to Distributor],
[Received by Distributor], [Shipped back to Warehouse], [Received at Warehouse], [Shipped back to Production House], [Received at Production House]
from vw_returns r join vw_ProductLife pl on r.[Serial Number] = pl.[Serial Number]
GO
/****** Object:  View [dbo].[vw_returnreplace]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_returnreplace] as
select c.SerialNo as [Serial Number],
		p.Name as Product,
		CustomerOrderID as [Customer Order],
		case when WarehouseOrderID is null then 'Replacement'
			 when WarehouseOrderID is not null then 'Returned' end as [Return status]
			 from created_product c
			 join product_return r on c.SerialNo = r.SerialNo
			 join Product_Info p on c.ProductID = p.ProductID
UNION ALL
select c.SerialNo, p.Name, CustomerOrderID,
case when WarehouseOrderID is null then 'Replacement'
	 when WarehouseOrderID is not null then 'Returned' end as [Return status]
	 from created_product c
	 join Product_Info p on c.ProductID = p.ProductID where WarehouseOrderID is null and CustomerOrderID is not null
GO
/****** Object:  View [dbo].[vw_warehousestockbycategory]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vw_warehousestockbycategory] as
select c.Country, w.WarehouseID [Warehouse ID], Category, count(SerialNo) as [Products in Warehouse Stock] from created_product cp
join warehouse_order wo on cp.WarehouseOrderID = wo.OrderID
join Warehouse w on w.WarehouseID = wo.WarehouseID
join Country c on w.Country = c.Country
join Product_Info p on cp.ProductID = p.ProductID
join category cat on p.CategoryID = cat.CategoryID
group by c.Country, w.WarehouseID, Category
GO
/****** Object:  View [dbo].[vw_fullwarehousestock]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_fullwarehousestock] as
select Country, count(*) as [Products in Warehouses] from Created_Product c
join Warehouse_Order w on c.WarehouseOrderID = w.OrderID
join Warehouse wa on w.WarehouseID = wa.WarehouseID
group by Country
GO
/****** Object:  View [dbo].[vw_subdistributorstockbycategory]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_subdistributorstockbycategory] as
select c.Country, [Subdistributor ID], Product, count([Serial Number]) as [Products in Subdistributor Stock] from vw_ProductLife pl
join Subdistributor s on s.SubdistributorID = pl.[Subdistributor ID]
join Country c on s.Country = c.Country
group by c.Country, [Subdistributor ID], Product
GO
/****** Object:  View [dbo].[vw_channelstockbycategory]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_channelstockbycategory] as
select c.Country, [Channel Partner ID], Product, count([Serial Number]) as [Channel Partner Stock] from vw_ProductLife pl
join channel_partner cp on cp.ChannelID = pl.[Channel Partner ID]
join Country c on cp.Country = c.Country
group by c.Country, [Channel Partner ID], Product 
GO
/****** Object:  View [dbo].[vw_undelivered]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_undelivered] as
select SerialNo [Serial Number], Name [Product], Category [Type of Product], ManufactDate [Created on], ProductionHouseID [In Production House],
WarehouseID [Warehouse ID], WarehouseOrderID [Warehouse Order Number], wo.Ordered [Ordered by Warehouse], wo.Shipped [Shipped to Warehouse], wo.Received [Arrived at Warehouse],
DistributorID [Distributor ID], DistributorOrderID [Distributor Order Number], do.Ordered [Ordered by Distributor], do.Shipped [Shipped to Distributor], do.Received [Arrived to Distributor],
SubdistributorID [Subdistributor ID], SubdistributorOrderID [Subdistributor Order Number], so.Ordered [Ordered by Subdistributor], so.Shipped [Shipped to Subdistributor], so.Received [Arrived to Subdistributor],
ChannelID [Channel Partner ID], ChannelOrderID [Channel Partner Order Number], co.Ordered [Ordered by Channel Partner], co.Shipped [Shipped to Channel Partner], co.Received [Arrived to Channel Partner],
SellerID [Store ID], SellerOrderID [Store Order Number], ro.Ordered [Ordered by Store], ro.Shipped [Shipped to Store], ro.Received [Arrived at Store],
CustomerID [Customer ID], CustomerOrderID [Customer Order Number], cust.Ordered [Ordered by Customer], cust.Shipped [Shipped to Customer], cust.Received [Final Delivery to Customer]
from created_product cp
join product_info p on cp.ProductID = p.ProductID
join category c on p.CategoryID = c.CategoryID
join Warehouse_Order wo on cp.WarehouseOrderID = wo.OrderID
join Distributor_Order do on cp.DistributorOrderID = do.OrderID
join subdistributor_order so on cp.SubdistributorOrderID = so.OrderID
join Channel_Order co on cp.ChannelOrderID = co.OrderID
join Retail_Order ro on cp.SellerOrderID = ro.OrderID
join Customer_Order cust on cp.CustomerOrderID = cust.OrderID where cust.Received is null
GO
/****** Object:  View [dbo].[vw_warehouseorders]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_warehouseorders] as
select OrderID [Order Number], SerialNo [Serial Number], dbo.f_currency_convert(ph.Country, BasePrice) [Base Price], ISO_code [Currency], BasePrice [Base Price in USD]
from created_product c
join warehouse_order w on c.WarehouseOrderID = w.OrderID
join product_info p on c.ProductID = p.ProductID
join production_house ph on c.ProductionHouseID = ph.ProductionHouseID
join country co on ph.Country = co.Country
GO
/****** Object:  Table [dbo].[currency]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[currency](
	[ISO Code] [varchar](3) NOT NULL,
	[Currency] [varchar](50) NULL,
	[CurrentRate] [float] NULL,
 CONSTRAINT [PK_Currencies] PRIMARY KEY CLUSTERED 
(
	[ISO Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[zone]    Script Date: 2/3/2021 12:41:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[zone](
	[ZoneID] [int] IDENTITY(1,1) NOT NULL,
	[ChannelID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ZoneID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [ix_OrderID]    Script Date: 2/3/2021 12:41:56 AM ******/
CREATE NONCLUSTERED INDEX [ix_OrderID] ON [dbo].[channel_order]
(
	[OrderID] ASC
)
INCLUDE([ChannelID],[Ordered],[Shipped],[Received]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ix_customer_warehouse_order]    Script Date: 2/3/2021 12:41:56 AM ******/
CREATE NONCLUSTERED INDEX [ix_customer_warehouse_order] ON [dbo].[created_product]
(
	[SerialNo] ASC,
	[CustomerOrderID] ASC,
	[WarehouseOrderID] ASC
)
INCLUDE([ProductID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ix_orderids]    Script Date: 2/3/2021 12:41:56 AM ******/
CREATE NONCLUSTERED INDEX [ix_orderids] ON [dbo].[created_product]
(
	[SellerOrderID] ASC,
	[SerialNo] ASC,
	[WarehouseOrderID] ASC,
	[CustomerOrderID] ASC,
	[ChannelOrderID] ASC,
	[SubdistributorOrderID] ASC,
	[DistributorOrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ix_orderids2]    Script Date: 2/3/2021 12:41:56 AM ******/
CREATE NONCLUSTERED INDEX [ix_orderids2] ON [dbo].[created_product]
(
	[CustomerOrderID] ASC,
	[SerialNo] ASC,
	[WarehouseOrderID] ASC,
	[SellerOrderID] ASC,
	[ChannelOrderID] ASC,
	[SubdistributorOrderID] ASC,
	[DistributorOrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ix_orderids3]    Script Date: 2/3/2021 12:41:56 AM ******/
CREATE NONCLUSTERED INDEX [ix_orderids3] ON [dbo].[created_product]
(
	[WarehouseOrderID] ASC,
	[CustomerOrderID] ASC,
	[SellerOrderID] ASC,
	[ChannelOrderID] ASC,
	[SubdistributorOrderID] ASC,
	[DistributorOrderID] ASC,
	[SerialNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ix_orderids4]    Script Date: 2/3/2021 12:41:56 AM ******/
CREATE NONCLUSTERED INDEX [ix_orderids4] ON [dbo].[created_product]
(
	[DistributorOrderID] ASC,
	[SellerOrderID] ASC,
	[CustomerOrderID] ASC,
	[ChannelOrderID] ASC,
	[SubdistributorOrderID] ASC,
	[WarehouseOrderID] ASC,
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ix_orderids5]    Script Date: 2/3/2021 12:41:56 AM ******/
CREATE NONCLUSTERED INDEX [ix_orderids5] ON [dbo].[created_product]
(
	[DistributorOrderID] ASC,
	[SellerOrderID] ASC,
	[CustomerOrderID] ASC,
	[ChannelOrderID] ASC,
	[SubdistributorOrderID] ASC,
	[WarehouseOrderID] ASC,
	[ProductID] ASC
)
INCLUDE([SerialNo],[ProductionHouseID],[ManufactDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ix_orderids6]    Script Date: 2/3/2021 12:41:56 AM ******/
CREATE NONCLUSTERED INDEX [ix_orderids6] ON [dbo].[created_product]
(
	[SubdistributorOrderID] ASC,
	[SerialNo] ASC,
	[WarehouseOrderID] ASC,
	[CustomerOrderID] ASC,
	[SellerOrderID] ASC,
	[ChannelOrderID] ASC,
	[DistributorOrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ix_orderids7]    Script Date: 2/3/2021 12:41:56 AM ******/
CREATE NONCLUSTERED INDEX [ix_orderids7] ON [dbo].[created_product]
(
	[ChannelOrderID] ASC,
	[SerialNo] ASC,
	[WarehouseOrderID] ASC,
	[CustomerOrderID] ASC,
	[SellerOrderID] ASC,
	[SubdistributorOrderID] ASC,
	[DistributorOrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ix_production_house]    Script Date: 2/3/2021 12:41:56 AM ******/
CREATE NONCLUSTERED INDEX [ix_production_house] ON [dbo].[created_product]
(
	[ProductionHouseID] ASC
)
INCLUDE([ManufactCost]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ix_warehouse_customer_productid]    Script Date: 2/3/2021 12:41:56 AM ******/
CREATE NONCLUSTERED INDEX [ix_warehouse_customer_productid] ON [dbo].[created_product]
(
	[WarehouseOrderID] ASC,
	[ProductID] ASC,
	[SerialNo] ASC,
	[CustomerOrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ix_orderid]    Script Date: 2/3/2021 12:41:56 AM ******/
CREATE NONCLUSTERED INDEX [ix_orderid] ON [dbo].[customer_order]
(
	[OrderID] ASC
)
INCLUDE([CustomerID],[Ordered],[Shipped],[Received]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ix_orderid]    Script Date: 2/3/2021 12:41:56 AM ******/
CREATE NONCLUSTERED INDEX [ix_orderid] ON [dbo].[distributor_order]
(
	[OrderID] ASC
)
INCLUDE([DistributorID],[Ordered],[Shipped],[Received]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ix_orderid alone]    Script Date: 2/3/2021 12:41:56 AM ******/
CREATE NONCLUSTERED INDEX [ix_orderid alone] ON [dbo].[distributor_order]
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ix_orderid]    Script Date: 2/3/2021 12:41:56 AM ******/
CREATE NONCLUSTERED INDEX [ix_orderid] ON [dbo].[retail_order]
(
	[OrderID] ASC
)
INCLUDE([SellerID],[Ordered],[Shipped],[Received]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ix_orderid]    Script Date: 2/3/2021 12:41:56 AM ******/
CREATE NONCLUSTERED INDEX [ix_orderid] ON [dbo].[subdistributor_order]
(
	[OrderID] ASC
)
INCLUDE([SubdistributorID],[Ordered],[Shipped],[Received]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ix_orderid]    Script Date: 2/3/2021 12:41:56 AM ******/
CREATE NONCLUSTERED INDEX [ix_orderid] ON [dbo].[warehouse_order]
(
	[OrderID] ASC
)
INCLUDE([WarehouseID],[Ordered],[Shipped],[Received]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ix_important_customer_info]    Script Date: 2/3/2021 12:41:56 AM ******/
CREATE NONCLUSTERED COLUMNSTORE INDEX [ix_important_customer_info] ON [dbo].[customer]
(
	[CustomerID],
	[NationalID],
	[Country]
)WITH (DROP_EXISTING = OFF, COMPRESSION_DELAY = 0) ON [PRIMARY]
GO
/****** Object:  Index [ix_columnstore_orderid]    Script Date: 2/3/2021 12:41:56 AM ******/
CREATE NONCLUSTERED COLUMNSTORE INDEX [ix_columnstore_orderid] ON [dbo].[customer_order]
(
	[OrderID],
	[CustomerID],
	[TotalCost],
	[Ordered]
)WITH (DROP_EXISTING = OFF, COMPRESSION_DELAY = 0) ON [PRIMARY]
GO
ALTER TABLE [dbo].[channel_order] ADD  CONSTRAINT [DF__Channel_O__Order__73BA3083]  DEFAULT (getdate()) FOR [Ordered]
GO
ALTER TABLE [dbo].[customer_order] ADD  CONSTRAINT [DF__Customer___Order__7D439ABD]  DEFAULT (getdate()) FOR [Ordered]
GO
ALTER TABLE [dbo].[distributor_order] ADD  CONSTRAINT [DF__Distribut__Order__693CA210]  DEFAULT (getdate()) FOR [Ordered]
GO
ALTER TABLE [dbo].[retail_order] ADD  CONSTRAINT [DF__Retail_Or__Order__778AC167]  DEFAULT (getdate()) FOR [Ordered]
GO
ALTER TABLE [dbo].[subdistributor_order] ADD  CONSTRAINT [DF__Subdistri__Order__6D0D32F4]  DEFAULT (getdate()) FOR [Ordered]
GO
ALTER TABLE [dbo].[warehouse_order] ADD  CONSTRAINT [DF__Warehouse__Order__656C112C]  DEFAULT (getdate()) FOR [Ordered]
GO
ALTER TABLE [dbo].[channel_order]  WITH CHECK ADD  CONSTRAINT [FK__Channel_O__Chann__72C60C4A] FOREIGN KEY([ChannelID])
REFERENCES [dbo].[channel_partner] ([ChannelID])
GO
ALTER TABLE [dbo].[channel_order] CHECK CONSTRAINT [FK__Channel_O__Chann__72C60C4A]
GO
ALTER TABLE [dbo].[channel_partner]  WITH CHECK ADD  CONSTRAINT [FK_Channel_Partners_Countries] FOREIGN KEY([Country])
REFERENCES [dbo].[country] ([Country])
GO
ALTER TABLE [dbo].[channel_partner] CHECK CONSTRAINT [FK_Channel_Partners_Countries]
GO
ALTER TABLE [dbo].[country]  WITH CHECK ADD  CONSTRAINT [FK_Countries_Currencies] FOREIGN KEY([ISO_code])
REFERENCES [dbo].[currency] ([ISO Code])
GO
ALTER TABLE [dbo].[country] CHECK CONSTRAINT [FK_Countries_Currencies]
GO
ALTER TABLE [dbo].[created_product]  WITH CHECK ADD  CONSTRAINT [FK_Created_Products_Channel_Orders] FOREIGN KEY([ChannelOrderID])
REFERENCES [dbo].[channel_order] ([OrderID])
GO
ALTER TABLE [dbo].[created_product] CHECK CONSTRAINT [FK_Created_Products_Channel_Orders]
GO
ALTER TABLE [dbo].[created_product]  WITH CHECK ADD  CONSTRAINT [FK_Created_Products_Customer_Orders] FOREIGN KEY([CustomerOrderID])
REFERENCES [dbo].[customer_order] ([OrderID])
GO
ALTER TABLE [dbo].[created_product] CHECK CONSTRAINT [FK_Created_Products_Customer_Orders]
GO
ALTER TABLE [dbo].[created_product]  WITH CHECK ADD  CONSTRAINT [FK_Created_Products_Distributor_Orders] FOREIGN KEY([DistributorOrderID])
REFERENCES [dbo].[distributor_order] ([OrderID])
GO
ALTER TABLE [dbo].[created_product] CHECK CONSTRAINT [FK_Created_Products_Distributor_Orders]
GO
ALTER TABLE [dbo].[created_product]  WITH CHECK ADD  CONSTRAINT [FK_Created_Products_Product_Info] FOREIGN KEY([ProductID])
REFERENCES [dbo].[product_info] ([ProductID])
GO
ALTER TABLE [dbo].[created_product] CHECK CONSTRAINT [FK_Created_Products_Product_Info]
GO
ALTER TABLE [dbo].[created_product]  WITH CHECK ADD  CONSTRAINT [FK_Created_Products_Production_House] FOREIGN KEY([ProductionHouseID])
REFERENCES [dbo].[production_house] ([ProductionHouseID])
GO
ALTER TABLE [dbo].[created_product] CHECK CONSTRAINT [FK_Created_Products_Production_House]
GO
ALTER TABLE [dbo].[created_product]  WITH CHECK ADD  CONSTRAINT [FK_Created_Products_Retail_Orders] FOREIGN KEY([SellerOrderID])
REFERENCES [dbo].[retail_order] ([OrderID])
GO
ALTER TABLE [dbo].[created_product] CHECK CONSTRAINT [FK_Created_Products_Retail_Orders]
GO
ALTER TABLE [dbo].[created_product]  WITH CHECK ADD  CONSTRAINT [FK_Created_Products_Subdistributor_Orders] FOREIGN KEY([SubdistributorOrderID])
REFERENCES [dbo].[subdistributor_order] ([OrderID])
GO
ALTER TABLE [dbo].[created_product] CHECK CONSTRAINT [FK_Created_Products_Subdistributor_Orders]
GO
ALTER TABLE [dbo].[created_product]  WITH CHECK ADD  CONSTRAINT [FK_Created_Products_Warehouse_Orders] FOREIGN KEY([WarehouseOrderID])
REFERENCES [dbo].[warehouse_order] ([OrderID])
GO
ALTER TABLE [dbo].[created_product] CHECK CONSTRAINT [FK_Created_Products_Warehouse_Orders]
GO
ALTER TABLE [dbo].[customer]  WITH CHECK ADD  CONSTRAINT [FK_Customers_Countries] FOREIGN KEY([Country])
REFERENCES [dbo].[country] ([Country])
GO
ALTER TABLE [dbo].[customer] CHECK CONSTRAINT [FK_Customers_Countries]
GO
ALTER TABLE [dbo].[customer_order]  WITH CHECK ADD  CONSTRAINT [FK__Customer___Custo__7C4F7684] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[customer] ([CustomerID])
GO
ALTER TABLE [dbo].[customer_order] CHECK CONSTRAINT [FK__Customer___Custo__7C4F7684]
GO
ALTER TABLE [dbo].[distributor]  WITH CHECK ADD  CONSTRAINT [FK_Distributors_Countries] FOREIGN KEY([Country])
REFERENCES [dbo].[country] ([Country])
GO
ALTER TABLE [dbo].[distributor] CHECK CONSTRAINT [FK_Distributors_Countries]
GO
ALTER TABLE [dbo].[distributor_order]  WITH CHECK ADD  CONSTRAINT [FK__Distribut__Distr__68487DD7] FOREIGN KEY([DistributorID])
REFERENCES [dbo].[distributor] ([DistributorID])
GO
ALTER TABLE [dbo].[distributor_order] CHECK CONSTRAINT [FK__Distribut__Distr__68487DD7]
GO
ALTER TABLE [dbo].[product_info]  WITH CHECK ADD  CONSTRAINT [FK_product_info_category] FOREIGN KEY([CategoryID])
REFERENCES [dbo].[category] ([CategoryID])
GO
ALTER TABLE [dbo].[product_info] CHECK CONSTRAINT [FK_product_info_category]
GO
ALTER TABLE [dbo].[product_return]  WITH CHECK ADD  CONSTRAINT [FK__Returns__SerialN__02FC7413] FOREIGN KEY([SerialNo])
REFERENCES [dbo].[created_product] ([SerialNo])
GO
ALTER TABLE [dbo].[product_return] CHECK CONSTRAINT [FK__Returns__SerialN__02FC7413]
GO
ALTER TABLE [dbo].[production_house]  WITH CHECK ADD  CONSTRAINT [FK_Production_House_Countries] FOREIGN KEY([Country])
REFERENCES [dbo].[country] ([Country])
GO
ALTER TABLE [dbo].[production_house] CHECK CONSTRAINT [FK_Production_House_Countries]
GO
ALTER TABLE [dbo].[retail_order]  WITH CHECK ADD  CONSTRAINT [FK__Retail_Or__Selle__76969D2E] FOREIGN KEY([SellerID])
REFERENCES [dbo].[retail_seller] ([SellerID])
GO
ALTER TABLE [dbo].[retail_order] CHECK CONSTRAINT [FK__Retail_Or__Selle__76969D2E]
GO
ALTER TABLE [dbo].[retail_seller]  WITH CHECK ADD  CONSTRAINT [FK__Retail_Se__ZoneI__47DBAE45] FOREIGN KEY([ZoneID])
REFERENCES [dbo].[zone] ([ZoneID])
GO
ALTER TABLE [dbo].[retail_seller] CHECK CONSTRAINT [FK__Retail_Se__ZoneI__47DBAE45]
GO
ALTER TABLE [dbo].[retail_seller]  WITH CHECK ADD  CONSTRAINT [FK_Retail_Sellers_Countries] FOREIGN KEY([Country])
REFERENCES [dbo].[country] ([Country])
GO
ALTER TABLE [dbo].[retail_seller] CHECK CONSTRAINT [FK_Retail_Sellers_Countries]
GO
ALTER TABLE [dbo].[subdistributor]  WITH CHECK ADD  CONSTRAINT [FK_Subdistributors_Countries] FOREIGN KEY([Country])
REFERENCES [dbo].[country] ([Country])
GO
ALTER TABLE [dbo].[subdistributor] CHECK CONSTRAINT [FK_Subdistributors_Countries]
GO
ALTER TABLE [dbo].[subdistributor_order]  WITH CHECK ADD  CONSTRAINT [FK__Subdistri__Wareh__6C190EBB] FOREIGN KEY([SubdistributorID])
REFERENCES [dbo].[subdistributor] ([SubdistributorID])
GO
ALTER TABLE [dbo].[subdistributor_order] CHECK CONSTRAINT [FK__Subdistri__Wareh__6C190EBB]
GO
ALTER TABLE [dbo].[warehouse]  WITH CHECK ADD  CONSTRAINT [FK_Warehouses_Countries] FOREIGN KEY([Country])
REFERENCES [dbo].[country] ([Country])
GO
ALTER TABLE [dbo].[warehouse] CHECK CONSTRAINT [FK_Warehouses_Countries]
GO
ALTER TABLE [dbo].[warehouse_order]  WITH CHECK ADD  CONSTRAINT [FK__Warehouse__Wareh__6477ECF3] FOREIGN KEY([WarehouseID])
REFERENCES [dbo].[warehouse] ([WarehouseID])
GO
ALTER TABLE [dbo].[warehouse_order] CHECK CONSTRAINT [FK__Warehouse__Wareh__6477ECF3]
GO
ALTER TABLE [dbo].[zone]  WITH CHECK ADD  CONSTRAINT [FK__Zones__ChannelID__44FF419A] FOREIGN KEY([ChannelID])
REFERENCES [dbo].[channel_partner] ([ChannelID])
GO
ALTER TABLE [dbo].[zone] CHECK CONSTRAINT [FK__Zones__ChannelID__44FF419A]
GO
/****** Object:  StoredProcedure [dbo].[f_channel_creation]    Script Date: 2/3/2021 12:41:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[f_channel_creation] @country varchar(35), @qty int
as
begin
	declare @cono int = 0
	while @cono < @qty
	begin
		select @cono = @cono + 1
		insert into channel_partner values(@country)
	end
end
GO
/****** Object:  StoredProcedure [dbo].[f_channel_order]    Script Date: 2/3/2021 12:41:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[f_channel_order] @cid int = null, @pid int = null, @qty int
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
GO
/****** Object:  StoredProcedure [dbo].[f_channel_received]    Script Date: 2/3/2021 12:41:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[f_channel_received]
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
GO
/****** Object:  StoredProcedure [dbo].[f_channel_shipped]    Script Date: 2/3/2021 12:41:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[f_channel_shipped]
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
GO
/****** Object:  StoredProcedure [dbo].[f_customer_creation]    Script Date: 2/3/2021 12:41:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[f_customer_creation]
@nationalid varchar(18) = null,
@country varchar(35) = null,
@name varchar(30) = null,
@phone varchar(20) = null,
@email varchar(40) = null,
@qty int = null
as
begin
	declare @cono int = 0
	if @nationalid is null
	begin
		set @nationalid = LEFT(NEWID(), 18)
	end
	if @qty is null
	begin
		if @country = null
		begin
			set @country = (select top 1 Country from country order by NEWID())
		end
		insert into customer values(@nationalid, @country, @name, @phone, @email)
	end
	else
	while @cono < @qty
	begin
		if @country = null
		begin
			set @country = (select top 1 Country from country order by NEWID())
		end
		select @cono = @cono + 1
		insert into customer values(@nationalid, @country, @name, @phone, @email)
	end
end
GO
/****** Object:  StoredProcedure [dbo].[f_customer_order]    Script Date: 2/3/2021 12:41:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[f_customer_order] @custid int = null, @pid int = null, @qty int
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
GO
/****** Object:  StoredProcedure [dbo].[f_customer_received]    Script Date: 2/3/2021 12:41:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[f_customer_received]
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
GO
/****** Object:  StoredProcedure [dbo].[f_customer_shipped]    Script Date: 2/3/2021 12:41:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[f_customer_shipped]
as
begin
	declare @cono int = 0
	declare @ord int = (select count(OrderID) from customer_order where ordered is not null and shipped is null)
	select @ord = @ord * 0.9
	while @cono < @ord
	begin
		select @cono = @cono + 1
		declare @orderid int = (select top 1 OrderID from customer_order where Shipped IS NULL and Ordered IS NOT NULL order by NEWID())
		update customer_order set Shipped = dateadd(hour, RAND()*100, Ordered) where OrderID = @orderid
	end
end
GO
/****** Object:  StoredProcedure [dbo].[f_distributor_creation]    Script Date: 2/3/2021 12:41:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[f_distributor_creation] @country varchar(35), @qty int
as
begin
	declare @cono int = 0
	while @cono < @qty
	begin
		select @cono = @cono + 1
		insert into distributor values(@country)
	end
end
GO
/****** Object:  StoredProcedure [dbo].[f_distributor_order]    Script Date: 2/3/2021 12:41:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[f_distributor_order] @did int = null, @pid int = null, @qty int
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
GO
/****** Object:  StoredProcedure [dbo].[f_distributor_received]    Script Date: 2/3/2021 12:41:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[f_distributor_received]
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
GO
/****** Object:  StoredProcedure [dbo].[f_distributor_shipped]    Script Date: 2/3/2021 12:41:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[f_distributor_shipped]
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
GO
/****** Object:  StoredProcedure [dbo].[f_new_product]    Script Date: 2/3/2021 12:41:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[f_new_product] @name varchar(25), @description varchar(50) = null, @category int, @price numeric(18,2) = null
as
begin
	if @price is null
	begin
	set @price = RAND() * 200 + 100
	end
	insert into product_info values(@name, @description, @price, @category)
end
GO
/****** Object:  StoredProcedure [dbo].[f_retail_creation]    Script Date: 2/3/2021 12:41:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[f_retail_creation] @zone int, @qty int
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
GO
/****** Object:  StoredProcedure [dbo].[f_returns]    Script Date: 2/3/2021 12:41:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[f_returns] @sno int = null, @reason varchar(80) = null
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
GO
/****** Object:  StoredProcedure [dbo].[f_seller_order]    Script Date: 2/3/2021 12:41:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[f_seller_order] @rid int = null, @pid int = null, @qty int
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
GO
/****** Object:  StoredProcedure [dbo].[f_seller_received]    Script Date: 2/3/2021 12:41:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[f_seller_received]
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
GO
/****** Object:  StoredProcedure [dbo].[f_seller_shipped]    Script Date: 2/3/2021 12:41:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[f_seller_shipped]
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
GO
/****** Object:  StoredProcedure [dbo].[f_subdistributor_creation]    Script Date: 2/3/2021 12:41:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[f_subdistributor_creation] @country varchar(35), @qty int
as
begin
	declare @cono int = 0
	while @cono < @qty
	begin
		select @cono = @cono + 1
		insert into subdistributor values(@country)
	end
end
GO
/****** Object:  StoredProcedure [dbo].[f_subdistributor_order]    Script Date: 2/3/2021 12:41:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[f_subdistributor_order] @sid int = null, @pid int = null, @qty int
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
GO
/****** Object:  StoredProcedure [dbo].[f_subdistributor_received]    Script Date: 2/3/2021 12:41:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[f_subdistributor_received]
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
GO
/****** Object:  StoredProcedure [dbo].[f_subdistributor_shipped]    Script Date: 2/3/2021 12:41:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[f_subdistributor_shipped]
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
GO
/****** Object:  StoredProcedure [dbo].[f_warehouse_creation]    Script Date: 2/3/2021 12:41:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[f_warehouse_creation] @country varchar(35), @qty int
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
GO
/****** Object:  StoredProcedure [dbo].[f_warehouse_order]    Script Date: 2/3/2021 12:41:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[f_warehouse_order] @wid int = null, @pid int = null, @qty int
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
						where ProductID = @prodid and Continent = @cont and WarehouseOrderID is null and CustomerOrderID is null)
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
							where ProductID = @prodid and Continent = @cont and WarehouseOrderID is null and CustomerOrderID is null
							order by ManufactDate desc)
		update created_product set WarehouseOrderID = @orderid where SerialNo = @sno
	end
end
GO
/****** Object:  StoredProcedure [dbo].[f_warehouse_received]    Script Date: 2/3/2021 12:41:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[f_warehouse_received]
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
GO
/****** Object:  StoredProcedure [dbo].[f_warehouse_shipped]    Script Date: 2/3/2021 12:41:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[f_warehouse_shipped]
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
GO
/****** Object:  StoredProcedure [dbo].[f_zone_creation]    Script Date: 2/3/2021 12:41:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[f_zone_creation] @channel int, @qty int
as
begin
	declare @cono int = 0
	while @cono < @qty
	begin
		select @cono = @cono + 1
		insert into zone values(@channel)
	end
end
GO
/****** Object:  StoredProcedure [dbo].[p_product_creation]    Script Date: 2/3/2021 12:41:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[p_product_creation] @productid as int = null, @qty as int, @prodhouseid as int = null
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
GO
USE [master]
GO
ALTER DATABASE [ProjectOneDB] SET  READ_WRITE 
GO
