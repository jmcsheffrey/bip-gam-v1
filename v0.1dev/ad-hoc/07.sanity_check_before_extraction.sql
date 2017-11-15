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
  from users where status = 'ACTIVE'
    and population in ('EMP', 'STU')
    and school_email = '';
select 'ERROR:  User exists with no school_email.'  as error_desc
    , unique_id, first_name, last_name, school_email
  from users where status = 'ACTIVE'
    and population in ('EMP', 'STU')
    and school_email is null;

-- no users should exist as ACTIVE without current_year_id (bad for groupings)
-- results should be zero
select 'ERROR:  User exists without current_year_id.'  as error_desc
    , unique_id, first_name, last_name, current_year_id
  from users where status = 'ACTIVE'
    and population in ('EMP', 'STU')
    and not (left(unique_id,3) = 'OTH' or left(unique_id,3) = 'TST')
    and (current_year_id = '' or current_year_id is null);

-- all users who are employees or students in grade 3 or above should have an email
-- results should be zero
select 'ERROR:  Employee or student Level II+ does not have email.'  as error_desc
    , unique_id, first_name, last_name, population, grade, school_email
  from users
  where (users.population = 'EMP' and users.school_email is null)
    or (users.population = 'STU'
        and grade in ('03','04','05','06','07','08','09','10','11','12')
        and users.school_email is null);

-- all users who are employees or students in grade 3 or above should have an profile_server
-- results should be zero
select 'ERROR:  Employee or student Level II+ does not have profile_server.' as error_desc
    , unique_id, first_name, last_name, population, grade, profile_server, school_email
  from users
  where (users.population = 'EMP' and users.profile_server is null)
    or (users.population = 'STU'
        and grade in ('03','04','05','06','07','08','09','10','11','12')
        and users.profile_server is null);


-- double/triple/quadruple check for conflicting fields that are supposed to be unique
-- results should be zero
select 'ERROR: duplicate unique_id.' as error_desc
    , unique_id, count
  from (select unique_id, count(unique_id) as count
          from users
          group by unique_id) as sumtable
  where count > 1;
select 'ERROR: duplicate school_email.' as error_desc
    , school_email, count
  from (select school_email, count(school_email) as count
          from users
          group by unique_id) as sumtable
  where count > 1;
select 'ERROR: duplicate user_name.' as error_desc
    , user_name, count
  from (select user_name, count(user_name) as count
          from users
          group by unique_id) as sumtable
  where count > 1;

-- ======================
-- SCRIPTS STUDENTS ONLY
-- ======================
select 'ERROR:  Missing expected graduation year.' as error_desc, unique_id, current_year_id, first_name, last_name, expected_grad_year
  from users
  where grade in ('09','10','11','12')
    and (expected_grad_year is null or expected_grad_year = '');


-- ======================
-- SCRIPTS EMPLOYEES ONLY
-- ======================

-- ======================
-- SCRIPTS FOR GROUPINGS
-- ======================
-- no groups should have missing names for courses with teacher/student
-- results should be zero
select 'ERROR:  Missing name from grouping.' as error_desc
    , unique_id, course_id, section_id, current_year, name
  from groupings as g
  where g.status = 'ACTIVE'
    and (g.name = '' or g.name is null)
    and unique_id in (select unique_id_grouping from groupings_users group by unique_id_grouping)
  order by unique_id
