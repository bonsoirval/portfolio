# remove ¥ and $ as in line 148
select name, regexp_replace(name, '¥$', '') from projects1_stage0;


