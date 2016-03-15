-- for using data from users table.  might be better to do that instead of "04.determine_updates"


-- ****************************************************
-- New users for Google, for upload
-- ****************************************************
-- export students
select
    users.first_name as 'First Name',
    users.last_name as 'Last Name',
    users.school_email as 'Email Address',
    'sscps123' as 'Password',
    '' as 'Secondary Email',
    '' as 'Work Phone 1',
    '' as 'Home Phone 1',
    '' as 'Mobile Phone 1',
    '' as 'Work address 1',
    '' as 'Home address 1',
    users.unique_id as 'Employee Id',
    '' as 'Employee Type',
    '' as 'Employee Title',
    '' as 'Manager',
    users.grade as 'Department',
    users.status as 'Cost Center'
  from users
  left join import_students as import on users.unique_id = import.unique_id
  where users.status = 'ACTIVE' and users.population = 'STU'
    and users.school_email != '' and import.school_email = ''
  order by users.school_email
-- export employees
select
    first_name as 'First Name',
    last_name as 'Last Name',
    school_email as 'Email Address',
    'sscps123' as 'Password',
    '' as 'Secondary Email',
    '' as 'Work Phone 1',
    '' as 'Home Phone 1',
    '' as 'Mobile Phone 1',
    '' as 'Work address 1',
    '' as 'Home address 1',
    unique_id as 'Employee Id',
    '' as 'Employee Type',
    '' as 'Employee Title',
    '' as 'Manager',
    '' as 'Department',
    users.status as 'Cost Center'
  from users
  where users.status = 'ACTIVE' and users.population = 'STU'
    and users.school_email != '' and import.school_email = ''
  order by school_email


-- ****************************************************
-- Inactive users for Google, via GAM
-- ****************************************************
-- suspend inactive users
select concat(
      'python ./gam/gam.py'
      , ' update user '
      , users.school_email
      , ' suspended on'
      ,(case when users.population = 'STU' then ' org /Archive/Aging/Students'
        when users.population = 'EMP' then ' org /Archive/Aging/Employees'
        else 'ERROR' end)
    )
  from users
  where users.status = 'INACTIVE'
  order by users.population, users.school_email


-- ****************************************************
-- Create users for Google, via GAM
-- ****************************************************
-- just copied from another query, need to see GAM can create/update based on
--   existing user (and not reset password)
select concat(
      'python ./gam/gam.py'
      , ' update user '
      , users.school_email
      , ' suspended on'
      ,(case when users.population = 'STU' then ' org /Archive/Aging/Students'
        when users.population = 'EMP' then ' org /Archive/Aging/Employees'
        else 'ERROR' end)
    )
  from users
  where users.status = 'INACTIVE'
  order by users.population, users.school_email


-- ****************************************************
-- Re-import to AdminPlus
-- ****************************************************
-- load email addresses, needs just unique_id & school_email
-- only do after verified Google Apps accounts are good
-- export students
select
    unique_id,
    school_email
  from users
  where users.status = 'ACTIVE' and users.population = 'STU' and school_email != ''
  order by school_email
-- export employees
select
    unique_id,
    school_email
  from users
  where users.status = 'ACTIVE' and users.population = 'EMP' and school_email != ''
  order by school_email


-- ****************************************************
-- Library data for Joomla _lendee table,
--    contact info done separately, but can use below in a spreadsheet
--    =(CONCATENATE("update s7rh8_booklibrary_lendee set contactname = '",A2,"' where lendeecode = '",C2,"';"))
--    =(CONCATENATE("update s7rh8_booklibrary_lendee set contactemail = '",B2,"' where lendeecode = '",C2,"';"))
-- ****************************************************
-- export students & staff at same time
select
    unique_id as lendeecode,
    concat (first_name, ' ', last_name) as full_name,
    '' as contactname,
    '' as contactemail,
    grade,
    concat (homeroom_teacher_first, ' ', homeroom_teacher_last) as homeroom_teacher,
    'Student' as population,
    0 as user_id
  from users
  where users.status = 'ACTIVE' and users.population = 'STU'
union
select
    unique_id as lendeecode,
    concat (first_name, ' ', last_name) as full_name,
    concat (first_name, ' ', last_name) as contactname,
    school_email as contactemail,
    '' as grade,
    concat (first_name, ' ', last_name) as homeroom_teacher,
    'Employee' as population,
    0 as user_id
  from users
  where users.status = 'ACTIVE' and users.population = 'EMP'


-- ****************************************************
-- Library cards/book, note: contact info is separate table
-- ****************************************************
-- export students
select
    concat (first_name, ' ', last_name) as full_name,
    unique_id as lendeecode,
    concat (homeroom_teacher_first, ' ', homeroom_teacher_last) as homeroom_teacher,
    grade,
    (case when grade = '0K' then '1'
      when grade = '01' then '1'
      when grade = '02' then '1'
      when grade = '03' then '2'
      when grade = '04' then '2'
      when grade = '05' then '3'
      when grade = '06' then '3'
      when grade = '07' then '4'
      when grade = '08' then '4'
      when grade = '09' then '5'
      when grade = '10' then '5'
      when grade = '11' then '5'
      when grade = '12' then '5'
      else 'ERROR' end) as level
  from users
  where users.status = 'ACTIVE' and users.population = 'STU'
  order by level, homeroom_teacher, first_name, last_name
-- export facstaff
select
    concat (first_name, ' ', last_name) as full_name,
    unique_id as lendeecode,
    '' as homeroom_teacher,
    '' as grade,
    '' as level
  from users
  where users.status = 'ACTIVE' and users.population = 'EMP'
  order by first_name, last_name


-- ****************************************************
-- Naviance data
-- ****************************************************
-- export students
select
    unique_id as 'Student_ID',
    expected_grad_year as 'Class_Year',
    grade,
    first_name,
    last_name,
    middle_name,
    gender,
    homeroom_room,
    household_id as 'FC Registration Code',
    user_name as 'FC User Name',
    school_email,
    'sscps123' as 'FC Password'
  from users
  where users.status = 'ACTIVE' and users.population = 'STU' and grade in ('09','10','11','12')
  order by grade, first_name, last_name
