-- =============================================
-- Krystian
-- Byrgiel
-- 230665
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================

--Wszystko dzia³a

-- =============================================
-- Zadanie 2
-- =============================================
DECLARE @Litera char(1) = 'K'
DECLARE @Cyfra int = 5

SELECT CustomerID, FirstName, LastName 
FROM SalesLT.Customer
WHERE LastName like @Litera + '%' AND CustomerID % 10 = @Cyfra;

GO
-- =============================================
-- Zadanie 3
-- =============================================

DECLARE @Produkty TABLE (
ProductID int,
Name nvarchar(50),
ListPrice money)

INSERT INTO @Produkty
SELECT ProductID, Name, ListPrice
FROM SalesLT.Product
WHERE Name like '%K%'

SELECT *
FROM @Produkty

GO
-- =============================================
-- Zadanie 4
-- =============================================

CREATE TABLE #KlienciMiasta (
CustomerID int PRIMARY KEY,
FirstName nvarchar(30),
LastName nvarchar(30),
City nvarchar(50))

INSERT INTO #KlienciMiasta
SELECT c.CustomerID, c.FirstName, c.LastName, a.City
FROM SalesLT.Customer c JOIN SalesLT.CustomerAddress ca ON c.CustomerID = ca.CustomerID JOIN SalesLT.Address a ON ca.AddressID = a.AddressID
WHERE a.City like 'K%'

SELECT *
FROM #KlienciMiasta;

DROP TABLE #KlienciMiasta;

GO
-- =============================================
-- Zadanie 5
-- =============================================
CREATE SCHEMA Student_665 AUTHORIZATION dbo

GO

CREATE TABLE Student_665.ProduktyK (
ProductID INT PRIMARY KEY,
Name nvarchar(100),
Category nvarchar(100),
ListPrice money)

INSERT INTO Student_665.ProduktyK (ProductID, Name, Category, ListPrice)
SELECT ProductID, p.Name, pc.Name as Category, ListPrice
FROM SalesLT.Product p JOIN SalesLT.ProductCategory pc ON p.ProductCategoryID = pc.ProductCategoryID
WHERE pc.Name like '%K%'

GO

-- =============================================
-- Zadanie 6
-- =============================================

DECLARE @Podsumowanie TABLE (
Category nvarchar(100),
SredniaCena money)

INSERT INTO @Podsumowanie (Category, SredniaCena)
SELECT pc.Name as Category, AVG(p.ListPrice) as SredniaCena
FROM SalesLT.ProductCategory pc JOIN SalesLT.Product p ON pc.ProductCategoryID = p.ProductCategoryID
WHERE pc.ProductCategoryID % 10 = 5
GROUP BY pc.Name;

SELECT * FROM @Podsumowanie

GO

-- =============================================
-- Zadanie 7
-- =============================================

CREATE SCHEMA [230665] AUTHORIZATION dbo;

GO

ALTER SCHEMA [230665] TRANSFER SalesLT.Customer;
ALTER SCHEMA [230665] TRANSFER SalesLT.CustomerAddress;
