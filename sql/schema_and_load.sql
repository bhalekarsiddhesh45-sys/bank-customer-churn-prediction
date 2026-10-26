CREATE DATABASE IF NOT EXISTS bank_churn;
USE bank_churn;

SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile=1;

CREATE TABLE bank_staging (
	RowNumber INT, CustomerId BIGINT, Surname VARCHAR(60),
    CreditScore INT, Geogaraphy VARCHAR(20), Gender VARCHAR(10), Age INT, Tenure INT,
    Balance DECIMAL(10,2), NumOfProducts INT, HasCrCard TINYINT, IsActiveMember TINYINT,
    EstimatedSalary DECIMAL(10,2), Exited TINYINT
);
 
LOAD DATA LOCAL INFILE
'C:/Users/Siddhesh/Downloads/bank-customer-churn/data/processed/Bank_churn_prediction.csv' INTO TABLE bank_staging
FIELDS TERMINATED BY ',' ENCLOSED BY '"'LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM bank_staging;
SELECT COUNT(*) FROM bank_staging;
