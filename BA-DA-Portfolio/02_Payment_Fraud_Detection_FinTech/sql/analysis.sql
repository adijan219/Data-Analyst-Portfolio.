-- Payment Fraud Detection (FinTech)
-- Table: transactions (loaded from creditcard.csv)

-- Q1: Overall fraud rate and fraud value
SELECT COUNT(*) AS transactions, SUM(Class) AS frauds,
       ROUND(100.0 * SUM(Class) / COUNT(*), 3) AS fraud_rate_pct,
       ROUND(SUM(CASE WHEN Class = 1 THEN Amount END), 2) AS fraud_value
FROM transactions;

-- Q2: Fraud rate by amount bucket
SELECT CASE WHEN Amount <= 1 THEN '1. $0-1'
            WHEN Amount <= 10 THEN '2. $1-10'
            WHEN Amount <= 100 THEN '3. $10-100'
            WHEN Amount <= 500 THEN '4. $100-500'
            ELSE '5. $500+' END AS amount_bucket,
       COUNT(*) AS transactions, SUM(Class) AS frauds,
       ROUND(100.0 * SUM(Class) / COUNT(*), 3) AS fraud_rate_pct
FROM transactions
GROUP BY amount_bucket
ORDER BY amount_bucket;

-- Q3: Top 5 riskiest hours (window function ranking)
WITH hourly AS (
  SELECT CAST(Time AS INTEGER) / 3600 % 24 AS hr,
         COUNT(*) AS transactions, SUM(Class) AS frauds,
         100.0 * SUM(Class) / COUNT(*) AS fraud_rate_pct
  FROM transactions GROUP BY hr
)
SELECT hr, transactions, frauds, ROUND(fraud_rate_pct, 3) AS fraud_rate_pct,
       RANK() OVER (ORDER BY fraud_rate_pct DESC) AS risk_rank
FROM hourly ORDER BY risk_rank LIMIT 5;

-- Q4: Small-amount fraud (possible card testing)
SELECT COUNT(*) AS small_frauds,
       ROUND(100.0 * COUNT(*) / (SELECT SUM(Class) FROM transactions), 1) AS pct_of_all_fraud
FROM transactions
WHERE Class = 1 AND Amount <= 1;
