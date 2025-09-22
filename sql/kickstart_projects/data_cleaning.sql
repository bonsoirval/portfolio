-- project steps
/* 1. Clean Data */ 
	-- 0. Copy table 
    -- 1. Remove duplicates
	-- 2. Standardize data
	-- 3. Remove null values
    -- 4. Drop columns or rows

-- 
-- 0. Copy table - avoiding working with original dataset
CREATE TABLE if not exists projects0 AS
SELECT *
FROM projects;

-- 1. Remove duplicates
# persisted table with unduplicated values
CREATE TABLE projects1 AS 
# use row_number() to find duplicates
WITH duplicate_cte AS (
	SELECT *, 
    ROW_NUMBER() OVER (PARTITION BY name ORDER BY name) as row_num
    FROM projects0
)
# select needed columns from the common table expression - cte
SELECT id, name, category, main_category, currency, deadline, goal, launched, pledged, state, backers,
country, 'usd pledged', usd_pledged_real, usd_goal_real
FROM duplicate_cte
WHERE row_num = 1; # select non duplicated values

-- 2. Standardize data

-- checking null values
select * 
from projects0 
where name is null or category is null or main_category is null or currency is null or deadline is null
or goal is null or launched is null or state is null or backers is null or country is null or 'usd pledged' is null
or usd_pledged_real is null or usd_goal_real is null;

/* above shows only one null value. Will delete this entry*/
delete from projects0 where name is null;
