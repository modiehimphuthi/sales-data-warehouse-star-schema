# Data Warehouse Modelling Project

Remodelling a simple e-commerce OLTP database into a dimensional data warehouse using a **Star Schema** in SQL Server (T-SQL).

The aim was to understand *why* transactional data is modelled differently for analytics, not just to copy tables across.

## Source Database
[🗄️ Online Retail SQL Database](https://github.com/modiehimphuthi/online-retail-database-/blob/main/README.md)

## Target Star Schema

| Type      | Table         | Grain                          |
| --------- | ------------- | ------------------------------ |
| Dimension | DimCustomer   | One row per customer           |
| Dimension | DimProducts   | One row per product            |
| Dimension | DimDate       | One row per calendar date      |
| Fact      | FactSales     | One row per product per order  |
| Fact      | FactPayments  | One row per payment            |


## Key Design Decisions

- **Two fact tables, not one.** Sales and payments have different grains. Joining `OrderItems` to `Payments` on order would duplicate rows and overcount payment amounts.
- **Surrogate keys.** Fact tables use warehouse-generated keys (`CustomerKey`, `ProductKey`, `DateKey`) found through dimension lookups on the source business keys.
- **Shared date dimension.** `DimDate` is a reusable calendar. The fact table decides whether a date is an order date or a payment date.
- **Transaction price kept in the fact.** `FactSales.UnitPrice` preserves the price actually charged. `DimProducts.Price` holds the current catalogue price.
- **Derived measure.** `Amount = quantity * unit_price` is calculated during the load.

## Repository Structure

```text
sql/
  01_create_dimensions.sql
  02_create_facts.sql
  03_load_dimensions.sql
  04_load_facts.sql
  05_validation_checks.sql
  06_analytical_queries.sql
docs/
  learning_notes.docx
README.md
```

Run the scripts in numbered order. Dimensions must be loaded before facts so surrogate keys exist.

## Validation

- Row counts: source tables vs fact tables
- Amount reconciliation: `SUM(quantity * unit_price)` vs `SUM(FactSales.Amount)`, and `SUM(Payments.amount)` vs `SUM(FactPayments.AmountPaid)`
- Orphan key checks: every fact foreign key resolves to a dimension row

## Example Query

```sql
SELECT dp.ProductName, SUM(fs.Amount) AS TotalSales
FROM FactSales fs
JOIN DimProducts dp ON fs.ProductKey = dp.ProductKey
GROUP BY dp.ProductName
ORDER BY TotalSales DESC;
```

More queries are in `sql/06_analytical_queries.sql`.

## Scope and Next Steps

This is a learning project focused on core dimensional modelling. SCD Type 1 and Type 2 are understood conceptually but **not implemented**.

For the full write-up of lessons and "aha moments", see file `learning_notes.docx`.
