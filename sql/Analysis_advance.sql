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

	