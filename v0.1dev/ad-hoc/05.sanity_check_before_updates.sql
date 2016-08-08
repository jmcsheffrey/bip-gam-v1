-- TODO
-- check for any unique_id changed by using school_email to connect tables
-- check for any unique_id changed by using name fields to connect tables


-- SCRIPTS TO RUN
-- in order to make sure users are appropriately marked INACTIVE, anyone marked ACTIVE & manual_entry = N
--   needs to have an record in staging_students or staging_employees
-- results should be zero
select users.unique_id, users.first_name, users.last_name, users.school_email from users
  left join staging_students as stage on users.unique_id = stage.unique_id
  where users.population = 'STU' and users.status = 'ACTIVE' and users.manual_entry = 'N' and stage.status is null
  order by users.unique_id desc;
select users.unique_id, users.first_name, users.last_name, users.school_email from users
  left join staging_employees as stage on users.unique_id = stage.unique_id
  where users.population = 'EMP' and users.status = 'ACTIVE' and users.manual_entry = 'N' and stage.status is null
  order by users.unique_id desc;

-- check for duplicate email addresses where unique_id is not same between USERS & STAGING
-- results should be zero
select stage.unique_id as staging_id, users.unique_id as users_id,
    stage.school_email as staging_email, users.school_email as users_email,
    stage.school_email as staging_first_name, users.school_email as users_first_name,
    stage.school_email as staging_last_name, users.school_email as users_last_name
  from staging_students as stage
  left join users on stage.school_email = users.school_email
  where stage.unique_id != users.unique_id;
select stage.unique_id as staging_id, users.unique_id as users_id,
    stage.school_email as staging_email, users.school_email as users_email,
    stage.first_name as staging_first_name, users.first_name as users_first_name,
    stage.last_name as staging_last_name, users.last_name as users_last_name
  from staging_employees as stage
  left join users on stage.school_email = users.school_email
  where stage.unique_id != users.unique_id;


-- check for duplicate user_name where unique_id is not same between USERS & STAGING
-- results should be zero
select stage.unique_id as staging_id, users.unique_id as users_id,
    stage.school_email as staging_email, users.user_name as users_username,
    stage.first_name as staging_first_name, users.first_name as users_first_name,
    stage.last_name as staging_last_name, users.last_name as users_last_name
  from staging_students as stage
  left join users on substring(stage.school_email,1,instr(stage.school_email, '@')-1) = users.user_name
  where stage.unique_id != users.unique_id;
select stage.unique_id as staging_id, users.unique_id as users_id,
    stage.school_email as staging_email, users.user_name as users_username,
    stage.first_name as staging_first_name, users.first_name as users_first_name,
    stage.last_name as staging_last_name, users.last_name as users_last_name
  from staging_employees as stage
  left join users on substring(stage.school_email,1,instr(stage.school_email, '@')-1) = users.user_name
  where stage.unique_id != users.unique_id;


-- find users who don't have correct (but existing) emails.  this is very simple, should be improved
-- results should be zero
select *
  from staging_students
  where school_email not like '%_@_%._%' and school_email != '' and school_email is not null;
select *
  from staging_employees
  where school_email not like '%_@_%._%' and school_email != '' and school_email is not null;
