-- Rank segments by churn within each country
WITH g AS 
(
    SELECT
        Geography,
        age_band,
        COUNT(*) n,
        AVG(Exited) r
    FROM v_customers
    GROUP BY 1,2
    HAVING COUNT(*) >= 30
)
SELECT
    *,
    RANK() OVER (
        PARTITION BY Geography
        ORDER BY r DESC
    ) rk
FROM g;

/*Segment lift** = segment rate ÷ overall rate, with the overall rate as `(SELECT AVG(Exited) FROM customers)`.
 *Pitfall:* `AVG(rate) OVER ()` averages group rates, not customers.*/

SELECT
    Geography,
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,

    ROUND(AVG(Exited) * 100, 2) AS segment_churn_rate,

    ROUND(
        AVG(Exited) /
        (SELECT AVG(Exited) FROM v_customers),
        2
    ) AS segment_lift

FROM v_customers
GROUP BY Geography
ORDER BY segment_lift DESC;

-- Cumulative churners by age
WITH age_churn AS (
    SELECT
        Age,
        SUM(Exited) AS churned_customers
    FROM v_customers
    GROUP BY Age
)

SELECT
    Age,
    churned_customers,

    SUM(churned_customers) OVER (
        ORDER BY Age
    ) AS cumulative_churners,

    ROUND(
        100.0 * SUM(churned_customers) OVER (ORDER BY Age)
        / SUM(churned_customers) OVER (),
        1
    ) AS cumulative_churn_percentage

FROM age_churn;


WITH segment_churn AS (
    SELECT
        Geography,
        age_band,
        IsActiveMember,
        COUNT(*) AS total_customers,
        SUM(Exited) AS churned_customers,
        AVG(Exited) AS churn_rate
    FROM v_customers
    GROUP BY
        Geography,
        age_band,
        IsActiveMember
    HAVING COUNT(*) >= 50
),
-- Top 5 highest-churn segments
ranked_segments AS (
    SELECT
        Geography,
        age_band,
        IsActiveMember,
        total_customers,
        churned_customers,
        ROUND(churn_rate * 100, 2) AS churn_rate_percentage,

        ROW_NUMBER() OVER (
            ORDER BY churn_rate DESC
        ) AS segment_rank

    FROM segment_churn
)

SELECT *
FROM ranked_segments
WHERE segment_rank <= 5
ORDER BY segment_rank;

-- Balance deciles:with churn rate and balance range per decile

WITH segment_churn AS (
    SELECT
        Geography,
        age_band,
        IsActiveMember,
        COUNT(*) AS total_customers,
        SUM(Exited) AS churned_customers,
        AVG(Exited) AS churn_rate
    FROM v_customers
    GROUP BY
        Geography,
        age_band,
        IsActiveMember
    HAVING COUNT(*) >= 50
),

ranked_segments AS (
    SELECT
        Geography,
        age_band,
        IsActiveMember,
        total_customers,
        churned_customers,
        ROUND(churn_rate * 100, 2) AS churn_rate_percentage,

        ROW_NUMBER() OVER (
            ORDER BY churn_rate DESC
        ) AS segment_rank

    FROM segment_churn
)

SELECT *
FROM ranked_segments
WHERE segment_rank <= 5
ORDER BY segment_rank; 	 	

-- Pareto of balance lost:
WITH churned_customers AS (
    SELECT
        CustomerID,
        Geography,
        Age,
        Balance
    FROM v_customers
    WHERE Exited = 1
),

balance_pareto AS (
    SELECT
        CustomerID,
        Geography,
        Age,
        Balance,

        SUM(Balance) OVER (
            ORDER BY Balance DESC, CustomerID
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_balance_lost,

        SUM(Balance) OVER () AS total_balance_lost

    FROM churned_customers
)

SELECT
    CustomerID,
    Geography,
    Age,
    Balance,
    ROUND(cumulative_balance_lost, 2) AS cumulative_balance_lost,

    ROUND(
        100.0 * cumulative_balance_lost /
        NULLIF(total_balance_lost, 0),
        2
    ) AS cumulative_balance_lost_pct

FROM balance_pareto
ORDER BY Balance DESC, CustomerID; 

-- Geography effect within age band
SELECT
    age_band,
    Geography,
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,
    ROUND(AVG(Exited) * 100, 2) AS churn_rate_percentage
FROM v_customers
GROUP BY
    age_band,
    Geography
HAVING COUNT(*) >= 30
ORDER BY
    age_band,
    churn_rate_percentage DESC;
    
-- Product effect within activity status

SELECT
	NumOfProducts,
    NumOfProducts,
    COUNT(*) AS total_customers,
    SUM(Exited) churned_customers,
    ROUND(AVG(Exited)*100,2) AS churn_rate_percentage
FROM v_customers
GROUP BY 
	NumOfProducts,
    IsActiveMember
HAVING COUNT(*) >= 30
ORDER BY 
	NumOfProducts,
    IsActiveMember;

-- segment contribution
SELECT
    Geography,
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS customer_share_percentage,

    ROUND(
        SUM(Exited) * 100.0 /
        SUM(SUM(Exited)) OVER (),
        2
    ) AS churner_share_percentage

FROM v_customers
GROUP BY Geography
ORDER BY churner_share_percentage DESC;

-- Percentiles of Balance
	WITH balance_percentiles AS (
    SELECT
        CustomerID,
        Balance,
        NTILE(100) OVER (
            ORDER BY Balance
        ) AS balance_percentile
    FROM v_customers
)
SELECT
    balance_percentile,
    COUNT(*) AS total_customers,
    MIN(Balance) AS minimum_balance,
    MAX(Balance) AS maximum_balance
FROM balance_percentiles
GROUP BY balance_percentile
ORDER BY balance_percentile;

-- Percentile of creditscore
WITH credit_score_percentiles AS (
    SELECT
        CustomerID,
        CreditScore,
        NTILE(100) OVER (
            ORDER BY CreditScore
        ) AS credit_score_percentile
    FROM v_customers
)
SELECT
    credit_score_percentile,
    COUNT(*) AS total_customers,
    MIN(CreditScore) AS minimum_credit_score,
    MAX(CreditScore) AS maximum_credit_score
FROM credit_score_percentiles
GROUP BY credit_score_percentile
ORDER BY credit_score_percentile;

-- percentile of age
WITH age_percentiles AS (
    SELECT
        CustomerID,
        Age,
        NTILE(100) OVER (
            ORDER BY Age
        ) AS age_percentile
    FROM v_customers
)
SELECT
    age_percentile,
    COUNT(*) AS total_customers,
    MIN(Age) AS minimum_age,
    MAX(Age) AS maximum_age
FROM age_percentiles
GROUP BY age_percentile
ORDER BY age_percentile;

-- Rule-based risk score baseline:
WITH customer_risk_scores AS (
    SELECT
        CustomerID,
        Exited,
        (
            CASE WHEN Age >= 45 THEN 2 ELSE 0 END +
            CASE WHEN IsActiveMember = 0 THEN 2 ELSE 0 END +
            CASE WHEN Geography = 'Germany' THEN 1 ELSE 0 END +
            CASE WHEN NumOfProducts >= 3 THEN 1 ELSE 0 END +
            CASE WHEN Balance = 0 THEN 1 ELSE 0 END
        ) AS risk_score
    FROM v_customers
)
SELECT
    risk_score,
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,
    ROUND(AVG(Exited) * 100, 2) AS churn_rate_percentage
FROM customer_risk_scores
GROUP BY risk_score
ORDER BY risk_score;
    
    
	 
	
    