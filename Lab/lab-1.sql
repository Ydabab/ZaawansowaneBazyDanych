-- =============================================
-- Krystian
-- Byrgiel
-- 230665
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================

SELECT * 
FROM SalesLT.Customer 
WHERE LastName like 'K%';

-- =============================================
-- Zadanie 2
-- =============================================

SELECT FirstName, LastName, EmailAddress 
FROM SalesLT.Customer 
WHERE CustomerID like '%5';

-- =============================================
-- Zadanie 3
-- =============================================

SELECT Name, ListPrice, ProductNumber 
FROM SalesLT.Product 
WHERE Name like '%K%' 
ORDER BY ListPrice desc;

-- =============================================
-- Zadanie 4
-- =============================================

SELECT p.ProductCategoryID, AVG(p.ListPrice) AS AvgPrice
FROM SalesLT.Product p
WHERE ProductCategoryID % 10 = 5
GROUP BY p.ProductCategoryID

-- =============================================
-- Zadanie 5
-- =============================================

SELECT DISTINCT City
FROM SalesLT.CustomerAddress ca
JOIN SalesLT.Address a ON ca.AddressID = a.AddressID
WHERE City like 'K%';

-- =============================================
-- Zadanie 6
-- =============================================

INSERT INTO SalesLT.Customer 
    (NameStyle, FirstName, LastName, CompanyName, EmailAddress, Phone, PasswordHash, PasswordSalt, rowguid, ModifiedDate)
VALUES
    (0, 'Krystian', 'Byrgiel', 'Lab5', 'krystian.byrgiel@lab5.com', '555-123-4567',
     'HASHEDPASSWORD', 'SALT', NEWID(), GETDATE());

SELECT *
FROM SalesLT.Customer
WHERE FirstName = 'Krystian' AND LastName = 'Byrgiel' AND CompanyName = 'Lab5' AND EmailAddress = 'krystian.byrgiel@lab5.com';

-- =============================================
-- Zadanie 7
-- =============================================

INSERT INTO SalesLT.ProductCategory (ParentProductCategoryID, Name, rowguid, ModifiedDate)
VALUES
    (NULL, 'Special-K', NEWID(), GETDATE()),
    (NULL, 'Extra-5', NEWID(), GETDATE());

-- =============================================
-- Zadanie 8
-- =============================================

SELECT 230665 as OwnerID, p.Name, ProductNumber, pc.Name as Category
INTO ProductsCategoriesY
FROM SalesLT.Product p
JOIN SalesLT.ProductCategory pc ON p.ProductCategoryID = pc.ProductCategoryID
WHERE p.Name LIKE 'K%K' OR pc.Name like '%K%'

-- =============================================
-- Zadanie 9
-- =============================================

SELECT Category, COUNT(Category) AS Ilo  Produkt w
FROM ProductsCategoriesY
GROUP BY Category