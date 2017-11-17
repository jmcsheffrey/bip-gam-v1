-- ****************************************************
-- Run these before starting a new "run" of process
-- ****************************************************
truncate import_students;
truncate import_employees;
truncate import_contacts;
truncate import_courses;
truncate import_sections;
truncate import_schedules;
truncate staging_students;
truncate staging_employees;
truncate staging_groupings;
truncate staging_groupings_users;
SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
