select * from hr_stage0;
select count(empid) from hr_stage0;
select count(distinct empid) from hr_stage0;

desc hr_stage0;
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
select *
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

-- employee_name
-- position, sex,

-- dates : dob, date_of_hire, last_performance_review_date




alter table hr_stage0
modify column last_performance_review_date DATE;

alter table hr_stage0
modify column date_of_termination DATE;


desc hr_stage0;




SELECT STR_TO_DATE(last_performance_review_date, '%m/%d/%y') from hr_stage0;
SELECT STR_TO_DATE(date_of_termination, '%m/%d/%y') from hr_stage0;
select * from hr_stage0;
desc hr_stage0;
/*, , , , , , ,
, , term_reason, emplooyment_status, department, manager_name,
, performance_score, last_performance_review_date
*/
-- trim values
employee_name, 
emp_id, 
married_id, 
marital_status_id, 
gender_id, 
emp_status_id, 
dept_id, 
perf_score_id, 
from_diversity_job_fair_id, 
salary, 
term_d, 
position_id, 
position, 
state, 
zip, 
dob, 
sex, 
marital_desc, 
citizen_desc, 
hispanic_latino, 
race_desc, 
date_of_hire, 
date_of_termination, 
term_reason, 
employment_status, 
department, 
manager_name, 
manager_id, 
recruitment_source, 
performance_score, 
engagement_survey, 
emp_satisfaaction, 
special_projects_count, 
last_performance_review_date, 
days_late_last_30, 
absences

desc hr_stage0;
select * from hr;