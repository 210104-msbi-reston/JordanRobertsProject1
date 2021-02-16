# Project 1 - Apple, Inc.
## Project Description
A robust, product-focused database structured for the recording of all aspects of an international technology company.

## Technologies Used
SQL Server Management Server

## Features
- Includes useful views and functions set up to store, add, and remove data as needed.
- Populated with over 1 million individual products located in each aspect of the supply chain.
- Full data for each product including returns, current location, and dates of movements between supply chain nodes.

## To-do list:
- Consolidation of stored procedures into a single procedure for performance improvement.

## Getting Started
Required Software: Microsoft SQL Server Management Studio

### Steps to pulling repo to a directory
- Create a directory that will store the project data
- Locate the directory in Git Bash
- Type git init and press Enter
- Type git pull https://github.com/210104-msbi-reston/JordanRobertsProject1.git
- Open Microsoft SQL Server Management Studio
- Go to File > Open
- Execute the SQL Scripts to create tables and procedures

## Usage
### Stored Procedures
- f_{entity}_creation
- f_{entity}_order
- f_{entity}_received
- f_{entity}_shipped
*Entities can be any of "Seller", "Subdistributor", "Channel", "Distributor", "Customer", "Warehouse". Each function either creates a new instance of the entity, creates a new order for products for the entity, or creates a shipping/receiving event for products ordered.*
- f_new_product
- p_product_creation
- f_returns

### Views
- vw_allproducts
- vw_customers
- vw_returns
- vw_TotalRevenue
- vw_ProductLife
- vw_ProductLifeWithReturn
- vw_ProductionCosts
- vw_returnreplace
