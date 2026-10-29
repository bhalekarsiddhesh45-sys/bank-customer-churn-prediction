	-- Overall churn
    SELECT COUNT(*) customers, SUM(Exited) churned, ROUND(100*AVG(Exited),2) churn_pct FROM customers;
    -- By geography
    SELECT Geography, COUNT(*) n, ROUND(100*AVG(Exited),1) churn_pct FROM customers GROUP BY Geography ORDER BY churn_pct DESC;
    -- By Gender
    SELECT Gender,COUNT(*) n,ROUND(100*AVG(Exited),1) churn_pct FROM customers GROUP BY Gender ORDER BY churn_pct DESC;
    -- By active member
    SELECT IsActiveMember,COUNT(*) n,ROUND(100*AVG(Exited),1) churn_pct FROM customers GROUP BY IsActiveMember ORDER BY churn_pct DESC;
    -- By NumOfProducts
    SELECT NumOfProducts,COUNT(*) n,ROUND(100*AVG(Exited),1) churn_pct FROM customers GROUP BY NumOfProducts ORDER BY churn_pct DESC;
    -- By Credit Card Flag
    SELECT HasCrCard,COUNT(*) n,ROUND(100*AVG(Exited),1) churn_pct FROM customers GROUP BY HasCrCard ORDER BY churn_pct DESC;
    
    -- Chunrned VS Retained Profile 
    SELECT Exited, ROUND(AVG(Age),1) avg_age, 
		   ROUND(AVG(Balance),0) avg_bal, ROUND(AVG(CreditScore),0) avg_cs,
           ROUND(AVG(Tenure),1) avg_tenure, 
		   ROUND(AVG(EstimatedSalary),0) avg_sal FROM customers GROUP BY Exited;
    
    -- Balance held by churned customers
    SELECT Exited,ROUND(SUM(Balance)) total_balance FROM customers GROUP BY Exited;
    
    -- By Age Band
    SELECT age_band,COUNT(*) n,ROUND(100*AVG(Exited),1) churn_pct FROM v_customers GROUP BY age_band ORDER BY churn_pct DESC;       
    -- By tenure year
    SELECT Tenure ,COUNT(*) n, ROUND(100*AVG(Exited),1) churn_pct FROM v_customers GROUP BY Tenure ORDER BY churn_pct DESC;
    -- Zero VS positive
    SELECT has_zero_balance,COUNT(*) n,ROUND(100*AVG(Exited),1) churn_pct FROM v_customers GROUP BY has_zero_balance ORDER BY churn_pct DESC;
    -- by creditband
    SELECT credit_band ,COUNT(*) n,ROUND(100*AVG(Exited),1) churn_pct FROM v_customers GROUP BY credit_band ORDER BY churn_pct DESC;
    