-- ****************************************************
-- Keep order of items for everything before CSV outputs
-- ****************************************************
-- ToDo:
--   1)  figure out how to deal with archiving last year classrooms

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
-- unique_id must be alias to be able to connect to classroom without knowing Google ID

-- archive appropriate classrooms
-- gam update course <alias> status ARCHIVED
select concat(
      'python ./gam/gam.py'
      , ' update course ', g.unique_id
      , ' ARCHIVED'
    )
  from groupings as g
  where g.status = 'INACTIVE'
  order by g.unique_id;

-- create classrooms; teacher must be set so admin user is not added by default
-- gam create course [alias <alias>] [name <name>] [section <section>] teacher <teacher email> status ACTIVE
select concat(
      'python ./gam/gam.py create course'
      , ' alias ', g.unique_id
      , ' teacher ', teachers.school_email
      , ' name ', char(34), concat(g.name, ' - ', g.time_block, ' (', (case
        when teachers.referred_to_as != ''
        then teachers.referred_to_as
        else teachers.first_name
        end), ')'), char(34)
      , ' section ', char(34), concat(g.course_id, '/', g.section_id,'-',g.current_year), char(34)
      , ' status', ' ACTIVE'
    )
  from groupings as g
  left join groupings_users as gu
    on g.unique_id = gu.unique_id_grouping and gu.user_type = 'TCH'
  left join users as teachers on gu.unique_id_user = teachers.unique_id
  where g.status = 'ACTIVE'
  order by g.unique_id;

-- assign teachers to Classrooms
-- gam course <alias> add teacher <email address>
-- not needed until set multiple teachers to one section (manually or from adminplus)

-- assign students to Classrooms
-- gam course <alias> add student <email address>
select concat(
      'python ./gam/gam.py course'
      , ' ', gu.unique_id_grouping
      , ' add student ', students.school_email
    )
  from groupings_users as gu
  inner join users as students on gu.unique_id_user = students.unique_id
  where gu.user_type = 'STU' and gu.status = 'ACTIVE'

-- ****************************************************
-- ****************************************************
-- ****************************************************
-- ****************************************************
-- ****************************************************
