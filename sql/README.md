# SQL Analysis — Bank Customer Churn Prediction

## Overview
This section covers data preparation, data-quality checks, and customer churn analysis using MySQL.

The objective is to identify customer segments associated with higher churn and generate business insights that can support customer retention strategies.

## Folder Structure

```text
sql/
│
├── schema_and_load.sql
├── clean_table_and_view.sql
├── Data_quality.sql
├── Analysis_basic.sql
├── Analysis_intermediate.sql
├── Analysis_advance.sql
└── README.md
```

## 1. Database and Data Preparation

- Created the `bank_churn` database.
- Created a staging table named `bank_staging`.
- Imported the raw bank churn CSV using `LOAD DATA LOCAL INFILE`.
- Created a cleaned table named `customers`.
- Added `CustomerId` as the primary key.
- Created the `v_customers` view with derived customer categories.

**Data preparation decisions:**
- Excluded `RowNumber` because it is only a row index.
- Excluded `Surname` because it is not required for the analysis and could act as a proxy for sensitive characteristics.
- Kept the original raw CSV unchanged.

## 2. Customer View — `v_customers`

Created derived columns to simplify customer segmentation:

| Column | Purpose |
|---|---|
| `age_band` | Groups customers by age |
| `balance_band` | Groups customers by account balance |
| `products_group` | Groups customers by number of products |
| `has_zero_balance` | Identifies customers with zero balance |

## 3. Data Quality Checks

Performed checks to understand the dataset's reliability:

- Total records and unique customer IDs.
- Missing and NULL values.
- Duplicate customer IDs.
- Minimum and maximum values of important columns.
- Geography and gender categories.
- Credit score distribution and possible capped values.
- Zero-balance customers.
- Customer distribution by product count.
- Invalid age and salary values.

**Outlier approach:** Investigated extreme values using percentile groups (`NTILE(100)`) instead of automatically deleting them.

## 4. SQL Analysis

Performed 28 analysis questions across three levels.

### Level 1 — Basic Analysis
- Overall customer churn.
- Churn by geography and gender.
- Churn by activity status, products, and credit card.
- Churned versus retained customer profiles.
- Balance held by churned customers.

### Level 2 — Intermediate Analysis
- Churn by age band and tenure.
- Zero versus positive balance.
- Churn by credit band and salary quartile.
- Geography × activity status.
- Products × activity status.
- Share of total churners by geography.

### Level 3 — Advanced Analysis
- Ranking customer segments by churn.
- Segment lift analysis.
- Cumulative churners by age.
- Five-year moving average of age-based churn.
- Top five highest-churn segments.
- Balance deciles.
- Pareto analysis of balance associated with churned customers.
- Geography effect within age bands.
- Products effect within activity status.
- Customer share versus churner share.
- Percentile analysis of balance, credit score, and age.
- Rule-based customer risk score baseline.

## 5. Rule-Based Risk Score

Created a simple baseline using business rules identified during the analysis.

| Condition | Points |
|---|---:|
| Age ≥ 45 | +2 |
| Inactive member | +2 |
| Germany (highest-churn country in Q2) | +1 |
| Products ≥ 3 | +1 |
| Zero balance (supported by Q11) | +1 |

The maximum possible risk score is 7.

Calculated churn rates for each risk score to understand whether higher scores are associated with higher churn.

This rule-based approach serves as a non-ML baseline for comparison with the future Machine Learning model.

## 6. SQL Concepts Used

- Database and table creation
- Data loading and cleaning
- Views and `CASE` statements
- Aggregate functions (`COUNT`, `SUM`, `AVG`)
- `GROUP BY`, `HAVING`, and `ORDER BY`
- Common Table Expressions (CTEs)
- Window functions (`NTILE`, `RANK`, `ROW_NUMBER`)
- Running totals and cumulative percentages
- Subqueries and conditional calculations

## 7. Important Notes

- Always show customer counts alongside churn rates.
- Use `AVG(Exited) * 100` to calculate churn percentage.
- Use `HAVING` to filter aggregated groups.
- Do not confuse churner share with churn rate.
- Balance associated with churned customers is not confirmed bank revenue or actual financial loss.
- Avoid drawing conclusions from very small customer groups.

## Outcome

The SQL analysis provides a structured understanding of customer churn patterns, identifies potentially high-risk customer segments, and establishes a rule-based baseline for the upcoming Python and Machine Learning stages.