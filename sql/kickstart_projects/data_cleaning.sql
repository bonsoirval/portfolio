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
	SELECT id, name, category, main_category, currency, deadline, goal, launched, pledged, state, backers,
	country, 'usd pledged', usd_pledged_real, usd_goal_real
	FROM duplicate_cte
	WHERE row_num = 1; # select non duplicated values

-- 2. Standardize data
	-- stage projects1 as projects1_stage0
    -- create a stage table projects1_stage0
		drop table projects1_stage0;
		create table if not exists projects1_stage0 as select * from projects1;

		# confirm new table creation
		select * from projects1_stage0;

		-- remove leading spaces and trailing  ' " ' and effect this seen in first and second rows
		UPDATE projects1_stage0
		set name = trim(leading from (trim(trailing '"' from name)));

		# remove '""' in text
		update projects1_stage0 set name = regexp_replace(name, '["":]', '');

		# remove ““ in line 15, () in line 16, _ in line 64
		update projects1_stage0 set name = regexp_replace(name, '[“”()_]', '');

		# hand leading emerged leading " ' " in line 5 and " -| " in line 74, "\" in line 118
		update projects1_stage0 set name = regexp_replace(name,'[-|\']', '');

		# treat line 153
		update projects1_stage0 set name = regexp_replace(name, '–', '');

		# treat 154
		update projects1_stage0
		set name = regexp_replace(name,'—', '');

		# removing leading * in line 114
		update projects1_stage0  set name = regexp_replace(name, '\\*', '');
		# confirm query effect

		# remove ? in line 148
		update projects1_stage0 set name = regexp_replace(name, '\\?','');

		# remove $,¥ and © in line 148
		update projects1_stage0 set name = regexp_replace(name, '[¥$©]','');

		# remove !, ¡ and \  in lines 175, 190, 249 to 280, 299,',' in 310,  §o and ~ in line 321 
		# ¿ in line 369 to 379
		update projects1_stage0 set name = regexp_replace(name, '[\\\\!¡/.><!÷¨·,§o~¿]', '');
		select name, name from projects1_stage0;

-- 3 checking null values
	select * 
	from projects1_stage0
	where name is null or category is null or main_category is null or currency is null or deadline is null
	or goal is null or launched is null or state is null or backers is null or country is null or 'usd pledged' is null
	or usd_pledged_real is null or usd_goal_real is null;

	/* above shows only one null value. Will delete this entry*/
	delete from projects1_stage0 where name is null;

-- 4 check and drop columns with null values
	-- check columns with null values
	-- find columns that allow null values
    select column_name, is_nullable 
    from information_schema.columns
    where table_schema = 'kickstart_projects'
    and table_name = 'projects1_stage0'
    and is_nullable = 'yes';
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
    alter table projects_cleaned modify Column id int primary key unique not null;
    alter table projects_cleaned modify column name varchar(100) not null;
    alter table projects_cleaned modify column category varchar(100) not null;
    alter table projects_cleaned modify column main_category varchar(50) not null;
    alter table projects_cleaned modify column currency varchar(4) not null;
    alter table projects_cleaned modify column deadline date not null;
    alter table projects_cleaned modify column goal float not null;
    alter table projects_cleaned modify column launched datetime not null;
    alter table projects_cleaned modify column pledged float(10,2) not null;
    alter table projects_cleaned modify column state varchar(10) null;
    alter table projects_cleaned modify column backers int default 0;
    alter table projects_cleaned modify column country  varchar(4) not null;
    alter table projects_cleaned modify column `usd pledged` varchar(20) not null;
    alter table projects_cleaned modify column usd_pledged_real float(10,2) not null;
    alter table projects_cleaned modify column usd_goal_real real(10,2) not null;
