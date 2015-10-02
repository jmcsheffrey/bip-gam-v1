-- for using data from users table.  might be better to do that instead of "04.determine_updates"

-- ****************************************************
-- Library data
-- ****************************************************
-- export students
select
    concat (first_name, ' ', last_name) as full_name,
    unique_id as lendeecode,
    concat (homeroom_teacher_first, ' ', homeroom_teacher_last) as homeroom,
    grade
  from users
  where users.status = 'ACTIVE' and users.population = 'STU'
  order by homeroom_teacher, first_name, last_name
-- export facstaff
select
    concat (first_name, ' ', last_name) as full_name,
    unique_id as lendeecode,
    'FacStaff' as homeroom,
    grade
  from users
  where users.status = 'ACTIVE' and users.population = 'EMP'
  order by first_name, last_name


-- ****************************************************
-- Re-import to AdminPlus
-- ****************************************************
-- load email addresses
