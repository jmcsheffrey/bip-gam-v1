-- ****************************************************
-- NOTE:  This file is for other miscellaneous scripts.
-- ****************************************************



-- For "Student Login List" Google Spreadsheets in SSCPS-GroupDocs.
--order for each cut & paste
select concat (homeroom_teacher_first, " ", homeroom_teacher_last) as homeroom
    , grade, first_name, last_name, user_name, school_email
    , (case when users.population = 'EMP' then '/Prod/Employees/Standard (EMP)'
                  when users.population = 'STU' and users.grade = '12' then 'High School'
                  when users.population = 'STU' and users.grade = '11' then 'High School'
                  when users.population = 'STU' and users.grade = '10' then 'High School'
                  when users.population = 'STU' and users.grade = '09' then 'High School'
                  when users.population = 'STU' and users.grade = '08' then 'Level 4'
                  when users.population = 'STU' and users.grade = '07' then 'Level 4'
                  when users.population = 'STU' and users.grade = '06' then 'Level 3'
                  when users.population = 'STU' and users.grade = '05' then 'Level 3'
                  when users.population = 'STU' and users.grade = '04' then 'Level 2'
                  when users.population = 'STU' and users.grade = '03' then 'Level 2'
                  else 'ERROR' end) as level
  from users
  where users.grade in ('03', '04', '05', '06', '07', '08', '09', '10', '11', '12')
    -- comment in/out depending if want to update everyone or not
    and users.newthisrun = 'Y'
  order by level, homeroom, grade, first_name, last_name
