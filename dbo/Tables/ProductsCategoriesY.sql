CREATE TABLE [dbo].[ProductsCategoriesY] (
    [OwnerID]       INT           NOT NULL,
    [Name]          [dbo].[Name]  NOT NULL,
    [ProductNumber] NVARCHAR (25) NOT NULL,
    [Category]      [dbo].[Name]  NOT NULL
);

