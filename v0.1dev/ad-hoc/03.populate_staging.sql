-- don't ever empty import_ tables until process is done, only do it when importing
-- stuff below is for "down & dirty" direct workings on the database

-- ***********************************************************
-- copy appropriate data from import_ tables to stagin_ tables
-- ***********************************************************
-- ** student statements
-- remove any student data from previous runs
truncate staging_students;
-- copy students
insert into staging_students
  select `PKEY`, `APID`, `full_name`, `unique_id`, `status`, `household_id`, `first_name`, `middle_name`, `last_name`,
    `school_email`, `grade`, convert(expected_grad_year, UNSIGNED INTEGER), `homeroom`, `homeroom_teacher_first`, `homeroom_teacher_last`, `referred_to_as`, `gender`,
    STR_TO_DATE(`birthdate`,'%m/%d/%Y'),
    STR_TO_DATE(`entry_date`,'%m/%d/%Y')
  from import_students
  order by grade, last_name, first_name, middle_name;
-- give emails to students who do not have it and need it
update staging_students
  set school_email =
    concat(substring(concat(
      replace(replace(replace(replace(replace(lower(first_name),char(46),char(0)),char(45),char(0)),char(44),char(0)),char(39),char(0)),char(32),char(0))
      , '_'
      , replace(replace(replace(replace(replace(lower(last_name),char(46),char(0)),char(45),char(0)),char(44),char(0)),char(39),char(0)),char(32),char(0))
    ),1,21), '@student.sscps.org')
  where (isnull(school_email) or school_email = '') and grade in ('03','04','05','06','07','08','09','10','11','12');
-- here are two new queries that I don't want to lose - rdegennaro
-- find next number value to use
select substring(max(school_email),instr(school_email, '@')-3,3)+1 as next_number,
  substring(max(school_email),instr(school_email, '@')-3,3) as max_number,
  substring(max(school_email),1,instr(school_email, '@')-4) as max_name
from users
where population = 'STU'
group by substring(school_email,1,instr(school_email, '@')-4)
-- combine next number value with what should be user_name
--    need to update as go & truncate to just 6 characters of last name
select concat(
  replace(
    replace(
      replace(
        replace(
          replace(substring(lower(first_name),1,1),char(46),char(0)),char(45),char(0)),char(44),char(0)),char(39),char(0)),char(32),char(0))
  ,replace(
    replace(
      replace(
        replace(
          replace(lower(last_name),char(46),char(0)),char(45),char(0)),char(44),char(0)),char(39),char(0)),char(32),char(0))
  ,case
      when next.next_number is null then '001'
      else next.next_number
      end
  ,'@student.sscps.org') as new_email
from staging_students as stage
left join (select substring(max(school_email),instr(school_email, '@')-3,3)+1 as next_number,
  substring(max(school_email),instr(school_email, '@')-3,3) as max_number,
  substring(max(school_email),1,instr(school_email, '@')-4) as max_name
from users
where population = 'STU'
group by substring(school_email,1,instr(school_email, '@')-4)) as next on next.max_name = concat(
  replace(
    replace(
      replace(
        replace(
          replace(substring(lower(first_name),1,1),char(46),char(0)),char(45),char(0)),char(44),char(0)),char(39),char(0)),char(32),char(0))
  ,replace(
    replace(
      replace(
        replace(
          replace(lower(last_name),char(46),char(0)),char(45),char(0)),char(44),char(0)),char(39),char(0)),char(32),char(0)))



-- make school_email null for everyone else so no duplicates (i.e. null is not checked as duplicate)
update staging_students
  set school_email = null
  where school_email = '';

-- ** employee statements
-- remove any employee data from previous runs
truncate staging_employees;
-- copy employees
insert into staging_employees
  select `PKEY`, `APID`, `full_name`, `unique_id`, `status`, `first_name`, `middle_name`, `last_name`,
    `school_email`, `homeroom`, `referred_to_as`, `gender`,
    STR_TO_DATE(`birthdate`,'%m/%d/%Y'),
    STR_TO_DATE(`date_of_hire`,'%m/%d/%Y'),
    position
  from import_employees
  order by last_name, first_name, middle_name;
-- give emails to all employees
update staging_employees
  set school_email =
    concat(substring(concat(
      replace(replace(replace(replace(replace(lower(substring(first_name,1,1)),char(46),char(0)),char(45),char(0)),char(44),char(0)),char(39),char(0)),char(32),char(0))
      , replace(replace(replace(replace(replace(lower(last_name),char(46),char(0)),char(45),char(0)),char(44),char(0)),char(39),char(0)),char(32),char(0))
    ),1,21), '@sscps.org')
  where isnull(school_email) or school_email = '';
  -- make school_email null for everyone else so no duplicates (i.e. null is not checked as duplicate)
  update staging_employees
    set school_email = null
    where school_email = '';
