-- Count IDs
SELECT COUNT(*) Total,COUNT(DISTINCT CustomerId) distinctid FROM customers;

-- Is null
SELECT SUM(CreditScore IS NULL) cs, SUM(Geography IS NULL) gro, SUM(Gender IS NULL) gen, SUM(Age IS NULL) age,
SUM(Balance IS NULL) bal FROM customers;

-- Geo count
SELECT Geography,COUNT(*) FROM customers GROUP BY Geography;

-- gen count
SELECT Gender, COUNT(*) FROM customers GROUP BY Gender;

-- Min and Maxx
SELECT MIN(Age),MAX(Age),MIN(CreditScore),MAX(CreditScore),MIN(Tenure),MAX(Tenure) FROM customers;

-- capped credit score count
SELECT COUNT(*) capped_credit_score FROM customers WHERE Creditscore =(SELECT MAX(CreditScore) FROM customers);

-- NumofProducts
SELECT NumOfProducts, COUNT(*) n, ROUND(100*AVG(Exited),1) churn_pct FROM customers GROUP BY NumOfProducts; 

-- Zero balance
SELECT SUM(Balance=0) zero_balance, ROUND(100*AVG(Balance=0),1) pct_zero FROM customers;

-- Estimate sal and age
SELECT COUNT(*) FROM customers WHERE EstimatedSalary<=0 OR Age<18;