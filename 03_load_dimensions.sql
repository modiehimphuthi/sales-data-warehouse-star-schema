/* =====================================================
   03_load_dimensions.sql
   Loads DimCustomer, DimProducts and DimDate from the source tables.
   Dimensions must be loaded BEFORE the facts so surrogate keys exist.
   Assumes the dimension tables are empty (created by 01_create_dimensions.sql).
   ===================================================== */

-- DimCustomer
INSERT INTO DimCustomer (
    Customer_Id,
    FirstName,
    LastName,
    EmailAddress,
    SignUpDate,
    City
)
SELECT DISTINCT
    customer_id,
    first_name,
    last_name,
    email,
    signup_date,
    city
FROM Customers;
GO

-- DimProducts
INSERT INTO DimProducts (
    ProductID,
    ProductName,
    ProductCategory,
    Price
)
SELECT DISTINCT
    product_id,
    product_name,
    category,
    price
FROM Products;
GO

-- DimDate: one row per calendar date between the start and end dates
DECLARE @StartDate DATE = '2025-01-01';
DECLARE @EndDate   DATE = '2026-12-31';

WHILE @StartDate <= @EndDate
BEGIN
    INSERT INTO DimDate (
        FullDate,
        Day,
        Month,
        Year,
        Quarter
    )
    SELECT
        @StartDate,
        DAY(@StartDate),
        MONTH(@StartDate),
        YEAR(@StartDate),
        DATEPART(QUARTER, @StartDate);

    SET @StartDate = DATEADD(DAY, 1, @StartDate);
END;
GO
