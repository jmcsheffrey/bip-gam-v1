-----------------------------------------------------------------------------
-- dev based queries
-----------------------------------------------------------------------------
-- run these separately, unless full output can be done by default
SHOW CREATE TABLE systems
SHOW CREATE TABLE users
SHOW CREATE TABLE import_students
SHOW CREATE TABLE import_employees
SHOW CREATE TABLE staging_students
SHOW CREATE TABLE staging_employees
SHOW CREATE TABLE groupings
SHOW CREATE TABLE groupings_users



-----------------------------------------------------------------------------
-- systems based queries
-----------------------------------------------------------------------------
-- select mac addresses for all windows workstations
select macaddresses
  --  , unique_id, machinename
  from systems
  where machineclass like '%workstation%' and ostype like '%windows%'
  order by macaddresses


-----------------------------------------------------------------------------
-- users based queries
-----------------------------------------------------------------------------
select * from staging_students where isnull(school_email) or school_email = ''
select * from staging_students where unique_id not in (select unique_id from users)
select * from staging_students where status = 'ACTIVE' and unique_id not in (select unique_id from users) order by grade DESC, school_email
select * from staging_students where grade in ('09','10','11','12') and status = 'ACTIVE' and unique_id not in (select unique_id from users) order by grade DESC, school_email

-- list students in existing data that do not have emails that are not in 3rd or 4th grade
select * from users
  where users.status = 'ACTIVE' and users.population = 'STU' and users.grade not in ('03','04') and (users.school_email = '' or isnull(users.school_email))

-- list all _NEW_ students between staging_students and users tables
select *
  from staging_students
  where grade in ('03','04','05','06','07','08','09','10','11','12') and status = 'ACTIVE' and unique_id not in (select unique_id from users)
  order by grade DESC, school_email

-- list user_name for students by truncating school_email
select school_email, substring(school_email,1,instr(school_email, '@')-1)
  from staging_students
  order by school_email

-- list all _NEW_ students for Google import
select first_name,last_name,school_email,"sscps123" as password,
    "" as Secondary_Email,"" as Work_Phone_1,"" as Home_Phone_1,"" as Mobile_Phone_1,"" as Work_address_1,"" as Home_address_1,unique_id
  from staging_students
  where grade in ('05','06','07','08','09','10','11','12') and status = 'ACTIVE' and unique_id not in (select unique_id from users)
  order by grade DESC, school_email

-- list all _NEW_ students for adding to groups or drive folders
select concat(school_email,char(44))
  from staging_students
  where grade in ('05','06','07','08','09','10','11','12') and status = 'ACTIVE' and unique_id not in (select unique_id from users)
  order by grade DESC, school_email

-- describe this!!!!
select
    users.unique_id,
    staging_students.status,
    'STU' as population,
    staging_students.first_name,
    staging_students.middle_name,
    staging_students.last_name,
    ??? as user_name,
    staging_students.school_email,
    staging_students.grade,
    staging_students.expected_grad_year,
    staging_students.homeroom,
    staging_students.referred_to_as,
    staging_students.gender,
    staging_students.birthdate,
    staging_students.entry_date,
    '' as position,
    concat ('SSCPS Grade ',staging_students.grade,' Student')
  from users
  join staging_students on users.unique_id = staging_students.unique_id


-- describe this!!!!
select concat(school_email,char(44))
  from staging_students
  where grade in ('09','10','11','12') and status = 'ACTIVE' and unique_id not in (select unique_id from users) order by grade DESC, school_email

-- describe this!!!!
select `unique_id`, `first_name`, `middle_name`, `last_name`,
  substring(concat(
    replace(replace(replace(replace(replace(lower(first_name),char(46),char(0)),char(45),char(0)),char(44),char(0)),char(39),char(0)),char(32),char(0))
    , '_'
    , replace(replace(replace(replace(replace(lower(last_name),char(46),char(0)),char(45),char(0)),char(44),char(0)),char(39),char(0)),char(32),char(0))
  ),1,21) as school_email_new
from staging_students

-- describe this!!!!
select `unique_id`, `first_name`, `middle_name`, `last_name`,
  substring(concat(
    substring(replace(replace(replace(replace(replace(lower(first_name),char(46),char(0)),char(45),char(0)),char(44),char(0)),char(39),char(0)),char(32),char(0)),1,1)
    , replace(replace(replace(replace(replace(lower(last_name),char(46),char(0)),char(45),char(0)),char(44),char(0)),char(39),char(0)),char(32),char(0))
  ),1,21) as school_email_new
from staging_employees
