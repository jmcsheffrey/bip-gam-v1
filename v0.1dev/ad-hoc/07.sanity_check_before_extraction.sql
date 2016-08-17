-- TODO
--  check for missing grade

-- ****************************************************
-- Scripts to run after update of staging tables.
-- ****************************************************
-- no users should exist as newthisrun and INACTIVE
-- results should be zero
select * from users where newthisrun = 'Y' and status = 'INACTIVE';

-- all users who are employees or students in grade 3 or above should have an email
select * from users
where (users.population = 'EMP' and users.school_email is null) or
      (users.population = 'STU' and grade in ('03','04','05','06','07','08','09','10','11','12') and users.school_email is null)
