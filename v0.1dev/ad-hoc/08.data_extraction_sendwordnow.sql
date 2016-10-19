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
    unique_id as unique_id,
    last_name as last_name,
    first_name as first_name,
    '' as pin_code,
    '' as group_id,
    '' as group_description,
    '' as address_1,
    '' as address_2,
    '' as city,
    '' as state_province,
    '' as zip_postalcode,
    '' as country,
    '' as time_zone,
    '' as preferred_language,
    '' as custom_label_1,
    '' as custom_value_1,
    '' as custom_label_2,
    '' as custom_value_2,
    'Home Phone' as phone_label_1,
    '' as phone_country_code_1,
    phone_home as phone_1,
    '' as phone_extension_1,
    '' as cascade_1,
    'Mobile Phone' as phone_label_2,
    '' as phone_country_code_2,
    phone_cell as phone_2,
    '' as phone_extension_2,
    '' as cascade_2,
    'Office Phone' as phone_label_3,
    '' as phone_country_code_3,
    '' as phone_3,
    '' as phone_extension_3,
    '' as cascade_3,
    'Home Email' as email_label_1,
    home_email as email_1,
    'Office Email' as email_label_2,
    school_email as email_2,
    '' as email_label_3,
    '' as email_3,
    '' as sms_label_1,
    '' as sms_1,
    '' as bb_pin_label_1,
    '' as bb_pin_1
  from users
  where population = 'EMP'
  order by unique_id
