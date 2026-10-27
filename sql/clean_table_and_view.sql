CREATE TABLE customers AS
SELECT CustomerId, CreditScore, Geography, Gender, Age, Tenure, Balance, NumOfProducts,
       HasCrCard, IsActiveMember, EstimatedSalary, Exited      -- RowNumber and Surname deliberately excluded
FROM bank_staging;
ALTER TABLE customers ADD PRIMARY KEY (CustomerId);
SELECT * FROM customers;

CREATE OR REPLACE VIEW v_customers AS
SELECT *,
  CASE WHEN Age<30 THEN '<30' WHEN Age<40 THEN '30-39' WHEN Age<50 THEN '40-49' WHEN Age<60 THEN '50-59' ELSE '60+' END AS age_band,
  CASE WHEN Balance=0 THEN 'Zero' WHEN Balance<100000 THEN '1-99K' ELSE '100K+' END AS balance_band,
  CASE WHEN NumOfProducts>=3 THEN '3+' ELSE CAST(NumOfProducts AS CHAR) END AS products_group,
  CASE WHEN Balance=0 THEN 1 ELSE 0 END AS has_zero_balance
FROM customers;
SELECT * FROM v_customers;
