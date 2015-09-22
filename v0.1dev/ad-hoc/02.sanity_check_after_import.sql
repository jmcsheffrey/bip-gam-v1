-- TODO
--  1.  check for malformed email addresses
--  2.  check for expected_grad_year that isn't YYYY

-- run these checks to see if data looks bad

-- no grades for students should be without leading zeros
-- results should be zero
select * from import_students where grade in ('3','4','5','6','7','8','9');

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
