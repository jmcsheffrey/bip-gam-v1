-- don't ever empty import_ tables, that is done only at start of processing
-- stuff for "down & dirty" workings on the database

-- remove any data from previous runs
truncate staging_students;
truncate staging_employees;

-- move appropriate data from import_ tables to stagin_ tables
-- TODO:  make sure text dates are converted to real dates
insert into staging_students select * from import_students where grade in ('03','04','05','06','07','08','09','10','11','12');
