-- ****************************************************
-- Library data for Joomla _lendee table via SQL script
--    contact info done separately, but can use below in a spreadsheet
--    =(CONCATENATE("update s7rh8_booklibrary_lendee set contactname = '",A2,"' where lendeecode = '",C2,"';"))
--    =(CONCATENATE("update s7rh8_booklibrary_lendee set contactemail = '",B2,"' where lendeecode = '",C2,"';"))
-- ****************************************************
-- export students & staff at same time
select
    users.unique_id as lendeecode,
    concat (users.first_name, ' ', users.last_name) as full_name,
    max(contacts.CONTACT_FULL_NAME) as contactname,
    max(contacts.CONTACT_HOME_EMAIL) as contactemail,
    users.grade,
    concat (users.homeroom_teacher_first, ' ', users.homeroom_teacher_last) as homeroom_teacher,
    'Student' as population,
    0 as user_id
  from users
  left join import_contacts as contacts on users.current_year_id = contacts.APID
  where users.status = 'ACTIVE' and users.population = 'STU'
  group by users.unique_id
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
-- Library cards/book via CSV upload
--   note: contact info is separate table
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
