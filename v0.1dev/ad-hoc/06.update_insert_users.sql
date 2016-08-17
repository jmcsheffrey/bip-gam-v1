-- ****************************************************
-- Keep order of items because of new/update flag
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
