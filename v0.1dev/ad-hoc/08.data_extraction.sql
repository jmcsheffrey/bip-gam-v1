-- ****************************************************
-- This file now smaller extracts; other files by
-- destination.
-- ****************************************************
-- TODO
--  SendWordNow - add phones to users for employees
--  SendWordNow - some families have multiple people in household_id,
--                right now just first record, need to check for dups & split out to multiple fields


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


-- ****************************************************
-- Naviance data via CSV upload
-- ****************************************************
-- export students
select
    unique_id as 'Student_ID',
    expected_grad_year as 'Class_Year',
    grade,
    first_name,
    last_name,
    middle_name,
    gender,
    homeroom_room,
    household_id as 'FC Registration Code',
    user_name as 'FC User Name',
    school_email,
    'sscps123' as 'FC Password'
  from users
  where users.status = 'ACTIVE' and users.population = 'STU' and grade in ('09','10','11','12')
  order by grade, first_name, last_name

-- ****************************************************
-- SendWordNow data via CSV upload
-- ****************************************************
-- export students & employees at the same time for loading
-- students contacts
select
    contact_household_id as unique_id,
    contact_last_name as last_name,
    contact_first_name as first_name,
    '' as pin_code,
    '' as group_id,
    '' as group_description,
    addressstreet as address_1,
    '' as address_2,
    addresscity as city,
    addressstate as state_province,
    addresszip as zip_postalcode,
    '' as country,
    '' as time_zone,
    '' as preferred_language,
    '' as custom_label_1,
    '' as custom_value_1,
    '' as custom_label_2,
    '' as custom_value_2,
    'Home Phone' as phone_label_1,
    '' as phone_country_code_1,
    homephone as phone_1,
    homephoneextension as phone_extension_1,
    '' as cascade_1,
    'Mobile Phone' as phone_label_2,
    '' as phone_country_code_2,
    mobilephone as phone_2,
    '' as phone_extension_2,
    '' as cascade_2,
    'Office Phone' as phone_label_3,
    '' as phone_country_code_3,
    officephone as phone_3,
    officephoneextension as phone_extension_3,
    '' as cascade_3,
    'Home Email' as email_label_1,
    contact_home_email as email_1,
    'Office Email' as email_label_2,
    contact_office_email as email_2,
    '' as email_label_3,
    '' as email_3,
    '' as sms_label_1,
    '' as sms_1,
    '' as bb_pin_label_1,
    '' as bb_pin_1
  from import_contacts
  where contact_household_id != ''
    and primary_contact = 'Y'
    and (do_not_call != 'Y' or do_not_email != 'Y')
  group by contact_household_id
  order by contact_household_id
-- below does not work, need to add phone to users process
union
select
    contact_household_id as unique_id,
    contact_last_name as last_name,
    contact_first_name as first_name,
    '' as pin_code,
    '' as group_id,
    '' as group_description,
    addressstreet as address_1,
    '' as address_2,
    addresscity as city,
    addressstate as state_province,
    addresszip as zip_postalcode,
    '' as country,
    '' as time_zone,
    '' as preferred_language,
    '' as custom_label_1,
    '' as custom_value_1,
    '' as custom_label_2,
    '' as custom_value_2,
    'Home Phone' as phone_label_1,
    '' as phone_country_code_1,
    homephone as phone_1,
    homephoneextension as phone_extension_1,
    '' as cascade_1,
    'Mobile Phone' as phone_label_2,
    '' as phone_country_code_2,
    mobilephone as phone_2,
    '' as phone_extension_2,
    '' as cascade_2,
    'Office Phone' as phone_label_3,
    '' as phone_country_code_3,
    officephone as phone_3,
    officephoneextension as phone_extension_3,
    '' as cascade_3,
    'Home Email' as email_label_1,
    contact_home_email as email_1,
    'Office Email' as email_label_2,
    contact_office_email as email_2,
    '' as email_label_3,
    '' as email_3,
    '' as sms_label_1,
    '' as sms_1,
    '' as bb_pin_label_1,
    '' as bb_pin_1
  from users
  where population = 'EMP'
  order by unique_id
