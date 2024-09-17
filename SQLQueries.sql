SELECT 
    SUM((sod.UnitPrice - p.StandardCost) * sod.OrderQty) AS TotalProfit
FROM 
    Sales.SalesOrderDetail sod
JOIN 
    Production.Product p ON sod.ProductID = p.ProductID;

--Total Sales

SELECT 
    SUM(sod.LineTotal) AS TotalSales
FROM 
    Sales.SalesOrderDetail sod;

--Total profit percent

SELECT 
    SUM(sod.UnitPrice * sod.OrderQty) AS TotalSales,
    SUM(p.StandardCost * sod.OrderQty) AS TotalCost,
    SUM((sod.UnitPrice - p.StandardCost) * sod.OrderQty) AS TotalProfit,
    (SUM((sod.UnitPrice - p.StandardCost) * sod.OrderQty) / SUM(sod.UnitPrice * sod.OrderQty)) * 100 AS ProfitPercent
FROM 
    Sales.SalesOrderDetail sod
JOIN 
    Production.Product p ON sod.ProductID = p.ProductID;

-- All of this

SELECT 
    SUM(sod.LineTotal) AS TotalSales,  -- Total Sales
    SUM((sod.UnitPrice - p.StandardCost) * sod.OrderQty) AS TotalProfit,  -- Total Profit
    (SUM((sod.UnitPrice - p.StandardCost) * sod.OrderQty) / SUM(sod.LineTotal)) * 100 AS ProfitPercent -- Profit Percent
FROM 
    Sales.SalesOrderDetail sod
JOIN 
    Production.Product p ON sod.ProductID = p.ProductID;


-- Profit percent for each product
SELECT 
    p.Name AS ProductName,
    SUM((sod.UnitPrice - p.StandardCost) * sod.OrderQty) AS TotalProfit,
    SUM(sod.UnitPrice * sod.OrderQty) AS TotalSales,
    CASE 
        WHEN SUM(sod.UnitPrice * sod.OrderQty) > 0 
        THEN (SUM((sod.UnitPrice - p.StandardCost) * sod.OrderQty) / SUM(sod.UnitPrice * sod.OrderQty)) * 100
        ELSE 0
    END AS ProfitPercent
FROM 
    Sales.SalesOrderDetail sod
JOIN 
    Production.Product p ON sod.ProductID = p.ProductID
GROUP BY 
    p.Name
ORDER BY 
    ProfitPercent DESC;



-- Total sales per product

SELECT 
    p.Name AS ProductName, 
    pc.Name AS CategoryName,
    SUM(sod.OrderQty) AS TotalQuantitySold, 
    SUM(sod.UnitPrice * sod.OrderQty) AS TotalRevenue
FROM 
    Sales.SalesOrderDetail sod
JOIN 
    Production.Product p ON sod.ProductID = p.ProductID
JOIN 
    Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN 
    Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY 
    p.Name, pc.Name
ORDER BY 
    TotalRevenue DESC;


-- Inventory Levels per Product

SELECT 
    p.Name AS ProductName, 
    SUM(pi.Quantity) AS TotalInStock
FROM 
    Production.ProductInventory pi
JOIN 
    Production.Product p ON pi.ProductID = p.ProductID
GROUP BY 
    p.Name
ORDER BY 
    TotalInStock DESC;


-- Top sold product

SELECT 
    TOP 1 p.Name AS ProductName,           -- Product Name
    SUM(sod.OrderQty) AS TotalQuantitySold -- Total Quantity Sold
FROM 
    Sales.SalesOrderDetail sod
JOIN 
    Production.Product p ON sod.ProductID = p.ProductID
GROUP BY 
    p.Name
ORDER BY 
    TotalQuantitySold DESC;


SELECT 
    p.Name AS ProductName,           
    SUM(sod.OrderQty) AS TotalQuantitySold 
FROM 
    Sales.SalesOrderDetail sod
JOIN 
    Production.Product p ON sod.ProductID = p.ProductID
GROUP BY 
    p.Name
ORDER BY 
    TotalQuantitySold DESC;

-- Category

SELECT *
FROM [Production].[ProductCategory]

-- Top Category 

SELECT 
    pc.Name AS CategoryName,                          
    SUM(sod.LineTotal) AS TotalSales                  
FROM 
    Sales.SalesOrderDetail sod
JOIN 
    Production.Product p ON sod.ProductID = p.ProductID
JOIN 
    Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN 
    Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY 
    pc.Name
ORDER BY 
    TotalSales DESC;


SELECT 
    pc.Name AS CategoryName,                          
    SUM(sod.OrderQty) AS TotalQuantitySold                  
FROM 
    Sales.SalesOrderDetail sod
JOIN 
    Production.Product p ON sod.ProductID = p.ProductID
JOIN 
    Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN 
    Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY 
    pc.Name
ORDER BY 
    TotalQuantitySold DESC;

-- profit to each country

SELECT 
    cr.Name AS Country,                                           -- Country Name
    SUM((sod.UnitPrice - p.StandardCost) * sod.OrderQty) AS TotalProfit  -- Total Profit
FROM 
    Sales.SalesOrderDetail sod
JOIN 
    Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID   -- Join Sales Header to get order info
JOIN 
    Person.Address a ON soh.ShipToAddressID = a.AddressID               -- Join with Address table for the shipping address
JOIN 
    Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID   -- Join with StateProvince to get region info
JOIN 
    Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode -- Join with CountryRegion to get country
JOIN 
    Production.Product p ON sod.ProductID = p.ProductID                 -- Join with Product to get cost info
GROUP BY 
    cr.Name
ORDER BY 
    TotalProfit DESC;


-- profit for each product

SELECT 
    pm.Name AS ProductModel,                                  -- Product Model Name
    SUM((sod.UnitPrice - p.StandardCost) * sod.OrderQty) AS TotalProfit  -- Total Profit
FROM 
    Sales.SalesOrderDetail sod
JOIN 
    Production.Product p ON sod.ProductID = p.ProductID              -- Join with Product to get cost and product model
JOIN 
    Production.ProductModel pm ON p.ProductModelID = pm.ProductModelID -- Join with ProductModel to get model name
GROUP BY 
    pm.Name
ORDER BY 
    TotalProfit DESC


-- profit for each product and each country

SELECT 
    pm.Name AS ProductModel,                                    -- Product Model Name
    cr.Name AS Country,                                         -- Country Name
    SUM((sod.UnitPrice - p.StandardCost) * sod.OrderQty) AS TotalProfit  -- Total Profit
FROM 
    Sales.SalesOrderDetail sod
JOIN 
    Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID   -- Join Sales Header to get order info
JOIN 
    Person.Address a ON soh.ShipToAddressID = a.AddressID               -- Join with Address table for the shipping address
JOIN 
    Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID   -- Join with StateProvince to get region info
JOIN 
    Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode -- Join with CountryRegion to get country
JOIN 
    Production.Product p ON sod.ProductID = p.ProductID                 -- Join with Product to get product and cost info
JOIN 
    Production.ProductModel pm ON p.ProductModelID = pm.ProductModelID   -- Join with ProductModel to get model name
GROUP BY 
    pm.Name, cr.Name
ORDER BY 
    TotalProfit DESC;


-- Top 5 Best-selling product

SELECT 
    TOP 5 p.Name AS ProductName, 
    SUM(sod.OrderQty) AS TotalQuantitySold
FROM 
    Sales.SalesOrderDetail sod
JOIN 
    Production.Product p ON sod.ProductID = p.ProductID
GROUP BY 
    p.Name
ORDER BY 
    TotalQuantitySold DESC;


-- Total cost for each product model

SELECT 
    pm.Name AS ProductModel,                                      -- Product Model Name
    SUM(p.StandardCost * sod.OrderQty) AS TotalCost               -- Total Cost
FROM 
    Sales.SalesOrderDetail sod
JOIN 
    Production.Product p ON sod.ProductID = p.ProductID           -- Join with Product to get cost and model info
JOIN 
    Production.ProductModel pm ON p.ProductModelID = pm.ProductModelID -- Join with ProductModel to get model name
GROUP BY 
    pm.Name
ORDER BY 
    TotalCost DESC;


-- Average cost for each product model

SELECT 
    pm.Name AS ProductModel,                                   -- Product Model Name
    AVG(p.StandardCost) AS AverageCost                         -- Average Cost for the Model
FROM 
    Production.Product p
JOIN 
    Production.ProductModel pm ON p.ProductModelID = pm.ProductModelID  -- Join with ProductModel to get model name
GROUP BY 
    pm.Name
ORDER BY 
    AverageCost DESC;


SELECT *
FROM [Production].[Product]

-- MakeFlag

SELECT 
    COUNT(*)
FROM 
    Production.Product
WHERE 
    MakeFlag = 1;

SELECT 
    COUNT(*)
FROM 
    Production.Product
WHERE 
    MakeFlag = 0;


SELECT 
    ProductID, 
    Name, 
    MakeFlag
FROM 
    Production.Product
WHERE 
    MakeFlag = 1;

SELECT 
    pc.Name AS CategoryName,                                   -- Product Category Name
    COUNT(p.ProductID) AS ManufacturedProductsCount            -- Count of Manufactured Products
FROM 
    Production.Product p
JOIN 
    Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID -- Join with ProductSubcategory
JOIN 
    Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID         -- Join with ProductCategory
WHERE 
    p.MakeFlag = 1                                             -- Only select products manufactured in-house
GROUP BY 
    pc.Name
ORDER BY 
    ManufacturedProductsCount DESC;

SELECT 
    pc.Name AS CategoryName,                                   -- Product Category Name
    COUNT(p.ProductID) AS ManufacturedProductsCount            -- Count of Manufactured Products
FROM 
    Production.Product p
JOIN 
    Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID -- Join with ProductSubcategory
JOIN 
    Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID         -- Join with ProductCategory
WHERE 
    p.MakeFlag = 0                                            -- Only select products manufactured in-house
GROUP BY 
    pc.Name
ORDER BY 
    ManufacturedProductsCount DESC;

SELECT 
    pm.Name AS ProductModel,                                   -- Product Model Name
    COUNT(p.ProductID) AS ManufacturedProductsCount            -- Count of Manufactured Products
FROM 
    Production.Product p
JOIN 
    Production.ProductModel pm ON p.ProductModelID = pm.ProductModelID -- Join with ProductModel to get model name
WHERE 
    p.MakeFlag = 1                                             -- Only select products manufactured in-house
GROUP BY 
    pm.Name
ORDER BY 
    ManufacturedProductsCount DESC;

SELECT 
    YEAR(soh.OrderDate) AS Year,                               -- Extract the year from the order date
    COUNT(sod.ProductID) AS ManufacturedProductsCount          -- Count of manufactured products sold
FROM 
    Sales.SalesOrderDetail sod
JOIN 
    Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID  -- Join to get the order date
JOIN 
    Production.Product p ON sod.ProductID = p.ProductID               -- Join with Product to get MakeFlag
WHERE 
    p.MakeFlag = 1                                                    -- Only select manufactured (in-house) products
GROUP BY 
    YEAR(soh.OrderDate)
ORDER BY 
    Year ASC;


--Customers to each country

SELECT 
    st.Name AS Country,              -- Country/Region of the customer
    COUNT(c.CustomerID) AS TotalCustomers -- Total number of customers in that country/region
FROM 
    Sales.Customer c
JOIN 
    Person.BusinessEntityAddress bea ON c.CustomerID = bea.BusinessEntityID  -- Link to BusinessEntity
JOIN 
    Person.Address a ON bea.AddressID = a.AddressID                         -- Link to Address
JOIN 
    Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID        -- Link to State/Province
JOIN 
    Sales.SalesTerritory st ON sp.TerritoryID = st.TerritoryID               -- Link to Territory (which has country/region data)
GROUP BY 
    st.Name
ORDER BY 
    TotalCustomers DESC;                -- Sort by number of customers
     

-- shipping each country

SELECT 
    st.Name AS Country,              -- Country/Region
    COUNT(soh.SalesOrderID) AS TotalShipments -- Total number of shipments (sales orders)
FROM 
    Sales.SalesOrderHeader soh
JOIN 
    Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID  -- Link to the country/region (territory)
GROUP BY 
    st.Name                            -- Group by country/region
ORDER BY 
    TotalShipments DESC; 

-- New table for modeling

SELECT 
    soh.TotalDue,                       -- Dependent variable
    soh.SubTotal,                       -- Independent variable
    soh.TaxAmt,                         -- Independent variable
    soh.Freight,                        -- Independent variable
    sod.OrderQty,                       -- Independent variable
    sod.UnitPrice,                      -- Independent variable
    soh.ShipMethodID,                   -- Categorical variable
    st.TerritoryID,                     -- Sales Territory
    soh.CustomerID,                     -- Categorical variable
    soh.OrderDate                       -- For potential trend analysis
FROM 
    Sales.SalesOrderHeader soh
JOIN 
    Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN 
    Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID;
