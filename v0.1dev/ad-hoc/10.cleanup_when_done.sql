-- ***********************************************************
-- Run these to cleanup after "run" has been verified
-- ***********************************************************
-- might want to keep data in import_ and staging_ tables to
-- trace through problems.  will also be good to do this
-- before backups.
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
