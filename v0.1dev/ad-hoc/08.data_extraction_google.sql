-- ****************************************************
-- Keep order of items for everything before CSV outputs
-- ****************************************************


-- ****************************************************
-- Inactive users for Google, via GAM script
-- ****************************************************
-- suspend inactive users
select concat(
      'python ./gam/gam.py'
      , ' update user '
      , users.school_email
      , ' suspended on'
      ,(case when users.population = 'STU' then ' org /Test/Archive/Aging/Students'
        when users.population = 'EMP' then ' org /Test/Archive/Aging/Employees'
        else 'ERROR' end)
    )
  from users
  where users.status = 'INACTIVE' and users.school_email != ''
  order by users.population, users.school_email

-- ****************************************************
-- Active users for Google, via GAM script
-- ****************************************************
-- create new users
-- gam create user <email address> firstname <First Name> lastname <Last Name> password <Password> changepassword on org <Org Name> externalid employeeID <unique_id>
select concat(
      'python ./gam/gam.py'
      , ' create user ', users.school_email
      , ' firstname ', users.first_name
      , ' lastname ', users.last_name
      , ' password sscps123'
      , ' changepassword on'
      ,(case when users.population = 'EMP' then ' org /Test/Users-Normal/Employees'
        when users.population = 'STU' and users.grade = '12' then ' org /Test/Users-Normal/Students/Level-HS'
        when users.population = 'STU' and users.grade = '11' then ' org /Test/Users-Normal/Students/Level-HS'
        when users.population = 'STU' and users.grade = '10' then ' org /Test/Users-Normal/Students/Level-HS'
        when users.population = 'STU' and users.grade = '09' then ' org /Test/Users-Normal/Students/Level-HS'
        when users.population = 'STU' and users.grade = '08' then ' org /Test/Users-Normal/Students/Level-4'
        when users.population = 'STU' and users.grade = '07' then ' org /Test/Users-Normal/Students/Level-4'
        when users.population = 'STU' and users.grade = '06' then ' org /Test/Users-Normal/Students/Level-3'
        when users.population = 'STU' and users.grade = '05' then ' org /Test/Users-Normal/Students/Level-3'
        when users.population = 'STU' and users.grade = '04' then ' org /Test/Users-Normal/Students/Level-2'
        when users.population = 'STU' and users.grade = '03' then ' org /Test/Users-Normal/Students/Level-2'
        else 'ERROR' end)
      , ' externalid organization ', users.unique_id
    )
  from users
  where users.status = 'ACTIVE' and users.newthisrun = 'Y' and users.school_email != ''
  order by users.population, users.school_email;
-- update existing users
--gam update user <email address> firstname <First Name> lastname <Last Name> org <Org Name> externalid employeeID <unique_id>
select concat(
      'python ./gam/gam.py'
      , ' update user ', users.school_email
      , ' firstname ', users.first_name
      , ' lastname ', users.last_name
      ,(case when users.population = 'EMP' then ' org /Test/Users-Normal/Employees'
        when users.population = 'STU' and users.grade = '12' then ' org /Test/Users-Normal/Students/Level-HS'
        when users.population = 'STU' and users.grade = '11' then ' org /Test/Users-Normal/Students/Level-HS'
        when users.population = 'STU' and users.grade = '10' then ' org /Test/Users-Normal/Students/Level-HS'
        when users.population = 'STU' and users.grade = '09' then ' org /Test/Users-Normal/Students/Level-HS'
        when users.population = 'STU' and users.grade = '08' then ' org /Test/Users-Normal/Students/Level-4'
        when users.population = 'STU' and users.grade = '07' then ' org /Test/Users-Normal/Students/Level-4'
        when users.population = 'STU' and users.grade = '06' then ' org /Test/Users-Normal/Students/Level-3'
        when users.population = 'STU' and users.grade = '05' then ' org /Test/Users-Normal/Students/Level-3'
        when users.population = 'STU' and users.grade = '04' then ' org /Test/Users-Normal/Students/Level-2'
        when users.population = 'STU' and users.grade = '03' then ' org /Test/Users-Normal/Students/Level-2'
        else 'ERROR' end)
      , ' externalid organization ', users.unique_id
    )
  from users
  where users.status = 'ACTIVE' and users.newthisrun = 'N' and users.school_email != ''
  order by users.population, users.school_email;


-- ****************************************************
-- Setup Google Classrooms, via GAM script
-- ****************************************************
-- create classrooms
-- gam create course [alias <alias>] [name <name>] [section <section>] [heading <heading>] [description <description>] [room <room>] [teacher <teacher email>] [status <PROVISIONED|ACTIVE|ARCHIVED|DECLINED>]


-- ****************************************************
-- ****************************************************
-- ****************************************************
-- ****************************************************
-- ****************************************************



-- ****************************************************
-- New users for Google, via CSV upload
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
