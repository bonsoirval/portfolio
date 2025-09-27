/* 1. Define Your HR Analytics Goals */
-- Focusing on:
-- Best recruitment sources (where successful employees come from).
-- Demographics & diversity insights (gender, race, citizenship, state).
-- Employee retention patterns (who stays vs who leaves).
-- Performance & satisfaction drivers.

/* 2. Prepare the Data for SQL */
-- Data cleaning:
/* 1. Clean Data */ 
	-- 0. Copy table 
    -- 1. Remove duplicates
	-- 2. Standardize data
	-- 3. Remove null values
    -- 4. Drop columns or rows

-- 
-- 0. Copy table - avoiding working with original dataset
	DROP TABLE IF EXISTS hr_stage0;
	CREATE TABLE IF NOT EXISTS hr_stage0 AS SELECT * FROM hr;
    
-- 1. Remove duplicates
	-- a. Check if duplicate values exist
    -- no duplicates found : count of empid existing equals count of distinct empid
	SELECT COUNT(empid) - COUNT(DISTINCT empid) AS num_duplicates FROM hr_stage0;

    
-- 2. Standardize data
	desc hr_stage0; -- shows column names and datatypes are of good standard
    -- notice: Upper camel casing was used
    -- Employee_Name and LastPerformanceReview_Date do not conform to the upper camel casing naming. 
    -- Converting all to all lower and words separated by underscore
    ALTER TABLE hr_stage0
	RENAME COLUMN ﻿Employee_Name TO employee_name,
	RENAME COLUMN EmpID TO  emp_id,
	RENAME COLUMN MarriedID TO married_id,
	RENAME COLUMN MaritalStatusID TO marital_status_id,
	RENAME COLUMN GenderID TO gender_id,
	rename column EmpStatusID to emp_status_id, 
	RENAME COLUMN DeptID to dept_id, 
	RENAME COLUMN PerfScoreID to perf_score_id, 
	RENAME COLUMN FromDiversityJobFairID to from_diversity_job_fair_id, 
	RENAME COLUMN Salary to salary, 
	RENAME COLUMN Termd to term_d, 
	RENAME COLUMN PositionID to position_id, 
	RENAME COLUMN Position to position, 
	RENAME COLUMN State to state, 
	RENAME COLUMN Zip to zip, 
	RENAME COLUMN DOB to dob, 
	RENAME COLUMN Sex to sex, 
	RENAME COLUMN MaritalDesc to marital_desc, 
	RENAME COLUMN CitizenDesc to citizen_desc, 
	RENAME COLUMN HispanicLatino to hispanic_latino, 
	RENAME COLUMN RaceDesc to race_desc, 
	RENAME COLUMN DateofHire to date_of_hire, 
	RENAME COLUMN DateofTermination to date_of_termination, 
	RENAME COLUMN TermReason to term_reason, 
	RENAME COLUMN EmploymentStatus to employment_status,  
	RENAME COLUMN Department to department,  
	RENAME COLUMN ManagerName to manager_name,  
	RENAME COLUMN ManagerID to manager_id,  
	RENAME COLUMN RecruitmentSource to recruitment_source,  
	RENAME COLUMN PerformanceScore to performance_score,  
	RENAME COLUMN EngagementSurvey to engagement_survey,  
	RENAME COLUMN EmpSatisfaction to emp_satisfaaction, 
	RENAME COLUMN SpecialProjectsCount to special_projects_count, 
	RENAME COLUMN LastPerformanceReview_Date to last_performance_review_date, 
	RENAME COLUMN DaysLateLast30 to days_late_last_30, 
	RENAME COLUMN Absences TO absences;

-- select null values
-- empty resultset returned. no null values;
	select count(*) AS num_nulls
	from hr_stage0
	where  
	employee_name is null
	or emp_id is null
	or married_id is null 
	or marital_status_id is null 
	or gender_id is null
	or emp_status_id is null 
	or dept_id is null
	or perf_score_id is null 
	or from_diversity_job_fair_id is null 
	or salary is null
	or term_d is null 
	or position_id is null
	or position is null
	or state is null
	or zip is null
	or dob is null 
	or sex is null 
	or marital_desc is null 
	or citizen_desc is null 
	or hispanic_latino is null 
	or race_desc is null
	or date_of_hire is null 
	or date_of_termination is null 
	or term_reason is null 
	or employment_status is null 
	or department is null  
	or manager_name is null 
	or manager_id is null
	or recruitment_source is null 
	or performance_score is null 
	or engagement_survey is null 
	or emp_satisfaaction is null 
	or special_projects_count is null 
	or last_performance_review_date is null 
	or days_late_last_30 is null
	or absences is null;

	-- update and format dob values to date format
	-- dob
    update hr_stage0
	set dob =  regexp_replace(str_to_date(dob,'%m/%e/%Y'), '2051', '1951');
    -- date_of_hire
	update hr_stage0
	set date_of_hire =  regexp_replace(str_to_date(date_of_hire,'%m/%e/%Y'), '2051', '1951');
	-- date_of_termination
	update hr_stage0
	set date_of_termination =  regexp_replace(str_to_date(date_of_termination,'%m/%e/%Y'), '2051', '1951');
	-- last_performance_review_date
	update hr_stage0
	set last_performance_review_date =  regexp_replace(str_to_date(last_performance_review_date,'%m/%e/%Y'), '2051', '1951');
	
    -- Convert dates (DOB, DateofHire, DateofTermination) into SQL DATE.
    -- dob
	ALTER TABLE hr_stage0
	MODIFY COLUMN dob DATE;
	-- date_of_hire
	ALTER TABLE hr_stage0
	MODIFY COLUMN date_of_hire DATE;
    -- date_of_termination
    ALTER TABLE hr_stage0
	MODIFY COLUMN date_of_termination DATE;
    -- last_performance_review_date
    ALTER TABLE hr_stage0
	MODIFY COLUMN last_performance_review_date DATE;
	
    -- confirm date column types update
    desc hr_stage0;

	--  Ensuring categorical columns (Sex, RaceDesc, RecruitmentSource, Department) are normalized.
    -- trim string columns
	update hr_stage0
	set 
		employee_name = (employee_name), 
		position = trim(position), 
		state = trim(state), 
		sex = trim(sex), 
		marital_desc = trim(marital_desc), 
		citizen_desc =  trim(citizen_desc),  
		hispanic_latino = trim(hispanic_latino), 
		race_desc = trim(race_desc), 
		term_reason = trim(term_reason), 
		employment_status = trim(employment_status),
		department = trim(department), 
		manager_name = trim(manager_name),
		recruitment_source = trim(recruitment_source), 
		performance_score = trim(performance_score);


-- Create derived columns, e.g.:
-- Tenure = DateofTermination - DateofHire
-- Age = CurrentDate - DOB
	    -- Feature engineering. 
    -- adding calculated columns 
    -- tenure_in_month and tenure_in_year
	ALTER TABLE hr_stage0
    ADD COLUMN tenure_in_month int AFTER date_of_hire;
    ALTER TABLE hr_stage0
    ADD COLUMN tenure_in_year int AFTER date_of_hire;
    alter table hr_stage0
	add column age int after dob;
    
    -- populate tenure column
    update hr_stage0
    set tenure_in_month = TIMESTAMPDIFF(MONTH, date_of_hire, date_of_termination);
    update hr_stage0
    set tenure_in_year = TIMESTAMPDIFF(YEAR, date_of_hire, date_of_termination);
	update hr_stage0
    set age = TIMESTAMPDIFF(year, dob, curdate());
    
    
-- 3. SQL Queries for HR Insights

/* 4. Insights You Can Draw */
-- Which recruitment channels yield the best performers and lowest turnover.
-- Which departments struggle with high attrition or absenteeism.
-- Employee satisfaction trends across demographics.
-- Optimal salary ranges that attract and retain talent.
