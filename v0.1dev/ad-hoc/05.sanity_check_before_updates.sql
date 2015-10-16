-- what to check before update/insert of records to main users table

-- TODO
-- check for any unique_id changed by using school_email to connect tables
-- check for any unique_id changed by using name fields to connect tables


-- SCRIPTS TO RUN
-- everyone not manually entered has to have data in AdminPlus if ACTIVE, so check for users who are
--   ACTIVE & manual_entry = 'N' in USERS and not listed in staging tables
-- results should be zero
select * from users
  left join staging_students as stu on users.unique_id = stu.unique_id
  where users.population = 'STU' and users.status = 'ACTIVE' and users.manual_entry = 'N' and stu.status is null
  order by users.unique_id desc
select * from users
  left join staging_employees as emp on users.unique_id = emp.unique_id
  where users.population = 'EMP' and users.status = 'ACTIVE' and users.manual_entry = 'N' and emp.status is null
  order by users.unique_id desc

-- check for duplicate email addresses where unique_id is not same between USERS & STAGING
-- results should be zero
select * from staging_students as stu
  left join users on stu.school_email = users.school_email
  where stu.unique_id != users.unique_id
select * from staging_employees as emp
  left join users on emp.school_email = users.school_email
  where emp.unique_id != users.unique_id


-- find users who don't have correct (but existing) emails.  this is very simple, should be improved
-- results should be zero
select *
  from staging_students
  where school_email not like '%_@_%._%' and school_email != '' and school_email is not null
-- results should be zero
select *
  from staging_employees
  where school_email not like '%_@_%._%' and school_email != '' and school_email is not null
