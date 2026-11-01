-- By quartile salary
WITH salary_groups AS (
    SELECT
        CustomerID,
        EstimatedSalary,
        Exited,
        NTILE(4) OVER (
            ORDER BY EstimatedSalary
        ) AS salary_quartile
    FROM v_customers
)

SELECT
    salary_quartile,
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,
    ROUND(AVG(Exited) * 100, 2) AS churn_rate
FROM salary_groups
GROUP BY salary_quartile
ORDER BY salary_quartile;
					
-- Geography × active member
SELECT 
	Geography,
    IsActiveMember,
    COUNT(*) AS Total_customers,
    SUM(Exited) AS churned_customers,
    ROUND(AVG(Exited) * 100, 2) AS churn_rate
FROM v_customers
GROUP BY 
	Geography,
    IsActiveMember
HAVING COUNT(*) >= 30
ORDER BY
    Geography,
    IsActiveMember;

-- Products × active member
SELECT 
	NumOfProducts,
    IsActiveMember,
    COUNT(*) AS Total_customers,
    SUM(Exited) AS churned_customers,
    ROUND(AVG(Exited) * 100, 2) AS churn_rate
FROM v_customers
GROUP BY 
	NumOfProducts,
    IsActiveMember
HAVING COUNT(*) >= 30
ORDER BY
    NumOfProducts,
    IsActiveMember;
-- Share of all churners by geography
SELECT
    Geography,
    SUM(Exited) AS churned_customers,
    ROUND(
        SUM(Exited) * 100.0 /
        SUM(SUM(Exited)) OVER (),
        2
    ) AS churner_share_pct
FROM v_customers
GROUP BY Geography
ORDER BY churner_share_pct DESC;
