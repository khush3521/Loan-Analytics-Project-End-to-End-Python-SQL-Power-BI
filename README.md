# Loan-Analytics-Project-End-to-End-Python-SQL-Power-BI
A complete real-world banking analytics project built to simulate how financial institutions monitor loan performance, customer risk, and portfolio health. This project includes data cleaning, SQL modeling, feature engineering, advanced analytics, and a fully interactive Power BI dashboard.
## Project Highlights
- Built an end-to-end analytics pipeline
- Cleaned and transformed 100K+ records
- Engineered features such as Age, EMI-to-Income Ratio, DPD Bands
- Wrote 25+ industry-level SQL queries
- Built interactive dashboards used for business decision-making
- Simulated real banking KPIs: loan disbursement, risk, defaults, branch performance
  
# Project Architecture

Data Source → Python Cleaning → SQL Database → Feature Engineering 
→ Analytical Queries → Power BI Dashboard → Insights & Reporting


## Tech Stack
-  Python (Pandas, NumPy)
-  MySQL
-  Power BI
-  Excel
-  Jupyter Notebook

# Data Cleaning (Python)

- Performed extensive preprocessing:
  -  Removed null & inconsistent values
  -  Converted all dates to standard format
  -  Fixed negative and impossible values
  -  Standardized categorical fields
  -  Created structured feature-ready datasets
 
   ## SQL Database Design

 - Created a relational schema with 3 core tables:
 - customers – demographic & financial profile
 - loans – loan attributes and status
 - payments – repayment behavior & DPD trends-
### Relationships:
  -  One customer → Many loans
  -  One loan → Many payments

  
