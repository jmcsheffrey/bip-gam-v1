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
  select `PKEY`, `APID`, `full_name`, `unique_id`, `status`, '', `household_id`, `first_name`, `middle_name`, `last_name`
    , `school_email`, `grade`, convert(expected_grad_year, UNSIGNED INTEGER), `homeroom`, `homeroom_teacher_first`
    , `homeroom_teacher_last`, `referred_to_as`, `gender`
    , STR_TO_DATE(`birthdate`,'%m/%d/%Y')
    , STR_TO_DATE(`entry_date`,'%m/%d/%Y')
  from import_students as import
  where import.grade in ('03','04','05','06','07','08','09','10','11','12')
  order by import.grade, import.last_name, import.first_name, import.middle_name;

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

-- grab existing profile_server value
update staging_students as stage
  inner join users on stage.unique_id = users.unique_id
  set stage.profile_server = users.profile_server

-- set file server for all 700L students (High School)
update staging_students
  set profile_server = 'RODRICK'
  where grade in ('09','10','11','12');

-- set file server for students at 100L, assumes 700L already set above
--this should look to load balance students across servers in profile_server_by_population, ignoring RODRICK

-------------------------
-- SCRIPTS FOR EMPLOYEES
-------------------------
-- remove any employee data from previous runs
truncate staging_employees;
-- copy employees
insert into staging_employees
  select `PKEY`, `APID`, `full_name`, `unique_id`, `status`, '', `first_name`, `middle_name`, `last_name`,
    `school_email`, `phone_home`, `phone_cell`, `homeroom`, `referred_to_as`, `gender`,
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

-- grab existing profile_server value
update staging_employees as stage
  inner join users on stage.unique_id = users.unique_id
  set stage.profile_server = users.profile_server

-- IMPORTANT: set file server manually for all 700L employees

-- set file server for employees at 100L, assumes 700L already set manually
--this should look to load balance students across servers in profile_server_by_population, ignoring RODRICK


-------------------------
-- SCRIPTS FOR GROUPINGS
-------------------------
-- remove groupings data from previous runs
truncate staging_groupings;
-- insert new groupings
insert into staging_groupings
  select sections.PKEY
    , concat(sections.course_id, '-',sections.section_id,'-','fy17') as unique_id
    , now() as update_date
    , 'ACTIVE' as status
    , 'FY17' as current_year
    , (case
      when courses.display_level = '3'
      then cohorts.cohort
      when substring(sections.schedule,1,1) = 'M'
      then 'Workshop'
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
