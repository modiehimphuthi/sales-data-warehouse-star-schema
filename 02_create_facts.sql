/* =====================================================
   02_create_facts.sql
   Creates the fact tables: FactSales, FactPayments
   Run after 01_create_dimensions.sql

   FactSales    grain: one row per product per order
   FactPayments grain: one row per payment
   ===================================================== */

DROP TABLE IF EXISTS FactSales;
GO

CREATE TABLE FactSales (
    FactSalesKey INT IDENTITY(1,1) PRIMARY KEY,
    OrderID      INT NOT NULL,              -- not unique: one order can have many items
    CustomerKey  INT NOT NULL,
    ProductKey   INT NOT NULL,
    DateKey      INT NOT NULL,
    UnitPrice    DECIMAL(10,2) NOT NULL,    -- price actually charged
    Quantity     INT NOT NULL,
    Amount       DECIMAL(10,2) NOT NULL,    -- Quantity * UnitPrice

    CONSTRAINT FK_FactSales_DimCustomer FOREIGN KEY (CustomerKey)
        REFERENCES DimCustomer(CustomerKey),
    CONSTRAINT FK_FactSales_DimProducts FOREIGN KEY (ProductKey)
        REFERENCES DimProducts(ProductKey),
    CONSTRAINT FK_FactSales_DimDate FOREIGN KEY (DateKey)
        REFERENCES DimDate(DateKey)
);
GO

DROP TABLE IF EXISTS FactPayments;
GO

CREATE TABLE FactPayments (
    FactPaymentsKey INT IDENTITY(1,1) PRIMARY KEY,
    PaymentID       INT NOT NULL,
    CustomerKey     INT NOT NULL,
    DateKey         INT NOT NULL,
    AmountPaid      DECIMAL(10,2) NOT NULL,
    PaymentMethod   VARCHAR(20) NOT NULL,

    CONSTRAINT FK_FactPayments_DimCustomer FOREIGN KEY (CustomerKey)
        REFERENCES DimCustomer(CustomerKey),
    CONSTRAINT FK_FactPayments_DimDate FOREIGN KEY (DateKey)
        REFERENCES DimDate(DateKey)
);
GO
