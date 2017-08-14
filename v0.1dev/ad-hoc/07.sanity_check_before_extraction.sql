-- ****************************************************
-- Scripts to run after final tables updated.
-- ****************************************************

-------------------------
-- SCRIPTS FOR ALL USERS
-------------------------
-- no users should exist as newthisrun and INACTIVE
-- results should be zero
select 'ERROR:  New user created but marked INACTIVE.'  as error_desc
    , unique_id, first_name, last_name, school_email
  from users where newthisrun = 'Y' and status = 'INACTIVE';

-- no users should exist as ACTIVE without email
-- results should be zero
select 'ERROR:  User exists with no school_email.'  as error_desc
    , unique_id, first_name, last_name, school_email
  from users where status = 'ACTIVE' and school_email = '';
select 'ERROR:  User exists with no school_email.'  as error_desc
    , unique_id, first_name, last_name, school_email
  from users where status = 'ACTIVE' and school_email = null;

-- no users should exist as ACTIVE without current_year_id (bad for groupings)
-- results should be zero
select 'ERROR:  User exists with current_year_id.'  as error_desc
    , unique_id, first_name, last_name, current_year_id
  from users where status = 'ACTIVE' and current_year_id = '';
select 'ERROR:  User exists with current_year_id.'  as error_desc
    , unique_id, first_name, last_name, current_year_id
  from users where status = 'ACTIVE' and current_year_id = null;

-- all users who are employees or students in grade 3 or above should have an email
-- results should be zero
select 'ERROR:  Employee or student Level II or above does not have email.'  as error_desc
    , unique_id, first_name, last_name, population, grade, school_email
  from users
  where (users.population = 'EMP' and users.school_email is null)
        or (users.population = 'STU' and grade in ('03','04','05','06','07','08','09','10','11','12') and users.school_email is null);


-------------------------
-- SCRIPTS FOR STUDENTS
-------------------------


-------------------------
-- SCRIPTS FOR EMPLOYEES
-------------------------
