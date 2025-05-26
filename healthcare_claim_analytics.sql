DROP TABLE IF EXISTS health_data;

-- Creating my table here

CREATE TABLE health_data (
     claim_id TEXT, 
     patient_id TEXT,
     provider_id TEXT, 
     claim_amount NUMERIC, 
     claim_date DATE, 
     diagnosis_code TEXT, 
     procedure_code TEXT, 
     patient_age INTEGER, 
     patient_gender TEXT, 
     provider_specialty TEXT, 
     claim_status TEXT, 
     patient_income NUMERIC, 
     patient_marital_status TEXT, 
     patient_employment_status TEXT, 
     provider_location TEXT, 
     claim_type TEXT, 
     claim_submission_method TEXT
     );

-- Loading the csv file
COPY health_data
FROM 'D:/MSBA/Machine_Learning/HealthCare_claim_analytics/enhanced_health_insurance_claims.csv'
DELIMITER ',' CSV HEADER;

--1. summaries about the data  
with claim_summary as (
    SELECT 
        COUNT (DISTINCT patient_id) as patient_count,
        COUNT (DISTINCT provider_id) as provider_count,
        COUNT (DISTINCT claim_id) as claim_count,
        COUNT (DISTINCT provider_location) as location_count,
        COUNT(*) AS total_rows,
        SUM(claim_amount) AS total_claim_amount,
        MIN(claim_amount) AS min_claim,
        MAX(claim_amount) AS max_claim,
        ROUND(AVG(claim_amount), 2) AS avg_claim
    From health_data
)

SELECT *
FROM claim_summary


--2. Monthly trend of total and approved claim percentages
WITH monthly_totals AS (
  SELECT TO_CHAR(claim_date, 'YYYY-MM') AS claim_month,
         COUNT(*) AS total_claims,
         SUM(claim_amount) AS total_amount
  FROM health_data
  GROUP BY claim_month
),
monthly_approved AS (
  SELECT TO_CHAR(claim_date, 'YYYY-MM') AS claim_month,
         COUNT(*) AS approved_claims,
         SUM(claim_amount) AS approved_amount
  FROM health_data
  WHERE claim_status = 'Approved'
  GROUP BY claim_month
)
SELECT
  m.claim_month,
  m.total_claims,
  m.total_amount,
  a.approved_claims,
  a.approved_amount,
  ROUND(100.0 * a.approved_claims / NULLIF(m.total_claims, 0), 2) AS approval_rate_pct
FROM monthly_totals m
LEFT JOIN monthly_approved a USING (claim_month)
ORDER BY claim_month;

--3. Gender-income-employment pivot-style claim summaries
SELECT
  patient_gender,
  patient_employment_status,
  COUNT(*) AS num_claims,
  ROUND(AVG(claim_amount), 2) AS avg_claim_amount,
  SUM(CASE WHEN patient_income >= 100000 THEN 1 ELSE 0 END) AS high_income_claims
FROM health_data
GROUP BY patient_gender, patient_employment_status
ORDER BY avg_claim_amount DESC;

-- 4. Weekly trend of denied claims for high-income married patients
WITH filtered_claims AS (
  SELECT
    DATE_TRUNC('week', claim_date)::date AS claim_week,
    claim_status,
    patient_income,
    patient_marital_status,
    claim_amount
  FROM health_data
  WHERE patient_income >= 100000
    AND patient_marital_status = 'Married'
    AND claim_status = 'Denied'
)
SELECT
  claim_week,
  COUNT(*) AS num_claims,
  SUM(claim_amount) AS total_claims,
  ROUND(AVG(claim_amount), 2) AS avg_claim
FROM filtered_claims
GROUP BY claim_week
ORDER BY claim_week;

-- 5. Use ROW_NUMBER to get top claim per gender per employment category
WITH ranked_claims AS (
  SELECT claim_amount, 
         patient_id,
         patient_employment_status,
         ROW_NUMBER() OVER (PARTITION BY 
         patient_employment_status 
   ORDER BY claim_amount DESC) AS rnk
  FROM health_data
)
SELECT *
FROM ranked_claims
WHERE rnk <= 10
ORDER BY claim_amount DESC;


