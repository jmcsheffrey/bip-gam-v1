-- don't ever empty import_ tables until process is done, only do it when importing
-- stuff below is for "down & dirty" direct workings on the database

-- remove any data from previous runs
truncate staging_students;
truncate staging_employees;

-- move appropriate data from import_ tables to stagin_ tables
insert into staging_students
  select `PKEY`, `APID`, `full_name`, `unique_id`, `status`, `first_name`, `middle_name`, `last_name`,
    `school_email`, `grade`, `homeroom`, `referred_to_as`, `gender`,
    STR_TO_DATE(`birthdate`,'%m/%d/%Y'),
    STR_TO_DATE(`entry_date`,'%m/%d/%Y')
  from import_students
  where grade in ('03','04','05','06','07','08','09','10','11','12')
  order by grade, last_name, first_name, middle_name;
insert into staging_employees
  select `PKEY`, `APID`, `full_name`, `unique_id`, `status`, `first_name`, `middle_name`, `last_name`,
    `school_email`, `homeroom`, `referred_to_as`, `gender`,
    STR_TO_DATE(`birthdate`,'%m/%d/%Y'),
    STR_TO_DATE(`date_of_hire`,'%m/%d/%Y'),
    position
  from import_employees
  order by last_name, first_name, middle_name;

-- add school_email for those that don't exist
update staging_students
  set school_email =
    concat(substring(concat(
      replace(replace(replace(replace(replace(lower(first_name),char(46),char(0)),char(45),char(0)),char(44),char(0)),char(39),char(0)),char(32),char(0))
      , '_'
      , replace(replace(replace(replace(replace(lower(last_name),char(46),char(0)),char(45),char(0)),char(44),char(0)),char(39),char(0)),char(32),char(0))
    ),1,21), '@student.sscps.org')
  where isnull(school_email) or school_email = ''

select * from staging_students where isnull(school_email) or school_email = ''
select * from staging_students where unique_id not in (select unique_id from users)
select * from staging_students where status = 'ACTIVE' and unique_id not in (select unique_id from users) order by grade DESC, school_email
select * from staging_students where grade in ('09','10','11','12') and status = 'ACTIVE' and unique_id not in (select unique_id from users) order by grade DESC, school_email
select first_name,last_name,school_email,"sscps123" as password,
    "" as Secondary_Email,"" as Work_Phone_1,"" as Home_Phone_1,"" as Mobile_Phone_1,"" as Work_address_1,"" as Home_address_1,unique_id
  from staging_students
  where grade in ('09','10','11','12') and status = 'ACTIVE' and unique_id not in (select unique_id from users) order by grade DESC, school_email
select concat(school_email,char(44))
  from staging_students
  where grade in ('09','10','11','12') and status = 'ACTIVE' and unique_id not in (select unique_id from users) order by grade DESC, school_email

select `unique_id`, `first_name`, `middle_name`, `last_name`,
  substring(concat(
    replace(replace(replace(replace(replace(lower(first_name),char(46),char(0)),char(45),char(0)),char(44),char(0)),char(39),char(0)),char(32),char(0))
    , '_'
    , replace(replace(replace(replace(replace(lower(last_name),char(46),char(0)),char(45),char(0)),char(44),char(0)),char(39),char(0)),char(32),char(0))
  ),1,21) as school_email_new
from staging_students

select `unique_id`, `first_name`, `middle_name`, `last_name`,
  substring(concat(
    substring(replace(replace(replace(replace(replace(lower(first_name),char(46),char(0)),char(45),char(0)),char(44),char(0)),char(39),char(0)),char(32),char(0)),1,1)
    , replace(replace(replace(replace(replace(lower(last_name),char(46),char(0)),char(45),char(0)),char(44),char(0)),char(39),char(0)),char(32),char(0))
  ),1,21) as school_email_new
from staging_employees
