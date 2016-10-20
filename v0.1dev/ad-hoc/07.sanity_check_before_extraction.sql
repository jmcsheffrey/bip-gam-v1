-- ****************************************************
-- Scripts to run after final tables updated.
-- ****************************************************
-- TODO
--  check for missing grade



-------------------------
-- SCRIPTS FOR ALL USERS
-------------------------
-- no users should exist as newthisrun and INACTIVE
-- results should be zero
select * from users where newthisrun = 'Y' and status = 'INACTIVE';

-- no users should exist as ACTIVE without email
-- results should be zero
select * from users where status = 'ACTIVE' and school_email = '';
select * from users where status = 'ACTIVE' and school_email = null;

-- no users should exist as ACTIVE without current_year_id (bad for groupings)
-- results should be zero
select * from users where status = 'ACTIVE' and current_year_id = '';
select * from users where status = 'ACTIVE' and current_year_id = null;

-- all users who are employees or students in grade 3 or above should have an email
-- results should be zero
select * from users
where (users.population = 'EMP' and users.school_email is null) or
      (users.population = 'STU' and grade in ('03','04','05','06','07','08','09','10','11','12') and users.school_email is null)

-------------------------
-- SCRIPTS FOR STUDENTS
-------------------------
-- for Naviance, all High School students should have expected_grad_year
-- results should be zero
select * from users
where users.population = 'STU'
  and grade in ('09','10','11','12')
  and users.expected_grad_year = ''
  and status = 'ACTIVE'
