
--create database HealthCare

--drop table if exists healthcare_dataset

use HealthCare

--Checking out the Table
SELECT COUNT(*) FROM healthcare_dataset

SELECT TOP 5 * FROM healthcare_dataset-- where name = 'andrEw waTtS'

SELECT * FROM healthcare_dataset where [Date of Admission] is null
--------------------------------------------------------------------PREPROCESSING---------------------------------------------------------------------------
--Checking for duplicates
SELECT Name, COUNT(*) AS Duplicate_Count
FROM healthcare_dataset
GROUP BY Name
HAVING COUNT(*) > 1;

--Removing the duplicates
WITH CTE AS (
    SELECT *, 
           ROW_NUMBER() OVER (PARTITION BY Name, Age, Gender, [Blood_Type], [Medical_Condition], [Date_of_Admission] ORDER BY (SELECT NULL)) AS rn
    FROM healthcare_dataset
)
DELETE FROM CTE WHERE rn > 1;

--Normalising the name
ALTER TABLE healthcare_dataset
ADD Proper_Name NVARCHAR(255);

--Proper naming
UPDATE healthcare_dataset
SET Proper_Name = 
    (SELECT STRING_AGG(CONCAT(UPPER(LEFT(value, 1)), LOWER(SUBSTRING(value, 2, LEN(value)))), ' ') 
     FROM STRING_SPLIT(Name, ' '));

--Changing the Data type
UPDATE healthcare_dataset
SET Age = cast(Age as int),
	[Date of Admission] = TRY_CONVERT(DATE, [Date of Admission], 103), --cast([Date of Admission] as date)
	[Discharge Date] = TRY_CONVERT(DATE, [Discharge Date], 103), --cast([Discharge Date] as date),
	[Billing Amount] =  try_convert(float, [Billing Amount]),--cast([Billing Amount] as float),
	[Room Number] =  cast([Room Number] as int)
	
ALTER TABLE healthcare_dataset
ADD Age_Group NVARCHAR(255);
UPDATE healthcare_dataset
SET Age_Group = CASE 
        WHEN Age < 18 THEN '0-17'
        WHEN Age BETWEEN 18 AND 35 THEN '18-35'
        WHEN Age BETWEEN 36 AND 50 THEN '36-50'
        WHEN Age BETWEEN 51 AND 65 THEN '51-65'
        ELSE '66+'  END
	from healthcare_dataset

ALTER TABLE healthcare_dataset
ADD Hospital_Duration NVARCHAR(255);
UPDATE healthcare_dataset
SET Hospital_Duration = DATEDIFF(second, Date_of_Admission, [Discharge_Date])/(3600*24)
from healthcare_dataset


------------------------------------------------------------------------ANALYSIS------------------------------------------------------------------------------
--------------------------------------------- DISTRIBUTION
SELECT GENDER, test_results, AVG(age) AVERAGE_AGE
FROM healthcare_dataset
GROUP BY GENDER, test_results

SELECT Gender, COUNT(*) AS Patient_Count
FROM healthcare_dataset
GROUP BY Gender;

SELECT Gender, test_results, COUNT(*) AS Patient_Count
FROM healthcare_dataset
GROUP BY Gender, test_results;

--Medical Condition
SELECT Medical_Condition, COUNT(*) AS Patient_Count
FROM healthcare_dataset
GROUP BY Medical_Condition
ORDER BY Patient_Count DESC;

--Blood Type
SELECT Blood_Type, COUNT(*) AS Count
FROM healthcare_dataset
GROUP BY Blood_Type
ORDER BY Count DESC;

--Age Group
SELECT Age_Group, COUNT(*) AS Patient_Count
FROM healthcare_dataset
GROUP BY Age_Group
ORDER BY Age_Group;

--Admission Count
SELECT Hospital, COUNT(*) AS Admission_Count
FROM healthcare_dataset
GROUP BY Hospital
ORDER BY Admission_Count DESC;

--Patients per room
SELECT Room_Number, COUNT(*) AS Patient_Count
FROM healthcare_dataset
GROUP BY Room_Number
ORDER BY Patient_Count DESC;






---------------------------------------------------MEDICAL CONDITION & TEST RESULTS
--Patients with Abnormal Test Results
SELECT Test_Results, COUNT(*) AS Test_Count
FROM healthcare_dataset
GROUP BY Test_Results;

--Count of Abnormal and Normal conditions
select Medical_Condition, Medication, Test_Results, count(*) Cases
from healthcare_dataset
where Test_Results <> 'Normal'
group by Medical_Condition, Medication, Test_Results
order by cases desc

select Medical_Condition, Medication, Test_Results, count(*) Cases
from healthcare_dataset
where Test_Results = 'Normal'
group by Medical_Condition, Medication, Test_Results
order by cases desc




-----------------------------------------------------BILLINGS--Billing
SELECT Hospital, SUM(Billing_Amount) AS Total_Revenue
FROM healthcare_dataset
GROUP BY Hospital
ORDER BY Total_Revenue DESC;

--Relationship between Stay in Hospital and the Billing
;with cte as (
select *,case when Hospital_Duration between 0 and 7 then '<= 1 week'
			when Hospital_Duration between 8 and 14 then '<= 2 weeks'
			when Hospital_Duration between 15 and 21 then '<= 3 weeks' 
			when Hospital_Duration between 22 and 30 then '<= 4 weeks'
			when Hospital_Duration > 30 then 'more than a month'
			end as Hospital_Stay
		from healthcare_dataset
)
select Hospital_Stay, Avg(Billing_Amount) Avg_Amount_Paid
from cte
group by Hospital_Stay
order by Hospital_Stay

--Billings for each Admission 
SELECT Admission_Type, AVG(Billing_Amount) AS Avg_Bill
FROM healthcare_dataset
GROUP BY Admission_Type;



-------------------------------------------------AGE GROUP AND THEIR EFFECTS
--Top medical Conditions affecting each age group
;with cte as(
SELECT Age_Group, Medical_Condition, count(*) Cases
from healthcare_dataset
GROUP BY Age_Group, Medical_Condition
--order by Age_Group, Cases
), 
	rankx as(
	select *, RANK() over (Partition by Age_Group order by Cases desc) ranking
	from cte
	)
	select * from rankx
	where ranking <= 2


------------------------------------------------MONTHLY TREND
--Monthly Admission Trend
SELECT 
    FORMAT(Date_of_Admission, 'yyyy-MM') AS Admission_Month,
    COUNT(*) AS Admissions
FROM healthcare_dataset
GROUP BY FORMAT(Date_of_Admission, 'yyyy-MM')
ORDER BY Admission_Month;