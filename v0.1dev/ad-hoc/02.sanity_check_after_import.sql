-- ****************************************************
-- Run these two before importing data
-- ****************************************************
truncate import_students;
truncate import_employees;
truncate import_contacts;
truncate import_courses;
truncate import_sections;
truncate import_schedules;

---------------------------------------
-- SCRIPTS FOR STUDENTS (after import)
---------------------------------------
-- double/triple/quadruple check for conflicting fields that are supposed to be unique
-- results should be zero
select 'ERROR: duplicate unique_id.' as error_desc
    , unique_id, count
  from (select unique_id, count(unique_id) as count
          from import_students
          group by unique_id) as sumtable
  where count > 1;
select 'ERROR: duplicate school_email.' as error_desc
    , school_email, count
  from (select school_email, count(school_email) as count
          from import_students
          where school_email != '' and not (school_email is null)
          group by school_email) as sumtable
  where count > 1;

-- all high school students should have a graduating year of correct format
-- results should be zero
select 'ERROR:  Malformed expected graduation year.' as error_desc, unique_id, APID, full_name, expected_grad_year from import_students
  where length(expected_grad_year) < 4 and length(expected_grad_year) > 0;
select 'ERROR:  Malformed expected graduation year.' as error_desc, unique_id, APID, full_name, expected_grad_year from import_students
  where (not (upper(expected_grad_year) REGEXP '^-?[0-9]+$')) and length(expected_grad_year) > 0;

-- grades for students should always have leading zeros
-- results should be zero
select 'ERROR:  Malformed grade.'  as error_desc, unique_id, APID, full_name, grade from import_students where grade in ('K','k','1','2','3','4','5','6','7','8','9');
select 'ERROR:  Malformed grade.'  as error_desc, unique_id, APID, full_name, grade from import_students where grade not in ('0K','01','02','03','04','05','06','07','08','09','10','11','12');

-- homerooms for ACTIVE students should be 3 digit room number
-- results should be zero
select 'ERROR:  Malformed homeroom.'  as error_desc, unique_id, APID, full_name, homeroom from import_students where status = 'ACTIVE' and not (upper(homeroom) REGEXP '^-?[0-9]+$');

-- check for people in users and in import, but don't have emails in import, but do in users
-- results should be zero
select 'ERROR:  School email in USERS table, but not in IMPORT_ table.'  as error_desc,
  users.unique_id, users.first_name, users.last_name, users.school_email as existing_email, import.school_email as new_email
from import_students as import
inner join users on import.unique_id = users.unique_id
where users.school_email != '' and import.school_email = '';

-- check for school_email that is non-empty & different between users and import_
-- results should be zero
select 'ERROR:  School email differs between USERS table and IMPORT_ table.'  as error_desc,
    users.unique_id, users.first_name, users.last_name, users.school_email as existing_email, import.school_email as new_email
  from users
  left join import_students as import on users.unique_id = import.unique_id
  where users.school_email != import.school_email and import.school_email != '';

-- NOT NEEDED because of new way to generate student login/email
-- check for names with more then even chance of being problematic
-- results should be zero
-- select 'WARNING:  Name may cause problems with login or email.'  as error_desc,
--    unique_id, APID, first_name, last_name
--  from import_students as import
--  where length(concat(import.first_name,import.last_name)) > 19
--    and import.school_email is NULL
--    and import.status != 'INACTIVE';

-- check for bad phone numbers, format is ###-###-####
-- results shoudl be zero
select 'ERROR:  PHONE_HOME field is malformed.' as error_desc,
    import.PKEY
    , import.APID
    , import.unique_id
    , import.full_name
    , import.phone_home
  from import_students as import
  where import.phone_home not REGEXP '[0-9]{3}-[0-9]{3}-[0-9]{4}'
    and import.phone_home != "";
select 'ERROR:  PHONE_CELL field is malformed.' as error_desc,
    import.PKEY
    , import.APID
    , import.unique_id
    , import.full_name
    , import.phone_cell
  from import_students as import
  where import.phone_cell not REGEXP '[0-9]{3}-[0-9]{3}-[0-9]{4}'
    and import.phone_cell != "";

---------------------------------------
-- SCRIPTS FOR EMPLOYEES (after import)
---------------------------------------
-- homerooms for ACTIVE employees should be 3 digit room number, or "OFF" or "A" & then number, or NURSE or RECEPT
-- results should be zero
--homerooms are not needed anymore
--select *
--  from import_employees
--  where (
--    (not (upper(homeroom) REGEXP '^-?[0-9]+$'))
--     and
--    ((substring(upper(homeroom),1,1) != 'A')
--      and (substring(upper(homeroom),1,3) != 'OFF')
--      and (substring(upper(homeroom),1,5) != 'NURSE')
--      and (substring(upper(homeroom),1,6) != 'RECEPT')
--    )
--     and
--    (status = 'ACTIVE')
--  );
-- double/triple/quadruple check for conflicting fields that are supposed to be unique
-- results should be zero
select 'ERROR: duplicate unique_id.' as error_desc
    , unique_id, count
  from (select unique_id, count(unique_id) as count
          from import_employees
          group by unique_id) as sumtable
  where count > 1;
select 'ERROR: duplicate school_email.' as error_desc
    , school_email, count
  from (select school_email, count(school_email) as count
          from import_employees
          where school_email != '' and not (school_email is null)
          group by school_email) as sumtable
  where count > 1;

-- check for people in users and in import, but don't have emails in import, but do in users
-- results should be zero
select 'ERROR:  School email in USERS table, but not in IMPORT_ table.' as error_desc,
  users.unique_id, users.first_name, users.last_name, users.school_email as existing_email, import.school_email as new_email
from import_employees as import
inner join users on import.unique_id = users.unique_id
where users.school_email != '' and import.school_email = '';

-- check for school_email that is non-empty & different between users and import_
-- results should be zero
select 'ERROR:  School email differs between USERS table and IMPORT_ table.'  as error_desc,
    users.unique_id, users.first_name, users.last_name, users.school_email as existing_email, import.school_email as new_email
  from users
  left join import_employees as import on users.unique_id = import.unique_id
  where users.school_email != import.school_email and import.school_email != '';

-- check for names with more then even chance of being problematic
-- results should be zero
select  'WARNING:  Name may cause problems with login or email.'  as error_desc,
    unique_id, APID, first_name, last_name
  from import_employees as import
  where length(concat(import.first_name,import.last_name)) > 19
    and import.school_email is NULL
    and import.status != 'INACTIVE';

-- check for bad phone numbers, format is ###-###-####
-- results shoudl be zero
select 'ERROR:  PHONE_HOME field is malformed.' as error_desc,
    import.PKEY
    , import.APID
    , import.unique_id
    , import.full_name
    , import.phone_home
  from import_employees as import
  where import.phone_home not REGEXP '[0-9]{3}-[0-9]{3}-[0-9]{4}'
    and import.phone_home != "";
select 'ERROR:  PHONE_CELL field is malformed.' as error_desc,
    import.PKEY
    , import.APID
    , import.unique_id
    , import.full_name
    , import.phone_cell
  from import_employees as import
  where import.phone_cell not REGEXP '[0-9]{3}-[0-9]{3}-[0-9]{4}'
    and import.phone_cell != "";

-------------------------
-- SCRIPTS FOR GROUPINGS
-------------------------
-- no courses with something scheduled should be missing display_name
--results should be zero
select 'ERROR: missing course name.' as error_desc
    , import_courses.name, 
