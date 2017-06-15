-----------------------------------------------------------------------------
-- users based queries
-----------------------------------------------------------------------------
select * from staging_students where isnull(school_email) or school_email = ''
select * from staging_students where unique_id not in (select unique_id from users)
select * from staging_students where status = 'ACTIVE' and unique_id not in (select unique_id from users) order by grade DESC, school_email
select * from staging_students where grade in ('09','10','11','12') and status = 'ACTIVE' and unique_id not in (select unique_id from users) order by grade DESC, school_email

insert into users
  select `unique_id`, `status`, 'N' as `manual_entry`, 'STU' as `population`, `first_name`, `middle_name`, `last_name`,
    concat(lower(first_name), '_', lower(last_name)) as `user_name`,
    concat(lower(first_name), '_', lower(last_name), '@student.sscps.org') as `school_email`,
    `grade`, `homeroom`, `referred_to_as`, `gender`,
    STR_TO_DATE(`birthdate`,'%m/%d/%Y'),
    STR_TO_DATE(`entry_date`,'%m/%d/%Y'),
    '' as position,
    concat('SSCSPS Grade ', `grade`, ' Student') as description
  from import_students
  where `grade` in ('04','05','06','07','08','09','10','11','12')
  order by grade, last_name, first_name, middle_name;

insert into users
  select `unique_id`, `status`, 'N' as `manual_entry`, 'STU' as `population`, `first_name`, `middle_name`, `last_name`,
    concat (lower(substring(first_name,1,1)), lower(last_name)) as `user_name`,
    concat (lower(substring(first_name,1,1)), lower(last_name), '@sscps.org') as `school_email`,
    '' as `grade`, `homeroom`, `referred_to_as`, `gender`,
    STR_TO_DATE(`birthdate`,'%m/%d/%Y'),
    STR_TO_DATE(`date_of_hire`,'%m/%d/%Y'),
    position,
    'SSCSPS Employee' as description
  from import_employees
  order by last_name, first_name, middle_name;

SELECT * FROM `users` where population = 'STU' order by school_email

select * from users
  left join staging_students as stu on users.unique_id = stu.unique_id
  where users.status = 'ACTIVE' and stu.unique_id is not null

-- list students in existing data that do not have emails that are not in 3rd or 4th grade
select * from users
  where users.status = 'ACTIVE' and users.population = 'STU' and users.grade not in ('03','04') and (users.school_email = '' or isnull(users.school_email))

-- list all _NEW_ students between staging_students and users tables
select *
  from staging_students
  where grade in ('03','04','05','06','07','08','09','10','11','12') and status = 'ACTIVE' and unique_id not in (select unique_id from users)
  order by grade DESC, school_email

-- list user_name for students by truncating school_email
select school_email, substring(school_email,1,instr(school_email, '@')-1)
  from staging_students
  order by school_email

-- list all _NEW_ students for Google import
select first_name,last_name,school_email,"sscps123" as password,
    "" as Secondary_Email,"" as Work_Phone_1,"" as Home_Phone_1,"" as Mobile_Phone_1,"" as Work_address_1,"" as Home_address_1,unique_id
  from staging_students
  where grade in ('05','06','07','08','09','10','11','12') and status = 'ACTIVE' and unique_id not in (select unique_id from users)
  order by grade DESC, school_email

-- list all _NEW_ students for adding to groups or drive folders
select concat(school_email,char(44))
  from staging_students
  where grade in ('05','06','07','08','09','10','11','12') and status = 'ACTIVE' and unique_id not in (select unique_id from users)
  order by grade DESC, school_email

-- list removes duplicate records, assumes PKEY is primary (could be added)
--make temporary table
DROP TABLE IF EXISTS UniqueIDs;
CREATE Temporary table UniqueIDs (PKEY int(11));
--populate temporary table with records TO KEEP
insert into UniqueIDs
  (select PKEY FROM `import_students` a
  inner join (SELECT max(APID) as APID, unique_id FROM `import_students` group by unique_id) b
  on (a.APID = b.APID and a.unique_id = b.unique_id));
--remove records not in temporary table
delete from import_students where PKEY not in (select PKEY from UniqueIDs);


-- class of query
select concat(users.school_email, ",")
  from users
  where users.status = 'ACTIVE'
    and users.population = 'STU'
    and users.expected_grad_year = '2017'
  order by users.school_email

-- update import table emails based on users where email not in import
update import_students as import
  inner join users on import.unique_id = users.unique_id
  set import.school_email = users.school_email
  where import.school_email = ''









-- describe this!!!!
select
    users.unique_id,
    staging_students.status,
    'STU' as population,
    staging_students.first_name,
    staging_students.middle_name,
    staging_students.last_name,
    ??? as user_name,
    staging_students.school_email,
    staging_students.grade,
    staging_students.expected_grad_year,
    staging_students.homeroom,
    staging_students.referred_to_as,
    staging_students.gender,
    staging_students.birthdate,
    staging_students.entry_date,
    '' as position,
    concat ('SSCPS Grade ',staging_students.grade,' Student')
  from users
  join staging_students on users.unique_id = staging_students.unique_id


-- describe this!!!!
select concat(school_email,char(44))
  from staging_students
  where grade in ('09','10','11','12') and status = 'ACTIVE' and unique_id not in (select unique_id from users) order by grade DESC, school_email

-- describe this!!!!
select `unique_id`, `first_name`, `middle_name`, `last_name`,
  substring(concat(
    replace(replace(replace(replace(replace(lower(first_name),char(46),char(0)),char(45),char(0)),char(44),char(0)),char(39),char(0)),char(32),char(0))
    , '_'
    , replace(replace(replace(replace(replace(lower(last_name),char(46),char(0)),char(45),char(0)),char(44),char(0)),char(39),char(0)),char(32),char(0))
  ),1,21) as school_email_new
from staging_students

-- describe this!!!!
select `unique_id`, `first_name`, `middle_name`, `last_name`,
  substring(concat(
    substring(replace(replace(replace(replace(replace(lower(first_name),char(46),char(0)),char(45),char(0)),char(44),char(0)),char(39),char(0)),char(32),char(0)),1,1)
    , replace(replace(replace(replace(replace(lower(last_name),char(46),char(0)),char(45),char(0)),char(44),char(0)),char(39),char(0)),char(32),char(0))
  ),1,21) as school_email_new
from staging_employees

-- describe this!!!!!
select * from import_contacts_contactpoints as points
where points.contact_point_value != '' and points.contact_point_value is not null
  and points.CONTACT_HOUSEHOLD_ID = ''
order by
  points.CONTACT_GUID
  , points.contact_point_type
  , points.APID
