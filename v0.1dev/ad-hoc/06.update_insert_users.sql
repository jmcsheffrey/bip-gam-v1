-- update existing student records
update users
  left join staging_students on users.unique_id = staging_students.unique_id
  set users.update_date = now(),
    users.status = staging_students.status,
    users.manual_entry = 'N',
    users.population = 'STU',
    users.household_id = staging_students.household_id,
    users.first_name = staging_students.first_name,
    users.middle_name = staging_students.middle_name,
    users.last_name = staging_students.last_name,
    users.user_name = substring(staging_students.school_email,1,instr(staging_students.school_email, '@')-1),
    users.school_email = staging_students.school_email,
    users.grade = staging_students.grade,
    users.expected_grad_year = staging_students.expected_grad_year,
    users.homeroom_room = staging_students.homeroom_room,
    users.homeroom_teacher_first = staging_students.homeroom_teacher_first,
    users.homeroom_teacher_last = staging_students.homeroom_teacher_last,
    users.referred_to_as = staging_students.referred_to_as,
    users.gender = staging_students.gender,
    users.birthdate = staging_students.birthdate,
    users.start_date = staging_students.entry_date,
    users.position = '',
    users.description = concat('SSCPS Grade ',staging_students.grade,' Student')
  where users.unique_id = staging_students.unique_id;

-- insert new student records
insert into users
  select
    staging_students.unique_id,
    now(),
    staging_students.status,
    'N' as manual_entry,
    'STU' as population,
    staging_students.household_id,
    staging_students.first_name,
    staging_students.middle_name,
    staging_students.last_name,
    substring(staging_students.school_email,1,instr(staging_students.school_email, '@')-1),
    staging_students.school_email,
    staging_students.grade,
    staging_students.expected_grad_year,
    staging_students.homeroom_room,
    staging_students.homeroom_teacher_first,
    staging_students.homeroom_teacher_last,
    staging_students.referred_to_as,
    staging_students.gender,
    staging_students.birthdate,
    staging_students.entry_date,
    '' as position,
    concat('SSCPS Grade ',staging_students.grade,' Student') as description
  from staging_students
  where
    staging_students.unique_id not in (select users.unique_id from users);
