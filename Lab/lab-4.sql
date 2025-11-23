-- =============================================
-- Krystian
-- Byrgiel
-- 230665
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================

--Nie mo¿na by³o stworzyæ widoku korzystaj¹c ze zmiennej wiêc zrobi³em w ten sposób

CREATE TABLE dbo.ProductPricePlanData
(
    ProductID INT PRIMARY KEY,
    NewPrice MONEY
);

DECLARE @ProductInfo NVARCHAR(MAX) = N'
[
    {"ProductID": 706, "NewPrice": 1499.99},
    {"ProductID": 707, "NewPrice": 39.99},
    {"ProductID": 708, "NewPrice": 89.90},
    {"ProductID": 709, "NewPrice": 7.49},
    {"ProductID": 710, "NewPrice": 299.00}
]';

INSERT INTO dbo.ProductPricePlanData(ProductID, NewPrice)
SELECT ProductID, NewPrice
FROM OPENJSON(@ProductInfo)
WITH (
    ProductID INT,
    NewPrice  MONEY
);

GO

CREATE VIEW dbo.ProductPricePlan AS
SELECT
    p.ProductID,
    p.Name,
    p.ListPrice AS CurrentPrice,
    d.NewPrice AS PlannedPrice
FROM SalesLT.Product p
LEFT JOIN dbo.ProductPricePlanData d
    ON p.ProductID = d.ProductID;

GO

-- =============================================
-- Zadanie 2
-- =============================================


CREATE VIEW Student_665.TheBestCustomers AS
SELECT TOP 10
    c.CustomerID,
    c.FirstName,
    c.LastName,
    SUM(od.LineTotal) AS TotalSpent
FROM [230665].Customer c
JOIN SalesLT.SalesOrderHeader oh 
    ON c.CustomerID = oh.CustomerID
JOIN SalesLT.SalesOrderDetail od
    ON oh.SalesOrderID = od.SalesOrderID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY SUM(od.LineTotal) DESC;

GO

-- =============================================
-- Zadanie 3
-- =============================================

CREATE FUNCTION Student_665.ufn_ProductsJsonByCategory
(
    @CategoryName NVARCHAR(50)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @Result NVARCHAR(MAX);

    SELECT @Result =
        (
            SELECT 
                p.ProductID,
                p.Name,
                p.ListPrice,
                pc.Name AS CategoryName
            FROM SalesLT.Product p
            JOIN SalesLT.ProductCategory pc
                ON p.ProductCategoryID = pc.ProductCategoryID
            WHERE pc.Name = @CategoryName
            FOR JSON AUTO
        );

    RETURN @Result;
END;

GO

-- =============================================
-- Zadanie 4
-- =============================================

CREATE FUNCTION Student_665.ufn_IsPriceHigherThanCurrent
(
    @ProductJson NVARCHAR(MAX)
)
RETURNS BIT
AS
BEGIN
    DECLARE @ProductID INT = JSON_VALUE(@ProductJson, '$.ProductID');
    DECLARE @NewPrice DECIMAL(10,2) = JSON_VALUE(@ProductJson, '$.NewPrice');
    DECLARE @CurrentPrice DECIMAL(10,2);
    DECLARE @Result BIT = 0;

    SELECT @CurrentPrice = ListPrice
    FROM SalesLT.Product
    WHERE ProductID = @ProductID;

    IF @NewPrice > @CurrentPrice
        SET @Result = 1;

    RETURN @Result;
END;
GO

-- =============================================
-- Zadanie 5
-- =============================================

CREATE FUNCTION Student_665.ufn_ProductPriceCheck
(
    @ProductsJson NVARCHAR(MAX)
)
RETURNS @Result TABLE
(
    ProductID INT,
    NewPrice MONEY,
    IsHigher BIT
)
AS
BEGIN
    INSERT INTO @Result (ProductID, NewPrice, IsHigher)
    SELECT
        JSON_VALUE(p.value, '$.ProductID') AS ProductID,
        JSON_VALUE(p.value, '$.NewPrice') AS NewPrice,
        Student_665.ufn_IsPriceHigherThanCurrent(p.value) AS IsHigher
    FROM OPENJSON(@ProductsJson) AS p;

    RETURN;
END;
GO

-- =============================================
-- Zadanie 6
-- =============================================

--Zadania nie da siê wykonaæ poniewa¿ nie mo¿na odwo³aæ siê do tabeli tymczasowej wewn¹trz funkcji.

-- =============================================
-- Zadanie 7
-- =============================================

-- =========================================================
-- iTVF: Produkty dla standardowych klientów
-- =========================================================
-- Scenariusz:
-- To s¹ zwykli klienci, którzy kupuj¹ czasem, nie maj¹ ¿adnego statusu.
-- Sprzedawca chce sprawdziæ dostêpne produkty i pokazaæ rabat zapisany w bazie.
-- =========================================================

CREATE FUNCTION Shop_01.ufn_StandardCustomerProducts()
RETURNS TABLE
AS
RETURN
(
    SELECT 
        ProductID,
        ProductName,
        Price,
        Price * (1 - DiscountRate) AS DiscountedPrice
    FROM Products
);

GO
-- =========================================================
-- mTVF: Produkty dla sta³ych klientów
-- =========================================================
-- Scenariusz:
-- Ci klienci kupuj¹ du¿o i regularnie. Maj¹ status lojalny.
-- Do rabatu bazowego doliczamy dodatkowe punkty procentowe:
-- 1) jeœli klient jest z nami >= 3 lat, +5%
-- 2) jeœli klient jest z nami >= 1 rok, +2%
-- =========================================================

CREATE FUNCTION Shop_01.ufn_LoyalCustomerProducts()
RETURNS @Result TABLE
(
    ProductID INT,
    ProductName NVARCHAR(100),
    BasePrice MONEY,
    LoyaltyDiscount DECIMAL(5,2),
    FinalPrice MONEY
)
AS
BEGIN
    INSERT INTO @Result (ProductID, ProductName, BasePrice, LoyaltyDiscount, FinalPrice)
    SELECT 
        p.ProductID,
        p.ProductName,
        p.Price,
        p.DiscountRate + 
            CASE 
                WHEN c.YearsWithUs >= 3 THEN 0.05  -- dodatkowe 5% rabatu dla klientów >= 3 lata
                WHEN c.YearsWithUs >= 1 THEN 0.02  -- dodatkowe 2% dla klientów >= 1 rok
                ELSE 0
            END AS LoyaltyDiscount,
        p.Price * (1 - (p.DiscountRate + 
            CASE 
                WHEN c.YearsWithUs >= 3 THEN 0.05
                WHEN c.YearsWithUs >= 1 THEN 0.02
                ELSE 0
            END)) AS FinalPrice
    FROM Products p
    CROSS JOIN Customers c
    WHERE c.IsLoyal = 1

    RETURN;
END;

GO

-- =========================================================
-- Widok: Inwentaryzacja dla pracowników
-- =========================================================
-- Scenariusz:
-- Pracownicy magazynu potrzebuj¹ podgl¹du produktów:
-- Posiadaj¹ wgl¹d do jedynie niektórych kolumn, poni¿ej parê przyk³adowych.
-- Widok dzia³a jak gotowa tabela do raportów i inwentaryzacji.
-- =========================================================

CREATE VIEW Shop_01.vw_Inventory
AS
SELECT
    ProductID,
    ProductName,
    CategoryName,
    WarehouseID,
    Stock,
    Price
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID;

GO

-- =========================================================
-- Funkcja skalarna: Sprawdzenie dostêpnoœci produktu
-- =========================================================
-- Scenariusz:
-- Chcemy szybko sprawdziæ, czy produkt jest w magazynie.
-- Funkcja zwraca 'Dostêpny' lub 'Brak'.
-- Przydatne dla sprzedawców i systemu online.
-- =========================================================

CREATE FUNCTION Shop_01.ufn_IsProductInStock(@ProductID INT)
RETURNS NVARCHAR(20)
AS
BEGIN
    DECLARE @Status NVARCHAR(20);

    SELECT @Status = CASE 
                        WHEN Stock > 0 THEN 'Dostêpny'
                        ELSE 'Brak'
                     END
    FROM Products
    WHERE ProductID = @ProductID;

    RETURN @Status;
END;
