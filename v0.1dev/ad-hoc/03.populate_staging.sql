-- ***********************************************************
-- copy appropriate data from import_ tables to stagin_ tables
-- ***********************************************************
-- don't ever empty import_ tables until process is done, only do it when importing
-- stuff below is for "down & dirty" direct workings on the database

------------------------
-- SCRIPTS FOR STUDENTS
------------------------
-- remove any student data from previous runs
truncate staging_students;
-- copy students
insert into staging_students
  select `PKEY`
    , `APID`
    , `full_name`
    , `unique_id`
    , `status`
    , ''
    , `household_id`
    , `first_name`
    , `middle_name`
    , `last_name`
    , ''
    , `school_email`
    , `phone_home`
    , `phone_cell`
    , `street`
    , `city`
    , `state`
    , `zipcode`
    , `grade`
    , (case when expected_grad_year = '' then NULL
       else convert(expected_grad_year, UNSIGNED INTEGER) end)
    , `homeroom`
    , `homeroom_teacher_first`
    , `homeroom_teacher_last`
    , `referred_to_as`
    , `gender`
    , (case when birthdate = '' then NULL
       else STR_TO_DATE(`birthdate`,'%m/%d/%Y') end)
    , entry_date
  from import_students as import
  -- below is commented out because library & sendwordnow needs all students
  -- where import.grade in ('03','04','05','06','07','08','09','10','11','12')
  order by import.grade, import.last_name, import.first_name, import.middle_name;

-- update "newthisrun" based on existing records in users table
update staging_students as stage
inner join users
on stage.unique_id = users.unique_id
set stage.newthisrun = 'N';
update staging_students as stage set stage.newthisrun = 'Y' where stage.newthisrun = '';

-- give emails to students who do not have it
--   NOTE:  this needs to be run until no updates are done
--   NOTE:  the library software requires all students to have username, so no filtering by grade level
--   NOTE:  default is 101 to avoid having to enter leading zeros
SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
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
where (school_email is null or school_email = '');
--  and grade in ('03','04','05','06','07','08','09','10','11','12');


-- make school_email null for everyone else so no duplicates (i.e. null is not checked as duplicate)
-- this probably isn't necessary as even K's get username/email assigned
update staging_students
  set school_email = null
  where school_email = '';

-------------------------
-- SCRIPTS FOR EMPLOYEES
-------------------------
-- remove any employee data from previous runs
truncate staging_employees;
-- null missing dates so eaier to import
update import_employees set birthdate = null where birthdate = '';
-- copy employees
insert into staging_employees
  select `PKEY`
    , `APID`
    , `full_name`
    , `unique_id`
    , `status`
    , `archive_acct`
    , ''
    , `first_name`
    , `middle_name`
    , `last_name`
    , ''
    , `school_email`
    , `school_ext`
    , `home_email`
    , `phone_home`
    , `phone_cell`
    , `street`
    , `city`
    , `state`
    , `zipcode`
    , `homeroom`
    , `referred_to_as`
    , `gender`
    , (case when birthdate = '' then NULL
       else STR_TO_DATE(`birthdate`,'%m/%d/%Y') end)
    , `date_of_hire`
    , `school_year_hired`
    , position
  from import_employees
  order by last_name, first_name, middle_name;

-- update "newthisrun" based on existing records in users table
update staging_employees as stage
inner join users
on stage.unique_id = users.unique_id
set stage.newthisrun = 'N';
update staging_employees as stage set stage.newthisrun = 'Y' where stage.newthisrun = '';

-- changes in workflow adds new flag for INACTIVE status for employees, set status field to expected value
update staging_employees as stage
  set status = 'INACTIVE'
  where upper(archive_acct) = 'Y' or upper(archive_acct) = 'YES'

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

-------------------------
-- SCRIPTS FOR GROUPINGS
-------------------------
-- NOTE: need to update "fy##" each year
-- TODO: remove groupings data from previous runs
truncate staging_groupings;
-- insert new groupings
insert into staging_groupings
  select sections.PKEY
    , concat(sections.course_id, '-',sections.section_id,'-','fy17') as unique_id
    , now() as update_date
    , 'ACTIVE' as status
    , 'FY17' as current_year
    , (case
         when courses.display_level = '3' then cohorts.cohort
         when substring(sections.schedule,1,1) = 'M' then 'Workshop'
         else concat ('Block ', substring(sections.schedule,1,1))
       end) as time_block
    , courses.display_level as level
    , courses.display_name as name
    , courses.num as course_id
    , sections.section_id as section_id
    , '' as email_teachers
    , '' as email_students
    , '' as folder_teachers
    , '' as google_id
  from `import_sections` as sections
  left join import_courses as courses on sections.course_id = courses.num
  left join section_cohorts as cohorts on sections.course_id = cohorts.course_id and sections.section_id = cohorts.section_id
  where sections.table_name = ''
  order by concat(sections.course_id, '-',sections.section_id,'-','fy17');

-------------------------------
-- SCRIPTS FOR GROUPINGS_USERS
-------------------------------
-- remove groupings data from previous runs
truncate staging_groupings_users;
-- insert teacher related records (from import_sections)
-- NOTE: do not bring over PKEY as this is combined teacher/student table
insert into staging_groupings_users
  select
    '' as PKEY
    , import.course_id
    , import.section_id
    , 'fy17' as current_year
    , users.unique_id as person_id
    , 'TCH' as person_population
    , '' as tobe_unique_id
  from import_sections as import
  left join users on import.teacher_id = users.current_year_id
  where import.table_name = ''
  order by import.course_id, import.section_id;
-- insert student related records (from import_sections)
-- NOTE: do not bring over PKEY as this is combined teacher/student table
insert into staging_groupings_users
  select
    '' as PKEY
    , import.course_number
    , import.section_number
    , 'fy17' as current_year
    , import.unique_id
    , 'STU' as person_population
    , '' as tobe_unique_id
  from import_schedules as import
  order by import.course_number, import.section_number;
-- set the unique_id to used
update staging_groupings_users as stage set tobe_unique_id = concat(stage.course_id, '-',stage.section_id,'-','fy17');
