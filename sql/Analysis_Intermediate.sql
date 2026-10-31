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