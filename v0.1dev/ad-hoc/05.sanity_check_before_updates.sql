-- ****************************************************
-- Scripts to run after populating staging.
-- ****************************************************


------------------------
-- SCRIPTS FOR STUDENTS
------------------------
-- in order to make sure users are appropriately marked INACTIVE, anyone marked ACTIVE & manual_entry = N
--   needs to have an record in staging_students or staging_employees, anyone who isn't is listed
-- results should be zero
select 'ERROR:  Student is active last year, but no record exists this year.'  as error_desc,
    users.unique_id, users.first_name, users.last_name, users.school_email, users.status
  from users
  left join staging_students as stage on users.unique_id = stage.unique_id
  where users.population = 'STU'
    and users.status = 'ACTIVE'
    and users.manual_entry = 'N'
    and stage.status is null
  order by users.unique_id desc;

-- check for duplicate current_year_id
-- results should be zero
select  'ERROR:  Duplicate APID or current_year_id found.'  as error_desc
    , APID, count
  from (
  select stage.APID, count(stage.APID) as count
    from staging_students as stage
    group by stage.APID
    order by stage.APID) as stage_count
  where stage_count.count > 1;

-- all students should have email because library software requires username
-- results should be zero
select 'ERROR:  .'  as error_desc
    , unique_id, full_name, school_email
  from staging_students
  where (school_email is null or school_email = '');

-- check for duplicate email addresses where unique_id is not same between USERS & STAGING
-- results should be zero
select 'ERROR:  different unique_ids have same school_email between USERS and STAGING_ tables.'  as error_desc
    , stage.unique_id as staging_id, users.unique_id as users_id
    , stage.school_email as staging_email, users.school_email as users_email
    , stage.first_name as staging_first_name, users.first_name as users_first_name
    , stage.middle_name as staging_middle_name, users.middle_name as users_middle_name
    , stage.last_name as staging_last_name, users.last_name as users_last_name
  from staging_students as stage
  left join users on stage.school_email = users.school_email
  where stage.unique_id != users.unique_id;

-- check for duplicate user_name where unique_id is not same between USERS & STAGING
-- results should be zero
select 'ERROR:  different unique_ids have same user_name between USERS and STAGING_ tables.'  as error_desc
    , stage.unique_id as staging_id, users.unique_id as users_id
    , stage.school_email as staging_email, users.user_name as users_username
    , stage.first_name as staging_first_name, users.first_name as users_first_name
    , stage.last_name as staging_last_name, users.last_name as users_last_name
  from staging_students as stage
  left join users on substring(stage.school_email,1,instr(stage.school_email, '@')-1) = users.user_name
  where stage.unique_id != users.unique_id;

-- find users who don't have correct (but existing) emails.  this is very simple, should be improved
-- results should be zero
select 'ERROR:  Malformed existing school_email.'  as error_desc
    , unique_id, full_name, school_email
  from staging_students
  where school_email not like '%_@_%._%' and school_email != '' and school_email is not null;

-- double/triple/quadruple check for conflicting fields that are supposed to be unique
-- results should be zero
select 'ERROR: duplicate unique_id.' as error_desc
    , unique_id, count
  from (select unique_id, count(unique_id) as count
          from stage_students
          group by unique_id) as sumtable
  where count > 1;
select 'ERROR: duplicate school_email.' as error_desc
    , unique_id, count
  from (select school_email, count(school_email) as count
          from stage_students
          group by unique_id) as sumtable
  where count > 1;
select 'ERROR: duplicate user_name.' as error_desc
    , unique_id, count
  from (select user_name, count(user_name) as count
          from stage_students
          group by unique_id) as sumtable
  where count > 1;


-------------------------
-- SCRIPTS FOR EMPLOYEES
-------------------------
-- in order to make sure users are appropriately marked INACTIVE, anyone marked ACTIVE & manual_entry = N
--   needs to have an record in staging_students or staging_employees, anyone who isn't is listed
-- results should be zero
select 'ERROR:  Records not found in STAGING_ table but marked ACTIVE in USERS table.'  as error_desc,
    users.unique_id, users.first_name, users.last_name, users.school_email, users.status, stage.archive_acct from users
  left join staging_employees as stage on users.unique_id = stage.unique_id
  where users.population = 'EMP' and users.status = 'ACTIVE' and users.manual_entry = 'N' and stage.status is null
  order by users.unique_id desc;

-- all employees should have email
-- results should be zero
select 'ERROR:  Employee with no school_email field.'  as error_desc,
    unique_id, APID, full_name, school_email
  from staging_employees where (school_email is null or school_email = '');

-- check for duplicate email addresses where unique_id is not same between USERS & STAGING
-- results should be zero
select 'ERROR:  Duplicate school_email values with different unique_id.'  as error_desc
    , stage.unique_id as staging_id, users.unique_id as users_id
    , stage.school_email as staging_email, users.school_email as users_email
    , stage.first_name as staging_first_name, users.first_name as users_first_name
    , stage.middle_name as staging_middle_name, users.middle_name as users_middle_name
    , stage.last_name as staging_last_name, users.last_name as users_last_name
  from staging_employees as stage
  left join users on stage.school_email = users.school_email
  where stage.unique_id != users.unique_id;

-- check for duplicate user_name where unique_id is not same between USERS & STAGING
-- results should be zero
select 'ERROR:  Duplicate user_name values with different unique_id.'  as error_desc
    , stage.unique_id as staging_id, users.unique_id as users_id
    , stage.school_email as staging_email, users.user_name as users_username
    , stage.first_name as staging_first_name, users.first_name as users_first_name
    , stage.last_name as staging_last_name, users.last_name as users_last_name
  from staging_employees as stage
  left join users on substring(stage.school_email,1,instr(stage.school_email, '@')-1) = users.user_name
  where stage.unique_id != users.unique_id;

-- find users who don't have correct (but existing) emails.  this is very simple, should be improved
-- results should be zero
select 'ERROR:  Malformed school_email field.'  as error_desc
    , unique_id, APID, full_name, school_email
  from staging_employees
  where school_email not like '%_@_%._%' and school_email != '' and school_email is not null;

-- double/triple/quadruple check for conflicting fields that are supposed to be unique
-- results should be zero
select 'ERROR: duplicate unique_id.' as error_desc
    , unique_id, count
  from (select unique_id, count(unique_id) as count
          from staging_employees
          group by unique_id) as sumtable
  where count > 1;
select 'ERROR: duplicate school_email.' as error_desc
    , unique_id, count
  from (select school_email, count(school_email) as count
          from staging_employees
          group by unique_id) as sumtable
  where count > 1;
select 'ERROR: duplicate user_name.' as error_desc
    , unique_id, count
  from (select user_name, count(user_name) as count
          from staging_employees
          group by unique_id) as sumtable
  where count > 1;
