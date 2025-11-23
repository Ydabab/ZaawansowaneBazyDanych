-- =============================================
-- Krystian
-- Byrgiel
-- 230665
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================

--https://github.com/Ydabab/ZaawansowaneBazyDanych.git

-- =============================================
-- Zadanie 2
-- =============================================

ALTER TABLE [230665].Customer
ADD SysStartTime datetime2(0) GENERATED ALWAYS AS ROW START 
    NOT NULL DEFAULT SYSUTCDATETIME(),
    SysEndTime datetime2(0) GENERATED ALWAYS AS ROW END 
    NOT NULL DEFAULT CONVERT(datetime2(0), '9999-12-31 23:59:59'),
    PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime);
GO

ALTER TABLE [230665].Customer
SET (SYSTEM_VERSIONING = ON);

-- =============================================
-- Zadanie 3
-- =============================================

UPDATE [230665].Customer
SET CompanyName = 'Zmiana1'
WHERE CustomerID IN (1,2,3,4,5,6,7,10,11,12);

UPDATE [230665].Customer
SET CompanyName = 'Zmiana2'
WHERE CustomerID IN (1);

UPDATE [230665].Customer
SET CompanyName = 'Zmiana3'
WHERE CustomerID IN (1);

INSERT INTO [230665].Customer (FirstName, LastName, CompanyName, PasswordHash, PasswordSalt)
VALUES ('Marek', 'Kowalski', 'FirmaX', 'xxx', 'aaa'),
       ('Anna', 'Krzak', 'FirmaY', 'xxx', 'aaa'),
       ('Jan', 'Krab', 'FirmaZ', 'xxx', 'aaa'),
       ('Ewa', 'Kula', 'FirmaW', 'xxx', 'aaa'),
       ('Piotr', 'Kret', 'FirmaV', 'xxx', 'aaa');

-- =============================================
-- Zadanie 4
-- =============================================

SELECT 
    CustomerID,
    FirstName,
    LastName,
    CompanyName,
    SysStartTime,
    SysEndTime
FROM [230665].Customer
FOR SYSTEM_TIME ALL
WHERE CustomerID = 1
ORDER BY SysStartTime DESC;

-- =============================================
-- Zadanie 5
-- =============================================

SELECT *
FROM [230665].Customer
FOR SYSTEM_TIME AS OF '2025-11-12 17:27:28'
ORDER BY CustomerID;

-- =============================================
-- Zadanie 6
-- =============================================

CREATE TABLE [SalesLT].[ProductAttribute] (
    ProductAttributeID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    Attributes XML NOT NULL,
    CONSTRAINT FK_ProductAttribute_Product FOREIGN KEY (ProductID)
        REFERENCES [SalesLT].[Product](ProductID)
);

INSERT INTO [SalesLT].[ProductAttribute] (ProductID, Attributes)
VALUES
(706, 
 '<Attributes>
     <Waga>1.2</Waga>
     <Wysokoœæ>10</Wysokoœæ>
     <Szerokoœæ>5</Szerokoœæ>
     <Kolor>Czerwony</Kolor>
     <Materia³>Plastik</Materia³>
  </Attributes>'),
(707,
 '<Attributes>
     <Waga>0.5</Waga>
     <Wysokoœæ>8</Wysokoœæ>
     <Szerokoœæ>4</Szerokoœæ>
     <Kolor>Niebieski</Kolor>
     <Materia³>Metal</Materia³>
  </Attributes>'),
  (708, 
  '<Attributes>
     <Waga>1</Waga>
     <Wysokoœæ>3</Wysokoœæ>
     <Szerokoœæ>2</Szerokoœæ>
     <Kolor>Zielony</Kolor>
     <Materia³>Drewno</Materia³>
  </Attributes>'),
  (709,
 '<Attributes>
     <Waga>0.8</Waga>
     <Wysokoœæ>10</Wysokoœæ>
     <Szerokoœæ>5</Szerokoœæ>
     <Kolor>Czarny</Kolor>
     <Materia³>Szk³o</Materia³>
  </Attributes>'),
(710,
 '<Attributes>
     <Waga>1.5</Waga>
     <Wysokoœæ>12</Wysokoœæ>
     <Szerokoœæ>6</Szerokoœæ>
     <Kolor>Czerwony</Kolor>
     <Materia³>Metal</Materia³>
  </Attributes>');

  -- =============================================
  -- Zadanie 7
  -- =============================================

  INSERT INTO [SalesLT].[ProductAttribute] (ProductID, Attributes)
VALUES
(711,
 '<Attributes>
     <Waga>2.0</Waga>
     <Wysokoœæ>15</Wysokoœæ>
     <Szerokoœæ>7</Szerokoœæ>
     <Kolor>¯ó³ty</Kolor>
     <Materia³>Plastik</Materia³>
  </Attributes>'),
(712,
 '<Attributes>
     <Waga>0.9</Waga>
     <Wysokoœæ>9</Wysokoœæ>
     <Szerokoœæ>4</Szerokoœæ>
     <Kolor>Bia³y</Kolor>
     <Materia³>Metal</Materia³>
  </Attributes>'),
(713,
 '<Attributes>
     <Waga>1.3</Waga>
     <Wysokoœæ>11</Wysokoœæ>
     <Szerokoœæ>5</Szerokoœæ>
     <Kolor>Zielony</Kolor>
     <Materia³>Drewno</Materia³>
  </Attributes>'),
(714,
 '<Attributes>
     <Waga>0.7</Waga>
     <Wysokoœæ>8</Wysokoœæ>
     <Szerokoœæ>3</Szerokoœæ>
     <Kolor>Br¹zowy</Kolor>
     <Materia³>Szk³o</Materia³>
  </Attributes>'),
(715,
 '<Attributes>
     <Waga>1.8</Waga>
     <Wysokoœæ>13</Wysokoœæ>
     <Szerokoœæ>6</Szerokoœæ>
     <Kolor>Czarny</Kolor>
     <Materia³>Metal</Materia³>
  </Attributes>');

  -- =============================================
  -- Zadanie 8
  -- =============================================
 
UPDATE [SalesLT].[ProductAttribute]
SET Attributes.modify('replace value of (/Attributes/Kolor/text())[1] with concat("K", (/Attributes/Kolor/text())[1])');

UPDATE [SalesLT].[ProductAttribute]
SET Attributes.modify('replace value of (/Attributes/Material/text())[1] with concat("K", (/Attributes/Material/text())[1])');

-- =============================================
-- Zadanie 9
-- =============================================

DECLARE @jsonData NVARCHAR(MAX) = N'{
    "Name": "Jan",
    "Age": 30,
    "City": "Warszawa",
    "Country": "Polska"
}';

SET @jsonData = JSON_MODIFY(@jsonData, '$.Name', '230665');

SELECT @jsonData AS UpdatedJson;