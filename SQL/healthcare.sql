-- Create Healthcare Database

CREATE DATABASE healthcare_db;

USE healthcare_db;

SELECT *
FROM cleaned_healthcare_data
LIMIT 10;

SELECT COUNT(*)
FROM cleaned_healthcare_data;

DESCRIBE cleaned_healthcare_data;

-- Total Patients
SELECT COUNT(*) AS Total_Patients
FROM cleaned_healthcare_data;

-- Gender Distribution

SELECT
    `Patient Gender`,
    COUNT(*) AS Total_Patients
FROM cleaned_healthcare_data
GROUP BY `Patient Gender`
ORDER BY Total_Patients DESC;

-- Average Patient Age

SELECT
    ROUND(AVG(`Patient Age`),2) AS Average_Age
FROM cleaned_healthcare_data;

-- Age Group Distribution

SELECT
CASE
    WHEN `Patient Age` < 18 THEN 'Children'
    WHEN `Patient Age` BETWEEN 18 AND 35 THEN 'Young Adults'
    WHEN `Patient Age` BETWEEN 36 AND 55 THEN 'Adults'
    WHEN `Patient Age` BETWEEN 56 AND 75 THEN 'Senior Adults'
    ELSE 'Elderly'
END AS Age_Group,

COUNT(*) AS Total_Patients
FROM cleaned_healthcare_data
GROUP BY Age_Group
ORDER BY Total_Patients DESC;


-- Department Referral Analysis

SELECT
    `Department Referral`,
    COUNT(*) AS Total_Referrals
FROM cleaned_healthcare_data
GROUP BY `Department Referral`
ORDER BY Total_Referrals DESC;

-- Admission Status

SELECT
    `Patient Admission Flag`,
    COUNT(*) AS Total_Patients
FROM cleaned_healthcare_data
GROUP BY `Patient Admission Flag`;

-- Average Patient Satisfaction

SELECT
    ROUND(AVG(`Patient Satisfaction Score`),2) AS Average_Satisfaction
FROM cleaned_healthcare_data;

-- Average Waiting Time

SELECT
    ROUND(AVG(`Patient Waittime`),2) AS Average_Wait_Time
FROM cleaned_healthcare_data;

-- Race Distribution

SELECT
    `Patient Race`,
    COUNT(*) AS Total_Patients
FROM cleaned_healthcare_data
GROUP BY `Patient Race`
ORDER BY Total_Patients DESC;

-- Monthly Admissions

SELECT
    `Admission Month Name`,
    COUNT(*) AS Total_Admissions
FROM cleaned_healthcare_data
GROUP BY `Admission Month Name`
ORDER BY MIN(`Admission Month`);

-- Weekend vs Weekday Admissions

SELECT
    Weekend,
    COUNT(*) AS Total_Patients
FROM cleaned_healthcare_data
GROUP BY Weekend;

-- Quarterly Admissions

SELECT
    `Admission Quarter`,
    COUNT(*) AS Total_Patients
FROM cleaned_healthcare_data
GROUP BY `Admission Quarter`
ORDER BY `Admission Quarter`;

-- Department Performance Dashboard

SELECT
    `Department Referral`,
    COUNT(*) AS Total_Patients,
    ROUND(AVG(`Patient Satisfaction Score`),2) AS Avg_Satisfaction,
    ROUND(AVG(`Patient Waittime`),2) AS Avg_Wait_Time

FROM cleaned_healthcare_data

GROUP BY `Department Referral`
ORDER BY Total_Patients DESC;

-- Gender-wise Satisfaction
SELECT
`Patient Gender`,
COUNT(*) AS Total_Patients,
ROUND(AVG(`Patient Satisfaction Score`),2) AS Avg_Satisfaction

FROM cleaned_healthcare_data

GROUP BY `Patient Gender`;

-- Age Group KPI
SELECT
CASE
WHEN `Patient Age` <18 THEN 'Children'
WHEN `Patient Age` BETWEEN 18 AND 35 THEN 'Young Adults'
WHEN `Patient Age` BETWEEN 36 AND 55 THEN 'Adults'
WHEN `Patient Age` BETWEEN 56 AND 75 THEN 'Senior Adults'
ELSE 'Elderly'
END AS Age_Group,

COUNT(*) AS Total_Patients,
ROUND(AVG(`Patient Waittime`),2) AS Avg_Wait,
ROUND(AVG(`Patient Satisfaction Score`),2) AS Avg_Satisfaction
FROM cleaned_healthcare_data
GROUP BY Age_Group
ORDER BY Total_Patients DESC;

-- Department Ranking by Wait Time
SELECT
`Department Referral`,
ROUND(AVG(`Patient Waittime`),2) AS Avg_Wait_Time
FROM cleaned_healthcare_data
GROUP BY `Department Referral`
ORDER BY Avg_Wait_Time DESC;

-- Monthly Performance
SELECT
`Admission Month Name`,
COUNT(*) AS Patients,
ROUND(AVG(`Patient Satisfaction Score`),2) AS Avg_Satisfaction,
ROUND(AVG(`Patient Waittime`),2) AS Avg_Wait
FROM cleaned_healthcare_data
GROUP BY
`Admission Month`,
`Admission Month Name`
ORDER BY `Admission Month`;

-- Weekend Performance
SELECT
Weekend,
COUNT(*) AS Patients,
ROUND(AVG(`Patient Waittime`),2) AS Avg_Wait,
ROUND(AVG(`Patient Satisfaction Score`),2) AS Avg_Satisfaction
FROM cleaned_healthcare_data
GROUP BY Weekend;

-- Admission Rate
SELECT
`Patient Admission Flag`,
COUNT(*) AS Total,
ROUND(
COUNT(*)*100.0/(SELECT COUNT(*) FROM cleaned_healthcare_data),2) AS Percentage

FROM cleaned_healthcare_data
GROUP BY `Patient Admission Flag`;

-- Referral Performance
SELECT
`Department Referral`,
COUNT(*) AS Patients,
SUM(CASE
WHEN `Patient Admission Flag`='Admitted'
THEN 1
ELSE 0
END) AS Admitted,
ROUND(AVG(`Patient Waittime`),2) AS Avg_Wait
FROM cleaned_healthcare_data
GROUP BY `Department Referral`
ORDER BY Patients DESC;

-- High-Volume Departments
SELECT
`Department Referral`,
COUNT(*) AS Total_Patients
FROM cleaned_healthcare_data

GROUP BY `Department Referral`
HAVING COUNT(*) > 100
ORDER BY Total_Patients DESC;

-- Satisfaction Categories
SELECT
CASE
WHEN `Patient Satisfaction Score`>=8 THEN 'Excellent'
WHEN `Patient Satisfaction Score`>=6 THEN 'Good'
WHEN `Patient Satisfaction Score`>=4 THEN 'Average'
ELSE 'Poor'
END AS Satisfaction_Level,
COUNT(*) AS Patients
FROM cleaned_healthcare_data
GROUP BY Satisfaction_Level
ORDER BY Patients DESC;

-- Wait Time Categories
SELECT
CASE
WHEN `Patient Waittime`<=15 THEN '0-15 Min'
WHEN `Patient Waittime`<=30 THEN '16-30 Min'
WHEN `Patient Waittime`<=60 THEN '31-60 Min'
ELSE 'Above 60 Min'
END AS Wait_Category,
COUNT(*) AS Patients
FROM cleaned_healthcare_data
GROUP BY Wait_Category;

-- Executive KPI Summary
SELECT
COUNT(*) AS Total_Patients,
ROUND(AVG(`Patient Age`),2) AS Avg_Age,
ROUND(AVG(`Patient Waittime`),2) AS Avg_Wait,
ROUND(AVG(`Patient Satisfaction Score`),2) AS Avg_Satisfaction,
SUM(CASE
WHEN `Patient Admission Flag`='Admitted'
THEN 1
ELSE 0
END) AS Total_Admissions
FROM cleaned_healthcare_data;

-----------------------
-- views
-----------------------

--  Executive KPI View
CREATE VIEW vw_executive_kpi AS
SELECT
COUNT(*) AS Total_Patients,
ROUND(AVG(`Patient Age`),2) AS Avg_Age,
ROUND(AVG(`Patient Waittime`),2) AS Avg_Wait_Time,
ROUND(AVG(`Patient Satisfaction Score`),2) AS Avg_Satisfaction,
SUM(CASE
WHEN `Patient Admission Flag`='Admitted'
THEN 1
ELSE 0
END) AS Total_Admissions
FROM cleaned_healthcare_data;

SELECT * FROM vw_executive_kpi;

-- Department Performance
CREATE VIEW vw_department_performance AS
SELECT
`Department Referral`,
COUNT(*) AS Total_Patients,
ROUND(AVG(`Patient Waittime`),2) AS Avg_Wait_Time,
ROUND(AVG(`Patient Satisfaction Score`),2) AS Avg_Satisfaction
FROM cleaned_healthcare_data
GROUP BY `Department Referral`;

SELECT * FROM vw_department_performance;

-- Monthly Trend
CREATE VIEW vw_monthly_trend AS
SELECT
`Admission Month`,
`Admission Month Name`,

COUNT(*) AS Patients,
ROUND(AVG(`Patient Waittime`),2) AS Avg_Wait,
ROUND(AVG(`Patient Satisfaction Score`),2) AS Avg_Satisfaction
FROM cleaned_healthcare_data
GROUP BY
`Admission Month`,
`Admission Month Name`;

SELECT * FROM vw_monthly_trend;

-- Age Group Summary
CREATE VIEW vw_age_group_summary AS
SELECT
CASE
WHEN `Patient Age`<18 THEN 'Children'
WHEN `Patient Age` BETWEEN 18 AND 35 THEN 'Young Adults'
WHEN `Patient Age` BETWEEN 36 AND 55 THEN 'Adults'
WHEN `Patient Age` BETWEEN 56 AND 75 THEN 'Senior Adults'
ELSE 'Elderly'
END AS Age_Group,
COUNT(*) AS Patients,
ROUND(AVG(`Patient Waittime`),2) AS Avg_Wait,
ROUND(AVG(`Patient Satisfaction Score`),2) AS Avg_Satisfaction
FROM cleaned_healthcare_data
GROUP BY Age_Group;

SELECT * FROM vw_age_group_summary;

----------------------
-- CTEs
----------------------

-- High Waiting Departments
WITH DepartmentStats AS (
SELECT
`Department Referral`,
ROUND(AVG(`Patient Waittime`),2) AS Avg_Wait
FROM cleaned_healthcare_data
GROUP BY `Department Referral`
)

SELECT *
FROM DepartmentStats
WHERE Avg_Wait>35;

-- High Satisfaction Departments
WITH Satisfaction AS (
SELECT
`Department Referral`,
ROUND(AVG(`Patient Satisfaction Score`),2) AS Avg_Score
FROM cleaned_healthcare_data
GROUP BY `Department Referral`
)

SELECT *
FROM Satisfaction
ORDER BY Avg_Score DESC;

-------------------------
-- Window Functions
-------------------------

-- Department Ranking
SELECT
`Department Referral`,
COUNT(*) AS Patients,
RANK() OVER(
ORDER BY COUNT(*) DESC
) AS Department_Rank

FROM cleaned_healthcare_data
GROUP BY `Department Referral`;

-- Dense Rank
SELECT
`Department Referral`,
COUNT(*) AS Patients,
DENSE_RANK() OVER(
ORDER BY COUNT(*) DESC
) AS Dense__Rank

FROM cleaned_healthcare_data
GROUP BY `Department Referral`;

-- Row Number
SELECT
`Patient Id`,
`Patient Age`,
ROW_NUMBER()
OVER(
ORDER BY `Patient Age` DESC
) AS Row__Number

FROM cleaned_healthcare_data;

-----------------------------
-- Running Total
-----------------------------
SELECT
`Admission Month`,
COUNT(*) AS Monthly_Patients,
SUM(COUNT(*))
OVER(
ORDER BY `Admission Month`
) AS Running_Total

FROM cleaned_healthcare_data
GROUP BY `Admission Month`;

-----------------------------
-- Percentage Contribution
-----------------------------
SELECT
`Department Referral`,
COUNT(*) AS Patients,
ROUND(
COUNT(*)*100/
SUM(COUNT(*))
OVER(),2
) AS Percentage

FROM cleaned_healthcare_data
GROUP BY `Department Referral`;

--------------------------
-- Top Departments
--------------------------
SELECT *
FROM (
SELECT
`Department Referral`,
COUNT(*) AS Patients,
RANK()
OVER(
ORDER BY COUNT(*) DESC
) AS Ranking
FROM cleaned_healthcare_data
GROUP BY `Department Referral`
)t

WHERE Ranking<=3;

--------------------------
-- Executive View
--------------------------
CREATE VIEW vw_hospital_dashboard AS
SELECT
`Department Referral`,
COUNT(*) AS Patients,
ROUND(AVG(`Patient Waittime`),2) AS Avg_Wait,
ROUND(AVG(`Patient Satisfaction Score`),2) AS Avg_Satisfaction,
SUM(
CASE
WHEN `Patient Admission Flag`='Admitted'
THEN 1
ELSE 0
END
) AS Admissions

FROM cleaned_healthcare_data
GROUP BY `Department Referral`;

SELECT * FROM vw_hospital_dashboard;


