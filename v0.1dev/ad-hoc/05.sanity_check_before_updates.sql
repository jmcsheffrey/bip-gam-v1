-- what to check before update/insert of records to main users table

-- TODO
--  1.  check for malformed email addresses

-- get list of users that are of "classes" of users that exist in live data, but not in import
--  * can ignore users in live data that status = 'INACTIVE'
--  * can ignore users in live data that manual_entry != 'N'
-- all information should come from SIS
select * from users



-- find out if any unique_id changed by using school_email to connect tables
select * from users

-- find users who don't have correct emails.  this is very simple, should be improved
-- results should be zero
select *
  from staging_students
  where school_email not like '%_@_%._%'
-- results should be zero
select *
  from staging_employees
  where school_email not like '%_@_%._%'
