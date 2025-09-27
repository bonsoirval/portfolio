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
	-- produce projects1 as the output table
	# persisted table with unduplicated values
	CREATE TABLE projects1 AS 
	# use row_number() to find duplicates
	WITH duplicate_cte AS (
		SELECT *, 
		ROW_NUMBER() OVER (PARTITION BY name ORDER BY name) as row_num
		FROM projects0
	)
	# select needed columns from the common table expression - cte
	SELECT 
		id,
		name,
		category,
		main_category,
		currency,
		deadline,
		goal,
		launched,
		pledged,
		state,
		backers,
		country,
		'usd pledged',
		usd_pledged_real,
		usd_goal_real
	FROM
		duplicate_cte
	WHERE
		row_num = 1; # select non duplicated values

-- 2. Standardize data
	-- stage projects1 as projects1_stage0
    -- create a stage table projects1_stage0
		DROP TABLE IF EXISTS projects1_stage0;
		CREATE TABLE IF NOT EXISTS projects1_stage0 
        AS 
        SELECT * 
        FROM projects1;

		# confirm new table creation
		SELECT 
			*
		FROM
			projects1_stage0;

		-- remove leading spaces and trailing  ' " ' and effect this seen in first and second rows
		UPDATE projects1_stage0
		SET name = TRIM(LEADING FROM (TRIM(TRAILING '"' FROM name)));

		# remove '""' in text
		UPDATE projects1_stage0 SET name = REGEXP_REPLACE(name, '["":]', '');

		# remove ““ in line 15, () in line 16, _ in line 64
		UPDATE projects1_stage0 SET name = REGEXP_REPLACE(name, '[“”()_]', '');

		# hand leading emerged leading " ' " in line 5 and " -| " in line 74, "\" in line 118
		UPDATE projects1_stage0 SET name = REGEXP_REPLACE(name,'[-|\']', '');

		# treat line 153
		UPDATE projects1_stage0 SET name = REGEXP_REPLACE(name, '–', '');

		# treat 154
		UPDATE projects1_stage0
		SET name = REGEXP_REPLACE(name,'—', '');

		# removing leading * in line 114
		UPDATE projects1_stage0 SET name = REGEXP_REPLACE(name, '\\*', '');
		# confirm query effect

		# remove ? in line 148
		UPDATE projects1_stage0 SET name = REGEXP_REPLACE(name, '\\?','');

		# remove $,¥ and © in line 148
		UPDATE projects1_stage0 SET name = REGEXP_REPLACE(name, '[¥$©]','');

		# remove !, ¡ and \  in lines 175, 190, 249 to 280, 299,',' in 310,  §o and ~ in line 321 
		# ¿ in line 369 to 379
		UPDATE projects1_stage0 SET name = REGEXP_REPLACE(name, '[\\\\!¡/.><!÷¨·,§o~¿]', '');
		SELECT name, name FROM projects1_stage0;

-- 3 checking null values
	SELECT 
		*
	FROM
		projects1_stage0
	WHERE
		name IS NULL OR category IS NULL
			OR main_category IS NULL
			OR currency IS NULL
			OR deadline IS NULL
			OR goal IS NULL
			OR launched IS NULL
			OR state IS NULL
			OR backers IS NULL
			OR country IS NULL
			OR 'usd pledged' IS NULL
			OR usd_pledged_real IS NULL
			OR usd_goal_real IS NULL;

	/* above shows only one null value. Will delete this entry*/
	DELETE FROM projects1_stage0 
	WHERE
		name IS NULL;

-- 4 check and drop columns with null values
	-- check columns with null values
	-- find columns that allow null values
	SELECT 
		COLUMN_NAME, is_nullable
	FROM
		information_schema.columns
	WHERE
		table_schema = 'kickstart_projects'
			AND table_name = 'projects1_stage0'
			AND is_nullable = 'yes';
    /* all columns, listed below allow null values. 
    id, name, category, main_category, currency,deadline, 
    goal, launched, pledged, state, backers, country, usd_pledged_real,
    usd_goal_real,
    */
    -- count null values in the columns
    SELECT COUNT(*) 
    FROM projects1_stage0
    WHERE usd_goal_real IS NULL;
    
    -- after running the above script and all the columns returned 0, it is confirmed that no null value(s) exist

-- 5 create projects_cleaned table after cleaning the table
CREATE TABLE IF NOT EXISTS projects_cleaned AS SELECT * FROM projects1_stage0;

-- Standardize table
	/* modify and correct column datatypes to suit content */
    ALTER TABLE projects_cleaned MODIFY COLUMN id INT PRIMARY KEY UNIQUE NOT NULL;
    ALTER TABLE projects_cleaned MODIFY COLUMN name VARCHAR(100) NOT NULL;
    ALTER TABLE projects_cleaned MODIFY COLUMN category VARCHAR(100) NOT NULL;
    ALTER TABLE projects_cleaned MODIFY COLUMN main_category VARCHAR(50) NOT NULL;
    ALTER TABLE projects_cleaned MODIFY COLUMN currency VARCHAR(4) NOT NULL;
    ALTER TABLE projects_cleaned MODIFY COLUMN deadline DATE NOT NULL;
    ALTER TABLE projects_cleaned MODIFY COLUMN goal FLOAT NOT NULL;
    ALTER TABLE projects_cleaned MODIFY COLUMN launched DATETIME NOT NULL;
    ALTER TABLE projects_cleaned MODIFY COLUMN pledged FLOAT(10,2) NOT NULL;
    ALTER TABLE projects_cleaned MODIFY COLUMN state VARCHAR(10) NULL;
    ALTER TABLE projects_cleaned MODIFY COLUMN backers INT DEFAULT 0;
    ALTER TABLE projects_cleaned MODIFY COLUMN country  VARCHAR(4) NOT NULL;
    ALTER TABLE projects_cleaned MODIFY COLUMN `usd pledged` VARCHAR(20) NOT NULL;
    ALTER TABLE projects_cleaned MODIFY COLUMN usd_pledged_real FLOAT(10,2) NOT NULL;
    ALTER TABLE projects_cleaned MODIFY COLUMN usd_goal_real REAL(10,2) NOT NULL;
    ALTER TABLE projects_cleaned MODIFY COLUMN usd_goal_real REAL(10,2) NOT NULL;
    ALTER TABLE projects_cleaned MODIFY COLUMN usd_goal_real REAL(10,2) NOT NULL;
    ALTER TABLE projects_cleaned MODIFY COLUMN usd_goal_real REAL(10,2) NOT NULL;
    ALTER TABLE projects_cleaned MODIFY COLUMN usd_goal_real REAL(10,2) NOT NULL;

