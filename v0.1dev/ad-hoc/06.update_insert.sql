-- ****************************************************
-- Keep order of items because of new/update flag
-- ****************************************************


-- ****************************************************
-- Populate users with student records
-- ****************************************************
-- insert new student records
insert into users
  select
    stage.unique_id,
    stage.APID,
    now(),
    stage.status,
    stage.newthisrun,
    'N' as manual_entry,
    'STU' as population,
    stage.household_id,
    stage.first_name,
    stage.middle_name,
    stage.last_name,
    substring(stage.school_email,1,instr(stage.school_email, '@')-1),
    stage.school_email,
    stage.grade,
    stage.expected_grad_year,
    stage.homeroom_room,
    stage.homeroom_teacher_first,
    stage.homeroom_teacher_last,
    stage.referred_to_as,
    stage.gender,
    stage.birthdate,
    stage.entry_date,
    '' as position,
    concat('SSCPS Grade ',stage.grade,' Student') as description
  from staging_students as stage
  where
    stage.unique_id not in (select users.unique_id from users);
    -- and stage.grade in ('03','04','05','06','07','08','09','10','11','12');
-- update existing student records
update users
  left join staging_students as stage on users.unique_id = stage.unique_id
  set users.update_date = now(),
    users.current_year_id = stage.APID,
    users.status = stage.status,
    users.newthisrun = stage.newthisrun,
    users.manual_entry = 'N',
    users.population = 'STU',
    users.household_id = stage.household_id,
    users.first_name = stage.first_name,
    users.middle_name = stage.middle_name,
    users.last_name = stage.last_name,
    users.user_name = substring(stage.school_email,1,instr(stage.school_email, '@')-1),
    users.school_email = stage.school_email,
    users.grade = stage.grade,
    users.expected_grad_year = stage.expected_grad_year,
    users.homeroom_room = stage.homeroom_room,
    users.homeroom_teacher_first = stage.homeroom_teacher_first,
    users.homeroom_teacher_last = stage.homeroom_teacher_last,
    users.referred_to_as = stage.referred_to_as,
    users.gender = stage.gender,
    users.birthdate = stage.birthdate,
    users.start_date = stage.entry_date,
    users.position = '',
    users.description = concat('SSCPS Grade ',stage.grade,' Student')
  where
    users.unique_id = stage.unique_id;
    -- and stage.grade in ('03','04','05','06','07','08','09','10','11','12');


-- ****************************************************
-- Populate users with employee records
-- ****************************************************
-- insert new employee records
insert into users
  select
    stage.unique_id,
    stage.APID,
    now(),
    stage.status,
    stage.newthisrun,
    'N' as manual_entry,
    'EMP' as population,
    ''  as household_id,
    stage.first_name,
    stage.middle_name,
    stage.last_name,
    substring(stage.school_email,1,instr(stage.school_email, '@')-1),
    stage.school_email,
    '' as grade,
    '' as expected_grad_year,
    stage.homeroom,
    '' as homeroom_teacher_first,
    '' as homeroom_teacher_last,
    stage.referred_to_as,
    stage.gender,
    stage.birthdate,
    stage.date_of_hire,
    stage.position as position,
    'SSCPS Employee' as description
  from staging_employees as stage
  where
    stage.unique_id not in (select users.unique_id from users);
-- update existing employee records
update users
  left join staging_employees as stage on users.unique_id = stage.unique_id
  set users.update_date = now(),
    users.current_year_id = stage.APID,
    users.status = stage.status,
    users.newthisrun = stage.newthisrun,
    users.manual_entry = 'N',
    users.population = 'EMP',
    users.household_id = '',
    users.first_name = stage.first_name,
    users.middle_name = stage.middle_name,
    users.last_name = stage.last_name,
    users.user_name = substring(stage.school_email,1,instr(stage.school_email, '@')-1),
    users.school_email = stage.school_email,
    users.grade = '',
    users.expected_grad_year = '',
    users.homeroom_room = stage.homeroom,
    users.homeroom_teacher_first = '',
    users.homeroom_teacher_last = '',
    users.referred_to_as = stage.referred_to_as,
    users.gender = stage.gender,
    users.birthdate = stage.birthdate,
    users.start_date = stage.date_of_hire,
    users.position = stage.position,
    users.description = 'SSCPS Employee'
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
    , sections.section
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
    , groupings.section = stage.section
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
