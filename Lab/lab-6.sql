-- =============================================
-- Krystian
-- Byrgiel
-- 230665
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================

CREATE PROCEDURE SalesLT.usp_AddCustomer
    @FirstName NVARCHAR(50),
    @LastName  [230665].K5_surname,
    @Email     NVARCHAR(100),
    @Phone     NVARCHAR(25) = NULL,
    @PasswordHash NVARCHAR(30),
    @PasswordSalt NVARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [230665].Customer (FirstName, LastName, EmailAddress, Phone, PasswordHash,PasswordSalt)
    VALUES (@FirstName, @LastName, @Email, @Phone, @PasswordHash, @PasswordSalt);
END;

GO

-- =============================================
-- Zadanie 2
-- =============================================

CREATE PROCEDURE SalesLT.usp_GetCustomers
    @FirstName NVARCHAR(50) = NULL,
    @LastName  [230665].K5_surname = NULL,
    @CustomerId    INT = NULL,
    @Email     NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        CustomerId,
        FirstName,
        LastName,
        EmailAddress
    FROM [230665].Customer
    WHERE
        (@FirstName    IS NULL OR FirstName    = @FirstName)
        AND (@LastName     IS NULL OR LastName     = @LastName)
        AND (@CustomerId   IS NULL OR CustomerId   = @CustomerId)
        AND (@Email IS NULL OR EmailAddress = @Email);
END;
GO

-- =============================================
-- Zadanie 3
-- =============================================

-- Zadanie nie jest mo¿liwe do wykonania poniewa¿ zmienna tabelaryczna jest tylko do odczytu
-- i nie mo¿na wstawiæ tu ¿adnych danych, wiêc nie mo¿na zwróciæ tabeli poprzez output

-- =============================================
-- Zadanie 4
-- =============================================

CREATE PROCEDURE SalesLT.usp_CheckCustomerExists
    @FirstName NVARCHAR(50),
    @LastName  [230665].K5_surname,
    @Email     NVARCHAR(100),
    @Exists    BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM [230665].Customer
        WHERE FirstName = @FirstName
          AND LastName = @LastName
          AND EmailAddress = @Email
    )
        SET @Exists = 1;
    ELSE
        SET @Exists = 0;
END;
GO

ALTER PROCEDURE SalesLT.usp_AddCustomer
    @FirstName NVARCHAR(50),
    @LastName  [230665].K5_surname,
    @Email     NVARCHAR(100),
    @Phone     NVARCHAR(25) = NULL,
    @PasswordHash NVARCHAR(30),
    @PasswordSalt NVARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Exists BIT;

    EXEC SalesLT.usp_CheckCustomerExists @FirstName, @LastName, @Email, @Exists OUTPUT;

    IF @Exists = 1
    BEGIN

        RETURN;
    END

    INSERT INTO [230665].Customer (FirstName, LastName, EmailAddress, Phone, PasswordHash, PasswordSalt)
    VALUES (@FirstName, @LastName, @Email, @Phone, @PasswordHash, @PasswordSalt);

END;
GO

-- =============================================
-- Zadanie 5
-- =============================================

CREATE OR ALTER PROCEDURE SalesLT.usp_UpdateCustomer
    @CustomerID INT,
    @FirstName NVARCHAR(50) = NULL,
    @LastName  [230665].K5_surname = NULL,
    @Email     NVARCHAR(100) = NULL,
    @Phone     NVARCHAR(25) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1 
        FROM [230665].Customer
        WHERE CustomerID = @CustomerID
    )
    BEGIN
        RAISERROR('Rekord o podanym CustomerID nie istnieje w bazie.', 16, 1);
        RETURN;
    END

    UPDATE [230665].Customer
    SET 
        FirstName = COALESCE(@FirstName, FirstName),
        LastName = COALESCE(@LastName, LastName),
        EmailAddress = COALESCE(@Email, EmailAddress),
        Phone = COALESCE(@Phone, Phone)
    WHERE CustomerID = @CustomerID;
END;
GO

--Chcia³em wykorzystaæ procedurê z zadania 4, ale wtedy trzeba zmieniæ wszystkie wartoœci
--A w ten sposób mo¿na zmieniæ tylko niektóre, np. samo FirstName

-- =============================================
-- Zadanie 6
-- =============================================

CREATE TABLE SalesLT.ProductInventory
(
    InventoryID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL DEFAULT 0,
    LocationID INT NOT NULL DEFAULT 1,
    CONSTRAINT FK_ProductInventory_Product FOREIGN KEY (ProductID)
        REFERENCES SalesLT.Product(ProductID)
);
GO

CREATE PROCEDURE SalesLT.AddNewProduct
    @ProductName NVARCHAR(100),
    @ProductNumber NVARCHAR(25),
    @CategoryID INT,
    @Price MONEY,
    @StockQty INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @Price <= 0
    BEGIN
        RAISERROR('Cena jednostkowa musi byæ wiêksza od zera.', 16, 1);
        RETURN;
    END

    IF @StockQty < 0
    BEGIN
        RAISERROR('Iloœæ w magazynie nie mo¿e byæ ujemna.', 16, 1);
        RETURN;
    END

    BEGIN TRAN;

    BEGIN TRY
        INSERT INTO SalesLT.Product (Name, ProductNumber, Color, StandardCost, ListPrice, SellStartDate, ProductCategoryID)
        VALUES (
            @ProductName,
            @ProductNumber,
            'Not Specified',
            @Price * 0.7,
            @Price,
            GETDATE(),
            @CategoryID
        );

        DECLARE @NewProductID INT = SCOPE_IDENTITY();

        INSERT INTO SalesLT.ProductInventory (ProductID, Quantity, LocationID)
        VALUES (@NewProductID, @StockQty, 1);

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('B³¹d podczas dodawania produktu: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO

-- =============================================
-- Zadanie 7
-- =============================================

-- Zadanie nie jest mo¿liwe do wykonania poniewa¿
-- zmienna summary zadeklarowana poza procedur¹ nie
-- jest dostêpna wewn¹trz procedury.