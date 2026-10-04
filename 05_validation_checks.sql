/* =====================================================
   05_validation_checks.sql
   Confirms the warehouse matches the source.
   ===================================================== */

-- 1. Row counts
-- FactSales should equal OrderItems because the grain is one row per order item
SELECT COUNT(*) AS SourceOrderItems FROM OrderItems;
SELECT COUNT(*) AS FactSalesRows    FROM FactSales;

-- FactPayments should equal Payments because the grain is one row per payment
SELECT COUNT(*) AS SourcePayments   FROM Payments;
SELECT COUNT(*) AS FactPaymentsRows FROM FactPayments;

-- 2. Amount reconciliation (each pair should match)
SELECT SUM(quantity * unit_price) AS SourceSales FROM OrderItems;
SELECT SUM(Amount)                AS FactSales   FROM FactSales;

SELECT SUM(amount)     AS SourcePaid FROM Payments;
SELECT SUM(AmountPaid) AS FactPaid   FROM FactPayments;

-- 3. Orphan key checks (expected: 0 rows each) 
-- Orphan keys are child table records that reference non-existent parent records, violating referential integrity.
-- Every fact foreign key should resolve to a dimension row
SELECT fs.*
FROM FactSales fs
LEFT JOIN DimCustomer dc ON fs.CustomerKey = dc.CustomerKey
WHERE dc.CustomerKey IS NULL;

SELECT fs.*
FROM FactSales fs
LEFT JOIN DimProducts dp ON fs.ProductKey = dp.ProductKey
WHERE dp.ProductKey IS NULL;

SELECT fs.*
FROM FactSales fs
LEFT JOIN DimDate dd ON fs.DateKey = dd.DateKey
WHERE dd.DateKey IS NULL;
