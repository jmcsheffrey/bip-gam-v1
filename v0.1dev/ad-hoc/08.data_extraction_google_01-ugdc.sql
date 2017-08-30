-- ****************************************************
-- NOTE:  Keep order of items for everything.
-- NOTE:  This is first & for users, their groups,
--        drive & calendars.
-- ****************************************************


-- ****************************************************
-- Suspend INACTIVE users in Google
-- ****************************************************
-- suspend inactive employees, all are former employees as of 7/1,
select concat(
      '../bin/gam/gam'
      , ' update user '
      , users.school_email
      , ' suspended on'
      ,(case when users.population = 'STU' then ' org /Archive/Aging/Students'
        when users.population = 'EMP' then ' org /Archive/Aging/Employees'
        else 'ERROR' end)
    ) as '#suspend inactive employees'
  from users
  where users.school_email != ''
    and users.status = 'INACTIVE'
    and users.population = 'EMP'
  order by users.population, users.school_email

-- suspend inactive students who where not seniors from previous year
-- NOTE:  need to adjust year in script so last year's seniors can use account, see next script
select concat(
      '../bin/gam/gam'
      , ' update user '
      , users.school_email
      , ' suspended on'
      ,(case when users.population = 'STU' then ' org /Archive/Aging/Students'
        when users.population = 'EMP' then ' org /Archive/Aging/Employees'
        else 'ERROR' end)
    ) as '#suspend inactive students, non-seniors'
  from users
  where users.school_email != ''
    and users.status = 'INACTIVE'
    and users.population = 'STU'
    and users.expected_grad_year != '2017'
  order by users.population, users.school_email

-- suspend inactive seniors from previous year
-- NOTE:  need to adjust year in script to suspend last year's seniors (usually run after Thanksgiving)
select concat(
      '../bin/gam/gam'
      , ' update user '
      , users.school_email
      , ' suspended on'
      ,(case when users.population = 'STU' then ' org /Archive/Aging/Students'
        when users.population = 'EMP' then ' org /Archive/Aging/Employees'
        else 'ERROR' end)
    ) as '#suspend inactive students, seniors'
  from users
  where users.school_email != ''
    and users.status = 'INACTIVE'
    and users.population = 'STU'
    and users.expected_grad_year = '2016'
  order by users.population, users.school_email

-- ****************************************************
-- Create / Update ACTIVE users in Google
-- ****************************************************
-- create new users
-- gam create user <email address> firstname <First Name> lastname <Last Name> password <Password> changepassword on org <Org Name> externalid employeeID <unique_id>
select concat(
      '../bin/gam/gam'
      , ' create user ', users.school_email
      , ' firstname ', char(34), users.first_name, char(34)
      , ' lastname ', char(34), users.last_name, char(34)
      , ' password sscps123'
      , ' changepassword on'
      , ' org '
      , char(34), (case when users.population = 'EMP' then '/Prod/Employees/Standard (EMP)'
                    when users.population = 'STU' and users.grade = '12' then '/Prod/Students/Level-HS'
                    when users.population = 'STU' and users.grade = '11' then '/Prod/Students/Level-HS'
                    when users.population = 'STU' and users.grade = '10' then '/Prod/Students/Level-HS'
                    when users.population = 'STU' and users.grade = '09' then '/Prod/Students/Level-HS'
                    when users.population = 'STU' and users.grade = '08' then '/Prod/Students/Level-4'
                    when users.population = 'STU' and users.grade = '07' then '/Prod/Students/Level-4'
                    when users.population = 'STU' and users.grade = '06' then '/Prod/Students/Level-3'
                    when users.population = 'STU' and users.grade = '05' then '/Prod/Students/Level-3'
                    when users.population = 'STU' and users.grade = '04' then '/Prod/Students/Level-2'
                    when users.population = 'STU' and users.grade = '03' then '/Prod/Students/Level-2'
                    else 'ERROR' end), char(34)
      , ' externalid organization ', users.unique_id
    ) as '# create new users'
  from users
  where users.school_email != ''
    and users.status = 'ACTIVE'
    and users.newthisrun = 'Y'
    and (users.population = 'EMP'
         or users.grade in ('03', '04', '05', '06', '07', '08', '09', '10', '11', '12')
        )
  order by users.population, users.grade, users.school_email;
-- update existing users
--gam update user <email address> firstname <First Name> lastname <Last Name> org <Org Name> externalid employeeID <unique_id>
select concat(
      '../bin/gam/gam'
      , ' update user ', users.school_email
      , ' firstname ', char(34), users.first_name, char(34)
      , ' lastname ', char(34), users.last_name, char(34)
      , ' org '
      , char(34) ,(case when users.population = 'EMP' then '/Prod/Employees/Standard (EMP)', char(34)
                   when users.population = 'STU' and users.grade = '12' then '/Prod/Students/Level-HS', char(34)
                   when users.population = 'STU' and users.grade = '11' then '/Prod/Students/Level-HS', char(34)
                   when users.population = 'STU' and users.grade = '10' then '/Prod/Students/Level-HS', char(34)
                   when users.population = 'STU' and users.grade = '09' then '/Prod/Students/Level-HS', char(34)
                   when users.population = 'STU' and users.grade = '08' then '/Prod/Students/Level-4', char(34)
                   when users.population = 'STU' and users.grade = '07' then '/Prod/Students/Level-4', char(34)
                   when users.population = 'STU' and users.grade = '06' then '/Prod/Students/Level-3', char(34)
                   when users.population = 'STU' and users.grade = '05' then '/Prod/Students/Level-3', char(34)
                   when users.population = 'STU' and users.grade = '04' then '/Prod/Students/Level-2', char(34)
                   when users.population = 'STU' and users.grade = '03' then '/Prod/Students/Level-2', char(34)
                   else 'ERROR' end)
      , ' externalid organization ', users.unique_id
    ) '# update user info'
  from users
  where users.school_email != ''
    and users.status = 'ACTIVE'
    and users.newthisrun = 'N'
    and (users.population = 'EMP'
         or users.grade in ('03', '04', '05', '06', '07', '08', '09', '10', '11', '12')
        )
  order by users.population, users.school_email;


-- ****************************************************
-- Update Google groups
-- ****************************************************
-- gam update group <group email> remove {user <email address> | group <group address> | org <org name> | file <file name> | all users}

-- make sure employees@sscps.org is populated correctly
--empty sync group from previous runs (just in case)
select '../bin/gam/gam update group sys-synctempgroup@sscps.org sync member group sys-syncemptygroup@sscps.org' as '# populate employees@sscps.org'
union
select '../bin/gam/gam update group sys-synctempgroup@sscps.org sync owner group sys-syncemptygroup@sscps.org' as '# populate employees@sscps.org'
union
select '../bin/gam/gam update group sys-synctempgroup@sscps.org sync manager group sys-syncemptygroup@sscps.org' as '# populate employees@sscps.org'
union
--add users to sync group
select concat(
      '../bin/gam/gam'
      , ' update group '
      , 'sys-synctempgroup@sscps.org'
      , ' add member ', users.school_email
    ) as '# populate employees@sscps.org'
  from users
  where users.status = 'ACTIVE'
    and users.school_email != ''
    and users.population = 'EMP'
--sync real group with sync group
union
select '../bin/gam/gam update group employees@sscps.org sync member group sys-synctempgroup@sscps.org' as '# populate employees@sscps.org'
--clear out sync group for future runs
union
select '../bin/gam/gam update group sys-synctempgroup@sscps.org sync member group sys-syncemptygroup@sscps.org' as '# populate employees@sscps.org'
union
select '../bin/gam/gam update group sys-synctempgroup@sscps.org sync owner group sys-syncemptygroup@sscps.org' as '# populate employees@sscps.org'
union
select '../bin/gam/gam update group sys-synctempgroup@sscps.org sync manager group sys-syncemptygroup@sscps.org' as '# populate employees@sscps.org'

-- make sure facstaff@sscps.org is populated correctly
--empty sync group from previous runs (just in case)
select '../bin/gam/gam update group sys-synctempgroup@sscps.org sync member group sys-syncemptygroup@sscps.org' as '# populate facstaff@sscps.org'
union
select '../bin/gam/gam update group sys-synctempgroup@sscps.org sync owner group sys-syncemptygroup@sscps.org' as '# populate facstaff@sscps.org'
union
select '../bin/gam/gam update group sys-synctempgroup@sscps.org sync manager group sys-syncemptygroup@sscps.org' as '# populate facstaff@sscps.org'
union
--add users to sync group
select concat(
      '../bin/gam/gam'
      , ' update group '
      , 'sys-synctempgroup@sscps.org'
      , ' add member ', users.school_email
    ) as '# populate facstaff@sscps.org'
  from users
  where users.status = 'ACTIVE'
    and users.school_email != ''
    and users.population = 'EMP'
--sync real group with sync group
union
select '../bin/gam/gam update group employees@sscps.org sync member group sys-synctempgroup@sscps.org' as '# populate facstaff@sscps.org'
--clear out sync group for future runs
union
select '../bin/gam/gam update group sys-synctempgroup@sscps.org sync member group sys-syncemptygroup@sscps.org' as '# populate facstaff@sscps.org'
union
select '../bin/gam/gam update group sys-synctempgroup@sscps.org sync owner group sys-syncemptygroup@sscps.org' as '# populate facstaff@sscps.org'
union
select '../bin/gam/gam update group sys-synctempgroup@sscps.org sync manager group sys-syncemptygroup@sscps.org' as '# populate facstaff@sscps.org'

-- make sure students@student.sscps.org is populated correctly
-- TODO: remove inactive users
select concat(
      '../bin/gam/gam update group '
      , 'students@student.sscps.org'
      , ' add member ', users.school_email
    ) as '# populate students@student.sscps.org'
  from users
  where users.school_email != ''
    and users.status = 'ACTIVE'
    and users.newthisrun = 'Y'
    and users.population = 'STU'
  order by users.population, users.grade, users.school_email;

-- make sure students_<level>@student.ssscps.org are populated correctly
-- TODO: remove inactive users
select concat(
      '../bin/gam/gam update group '
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
    ) as  '# populate student level groups'
  from users
  where users.school_email != ''
    and users.status = 'ACTIVE'
    and users.newthisrun = 'Y'
    and users.population = 'STU'
    and users.grade in ('03', '04', '05', '06', '07', '08', '09', '10', '11', '12')
  order by users.population, users.grade, users.school_email;


-- add students to their "Graduating Year of" groups
-- NOTE: MUST create group manually first!!!
-- TODO: remove inactive users, but from currently active years
select '../bin/gam/gam update group gco-fy2018@student.sscps.org remove group gco-fy2018@student.sscps.org' as '# populate gco groups'
union
select '../bin/gam/gam update group gco-fy2018@student.sscps.org add owner mcarter@sscps.org' as '# populate gco groups'
union
select '../bin/gam/gam update group gco-fy2019@student.sscps.org remove group gco-fy2019@student.sscps.org' as '# populate gco groups'
union
select '../bin/gam/gam update group gco-fy2019@student.sscps.org add owner mcarter@sscps.org' as '# populate gco groups'
union
select '../bin/gam/gam update group gco-fy2020@student.sscps.org remove group gco-fy2020@student.sscps.org' as '# populate gco groups'
union
select '../bin/gam/gam update group gco-fy2020@student.sscps.org add owner mcarter@sscps.org' as '# populate gco groups'
union
select '../bin/gam/gam update group gco-fy2021@student.sscps.org remove group gco-fy2021@student.sscps.org' as '# populate gco groups'
union
select '../bin/gam/gam update group gco-fy2021@student.sscps.org add owner mcarter@sscps.org' as '# populate gco groups'
-- for some reason can't union the statement below
select concat(
      '../bin/gam/gam update group '
      , concat('gco-fy',users.expected_grad_year,'@student.sscps.org')
      , ' add member ', users.school_email
    ) as '# populate gco groups'
  from users
  where users.school_email != ''
    and users.status = 'ACTIVE'
    and users.population = 'STU'
    and users.grade in ('09','10','11','12')
  order by users.population, users.grade, users.school_email;


-- ****************************************************
-- Update Drive folders for users in Google
-- ****************************************************
-- requires that users be in proper groups first
-- gam user <user email> add drivefileacl <file id> [user|group|domain|anyone <value>] [withlink] [role <reader|commenter|writer|owner>] [sendemail] [emailmessage <message text>]

-- share with active users - the user's "My Drive" is not created until they log in
-- gam user targetUser@domain.org update drivefile id  0B8aCWH-xLi2NckxXOEp5REUtNEE parentid root
-- NOTE:  no need to share with individual users as the groups is working properly now
select concat(
      '../bin/gam/gam'
      , ' user ', users.school_email
      , ' update drivefile id 0Byc5mfoLgdM3MDE0YjEyOWEtMjIxNi00YTE0LTgxZDgtODQxOGEwODU5YjE3'
      , ' parentid root') as '# add users to SSCPS-GroupDocs'
  from users
  where users.school_email != ''
    and users.status = 'ACTIVE'
    and users.newthisrun = 'Y'
    and (users.population = 'EMP'
         or users.grade in ('03', '04', '05', '06', '07', '08', '09', '10', '11', '12')
        )
  order by users.population, users.school_email;


-- ****************************************************
-- Update School calendars for users in Google
-- ****************************************************
-- requires that users be in proper groups first
--gam user <user>|group <group>|ou <ou>|all users add calendar <calendar email> [selected true|false] [hidden true|false] [reminder email|sms|popup <minutes>] [notification email|sms eventcreation|eventchange|eventcancellation|eventresponse|agenda] [summary <summary>] [colorindex <1-24>] [backgroundcolor <htmlcolor>] [foregroundcolor <htmlcolor>]

-- SSCPS-Main calendar for students & employees
select concat(
      '../bin/gam/gam'
      , ' user ', users.school_email
      , ' add calendar sscps.org_2skq6kkh75tr8e8g0q3ooblh84@group.calendar.google.com') as '# populate SSCPS-Main calendar'
  from users
  where users.school_email != ''
    and users.status = 'ACTIVE'
    and users.newthisrun = 'Y'
    and (users.population = 'EMP'
         or users.grade in ('03', '04', '05', '06', '07', '08', '09', '10', '11', '12')
        )
  order by users.population, users.school_email;
-- SSCPS-Athletics calendar for students & employees
select concat(
      '../bin/gam/gam'
      , ' user ', users.school_email
      , ' add calendar sscps.org_kiv73854jfpsvsh8luul29luj0@group.calendar.google.com') as '# populate SSCPS-Athletics calendar'
  from users
  where users.school_email != ''
    and users.status = 'ACTIVE'
    and users.newthisrun = 'Y'
    and (users.population = 'EMP'
         or users.grade in ('03', '04', '05', '06', '07', '08', '09', '10', '11', '12')
        )
  order by users.population, users.school_email;

-- SSCPS-FacStaff calendar for employees
select concat(
      '../bin/gam/gam'
      , ' user ', users.school_email
      , ' add calendar sscps.org_mnh2vaotaksv4uf8cml2pgrsgg@group.calendar.google.com') as '# populate SSCPS-FacStaff calendar'
  from users
  where users.school_email != ''
    and users.status = 'ACTIVE'
    and users.newthisrun = 'Y'
    and users.population = 'EMP'
  order by users.population, users.school_email;

-- library schedule calendar for employees
select concat(
      '../bin/gam/gam'
      , ' user ', users.school_email
      , ' add calendar sscps.org_vl29nvplfr6s0avhmp8cpd39rk@group.calendar.google.com') as '# populate Library Schedule calendar'
  from users
  where users.school_email != ''
    and users.status = 'ACTIVE'
    and users.newthisrun = 'Y'
    and users.population = 'EMP'
  order by users.population, users.school_email;

-- ROOM NO LONGER EXISTS
-- 100L Main Computer Lab calendar for employees
--select concat(
--      '../bin/gam/gam'
--      , ' user ', users.school_email
--      , ' add calendar sscps.org_g58pmsteng42vtqrpc9pbsl1rk@group.calendar.google.com') as '# populate 100L Main Computer Lab calendar'
--  from users
--  where users.school_email != ''
--    and users.status = 'ACTIVE'
--    and users.newthisrun = 'Y'
--    and users.population = 'EMP'
--  order by users.population, users.school_email;

-- 100L Device Carts calendar for employees
select concat(
      '../bin/gam/gam'
      , ' user ', users.school_email
      , ' add calendar sscps.org_9mded3l08bo9bf37cr48esu6us@group.calendar.google.com') as '# populate 100L Device Carts calendar'
  from users
  where users.school_email != ''
    and users.status = 'ACTIVE'
    and users.newthisrun = 'Y'
    and users.population = 'EMP'
  order by users.population, users.school_email;

-- 700L Device Carts calendar for employees
select concat(
      '../bin/gam/gam'
      , ' user ', users.school_email
      , ' add calendar sscps.org_cqs6p4h8fa9n3jfo6in3rhuha4@group.calendar.google.com') as '# populate 700L Device Carts calendar'
  from users
  where users.school_email != ''
    and users.status = 'ACTIVE'
    and users.newthisrun = 'Y'
    and users.population = 'EMP'
  order by users.population, users.school_email;

-- ****************************************************
-- Get school_email field for reimport to AdminPlus
-- ****************************************************
select unique_id, school_email
  from users
  where users.school_email != ''
    and users.status = 'ACTIVE'
    and (substring(unique_id,1,3) != 'OTH' or substring(unique_id,1,3) != 'TST');
