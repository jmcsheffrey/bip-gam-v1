-- TODO
--  1.  check for malformed email addresses
--  2.  check for expected_grad_year that isn't YYYY


-- Run these two before importing data
truncate import_students;
truncate import_employees;

-- SCRIPTS TO RUN (after import)
-- check for bad grade year
-- results should be zero
select * from import_students
  where length(expected_grad_year) < 4
select * from import_students
  where not (upper(expected_grad_year) REGEXP '^-?[0-9]+$');

-- no grades for students should be without leading zeros
-- results should be zero
select * from import_students where grade in ('K','k','1','2','3','4','5','6','7','8','9');

-- homerooms for ACTIVE students should be 3 digit room number
-- results should be zero
select * from import_students where status = 'ACTIVE' and not (upper(homeroom) REGEXP '^-?[0-9]+$');

-- homerooms for employees should be 3 digit room number, or "OFF" or "A" & then number
-- results should be zero
select *
  from import_employees
  where (
    (not (upper(homeroom) REGEXP '^-?[0-9]+$'))
     and
    ((substring(upper(homeroom),1,1) != 'A')
      and (substring(upper(homeroom),1,3) != 'OFF')
      and (substring(upper(homeroom),1,5) != 'NURSE')
      and (substring(upper(homeroom),1,6) != 'RECEPT')
    )
  );

-- check for school_email that is non-empty & different between users and import_
-- results should be zero
select *
  from users
  join import_students on users.unique_id = import_students.unique_id
  where users.school_email != import_students.school_email;
-- results should be zero
select *
  from users
  join import_employees on users.unique_id = import_employees.unique_id
  where users.school_email != import_employees.school_email;

-- check for names with more then even chance of being problematic
-- results should be zero
select *
  from import_students
  join users on import_students.unique_id = users.unique_id
  where length(concat(import_students.first_name,import_students.last_name)) > 19
    and import_students.school_email = NULL
    and import_students.status != 'INACTIVE'
-- results should be zero
select *
  from import_employees
  join users on import_employees.unique_id = users.unique_id
  where length(concat(import_employees.first_name,import_employees.last_name)) > 19
    and import_employees.school_email = NULL
    and import_employees.status != 'INACTIVE'

-- check for malformed email addresses
-- results should be zero
