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
select name from projects1_stage0;

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
select name, regexp_replace(name, '[$¥\\?]', '') from projects1_stage0;
update projects1_stage0 set name = regexp_replace(name, '\\?','');
select name, name from projects1_stage0;

# remove $,¥ and © in line 148
select name, regexp_replace(name, '\\?', '') from projects1_stage0;
update projects1_stage0 set name = regexp_replace(name, '\\?','');
select name, name from projects1_stage0;
########################################################
here down not implemented yet
########################################################
# treat line 155, * in 166, ! in line 175, ¡ in line 191
select name, regexp_replace(name, '[,\[!\]¡]','') from projects1_stage0;
























select name, trim(name) as worked_on from projects1_stage0;
update projects1_stage0 set name = trim(leading '"' from name); 
select name, name from projects1_stage0;

update projects1_stage0 set name = trim(leading "'" from name);
select name, name from projects1_stage0;

update projects1_stage0 set name = trim(leading "_" from name);
select name from projects1_stage0;

update projects1_stage0 set name = regexp_replace(name, "-", '');
select name, name as worked_on from projects1_stage0; 

update projects1_stage0 set name = regexp_replace(trim(name), "|", ''); -- 2. removes spaces surrounding |
select name, name  as worked_on from projects1_stage0;

update projects1_stage0 set name = regexp_replace(name, "-", ''); -- 3. removes all dashes. 
select name, name  as worked_on from projects1_stage0;

update projects1_stage0 set name = regexp_replace(name, '[?\*]', ''); -- 4. removes '? \"
select name, name  as worked_on from projects1_stage0;

update projects1_stage0 set name = regexp_replace(name, '—','');
select name from projects1_stage0;

update projects1_stage0 set name = regexp_replace(name, ',', '');
select name from projects1_stage0;

update projects1_stage0 set name = regexp_replace(name, '¡', ''); -- 5. removes ':'
select name, name  as worked_on from projects1_stage0;

update projects1_stage0 set name = regexp_replace(name, '¡', ''); -- 5. removes ':'
select name, name  as worked_on from projects1_stage0;

update projects1_stage0 set name = trim(regexp_replace(name, '!', ''));
select name, name from projects1_stage0;

update projects1_stage0 set name = trim(regexp_replace(name, '/', ''));
select name, name from projects1_stage0;

update projects1_stage0 set name = trim(regexp_replace(name, '[</>|"\'÷().]', ''));
select name, name from projects1_stage0;
-- $$$$$$$$$$$$$$$$$$$$
update projects1_stage0 set name = egexp_replace(name, '¡', ''); -- 6. removes "¡"
select name, name  as worked_on from projects1_stage0;

update projects1_stage0 set name = regexp_replace(name, '¿', '');-- 7. remvoes "¿" 
select name, name  as worked_on from projects1_stage0;

update projects1_stage0 set name = regexp_replace(name, '¿', '');-- 7. remvoes "¿" 
select name, trim(leading '.' from name) as worked_on from projects1_stage0;
select name, regexp_replace(name, '', '') as worked_on from projects1_stage0;
select name, regexp_replace(name, '¿', '') as worked_on from projects1_stage0;
select name, name  as worked_on from projects1_stage0;

select name, regexp_replace(name, '¿', '') as worked_on from projects1_stage0;
select name, name  as worked_on from projects1_stage0;
