-- ****************************************************
-- Keep order of items for everything before CSV outputs
-- ****************************************************

-- ****************************************************
-- Inactive users for Google, via GAM script
-- ****************************************************
-- suspend inactive users
--   employees are all former employees,
--   students hold off on last year graudates until afte Thanksgiving
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
  where
    (users.status = 'INACTIVE'
      and users.school_email != ''
      and users.population = 'EMP'
    or (
      users.status = 'INACTIVE'
      and users.school_email != ''
      and users.population = 'STU'
      and users.expected_grad_year != '2016'
    )
  order by users.population, users.school_email

-- ****************************************************
-- Active users for Google, via GAM script
-- ****************************************************
-- create new users
-- gam create user <email address> firstname <First Name> lastname <Last Name> password <Password> changepassword on org <Org Name> externalid employeeID <unique_id>
select concat(
      'python ./gam/gam.py'
      , ' create user ', users.school_email
      , ' firstname ', char(34), users.first_name, char(34)
      , ' lastname ', char(34), users.last_name, char(34)
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
  where users.status = 'ACTIVE'
    and users.school_email != ''
    and users.newthisrun = 'Y'
  order by users.population, users.school_email;
-- update existing users
--gam update user <email address> firstname <First Name> lastname <Last Name> org <Org Name> externalid employeeID <unique_id>
select concat(
      'python ./gam/gam.py'
      , ' update user ', users.school_email
      , ' firstname ', char(34), users.first_name, char(34)
      , ' lastname ', char(34), users.last_name, char(34)
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
  where users.status = 'ACTIVE'
    and users.school_email != ''
    and users.newthisrun = 'N'
  order by users.population, users.school_email;


-- ****************************************************
-- User/Google groups for users, via GAM script
-- ****************************************************
-- make sure employees@sscps.org is populated correctly
--need to add in empty & re-add of owners
select concat(
      'python ./gam/gam.py update group '
      , 'employees@sscps.org'
      , ' add member ', users.school_email
    ) as statement
  from users
  where users.status = 'ACTIVE' and users.school_email != ''
    and users.population = 'EMP'
  order by users.population, users.school_email;
-- make sure facstaff@sscps.org is populated correctly
--need to add in empty & re-add of owners
select concat(
      'python ./gam/gam.py update group '
      , 'facstaff@sscps.org'
      , ' add member ', users.school_email
    ) as statement
  from users
  where users.status = 'ACTIVE' and users.school_email != ''
    and users.population = 'EMP'
  order by users.population, users.school_email;

-- make sure students@sscps.org is populated correctly
select concat(
      'python ./gam/gam.py update group '
      , 'students@sscps.org'
      , ' add member ', users.school_email
    ) as statement
  from users
  where users.status = 'ACTIVE' and users.school_email != ''
    and users.population = 'STU'
  order by users.population, users.grade, users.school_email;

-- make sure students_<level>@ssscps.org are populated correctly
--need to add in empty & re-add of owners
select concat(
      'python ./gam/gam.py update group '
      ,(case when users.population = 'STU' and users.grade = '12' then 'students_lhs@student.sscps.org'
        when users.population = 'STU' and users.grade = '11' then 'students_lhs@student.sscps.org'
        when users.population = 'STU' and users.grade = '10' then 'students_lhs@student.sscps.org'
        when users.population = 'STU' and users.grade = '09' then 'students_lhs@student.sscps.org'
        when users.population = 'STU' and users.grade = '08' then 'students_l4@student.sscps.org'
        when users.population = 'STU' and users.grade = '07' then 'students_l4@student.sscps.org'
        when users.population = 'STU' and users.grade = '06' then 'students_l3@student.sscps.org'
        when users.population = 'STU' and users.grade = '05' then 'students_l3@student.sscps.org'
        when users.population = 'STU' and users.grade = '04' then 'students_l2@student.sscps.org'
        when users.population = 'STU' and users.grade = '03' then 'students_l2@student.sscps.org'
        else 'ERROR' end)
      , ' add member ', users.school_email
    ) as statement
  from users
  where users.status = 'ACTIVE' and users.school_email != ''
    and users.population = 'STU'
  order by users.population, users.grade, users.school_email;


-- add students to their "Graduating Year of" groups
--MUST create group manually first!!!
--do not empty groups from graduated years
select 'python ./gam/gam.py update group gco-fy2017@student.sscps.org remove group gco-fy2017@student.sscps.org' as statement
union
select 'python ./gam/gam.py update group gco-fy2017@student.sscps.org add owner mcarter@sscps.org' as statement
union
select 'python ./gam/gam.py update group gco-fy2018@student.sscps.org remove group gco-fy2018@student.sscps.org' as statement
union
select 'python ./gam/gam.py update group gco-fy2018@student.sscps.org add owner mcarter@sscps.org' as statement
union
select 'python ./gam/gam.py update group gco-fy2019@student.sscps.org remove group gco-fy2019@student.sscps.org' as statement
union
select 'python ./gam/gam.py update group gco-fy2019@student.sscps.org add owner mcarter@sscps.org' as statement
union
select 'python ./gam/gam.py update group gco-fy2020@student.sscps.org remove group gco-fy2020@student.sscps.org' as statement
union
select 'python ./gam/gam.py update group gco-fy2020@student.sscps.org add owner mcarter@sscps.org' as statement
--for some reason can't union the statement below
select concat(
      'python ./gam/gam.py update group '
      , concat('gco-fy',users.expected_grad_year,'@student.sscps.org')
      , ' add member ', users.school_email
    ) as statement
  from users
  where users.status = 'ACTIVE' and users.school_email != ''
    and users.population = 'STU'
    and users.expected_grad_year is not null
    and users.grade in ('09','10','11','12')
  order by users.population, users.grade, users.school_email;


-- ****************************************************
-- Drive folders for users for Google, via GAM script
-- ****************************************************
-- requires that users be in proper groups first
-- re/add user view rights to SSCPS-GroupDocs
--   gam user <user email> add drivefileacl <file id> [user|group|domain|anyone <value>] [withlink] [role <reader|commenter|writer|owner>] [sendemail] [emailmessage <message text>]
--   python ./gam/gam.py user admin.google@sscps.org add drivefileacl 0Byc5mfoLgdM3MDE0YjEyOWEtMjIxNi00YTE0LTgxZDgtODQxOGEwODU5YjE3
--          user jen_student@student.sscps.org role reader
-- unshare with inactive users
select concat(
      'python ./gam/gam.py'
      , ' user admin.google@sscps.org'
      , ' delete drivefileacl 0Byc5mfoLgdM3MDE0YjEyOWEtMjIxNi00YTE0LTgxZDgtODQxOGEwODU5YjE3'
      , ' user ', users.school_email)
  from users
  where users.status = 'INACTIVE' and users.school_email != ''
  order by users.population, users.school_email;
-- share with active users
-- gam user targetUser@domain.org update drivefile id  0B8aCWH-xLi2NckxXOEp5REUtNEE parentid root
select concat(
      'python ./gam/gam.py'
      , ' user ', users.school_email
      , ' update drivefile id 0Byc5mfoLgdM3MDE0YjEyOWEtMjIxNi00YTE0LTgxZDgtODQxOGEwODU5YjE3'
      , ' parentid root')
  from users
  where users.status = 'ACTIVE'
    and users.school_email != ''
  order by users.population, users.school_email;
-- below is old way, which shares individually
-- select concat(
--       'python ./gam/gam.py'
--       , ' user admin.google@sscps.org'
--       , ' add drivefileacl 0Byc5mfoLgdM3MDE0YjEyOWEtMjIxNi00YTE0LTgxZDgtODQxOGEwODU5YjE3'
--       , ' user ', users.school_email
--       , ' role reader')
--   from users
--   where users.status = 'ACTIVE'
--     and users.school_email != ''
--   order by users.population, users.school_email;


-- ****************************************************
-- School calendars for users for Google, via GAM script
-- ****************************************************
-- requires that users be in proper groups first
--gam user <user>|group <group>|ou <ou>|all users add calendar <calendar email> [selected true|false] [hidden true|false] [reminder email|sms|popup <minutes>] [notification email|sms eventcreation|eventchange|eventcancellation|eventresponse|agenda] [summary <summary>] [colorindex <1-24>] [backgroundcolor <htmlcolor>] [foregroundcolor <htmlcolor>]
-- SSCPS-FacStaff calendar for employees
select concat(
      'python ./gam/gam.py'
      , ' user ', users.school_email
      , ' add calendar sscps.org_mnh2vaotaksv4uf8cml2pgrsgg@group.calendar.google.com')
  from users
  where users.status = 'ACTIVE'
    and users.population = 'EMP'
    and users.school_email != ''
  order by users.population, users.school_email;
-- SSCPS-Main calendar for employees
select concat(
      'python ./gam/gam.py'
      , ' user ', users.school_email
      , ' add calendar sscps.org_2skq6kkh75tr8e8g0q3ooblh84@group.calendar.google.com')
  from users
  where users.status = 'ACTIVE'
    and users.population = 'EMP'
    and users.school_email != ''
  order by users.population, users.school_email;
-- SSCPS-Athletics calendar for employees
select concat(
      'python ./gam/gam.py'
      , ' user ', users.school_email
      , ' add calendar sscps.org_kiv73854jfpsvsh8luul29luj0@group.calendar.google.com')
  from users
  where users.status = 'ACTIVE'
    and users.population = 'EMP'
    and users.school_email != ''
  order by users.population, users.school_email;
-- library schedule calendar for employees
select concat(
      'python ./gam/gam.py'
      , ' user ', users.school_email
      , ' add calendar sscps.org_vl29nvplfr6s0avhmp8cpd39rk@group.calendar.google.com')
  from users
  where users.status = 'ACTIVE'
    and users.population = 'EMP'
    and users.school_email != ''
  order by users.population, users.school_email;
-- 100L Main Computer Lab calendar for employees
select concat(
      'python ./gam/gam.py'
      , ' user ', users.school_email
      , ' add calendar sscps.org_g58pmsteng42vtqrpc9pbsl1rk@group.calendar.google.com')
  from users
  where users.status = 'ACTIVE'
    and users.population = 'EMP'
    and users.school_email != ''
  order by users.population, users.school_email;
-- 100L Device Carts calendar for employees
select concat(
      'python ./gam/gam.py'
      , ' user ', users.school_email
      , ' add calendar sscps.org_9mded3l08bo9bf37cr48esu6us@group.calendar.google.com')
  from users
  where users.status = 'ACTIVE'
    and users.population = 'EMP'
    and users.school_email != ''
  order by users.population, users.school_email;
-- 700L Device Carts calendar for employees
select concat(
      'python ./gam/gam.py'
      , ' user ', users.school_email
      , ' add calendar sscps.org_cqs6p4h8fa9n3jfo6in3rhuha4@group.calendar.google.com')
  from users
  where users.status = 'ACTIVE'
    and users.population = 'EMP'
    and users.school_email != ''
  order by users.population, users.school_email;

-- ****************************************************
-- Reimport to AdminPlus to update school_email field
-- ****************************************************
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
--
-- this one is for parents@sscps.org
select 'python ./gam/gam.py update group parents@sscps.org remove group parents@sscps.org' as statement
  from import_
  s as import_junk
  limit 1
union
select 'python ./gam/gam.py update group parents@sscps.org add owner asavage@sscps.org' as statement
  from import_contacts as import_junk
  limit 1
union
select 'python ./gam/gam.py update group parents@sscps.org add owner mtondorf@sscps.org' as statement
  from import_contacts as import_junk
  limit 1
union
select 'python ./gam/gam.py update group parents@sscps.org add owner rdegennaro@sscps.org' as statement
  from import_contacts as import_junk
  limit 1
union
select concat(
      'python ./gam/gam.py update'
      , ' group', ' parents@sscps.org'
      , ' add member ', import.CONTACT_HOME_EMAIL
    ) as statement
  from import_contacts as import
  where (import.PRIMARY_CONTACT = 'Y' or import.PARENT_PORTAL_ACCESS = 'Y')
    and import.DO_NOT_EMAIL != 'Y'
    and import.CONTACT_HOME_EMAIL != ''

-- this one is for weeklyupdate@sscps.org
select 'python ./gam/gam.py update group weeklyupdate@sscps.org remove group weeklyupdate@sscps.org' as statement
  from import_contacts as import_junk
  limit 1
union
select 'python ./gam/gam.py update group weeklyupdate@sscps.org add owner palgera@sscps.org' as statement
  from import_contacts as import_junk
  limit 1
union
select 'python ./gam/gam.py update group weeklyupdate@sscps.org add owner rdegennaro@sscps.org' as statement
  from import_contacts as import_junk
  limit 1
union
select concat(
      'python ./gam/gam.py update'
      , ' group', ' weeklyupdate@sscps.org'
      , ' add member ', import.CONTACT_HOME_EMAIL
    ) as statement
  from import_contacts as import
  where (import.PRIMARY_CONTACT = 'Y' or import.PARENT_PORTAL_ACCESS = 'Y')
    and import.DO_NOT_EMAIL != 'Y'
    and import.CONTACT_HOME_EMAIL != ''
  group by import.CONTACT_HOME_EMAIL



-- select statement for just email addresses
SELECT `CONTACT_HOME_EMAIL`, `PRIMARY_CONTACT`, `PARENT_PORTAL_ACCESS`, `DO_NOT_EMAIL`
FROM `import_contacts`
WHERE (`PRIMARY_CONTACT` = 'Y' or `PARENT_PORTAL_ACCESS` = 'Y')
  and `DO_NOT_EMAIL` != 'Y'
  and `CONTACT_HOME_EMAIL` != ''
GROUP BY `CONTACT_HOME_EMAIL`
ORDER BY `PRIMARY_CONTACT`, `PARENT_PORTAL_ACCESS`, `CONTACT_HOME_EMAIL`
