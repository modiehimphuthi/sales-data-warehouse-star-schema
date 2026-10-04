/* =====================================================
   04_load_facts.sql
   Loads FactSales and FactPayments.
   Each source business key is looked up in its dimension to get the surrogate key.
   Run after 03_load_dimensions.sql
   ===================================================== */

-- FactSales: one row per product per order
INSERT INTO FactSales (
    OrderID,
    CustomerKey,
    ProductKey,
    DateKey,
    UnitPrice,
    Quantity,
    Amount
)
SELECT
    o.order_id,
    dc.CustomerKey,                          
    dp.ProductKey,                          
    dd.DateKey,                              
    oi.unit_price,                           
    oi.quantity,
    oi.quantity * oi.unit_price AS Amount    -- derived measure
FROM Orders o
JOIN OrderItems oi
    ON oi.order_id = o.order_id
JOIN DimCustomer dc
    ON o.customer_id = dc.Customer_Id
JOIN DimProducts dp
    ON oi.product_id = dp.ProductID
JOIN DimDate dd
    ON CAST(o.order_date AS DATE) = dd.FullDate;
GO

-- FactPayments: one row per payment
INSERT INTO FactPayments (
    PaymentID,
    CustomerKey,
    DateKey,
    AmountPaid,
    PaymentMethod
)
SELECT
    p.payment_id,
    dc.CustomerKey,
    dd.DateKey,
    p.amount,
    p.payment_method
FROM DimCustomer dc
JOIN Orders o
    ON o.customer_id = dc.Customer_Id
JOIN Payments p
    ON p.order_id = o.order_id
JOIN DimDate dd
    ON dd.FullDate = CAST(p.payment_date AS DATE);
GO
