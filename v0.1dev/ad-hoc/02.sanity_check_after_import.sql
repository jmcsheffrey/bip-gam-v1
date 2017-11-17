
-- ****************************************************
-- SCRIPTS FOR STUDENTS (after import)
-- ****************************************************
-- double/triple/quadruple check for conflicting fields that are supposed to be unique
-- results should be zero
select 'ERROR: duplicate unique_id.' as error_desc
    , unique_id, count
  from (select unique_id, count(unique_id) as count
          from import_students
          group by unique_id) as sumtable
  where count > 1;
select 'ERROR: duplicate school_email.' as error_desc
    , school_email, count
  from (select school_email, count(school_email) as count
          from import_students
          where school_email != '' and not (school_email is null)
          group by school_email) as sumtable
  where count > 1;

-- check for birthdate formats that are not %m-%d-%Y or %m/%d/%Y
-- results should be zero
select 'ERROR: Unexpected date format in birthdate.' as error_desc
    , unique_id
  from import_students as import
  where not (instr(`birthdate`,'-') > 0 or instr(`birthdate`,'/') > 0 or `birthdate` = '');

-- all high school students should have a graduating year of correct format
-- results should be zero
select 'ERROR:  Malformed expected graduation year.' as error_desc, unique_id, APID, full_name, expected_grad_year
  from import_students
  where length(expected_grad_year) < 4 and length(expected_grad_year) > 0;
select 'ERROR:  Malformed expected graduation year.' as error_desc, unique_id, APID, full_name, expected_grad_year
  from import_students
  where (not (upper(expected_grad_year) REGEXP '^-?[0-9]+$')) and length(expected_grad_year) > 0;

-- grades for students should always have leading zeros
-- results should be zero
select 'ERROR:  Malformed grade.'  as error_desc, unique_id, APID, full_name, grade
  from import_students
  where grade in ('K','k','1','2','3','4','5','6','7','8','9');
select 'ERROR:  Malformed grade.'  as error_desc, unique_id, APID, full_name, grade
  from import_students
  where grade not in ('0K','01','02','03','04','05','06','07','08','09','10','11','12');

-- homerooms for ACTIVE students should be 3 or 4 digit room number
-- results should be zero
select 'ERROR:  Homeroom malformed.'  as error_desc, unique_id, APID, full_name, homeroom
  from import_students
  where status = 'ACTIVE'
    and not (upper(homeroom) REGEXP '^-?[0-9]+$');
select 'ERROR:  Homeroom incorrect length.'  as error_desc, unique_id, APID, full_name, homeroom
  from import_students
  where status = 'ACTIVE'
    and (length(homeroom) != 3 and length(homeroom) != 4) ;

-- check for people in users and in import, but don't have emails in import, but do in users
-- results should be zero
select 'WARNING:  School email in USERS table, but not in IMPORT_ table. Was reimport to AdminPlus completed?'  as error_desc,
  users.unique_id, users.first_name, users.last_name, users.school_email as existing_email, import.school_email as new_email
from import_students as import
inner join users on import.unique_id = users.unique_id
where users.school_email != '' and import.school_email = '';

-- check for school_email that is non-empty & different between users and import_
-- results should be zero
select 'ERROR:  School email differs between USERS table and IMPORT_ table.'  as error_desc,
    users.unique_id, users.first_name, users.last_name, users.school_email as existing_email, import.school_email as new_email
  from users
  left join import_students as import on users.unique_id = import.unique_id
  where users.school_email != import.school_email and import.school_email != '';

-- NOT NEEDED because of new way to generate student login/email
-- check for names with more then even chance of being problematic
-- results should be zero
-- select 'WARNING:  Name may cause problems with login or email.'  as error_desc,
--    unique_id, APID, first_name, last_name
--  from import_students as import
--  where length(concat(import.first_name,import.last_name)) > 19
--    and import.school_email is NULL
--    and import.status != 'INACTIVE';

-- check for bad phone numbers, format is ###-###-####
-- results shoudl be zero
select 'ERROR:  PHONE_HOME field is malformed.' as error_desc,
    import.PKEY
    , import.APID
    , import.unique_id
    , import.full_name
    , import.phone_home
  from import_students as import
  where import.phone_home not REGEXP '[0-9]{3}-[0-9]{3}-[0-9]{4}'
    and import.phone_home != "";
select 'ERROR:  PHONE_CELL field is malformed.' as error_desc,
    import.PKEY
    , import.APID
    , import.unique_id
    , import.full_name
    , import.phone_cell
  from import_students as import
  where import.phone_cell not REGEXP '[0-9]{3}-[0-9]{3}-[0-9]{4}'
    and import.phone_cell != "";

-- ****************************************************
-- SCRIPTS FOR EMPLOYEES (after import)
-- ****************************************************
-- double/triple/quadruple check for conflicting fields that are supposed to be unique
-- results should be zero
select 'ERROR: duplicate unique_id.' as error_desc
    , unique_id, count
  from (select unique_id, count(unique_id) as count
          from import_employees
          group by unique_id) as sumtable
  where count > 1;
select 'ERROR: duplicate school_email.' as error_desc
    , school_email, count
  from (select school_email, count(school_email) as count
          from import_employees
          where school_email != '' and not (school_email is null)
          group by school_email) as sumtable
  where count > 1;

-- check for birthdate formats that are not %m-%d-%Y or %m/%d/%Y
-- results should be zero
select 'ERROR: Unexpected date format in birthdate.' as error_desc
    , unique_id
  from import_employees as import
  where not (instr(`birthdate`,'-') > 0 or instr(`birthdate`,'/') > 0 or `birthdate` = '')

-- check for birthdate formats that are not %m-%d-%Y or %m/%d/%Y
-- results should be zero
select 'ERROR: Unexpected date format in date_of_hire.' as error_desc
    , unique_id
  from import_employees as import
  where not (instr(`date_of_hire`,'-') > 0 or instr(`date_of_hire`,'/') > 0 or `date_of_hire` = '')

-- check for people in users and in import, but don't have emails in import, but do in users
-- results should be zero
select 'ERROR:  School email in USERS table, but not in IMPORT_ table.' as error_desc,
  users.unique_id, users.first_name, users.last_name, users.school_email as existing_email, import.school_email as new_email
from import_employees as import
inner join users on import.unique_id = users.unique_id
where users.school_email != '' and import.school_email = '';

-- check for school_email that is non-empty & different between users and import_
-- results should be zero
select 'ERROR:  School email differs between USERS table and IMPORT_ table.'  as error_desc,
    users.unique_id, users.first_name, users.last_name, users.school_email as existing_email, import.school_email as new_email
  from users
  left join import_employees as import on users.unique_id = import.unique_id
  where users.school_email != import.school_email and import.school_email != '';

-- check for names with more then even chance of being problematic
-- results should be zero
select  'WARNING:  Name may cause problems with login or email.'  as error_desc,
    unique_id, APID, first_name, last_name
  from import_employees as import
  where length(concat(import.first_name,import.last_name)) > 19
    and import.school_email is NULL
    and import.status != 'INACTIVE';

-- check for bad phone numbers, format is ###-###-####
-- results should be zero
select 'ERROR:  PHONE_HOME field is malformed.' as error_desc
    , import.PKEY
    , import.APID
    , import.unique_id
    , import.full_name
    , import.phone_home
  from import_employees as import
  where import.phone_home not REGEXP '[0-9]{3}-[0-9]{3}-[0-9]{4}'
    and import.phone_home != "";
select 'ERROR:  PHONE_CELL field is malformed.' as error_desc
    , import.PKEY
    , import.APID
    , import.unique_id
    , import.full_name
    , import.phone_cell
  from import_employees as import
  where import.phone_cell not REGEXP '[0-9]{3}-[0-9]{3}-[0-9]{4}'
    and import.phone_cell != "";

-- ****************************************************
-- SCRIPTS FOR GROUPINGS
-- ****************************************************
-- every section should have an entry in course list
-- results should be zero
select 'ERROR:  Course in import_schedules is not in import_courses.' as error_desc
    , import.course_id, import.course_name
from import_sections as import
where course_id not in (select num from import_courses);

-- any scheduled course should have an entry in course list
-- results should be zero
select 'ERROR:  Course in import_schedules and not in import_courses.' as error_desc
    , import.course_number, import.course_name
from import_schedules as import
where course_number not in (select num from import_courses);

-- every course scheduled in import_sections should have a display_level in import_courses
-- results should be zero
select 'ERROR:  Course in import_schedules does not have display_level in import_courses; add display_level or mark ignore_for_sync.' as error_desc
    , import.course_number, import.course_name
from import_schedules as import
left join import_courses as courses
  on import.course_number = courses.num
where courses.ignore_for_sync != 'Y'
  and (courses.display_level is null or courses.display_level = '')
group by import.course_number;

-- every course scheduled in import_sections should have 2, 3, 4, or HS as display_level in import_courses
-- results should be zero
select 'ERROR:  Course in import_schedules has incorrect display_level in import_courses; should be 2, 3, 4, HS.' as error_desc
    , import.course_number, import.course_name, courses.display_level
from import_schedules as import
left join import_courses as courses
  on import.course_number = courses.num
where courses.ignore_for_sync != 'Y'
  and courses.display_level not in ('2', '3', '4', 'HS')
group by import.course_number;


-- every scheduled course should have a display_name in course list
-- results should be zero
select 'ERROR:  Course in import_schedules does not have display_name in import_courses.' as error_desc
    , import.course_number, import.course_name
from import_schedules as import
left join import_courses as courses
  on import.course_number = courses.num
where courses.ignore_for_sync != 'Y'
  and (courses.display_name is null or courses.display_name = '')
group by import.course_number;


-- every scheduled "Level III" and "Level IV" course (except Workshop) should have a cohort in import_sections
-- results should be zero
select 'ERROR:  Section does not have cohort in import_sections.' as error_desc
    , courses.name, courses.description, import.course_number, import.section_number
from import_schedules as import
left join import_courses as courses
  on import.course_number = courses.num
left join section_cohorts as cohorts
  on import.course_number = cohorts.course_id and import.section_number = cohorts.section_id
where courses.ignore_for_sync != 'Y'
  and courses.display_level in ('3','4')
  and (cohorts.cohort = '' or cohorts.cohort is null)
group by import.course_number, import.section_number;
