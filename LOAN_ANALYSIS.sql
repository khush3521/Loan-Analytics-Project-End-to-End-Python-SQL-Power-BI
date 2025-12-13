CREATE DATABASE loan_analytics;
USE loan_analytics;

-- customber table 
CREATE TABLE customers (
    applicant_id VARCHAR(20) PRIMARY KEY,
    full_name VARCHAR(100),
    dob DATE,
    gender VARCHAR(10),
    income INT,
    employment_type VARCHAR(30),
    credit_score INT
);

-- loans table 

CREATE TABLE loans (
    loan_id VARCHAR(20) PRIMARY KEY,
    applicant_id VARCHAR(20),
    application_date DATE,
    disbursement_date DATE,
    loan_amount INT,
    term_months INT,
    interest_rate FLOAT,
    product_type VARCHAR(30),
    channel VARCHAR(30),
    branch_id VARCHAR(20),
    status VARCHAR(20),
    default_flag INT,
    age_at_application INT,
    emi INT,
    FOREIGN KEY (applicant_id) REFERENCES customers(applicant_id)
);

--  payment TABLE

CREATE TABLE payments (
    payment_id VARCHAR(20) PRIMARY KEY,
    loan_id VARCHAR(20),
    payment_date DATE,
    scheduled_amount INT,
    paid_amount INT,
    days_past_due INT,
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);















-- DATA CLEANING IN SQL

SELECT * FROM customers WHERE income IS NULL;

-- Fix negative income
UPDATE customers
SET income = ABS(income)
WHERE income < 0;

-- Invalid DOB check

SELECT * FROM customers WHERE dob IS NULL OR dob = '';

-- Remove blank branch IDs

UPDATE loans
SET branch_id = NULL
WHERE branch_id = '';

-- Replace NULL interest with avg
UPDATE loans
SET interest_rate = (SELECT AVG(interest_rate) FROM loans)
WHERE interest_rate IS NULL;


