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
-- check if students have bad expected graduation year
-- results should be zero
select * from import_students
  where length(expected_grad_year) < 4 and length(expected_grad_year) > 0;
select * from import_students
  where (not (upper(expected_grad_year) REGEXP '^-?[0-9]+$')) and length(expected_grad_year) > 0;

-- grades for students should always have leading zeros
-- results should be zero
select * from import_students where grade in ('K','k','1','2','3','4','5','6','7','8','9');
select * from import_students where grade not in ('0K','01','02','03','04','05','06','07','08','09','10','11','12');

-- homerooms for ACTIVE students should be 3 digit room number
-- results should be zero
select * from import_students where status = 'ACTIVE' and not (upper(homeroom) REGEXP '^-?[0-9]+$');

-- all high school students should have a graduating year
-- results should be zero
select *
  from import_students
  where grade in ('09','10','11','12')
    and (expected_grad_year is null or expected_grad_year = '');


-- check for people in users and in import, but don't have emails in import, but do in users
-- results should be zero
select
  users.unique_id, users.first_name, users.last_name, users.school_email as existing_email, import.school_email as new_email
from import_students as import
inner join users on import.unique_id = users.unique_id
where users.school_email != '' and import.school_email = '';


-- check for school_email that is non-empty & different between users and import_
-- results should be zero
select users.unique_id, users.first_name, users.last_name, users.school_email as existing_email, import.school_email as new_email
  from users
  left join import_students as import on users.unique_id = import.unique_id
  where users.school_email != import.school_email and import.school_email != '';

-- check for names with more then even chance of being problematic
-- results should be zero
select *
  from import_students as import
  left join users on import.unique_id = users.unique_id
  where length(concat(import.first_name,import.last_name)) > 19
    and import.school_email = NULL
    and import.status != 'INACTIVE';

-- for Naviance, all High School students should have expected_grad_year
-- results should be zero
select * from users
where users.population = 'STU'
  and grade in ('09','10','11','12')
  and users.expected_grad_year = ''
  and status = 'ACTIVE';

-- check for bad phone numbers, format is ###-###-####
-- results shoudl be zero
select
    import.PKEY
    , import.APID
    , import.unique_id
    , import.full_name
    , import.phone_home
  from import_students as import
  where import.phone_home not REGEXP '[0-9]{3}-[0-9]{3}-[0-9]{4}'
    and import.phone_home != "";
select
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

-- check for people in users and in import, but don't have emails in import, but do in users
-- results should be zero
select
  users.unique_id, users.first_name, users.last_name, users.school_email as existing_email, import.school_email as new_email
from import_employees as import
inner join users on import.unique_id = users.unique_id
where users.school_email != '' and import.school_email = '';

-- check for school_email that is non-empty & different between users and import_
-- results should be zero
select users.unique_id, users.first_name, users.last_name, users.school_email as existing_email, import.school_email as new_email
  from users
  left join import_employees as import on users.unique_id = import.unique_id
  where users.school_email != import.school_email and import.school_email != '';

-- check for names with more then even chance of being problematic
-- results should be zero
select *
  from import_employees as import
  left join users on import.unique_id = users.unique_id
  where length(concat(import.first_name,import.last_name)) > 19
    and import.school_email = NULL
    and import.status != 'INACTIVE';

-- check for bad phone numbers, format is ###-###-####
-- results shoudl be zero
select
    import.PKEY
    , import.APID
    , import.unique_id
    , import.full_name
    , import.phone_home
  from import_employees as import
  where import.phone_home not REGEXP '[0-9]{3}-[0-9]{3}-[0-9]{4}'
    and import.phone_home != "";
select
    import.PKEY
    , import.APID
    , import.unique_id
    , import.full_name
    , import.phone_cell
  from import_employees as import
  where import.phone_cell not REGEXP '[0-9]{3}-[0-9]{3}-[0-9]{4}'
    and import.phone_cell != "";
