-- ****************************************************
-- Scripts to run to update final tables.
-- NOTE:  Keep order of items!!!
-- ****************************************************


------------------------
-- SCRIPTS FOR STUDENTS
------------------------

-- PRE-PROCESSING:  Adjust users table first for students
-- mark all existing users not "newthisrun"
update users
  set update_date = now(),
    newthisrun = 'N'
  where population = 'STU';
-- set status in users who are INACTIVE in staging
update users
  inner join staging_students as stage on users.unique_id = stage.unique_id
    and stage.status = 'INACTIVE'
  set users.update_date = now(),
    users.status = 'INACTIVE';
-- mark in users not staging as INACTIVE (seniors & left students)
update users
  set update_date = now()
    , status = 'INACTIVE'
  where manual_entry = 'N'
    and population = 'STU'
    and status != 'INACTIVE'
    and unique_id not in (select unique_id from staging_students);
-- clear current_year_id because users may have been deleted from AdminPlus & ID reused
update users
  set update_date = now()
    , current_year_id = null
  where population = 'STU';
-- future scripts need null or value from users for profile_server
update staging_students as stage
  set stage.profile_server = null;
update staging_students as stage
  inner join users on stage.unique_id = users.unique_id
  set stage.profile_server = users.profile_server;


-- UPDATING:  add/update records for students
-- insert new student records
insert into users
  select
    stage.unique_id
    , stage.APID
    , now()
    , stage.status
    , '' as archive_acct
    , stage.newthisrun
    , 'N' as manual_entry
    , 'STU' as population
    , stage.household_id
    , stage.first_name
    , stage.middle_name
    , stage.last_name
    , substring(stage.school_email,1,instr(stage.school_email, '@')-1)
    , stage.profile_server
    , stage.school_email
    , '' as school_ext
    , '' as home_email
    , '' as phone_home
    , '' as phone_cell
    , stage.street
    , stage.city
    , stage.state
    , stage.zipcode
    , stage.grade
    , stage.expected_grad_year
    , stage.homeroom_room
    , stage.homeroom_teacher_first
    , stage.homeroom_teacher_last
    , stage.referred_to_as
    , stage.gender
    , stage.birthdate
    , stage.entry_date
    , '' as school_year_hired
    , '' as position
    , concat('SSCPS Grade ',stage.grade,' Student') as description
  from staging_students as stage
  where
    stage.unique_id not in (select users.unique_id from users);
      -- and stage.grade in ('03','04','05','06','07','08','09','10','11','12');
-- update existing student records
update users
  left join staging_students as stage on users.unique_id = stage.unique_id
  set users.update_date = now()
    , users.current_year_id = stage.APID
    , users.status = stage.status
    , users.newthisrun = stage.newthisrun
    , users.manual_entry = 'N'
    , users.population = 'STU'
    , users.household_id = stage.household_id
    , users.first_name = stage.first_name
    , users.middle_name = stage.middle_name
    , users.last_name = stage.last_name
    , users.user_name = substring(stage.school_email,1,instr(stage.school_email, '@')-1)
    , users.profile_server = stage.profile_server
    , users.school_email = stage.school_email
    , users.street = stage.street
    , users.city = stage.city
    , users.state = stage.state
    , users.zipcode = stage.zipcode
    , users.grade = stage.grade
    , users.expected_grad_year = stage.expected_grad_year
    , users.homeroom_room = stage.homeroom_room
    , users.homeroom_teacher_first = stage.homeroom_teacher_first
    , users.homeroom_teacher_last = stage.homeroom_teacher_last
    , users.referred_to_as = stage.referred_to_as
    , users.gender = stage.gender
    , users.birthdate = stage.birthdate
    , users.startdate = stage.entry_date
    , users.position = ''
    , users.description = concat('SSCPS Grade ',stage.grade,' Student')
  where
    users.unique_id = stage.unique_id;
      -- and stage.grade in ('03','04','05','06','07','08','09','10','11','12');


------------------------
-- SCRIPTS FOR EMPLOYEES
------------------------

-- PRE-PROCESSING:  Adjust users table first for students
-- mark all existing users not "newthisrun"
update users
  set update_date = now(),
    newthisrun = 'N'
  where population = 'EMP';
-- set status in users who are INACTIVE in staging
update users
  inner join staging_employees as stage on users.unique_id = stage.unique_id
    and stage.status = 'INACTIVE'
  set users.update_date = now(),
    users.status = 'INACTIVE';
-- mark in users not staging as INACTIVE (this should not happen for employees)
update users
  set update_date = now(),
    status = 'INACTIVE'
  where manual_entry = 'N'
    and population = 'EMP'
    and status != 'INACTIVE'
    and unique_id not in (select unique_id from staging_employees);
-- clear current_year_id because users may have been deleted from AdminPlus & ID reused
update users
  set update_date = now(),
    current_year_id = null
  where population = 'EMP';
-- future scripts need null or value from users for profile_server
update staging_employees as stage
  set stage.profile_server = null;
update staging_employees as stage
  inner join users on stage.unique_id = users.unique_id
  set stage.profile_server = users.profile_server;

-- UPDATING:  add/update records for students
-- insert new employee records
insert into users
  select
    stage.unique_id
    , stage.APID
    , now()
    , stage.status
    , stage.archive_acct
    , stage.newthisrun
    , 'N' as manual_entry
    , 'EMP' as population
    , ''  as household_id
    , stage.first_name
    , stage.middle_name
    , stage.last_name
    , substring(stage.school_email,1,instr(stage.school_email, '@')-1)
    , stage.profile_server
    , stage.school_email
    , stage.school_ext
    , stage.home_email
    , stage.phone_home as phone_home
    , stage.phone_cell as phone_cell
    , stage.street
    , stage.city
    , stage.state
    , stage.zipcode
    , '' as grade
    , null as expected_grad_year
    , stage.homeroom
    , '' as homeroom_teacher_first
    , '' as homeroom_teacher_last
    , stage.referred_to_as
    , stage.gender
    , stage.birthdate
    , stage.date_of_hire
    , stage.school_year_hired
    , stage.position as position
    , 'SSCPS Employee' as description
  from staging_employees as stage
  where
    stage.unique_id not in (select users.unique_id from users);
-- update existing employee records
update users
  left join staging_employees as stage on users.unique_id = stage.unique_id
  set users.update_date = now()
    , users.current_year_id = stage.APID
    , users.status = stage.status
    , users.newthisrun = stage.newthisrun
    , users.manual_entry = 'N'
    , users.population = 'EMP'
    , users.household_id = ''
    , users.first_name = stage.first_name
    , users.middle_name = stage.middle_name
    , users.last_name = stage.last_name
    , users.user_name = substring(stage.school_email,1,instr(stage.school_email, '@')-1)
    , users.profile_server = stage.profile_server
    , users.home_email = stage.home_email
    , users.school_email = stage.school_email
    , users.phone_home = stage.phone_home
    , users.phone_cell = stage.phone_cell
    , users.street = stage.street
    , users.city = stage.city
    , users.state = stage.state
    , users.zipcode = stage.zipcode
    , users.grade = ''
    , users.expected_grad_year = null
    , users.homeroom_room = stage.homeroom
    , users.homeroom_teacher_first = ''
    , users.homeroom_teacher_last = ''
    , users.referred_to_as = stage.referred_to_as
    , users.gender = stage.gender
    , users.birthdate = stage.birthdate
    , users.startdate = stage.date_of_hire
    , users.position = stage.position
    , users.description = 'SSCPS Employee'
  where
    users.unique_id = stage.unique_id;

-- ****************************************************
-- Populate groupings for Google Classrooms
-- ****************************************************
-- be sure to adjust current_year for the current year running
-- mark all prior years courses inactive
update groupings set status = 'INACTIVE' where current_year != 'FY17';
-- insert new groupings
insert into groupings
  select sections.unique_id
    , now() as update_date
    , sections.status
    , sections.current_year
    , sections.time_block
    , sections.level
    , sections.name
    , sections.course_id
    , sections.section_id
    , sections.email_teachers
    , sections.email_students
    , sections.folder_teachers
    , sections.google_id
  from `staging_groupings` as sections
  where sections.unique_id not in (select unique_id from groupings)
  order by sections.unique_id;
-- update existing groupings (in case run twice)
update groupings
  left join staging_groupings as stage on groupings.unique_id = stage.unique_id
  set groupings.status = stage.status
    , groupings.current_year = stage.current_year
    , groupings.time_block = stage.time_block
    , groupings.level = stage.level
    , groupings.name = stage.name
    , groupings.course_id = stage.course_id
    , groupings.section_id = stage.section_id
    , groupings.email_teachers = stage.email_teachers
    , groupings.email_students = stage.email_students
    , groupings.folder_teachers = stage.folder_teachers
    , groupings.google_id = stage.google_id
  where groupings.unique_id = stage.unique_id;

-- ****************************************************
-- Populate groupings_users for Google Classrooms
-- ****************************************************
-- need distinction between new & old so can run multiple times a year
-- mark all prior years courses inactive
update groupings_users as gu
  left join groupings as g on gu.unique_id_grouping = g.unique_id
  set gu.status = 'INACTIVE'
  where g.current_year != 'FY17';
-- insert new schedules
insert into groupings_users
  select
    stage.tobe_unique_id as unique_id_grouping
    , stage.person_id as unique_id_user
    , stage.person_population as user_type
    , 'ACTIVE' as status
  from staging_groupings_users as stage
  left join groupings_users as gu on stage.tobe_unique_id = gu.unique_id_grouping
    and stage.person_id = gu.unique_id_user
  where gu.unique_id_user is null
  order by concat(stage.course_id, '-', stage.section_id, '-', stage.current_year);
-- mark missing schedules as INACTIVE, this servers two purposes:
--    1) automatically mark last year schedules as INACTIVE
--    2) any removals are kept track of
update groupings_users as gu
  left join staging_groupings_users as stage on stage.tobe_unique_id = gu.unique_id_grouping and stage.person_id = gu.unique_id_user
  set gu.status = 'INACTIVE'
  where stage.tobe_unique_id is null and stage.person_id is null;
-- now update rows in case someone was added, removed and added back
update groupings_users as gu
  inner join staging_groupings_users as stage on stage.tobe_unique_id = gu.unique_id_grouping and stage.person_id = gu.unique_id_user
  set gu.user_type = stage.person_population
    , gu.status = 'ACTIVE';
