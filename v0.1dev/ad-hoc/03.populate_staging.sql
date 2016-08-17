-- don't ever empty import_ tables until process is done, only do it when importing
-- stuff below is for "down & dirty" direct workings on the database

-- ***********************************************************
-- copy appropriate data from import_ tables to stagin_ tables
-- ***********************************************************
-- ** student statements
-- remove any student data from previous runs
truncate staging_students;
-- copy students
insert into staging_students
  select `PKEY`, `APID`, `full_name`, `unique_id`, `status`, '', `household_id`, `first_name`, `middle_name`, `last_name`,
    `school_email`, `grade`, convert(expected_grad_year, UNSIGNED INTEGER), `homeroom`, `homeroom_teacher_first`, `homeroom_teacher_last`, `referred_to_as`, `gender`,
    STR_TO_DATE(`birthdate`,'%m/%d/%Y'),
    STR_TO_DATE(`entry_date`,'%m/%d/%Y')
  from import_students
  order by grade, last_name, first_name, middle_name;
-- update "newthisrun" based on existing records in users table
update staging_students as stage
inner join users
on stage.unique_id = users.unique_id
set stage.newthisrun = 'N';
update staging_students as stage set stage.newthisrun = 'Y' where stage.newthisrun = '';
-- give emails to students who do not have it and need it
--  this needs to be run until no students who need emails don't have it:
--     select * from staging_students where (isnull(school_email) or school_email = '') and grade in ('03','04','05','06','07','08','09','10','11','12');
--  default is 101 to avoid having to enter leading zeros
update staging_students as stage
inner join (select prefix, max(unique_id) as unique_id
            from staging_students_prefix
            group by prefix) as prefixtbl
on stage.unique_id = prefixtbl.unique_id
set school_email = concat (
  replace(
      replace(
        replace(
          replace(
            replace(substring(lower(first_name),1,1),
              char(46),char(0)),char(45),char(0)),char(44),char(0)),char(39),char(0)),char(32),char(0))
  ,replace(
    replace(
      replace(
        replace(
          replace(substring(lower(last_name),1,6),
            char(46),char(0)),char(45),char(0)),char(44),char(0)),char(39),char(0)),char(32),char(0))
  ,(case
    when (select nextsuffix.next_number
          from nextsuffix where nextsuffix.max_name = concat(
          replace(
              replace(
                replace(
                  replace(
                    replace(substring(lower(first_name),1,1),
                      char(46),char(0)),char(45),char(0)),char(44),char(0)),char(39),char(0)),char(32),char(0))
          ,replace(
            replace(
              replace(
                replace(
                  replace(substring(lower(last_name),1,6),
                    char(46),char(0)),char(45),char(0)),char(44),char(0)),char(39),char(0)),char(32),char(0)))) is null
    then '101'
    else (select nextsuffix.next_number
        from nextsuffix where nextsuffix.max_name = concat(
        replace(
            replace(
              replace(
                replace(
                  replace(substring(lower(first_name),1,1),
                    char(46),char(0)),char(45),char(0)),char(44),char(0)),char(39),char(0)),char(32),char(0))
          ,replace(
            replace(
              replace(
                replace(
                  replace(substring(lower(last_name),1,6),
                    char(46),char(0)),char(45),char(0)),char(44),char(0)),char(39),char(0)),char(32),char(0))))
    end)
  ,'@student.sscps.org')
where (isnull(school_email) or school_email = '') and grade in ('03','04','05','06','07','08','09','10','11','12');
-- make school_email null for everyone else so no duplicates (i.e. null is not checked as duplicate)
update staging_students
  set school_email = null
  where school_email = '';


-- ** employee statements
-- remove any employee data from previous runs
truncate staging_employees;
-- copy employees
insert into staging_employees
  select `PKEY`, `APID`, `full_name`, `unique_id`, `status`, '', `first_name`, `middle_name`, `last_name`,
    `school_email`, `homeroom`, `referred_to_as`, `gender`,
    STR_TO_DATE(`birthdate`,'%m/%d/%Y'),
    STR_TO_DATE(`date_of_hire`,'%m/%d/%Y'),
    position
  from import_employees
  order by last_name, first_name, middle_name;
-- update "newthisrun" based on existing records in users table
update staging_employees as stage
inner join users
on stage.unique_id = users.unique_id
set stage.newthisrun = 'N';
update staging_employees as stage set stage.newthisrun = 'Y' where stage.newthisrun = '';
-- give emails to all employees
update staging_employees
  set school_email =
    concat(substring(concat(
      replace(replace(replace(replace(replace(lower(substring(first_name,1,1)),char(46),char(0)),char(45),char(0)),char(44),char(0)),char(39),char(0)),char(32),char(0))
      , replace(replace(replace(replace(replace(lower(last_name),char(46),char(0)),char(45),char(0)),char(44),char(0)),char(39),char(0)),char(32),char(0))
    ),1,21), '@sscps.org')
  where isnull(school_email) or school_email = '';
  -- make school_email null for everyone else so no duplicates (i.e. null is not checked as duplicate)
  update staging_employees
    set school_email = null
    where school_email = '';
