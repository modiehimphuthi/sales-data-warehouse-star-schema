/* =====================================================
   01_create_dimensions.sql
   Creates the dimension tables: DimCustomer, DimProducts, DimDate
   ===================================================== */

-- Fact tables reference the dimensions, so drop them first
DROP TABLE IF EXISTS FactPayments;
DROP TABLE IF EXISTS FactSales;
GO

-- DimCustomer
DROP TABLE IF EXISTS DimCustomer;
GO

CREATE TABLE DimCustomer (
    CustomerKey  INT IDENTITY(1,1) PRIMARY KEY,   -- surrogate key
    Customer_Id  INT NOT NULL,                    -- natural / business key
    FirstName    VARCHAR(20) NOT NULL,
    LastName     VARCHAR(20) NOT NULL,
    EmailAddress VARCHAR(100) NOT NULL UNIQUE,
    SignUpDate   DATE NOT NULL DEFAULT GETDATE(),
    City         VARCHAR(50) NULL
);
GO

-- DimProducts
DROP TABLE IF EXISTS DimProducts;
GO

CREATE TABLE DimProducts (
    ProductKey      INT IDENTITY(1,1) PRIMARY KEY,   
    ProductID       INT NOT NULL,                    
    ProductName     VARCHAR(50) NOT NULL,
    ProductCategory VARCHAR(50) NOT NULL,
    Price           DECIMAL(10,2) NOT NULL CHECK (Price > 0)   -- current catalogue price
);
GO

-- DimDate (reusable calendar, one row per date)
DROP TABLE IF EXISTS DimDate;
GO

CREATE TABLE DimDate (
    DateKey  INT IDENTITY(1,1) PRIMARY KEY,
    FullDate DATE NOT NULL,
    Day      INT NOT NULL,
    Month    INT NOT NULL,
    Year     INT NOT NULL,
    Quarter  INT NOT NULL
);
GO
