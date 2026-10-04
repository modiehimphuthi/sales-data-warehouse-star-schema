/* =====================================================
   06_analytical_queries.sql
   Business questions answered by joining facts to dimensions.
   Pattern: FACT -> JOIN DIMENSION -> GROUP BY attribute -> AGGREGATE measure
   ===================================================== */

-- Total quantity sold
SELECT SUM(Quantity) AS TotalQuantitySold
FROM FactSales;

-- Total sales
SELECT SUM(Amount) AS TotalSales
FROM FactSales;

-- How much revenue did each product generate?
SELECT
    dp.ProductName,
    SUM(fs.Amount) AS TotalSales
FROM FactSales fs
JOIN DimProducts dp
    ON fs.ProductKey = dp.ProductKey
GROUP BY dp.ProductName
ORDER BY TotalSales DESC;

-- How much was paid by each payment method (card vs EFT vs cash)?
SELECT
    PaymentMethod,
    SUM(AmountPaid) AS TotalPaid
FROM FactPayments
GROUP BY PaymentMethod
ORDER BY TotalPaid DESC;

