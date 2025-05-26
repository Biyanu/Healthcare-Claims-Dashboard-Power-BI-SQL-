# Healthcare Claims Dashboard (Power BI + SQL)

![Dashboard Demo](./Dashboard.gif)

## 🔍 Overview

This project analyzes healthcare insurance claims data using **PostgreSQL** for backend processing and **Power BI** for dynamic visualization. It focuses on patient demographics, claim trends, and approval insights.

## 📦 Dataset

* **Source**: [Kaggle – Enhanced Health Insurance Claims](insert-your-kaggle-link)

## 🛠 Tools

* PostgreSQL for data modeling and advanced SQL queries
* Power BI for interactive charts and dashboards

## 🗃 Schema

```sql
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
```

## 📈 Key Insights

* **Monthly approval rate trends**
* **Top claims by employment status**
* **Denied claims for high-income married patients**
* **Pivoted summaries by gender and employment**

## ⚡ How to Run

1. Load CSV to PostgreSQL using `COPY`
2. Run SQL queries (see `queries.sql`)
3. Connect Power BI to PostgreSQL and refresh

## 📬 Author

**Biyanu Zerom**


---

⭐ Star this repo if it helps with your analytics or BI learning!
