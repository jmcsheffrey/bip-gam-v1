-- ****************************************************
-- Keep order of items for everything before CSV outputs
-- ****************************************************
-- ToDo:
--   * fix issue with pre-3rd graders that exist in users without UID confuse newthisrun
--   * fix names so they are double quoted
--   * add SSCPS-GroupDocs to everyone's My drive
--   * add calendars (Main, Athletics, FacStaff) to everyone's calendar
--   * add Level calendars to folks?

--   * figure out how to deal with archiving last year classrooms

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
      ,(case when users.population = 'EMP' then ' org /Prod/Users-Normal/Employees'
        when users.population = 'STU' and users.grade = '12' then ' org /Prod/Users-Normal/Students/Level-HS'
        when users.population = 'STU' and users.grade = '11' then ' org /Prod/Users-Normal/Students/Level-HS'
        when users.population = 'STU' and users.grade = '10' then ' org /Prod/Users-Normal/Students/Level-HS'
        when users.population = 'STU' and users.grade = '09' then ' org /Prod/Users-Normal/Students/Level-HS'
        when users.population = 'STU' and users.grade = '08' then ' org /Prod/Users-Normal/Students/Level-4'
        when users.population = 'STU' and users.grade = '07' then ' org /Prod/Users-Normal/Students/Level-4'
        when users.population = 'STU' and users.grade = '06' then ' org /Prod/Users-Normal/Students/Level-3'
        when users.population = 'STU' and users.grade = '05' then ' org /Prod/Users-Normal/Students/Level-3'
        when users.population = 'STU' and users.grade = '04' then ' org /Prod/Users-Normal/Students/Level-2'
        when users.population = 'STU' and users.grade = '03' then ' org /Prod/Users-Normal/Students/Level-2'
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
      ,(case when users.population = 'EMP' then ' org /Prod/Users-Normal/Employees'
        when users.population = 'STU' and users.grade = '12' then ' org /Prod/Users-Normal/Students/Level-HS'
        when users.population = 'STU' and users.grade = '11' then ' org /Prod/Users-Normal/Students/Level-HS'
        when users.population = 'STU' and users.grade = '10' then ' org /Prod/Users-Normal/Students/Level-HS'
        when users.population = 'STU' and users.grade = '09' then ' org /Prod/Users-Normal/Students/Level-HS'
        when users.population = 'STU' and users.grade = '08' then ' org /Prod/Users-Normal/Students/Level-4'
        when users.population = 'STU' and users.grade = '07' then ' org /Prod/Users-Normal/Students/Level-4'
        when users.population = 'STU' and users.grade = '06' then ' org /Prod/Users-Normal/Students/Level-3'
        when users.population = 'STU' and users.grade = '05' then ' org /Prod/Users-Normal/Students/Level-3'
        when users.population = 'STU' and users.grade = '04' then ' org /Prod/Users-Normal/Students/Level-2'
        when users.population = 'STU' and users.grade = '03' then ' org /Prod/Users-Normal/Students/Level-2'
        else 'ERROR' end)
      , ' externalid organization ', users.unique_id
    )
  from users
  where users.status = 'ACTIVE' and users.newthisrun = 'N' and users.school_email != ''
  order by users.population, users.school_email;

-- reimport to AdminPlus to update school_email field
select unique_id, school_email
  from users
  where users.population = 'STU' and users.status = 'ACTIVE' and users.school_email != '';
select unique_id, school_email
  from users
  where users.population = 'EMP' and users.status = 'ACTIVE' and users.school_email != '';


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
-- temp query to create list of students for levels
SELECT grade, newthisrun as newthisyear, `unique_id`, `first_name`, `last_name`, `user_name`, `school_email`, `newthisrun`
FROM `users`
WHERE status = 'ACTIVE' and grade in ('05','06','07','08','09','10','11','12')
ORDER BY grade, newthisrun, homeroom_teacher_first, homeroom_teacher_last, first_name, last_name


-- temp stuff to extract parents for email list
-- this grabs just home email address for:
--   "DO NOT EMAIL" flag != Y
--   "PARENT PORTAL ACCESS" = Y
-- gam update group <group email> add owner|member|manager {user <email address> | group <group address> | org <org name> | file <file name> | all users}
-- SHEETS formula:
--   =concatenate("python ./gam/gam.py update group parents@sscps.org add member " & B2)
--  Add test email addresses, don't actually use this, just examples
-- this removes all users from group, maybe do a join with this statement?
--   python ./gam/gam.py gam update group membersclub@acme.org remove group membersclub@acme.org
-- this adds users to group
--   python ./gam/gam.py update group parents@sscps.org add member testemailxyz@gmail.com
select 'python ./gam/gam.py gam update group parents@sscps.org remove group parents@sscps.org' as statement
  from import_mastercontacts as import_junk
  limit 1
union
select 'python ./gam/gam.py gam update group parents@sscps.org add owner asavage@sscps.org' as statement
  from import_mastercontacts as import_junk
  limit 1
union
select 'python ./gam/gam.py gam update group parents@sscps.org add owner mtondorf@sscps.org' as statement
  from import_mastercontacts as import_junk
  limit 1
union
select 'python ./gam/gam.py gam update group parents@sscps.org add owner rdegennaro@sscps.org' as statement
  from import_mastercontacts as import_junk
  limit 1
union
select concat(
      'python ./gam/gam.py update'
      , ' group', ' parents@sscps.org'
      , ' add member ', import.CONTACT_HOME_EMAIL
    ) as statement
  from import_mastercontacts as import
  where (import.PRIMARY_CONTACT = 'Y' or import.PARENT_PORTAL_ACCESS = 'Y'
    and import.DO_NOT_EMAIL != 'Y'
    and import.CONTACT_HOME_EMAIL != ''

-- select statement for just email addresses
SELECT `CONTACT_HOME_EMAIL`, `PRIMARY_CONTACT`, `PARENT_PORTAL_ACCESS`, `DO_NOT_EMAIL`
FROM `import_mastercontacts`
WHERE (`PRIMARY_CONTACT` = 'Y' or `PARENT_PORTAL_ACCESS` = 'Y')
  and `DO_NOT_EMAIL` != 'Y'
  and `CONTACT_HOME_EMAIL` != ''
GROUP BY `CONTACT_HOME_EMAIL`
ORDER BY `PRIMARY_CONTACT`, `PARENT_PORTAL_ACCESS`, `CONTACT_HOME_EMAIL`
