-- create a stage table projects1_stage0
drop table projects1_stage0;
create table if not exists projects1_stage0 as select * from projects1;

# confirm new table creation
select * from projects1_stage0;

-- remove leading spaces and trailing  ' " ' and effect this seen in first and second rows
select name, trim(leading from (trim(trailing '"' from name))) as trimmed from projects1;
UPDATE projects1_stage0
set name = trim(leading from (trim(trailing '"' from name)));
# confirm removal of ' " '
select * from projects1_stage0;

# remove '""' in text
select name, regexp_replace(name, '["":]', '') from projects1_stage0;
update projects1_stage0 set name = regexp_replace(name, '["":]', '');
-- confirm 
select name, name from projects1_stage0;

# remove ““ in line 15, () in line 16, _ in line 64
select name, regexp_replace(name, '[“”()_]', '') from projects1_stage0;
update projects1_stage0 set name = regexp_replace(name, '[“”()_]', '');
# confirm effect
select name, name from projects1_stage0;

# hand leading emerged leading " ' " in line 5 and " -| " in line 74, "\" in line 118
select name, regexp_replace(name,'[-|\']', '') from projects1_stage0;
update projects1_stage0 set name = regexp_replace(name,'[-|\']', '');
select name, name from projects1_stage0;

# treat line 153
select name, regexp_replace(name, '–', '') from projects1_stage0;
update projects1_stage0 set name = regexp_replace(name, '–', '');
select name, name from projects1_stage0;

# treat 154
select name, regexp_replace(name,'—', '') from projects1_stage0;
update projects1_stage0
set name = regexp_replace(name,'—', '');
select name, name 
from projects1_stage0;

# removing leading * in line 114
select name, regexp_replace(name, '\\*','') from projects1_stage0;
update projects1_stage0  set name = regexp_replace(name, '\\*', '');
# confirm query effect

# remove ? in line 148
select name, regexp_replace(name, '\\?', '') from projects1_stage0;
update projects1_stage0 set name = regexp_replace(name, '\\?','');
select name, name from projects1_stage0;

# remove $,¥ and © in line 148
select name, regexp_replace(name, '[¥$©]', '') from projects1_stage0;
update projects1_stage0 set name = regexp_replace(name, '[¥$©]','');
select name, name from projects1_stage0;

# remove !, ¡ and \  in lines 175, 190, 249 to 280, 299,',' in 310,  §o and ~ in line 321 
# ¿ in line 369 to 379
select id, name, trim(regexp_replace(name, '[\\\\!¡/.><!÷¨·,§o~¿]', '')) as cleaned
from projects1_stage0;

update projects1_stage0 set name = regexp_replace(name, '[\\\\!¡/.><!÷¨·,§o~¿]', '');
select name, name from projects1_stage0;


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
    
    
    
    -- Standardize table
    /*, pledged, state, backers, country, usd_pledged_real,usd_goal_real,*/
    -- id
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
