# 🏦 Loan Analytics Project — End-to-End Banking Intelligence

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![DAX](https://img.shields.io/badge/DAX-005C84?style=for-the-badge)
![Excel](https://img.shields.io/badge/Excel-217346?style=for-the-badge&logo=microsoftexcel&logoColor=white)
![Status](https://img.shields.io/badge/Project-Completed-success?style=for-the-badge)

> 🏛️ 100K+ loan records | 💳 Real banking KPIs | ⚠️ Credit risk & default analysis | 25+ SQL queries

---

## 📊 End-to-End Analytics Pipeline

```
Raw Banking Data → Python (Cleaning & Feature Engineering) → MySQL (Relational Schema) 
→ 25+ SQL Queries → Power BI Dashboard → Risk & Portfolio Insights
```

---

## 📌 Project Overview

Financial institutions manage thousands of loans simultaneously — but identifying **which borrowers are at risk, which branches are underperforming, and where the portfolio is most exposed** requires more than raw data. It requires a structured analytics system.

This project simulates a **real-world banking analytics pipeline** — from raw data ingestion to an executive-ready Power BI dashboard — covering loan disbursement, repayment behavior, customer risk profiling, and branch performance. Built on **100,000+ records** with industry-standard features used by actual credit risk teams.

---

## 🎯 Business Problem

A bank's risk team needs answers to these questions every month:

1. **Which borrowers are most likely to default — and why?**
2. **Which branches are generating healthy vs high-risk portfolios?**
3. **Does EMI-to-income ratio predict default behavior?**
4. **Which loan channels bring volume but carry hidden risk?**

This project answers all four with data, SQL, and interactive dashboards.

---

## 🏗️ Project Architecture

```
Raw Data (CSV/Excel)
        ↓
Python — Pandas & NumPy
  • Null handling & deduplication
  • Date standardization
  • Negative/impossible value correction
  • Feature engineering (Age, EMI Ratio, DPD Bands)
        ↓
MySQL — Relational Schema (3 tables)
  • customers, loans, payments
  • 25+ analytical SQL queries
        ↓
Power BI Dashboard
  • KPIs, trends, risk segmentation
  • Branch & channel performance
  • Default vs non-default comparison
        ↓
Business Insights & Recommendations
```

---

## 📈 Key Insights & Business Impact

| Finding | Business Implication |
|---|---|
| **DPD > 30 strongly correlates with default** | Flag all DPD 31+ accounts for collections team intervention |
| **EMI-to-income ratio identifies default-prone borrowers** | Set max EMI ratio threshold at underwriting stage |
| **Education loans dominate the portfolio** | Concentration risk — diversify product mix |
| **Certain branches outperform significantly** | Replicate top-branch processes across underperformers |
| **Online channels = high volume + higher risk** | Apply stricter credit checks to digital loan applications |

---
Page 1 :
<img width="1274" height="723" alt="Screenshot 2025-12-13 140726" src="https://github.com/user-attachments/assets/d9526271-f995-4c5e-8034-108c93b12fe5" />
Page 2 :
<img width="1281" height="720" alt="Screenshot 2025-12-13 140735" src="https://github.com/user-attachments/assets/ab50fea7-2abe-4c8b-82c8-4d75fce45d52" />
Page 3:
<img width="1278" height="715" alt="Screenshot 2025-12-13 140745" src="https://github.com/user-attachments/assets/2ef32609-ce7b-4653-b32f-32bdc5533bb8" />

## 🗄️ SQL Database Design

### Schema — 3 Core Tables

```sql
-- customers: demographic & financial profile
CREATE TABLE customers (
    customer_id     INT PRIMARY KEY,
    name            VARCHAR(100),
    dob             DATE,
    income          DECIMAL(12,2),
    income_band     VARCHAR(20),       -- Engineered feature
    age             INT,               -- Engineered from DOB
    city            VARCHAR(50),
    branch_id       INT
);

-- loans: loan attributes and status
CREATE TABLE loans (
    loan_id         INT PRIMARY KEY,
    customer_id     INT,
    loan_type       VARCHAR(50),
    loan_amount     DECIMAL(12,2),
    interest_rate   DECIMAL(5,2),
    emi_amount      DECIMAL(10,2),
    emi_to_income   DECIMAL(5,2),      -- Engineered feature
    loan_status     VARCHAR(20),
    channel         VARCHAR(30),
    disbursement_dt DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- payments: repayment behavior & DPD trends
CREATE TABLE payments (
    payment_id      INT PRIMARY KEY,
    loan_id         INT,
    payment_date    DATE,
    amount_paid     DECIMAL(10,2),
    dpd             INT,               -- Days Past Due
    dpd_band        VARCHAR(20),       -- Engineered: 0 / 1–30 / 31–60 / 61–90 / 90+
    is_default      TINYINT(1),
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);
```

### Relationships
- One **customer** → many **loans**
- One **loan** → many **payments**

---

## 🗄️ SQL — Sample Analytical Queries (25+ Total)

```sql
-- 1. Default rate by loan type
SELECT loan_type,
       COUNT(*) AS Total_Loans,
       SUM(is_default) AS Defaults,
       ROUND(SUM(is_default) * 100.0 / COUNT(*), 2) AS Default_Rate_Pct
FROM loans l
JOIN payments p ON l.loan_id = p.loan_id
GROUP BY loan_type
ORDER BY Default_Rate_Pct DESC;

-- 2. High-risk customers (EMI ratio > 40% AND DPD > 30)
SELECT c.customer_id, c.name, l.emi_to_income, p.dpd, l.loan_status
FROM customers c
JOIN loans l ON c.customer_id = l.customer_id
JOIN payments p ON l.loan_id = p.loan_id
WHERE l.emi_to_income > 0.40
  AND p.dpd > 30
ORDER BY p.dpd DESC;

-- 3. Branch performance — disbursement vs default rate
SELECT c.branch_id,
       COUNT(DISTINCT l.loan_id) AS Total_Loans,
       SUM(l.loan_amount) AS Total_Disbursed,
       ROUND(AVG(l.interest_rate), 2) AS Avg_Rate,
       ROUND(SUM(p.is_default) * 100.0 / COUNT(*), 2) AS Default_Rate
FROM customers c
JOIN loans l ON c.customer_id = l.customer_id
JOIN payments p ON l.loan_id = p.loan_id
GROUP BY c.branch_id
ORDER BY Default_Rate DESC;

-- 4. DPD band distribution
SELECT dpd_band,
       COUNT(*) AS Records,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS Share_Pct
FROM payments
GROUP BY dpd_band
ORDER BY FIELD(dpd_band, '0', '1-30', '31-60', '61-90', '90+');

-- 5. Channel risk analysis — volume vs default
SELECT l.channel,
       COUNT(*) AS Loan_Count,
       SUM(l.loan_amount) AS Total_Volume,
       ROUND(SUM(p.is_default) * 100.0 / COUNT(*), 2) AS Default_Rate
FROM loans l
JOIN payments p ON l.loan_id = p.loan_id
GROUP BY l.channel
ORDER BY Default_Rate DESC;

-- 6. Monthly loan disbursement trend
SELECT DATE_FORMAT(disbursement_dt, '%Y-%m') AS Month,
       COUNT(*) AS Loans_Issued,
       SUM(loan_amount) AS Amount_Disbursed
FROM loans
GROUP BY Month
ORDER BY Month;
```

---

## 🐍 Python — Data Cleaning & Feature Engineering

```python
import pandas as pd
import numpy as np

df = pd.read_csv('data/raw_loan_data.csv')

# --- Data Cleaning ---
df.drop_duplicates(inplace=True)
df.dropna(subset=['customer_id', 'loan_amount', 'dob'], inplace=True)

# Fix impossible values
df = df[df['loan_amount'] > 0]
df = df[df['income'] > 0]
df['interest_rate'] = df['interest_rate'].clip(lower=0, upper=40)

# Standardize dates
df['dob'] = pd.to_datetime(df['dob'], dayfirst=True)
df['disbursement_dt'] = pd.to_datetime(df['disbursement_dt'], dayfirst=True)

# --- Feature Engineering ---

# Age from DOB
df['age'] = ((pd.Timestamp.today() - df['dob']).dt.days / 365).astype(int)

# Income Band
df['income_band'] = pd.cut(
    df['income'],
    bins=[0, 25000, 50000, 100000, float('inf')],
    labels=['Low', 'Medium', 'High', 'Premium']
)

# EMI-to-Income Ratio
df['emi_to_income'] = (df['emi_amount'] / df['income']).round(4)

# High-Risk Flag
df['high_risk'] = ((df['emi_to_income'] > 0.40) & (df['dpd'] > 30)).astype(int)

# DPD Band
def dpd_band(dpd):
    if dpd == 0: return '0'
    elif dpd <= 30: return '1-30'
    elif dpd <= 60: return '31-60'
    elif dpd <= 90: return '61-90'
    else: return '90+'

df['dpd_band'] = df['dpd'].apply(dpd_band)

print(f"Records after cleaning: {len(df):,}")
print(f"High-risk customers: {df['high_risk'].sum():,}")
print(f"Default rate: {df['is_default'].mean()*100:.2f}%")

df.to_csv('data/loan_data_clean.csv', index=False)
```

---

## 📊 Power BI Dashboard

### KPIs (Executive Summary)
- Total Loan Amount Disbursed
- Average Interest Rate
- Average EMI Amount
- Active vs Closed Customers

### Pages & Visuals
- **Monthly Loan Trends** — disbursement volume over time
- **Product Segmentation** — loan type breakdown (education, personal, home, auto)
- **Branch Performance** — which branches lead vs lag
- **Channel Analysis** — online vs offline volume & risk
- **Default vs Non-Default** — side-by-side comparison
- **DPD & Risk Distribution** — where the portfolio stands today

---

## ⚙️ Feature Engineering Summary

| Feature | Description | Used For |
|---|---|---|
| `age` | Calculated from date of birth | Demographic risk profiling |
| `income_band` | Low / Medium / High / Premium | Segment-level analysis |
| `emi_to_income` | EMI ÷ Monthly Income | Repayment capacity scoring |
| `high_risk_flag` | EMI ratio > 40% AND DPD > 30 | Collections prioritization |
| `dpd_band` | 0 / 1–30 / 31–60 / 61–90 / 90+ | Default risk classification |

---

## 🛠 Tools & Technologies

| Tool | Purpose |
|------|---------|
| Python (Pandas, NumPy) | Data cleaning & feature engineering |
| MySQL | Relational schema & 25+ analytical queries |
| Power BI Desktop | Interactive multi-page dashboard |
| DAX | Banking KPI calculations |
| Excel | Raw data source & validation |
| Jupyter Notebook | EDA & preprocessing documentation |

---

## 📂 Repository Structure

```
Loan-Analytics-Project-End-to-End-Python-SQL-Power-BI/
│
├── data/
│   ├── raw_loan_data.csv
│   └── loan_data_clean.csv
│
├── python/
│   └── loan_data_cleaning.ipynb
│
├── sql/
│   └── loan_analytics_queries.sql
│
├── powerbi/
│   └── Loan_Analytics_Dashboard.pbix
│
├── dashboard_screenshots/
│   └── *.png
│
└── README.md
```

---

## 🔮 Future Improvements

- Build a **credit scorecard model** using logistic regression in Python
- Add **cohort analysis** — track repayment behavior of same-month borrowers
- Implement **real-time DPD alerting** via Power BI Service scheduled refresh
- Integrate **external credit bureau data** for enriched risk scoring
- Build **Power BI Service dashboard** for live bank reporting

---

## 👨‍💻 Author

**Khush Panchal** — Data Analyst
Specializing in financial analytics, credit risk & business intelligence

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?style=flat&logo=linkedin)](https://www.linkedin.com/in/khush-panchal-96b557352)
[![GitHub](https://img.shields.io/badge/GitHub-Portfolio-black?style=flat&logo=github)](https://github.com/khush3521)

---

⭐ If you found this project valuable, please consider starring this repository!
