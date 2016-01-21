-- TODO
-- check for any unique_id changed by using school_email to connect tables
-- check for any unique_id changed by using name fields to connect tables


-- SCRIPTS TO RUN
-- everyone not manually entered has to have data in AdminPlus if ACTIVE, so check for users who are
--   ACTIVE & manual_entry = 'N' in USERS and not listed in staging tables
-- results should be zero
select * from users
  left join staging_students as stage on users.unique_id = stage.unique_id
  where users.population = 'STU' and users.status = 'ACTIVE' and users.manual_entry = 'N' and stage.status is null
  order by users.unique_id desc
select * from users
  left join staging_employees as stage on users.unique_id = stage.unique_id
  where users.population = 'EMP' and users.status = 'ACTIVE' and users.manual_entry = 'N' and stage.status is null
  order by users.unique_id desc

-- check for duplicate email addresses where unique_id is not same between USERS & STAGING
-- results should be zero
select stage.unique_id as staging_id, users.unique_id as users_id, stage.school_email as staging_email, users.school_email as users_email
  from staging_students as stage
  left join users on stage.school_email = users.school_email
  where stage.unique_id != users.unique_id
select stage.unique_id as staging_id, users.unique_id as users_id, stage.school_email as staging_email, users.school_email as users_email
  from staging_employees as stage
  left join users on stage.school_email = users.school_email
  where stage.unique_id != users.unique_id


-- check for "soon to be" duplicate school_email, i.e. once do updates, they will not be unique
-- results should be zero
select stage.unique_id as stage_id, users.unique_id as users_id, stage.school_email as new_email, users.school_email
  from staging_students as stage
  left join users on stage.school_email = users.user_name
  where stage.unique_id != users.unique_id
select stage.unique_id, users.unique_id as existing_unique_id, stage.school_email as new_email, users.school_email
  from staging_employees as stage
  left join users on stage.school_email = users.user_name
  where stage.unique_id != users.unique_id


-- check for duplicate user_name where unique_id is not same between USERS & STAGING
-- results should be zero
select stage.unique_id as staging_id, users.unique_id as users_id, substring(stage.school_email,1,instr(stage.school_email, '@')-1) as staging_username, users.user_name as users_username
  from staging_students as stage
  left join users on substring(stage.school_email,1,instr(stage.school_email, '@')-1) = users.user_name
  where stage.unique_id != users.unique_id
select stage.unique_id as staging_id, users.unique_id as users_id, substring(stage.school_email,1,instr(stage.school_email, '@')-1) as staging_username, users.user_name as users_username
  from staging_employees as stage
  left join users on substring(stage.school_email,1,instr(stage.school_email, '@')-1) = users.user_name
  where stage.unique_id != users.unique_id


-- check for "soon to be" duplicate user_names, i.e. once do updates, they will not be unique
-- first statement is just to see if created username correctly
select
    stage.unique_id as stage_id,
    stage.school_email,
    substring(stage.school_email,1,instr(stage.school_email, '@')-1) as stage_username
  from staging_students as stage
-- results should be zero
select
    stage.unique_id as stage_id, users.unique_id as users_id,
    substring(stage.school_email,1,instr(stage.school_email, '@')-1) as stage_username, users.user_name as users_username
  from staging_students as stage
  left join users on substring(stage.school_email,1,instr(stage.school_email, '@')-1) = users.user_name
  where stage.unique_id != users.unique_id
select stage.unique_id as stage_id, users.unique_id as users_id, substring(stage.school_email,1,instr(stage.school_email, '@')-1) as stage_username, users.user_name as users_username
  from staging_employees as stage
  left join users on substring(stage.school_email,1,instr(stage.school_email, '@')-1) = users.user_name
  where stage.unique_id != users.unique_id


-- find users who don't have correct (but existing) emails.  this is very simple, should be improved
-- results should be zero
select *
  from staging_students
  where school_email not like '%_@_%._%' and school_email != '' and school_email is not null
-- results should be zero
select *
  from staging_employees
  where school_email not like '%_@_%._%' and school_email != '' and school_email is not null
