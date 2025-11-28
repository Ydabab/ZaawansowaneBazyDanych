-- =============================================
-- Krystian
-- Byrgiel
-- 230665
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================
CREATE TYPE [230665].K5_surname 
FROM NVARCHAR(50) NOT NULL;

GO

ALTER TABLE [230665].Customer
ALTER COLUMN LastName [230665].K5_surname;

-- =============================================
-- Zadanie 2
-- =============================================

BEGIN TRAN;

SELECT *
FROM [230665].Customer

--Transakcja bez wykonanego commita jest niebezpieczna, 
--bo istnieje wysokie ryzyko powstania deadlocka i mo¿e wzrosn¹æ 
--kolejka zapytañ które siê nie wykonuj¹ co d¹¿y do obci¹¿enia bazy. 
--Jest to bardzo prosta droga do sparali¿owania ca³ego systemu.

-- =============================================
-- Zadanie 3
-- =============================================

SELECT TOP 10 CustomerID, FirstName, LastName FROM [230665].[Customer];
SELECT TOP 10 Name, ProductNumber, Color FROM SalesLT.Product WHERE ProductNumber LIKE '_';
SELECT COUNT(*) AS ilosc FROM SalesLT.SalesOrderHeader;
SELECT TOP 10 * FROM Student_665.ProduktyK;

BEGIN TRAN;

UPDATE [230665].Customer
SET FirstName = 'asdfghjkl'
WHERE CustomerID <= 10;

INSERT INTO SalesLT.Product (Name, ProductNumber, Color, StandardCost, ListPrice, SellStartDate)
VALUES ('zxc','0','Red',10,20, GETDATE()),
       ('asd','1','Blue',15,30, GETDATE()),
       ('qwe','2','Green',12,25, GETDATE()),
       ('qaz','3','Red',10,20, GETDATE()),
       ('wsx','4','Blue',15,30, GETDATE()),
       ('edc','5','Green',12,25, GETDATE()),
       ('zaq','6','Red',10,20, GETDATE()),
       ('xsw','7','Blue',15,30, GETDATE()),
       ('cde','8','Green',12,25, GETDATE()),
       ('zse','9','Green',12,25, GETDATE());

DELETE TOP (10)
FROM SalesLT.SalesOrderHeader;

TRUNCATE TABLE Student_665.ProduktyK;

SELECT TOP 10 CustomerID, FirstName, LastName FROM [230665].[Customer];
SELECT TOP 10 Name, ProductNumber, Color FROM SalesLT.Product WHERE ProductNumber LIKE '_';
SELECT COUNT(*) AS ilosc FROM SalesLT.SalesOrderHeader;
SELECT TOP 10 * FROM Student_665.ProduktyK;

ROLLBACK;

SELECT TOP 10 CustomerID, FirstName, LastName FROM [230665].[Customer];
SELECT TOP 10 Name, ProductNumber, Color FROM SalesLT.Product WHERE ProductNumber LIKE '_';
SELECT COUNT(*) AS ilosc FROM SalesLT.SalesOrderHeader;
SELECT TOP 10 * FROM Student_665.ProduktyK;

--Najpierw widzimy pocz¹tkowy stan tabel przed transakcj¹.
--Potem po wykonaniu operacji widzimy stan zgodny z przebiegiem tych operacji (np. po delete 10 rekordów mniej, FirstName zmienione etc.)
--Ostatnie jest po rollbacku i tam widzimy ponownie stan pocz¹tkowy, gdy¿ rollback wycofa³ zmiany które zasz³y wewn¹trz transakcji.

-- =============================================
-- Zadanie 4
-- =============================================

SELECT TOP 10 CustomerID, FirstName, LastName FROM [230665].[Customer];
SELECT TOP 10 Name, ProductNumber, Color FROM SalesLT.Product WHERE ProductNumber LIKE '_';
SELECT COUNT(*) AS ilosc FROM SalesLT.SalesOrderHeader;
SELECT TOP 10 * FROM Student_665.ProduktyK;

BEGIN TRAN;

UPDATE [230665].Customer
SET FirstName = 'asdfghjkl'
WHERE CustomerID <= 10;

INSERT INTO SalesLT.Product (Name, ProductNumber, Color, StandardCost, ListPrice, SellStartDate)
VALUES ('zxc','0','Red',10,20, GETDATE()),
       ('asd','1','Blue',15,30, GETDATE()),
       ('qwe','2','Green',12,25, GETDATE()),
       ('qaz','3','Red',10,20, GETDATE()),
       ('wsx','4','Blue',15,30, GETDATE()),
       ('edc','5','Green',12,25, GETDATE()),
       ('zaq','6','Red',10,20, GETDATE()),
       ('xsw','7','Blue',15,30, GETDATE()),
       ('cde','8','Green',12,25, GETDATE()),
       ('zse','9','Green',12,25, GETDATE());

DELETE TOP (10)
FROM SalesLT.SalesOrderHeader;

TRUNCATE TABLE Student_665.ProduktyK;

SELECT TOP 10 CustomerID, FirstName, LastName FROM [230665].[Customer];
SELECT TOP 10 Name, ProductNumber, Color FROM SalesLT.Product WHERE ProductNumber LIKE '_';
SELECT COUNT(*) AS ilosc FROM SalesLT.SalesOrderHeader;
SELECT TOP 10 * FROM Student_665.ProduktyK;

WAITFOR DELAY '00:05:00';

ROLLBACK;

SELECT TOP 10 CustomerID, FirstName, LastName FROM [230665].[Customer];
SELECT TOP 10 Name, ProductNumber, Color FROM SalesLT.Product WHERE ProductNumber LIKE '_';
SELECT COUNT(*) AS ilosc FROM SalesLT.SalesOrderHeader;
SELECT TOP 10 * FROM Student_665.ProduktyK;

--Powy¿ej zmodyfikowane zadanie 3, poni¿ej jak odczytaæ dane w niezale¿nej sesji (w formie dirty read):
SELECT TOP 10 CustomerID, FirstName, LastName 
FROM [230665].[Customer] WITH (NOLOCK);

SELECT TOP 10 Name, ProductNumber, Color 
FROM SalesLT.Product WITH (NOLOCK) 
WHERE ProductNumber LIKE '_';

SELECT COUNT(*) AS ilosc 
FROM SalesLT.SalesOrderHeader WITH (NOLOCK);

SELECT TOP 10 * 
FROM Student_665.ProduktyK WITH (NOLOCK);

-- =============================================
-- Zadanie 5
-- =============================================

BEGIN TRY
    INSERT INTO SalesLT.Product (Name, ProductNumber, Color, StandardCost, ListPrice, SellStartDate)
    VALUES ('zxc','1','Red',10,20, GETDATE()),
       ('asd','1','Blue',15,30, GETDATE())
END TRY
BEGIN CATCH
SELECT 
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- =============================================
-- Zadanie 6
-- =============================================

--Procesem jest dodanie nowego produktu.
--Zak³adamy ¿e nie istnieje taki produkt

--Mo¿liwe b³êdy:
--Produkt o takim Name lub ProductNumber ju¿ jest w tabeli
--Brak wartoœci w polu które jest NOT NULL

DECLARE 
    @Name NVARCHAR(50) = 'Nowy Produkt',
    @ProductNumber NVARCHAR(25) = '12345',
    @Color NVARCHAR(15) = 'Red',
    @StandardCost MONEY = 10,
    @ListPrice MONEY = 100,
    @SellStartDate DATETIME = GETDATE();

BEGIN TRY
    IF @Name IS NULL OR @ProductNumber IS NULL OR @StandardCost IS NULL
       OR @ListPrice IS NULL OR @SellStartDate IS NULL
        THROW 50001, 'Brak wymaganych danych', 1;

    IF EXISTS (SELECT 1 FROM SalesLT.Product WHERE ProductNumber = @ProductNumber OR Name = @Name)
        THROW 50002, 'Produkt o tym numerze lub nazwie ju¿ istnieje', 1;

    INSERT INTO SalesLT.Product 
        ([Name], [ProductNumber], [Color], [StandardCost], [ListPrice], [SellStartDate], [rowguid], [ModifiedDate])
    VALUES 
        (@Name, @ProductNumber, @Color, @StandardCost, @ListPrice, @SellStartDate, NEWID(), GETDATE());
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- =============================================
-- Zadanie 7
-- =============================================

DECLARE 
    @Name NVARCHAR(50) = 'Nowy1 Produkt',
    @ProductNumber NVARCHAR(25) = '1NP123',
    @Color NVARCHAR(15) = 'Red',
    @StandardCost MONEY = 50,
    @ListPrice MONEY = 100,
    @SellStartDate DATETIME = GETDATE();

BEGIN TRY
    BEGIN TRAN;

    IF @Name IS NULL OR @ProductNumber IS NULL OR @StandardCost IS NULL
       OR @ListPrice IS NULL OR @SellStartDate IS NULL
        THROW 50001, 'Brak wymaganych danych', 1;

    IF EXISTS (SELECT 1 FROM SalesLT.Product WHERE ProductNumber = @ProductNumber OR Name = @Name)
        THROW 50002, 'Produkt o tym numerze lub nazwie ju¿ istnieje', 1;

    INSERT INTO SalesLT.Product 
        ([Name], [ProductNumber], [Color], [StandardCost], [ListPrice], [SellStartDate], [rowguid], [ModifiedDate])
    VALUES 
        (@Name, @ProductNumber, @Color, @StandardCost, @ListPrice, @SellStartDate, NEWID(), GETDATE());
    COMMIT TRAN;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN;

    SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
END CATCH
