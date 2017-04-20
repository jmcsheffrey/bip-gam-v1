-- ****************************************************
-- SendWordNow data via CSV upload
-- ****************************************************
-- export students & employees at the same time for loading
-- students contacts
select
    contact_household_id as unique_id,
    contact_first_name as First,
    contact_last_name as Last,
    addressstreet as "Address 1",
    addresscity as city,
    addressstate as state,
    addresszip as zip,
    'UNITED STATES' as country,
    'TITLE' as "Custom Label 1",
    'PARENTS' as "Custom Value 1",
    'School Email' as "Email Label 1",
    '' as "Email 1",
    'Home Email' as "Email Label 2",
    contact_home_email as "Email 2",
    'Employee Personal' as "Email Label 3",
    '' as "Email 3",
    'Parent Work Email' as "Email Label 4",
    contact_office_email as "Email 4",
    'Home Phone' as "Phone 1 Label",
    '1' as "Phone 1 Country Code",
    homephone as "Phone 1",
    homephoneextension as "Phone 1 Extension",
    '' as "Phone 1 Cascade",
    'Mobile Phone' as "Phone 2 Label",
    '1' as "Phone 2 Country Code",
    mobilephone as "Phone 2",
    '' as "Phone 2 Extension",
    '' as "Phone 2 Cascade",
    'Office Phone' as "Phone 3 Label",
    '1' as "Phone 3 Country Code",
    officephone as "Phone 3",
    officephoneextension as "Phone 3 Extension",
    '' as "Phone 3 Cascade"
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
    first_name as First,
    last_name as Last,
    '' as "Address 1",
    '' as city,
    '' as state,
    '' as zip,
    'UNITED STATES' as country,
    'TITLE' as "Custom Label 1",
    'EMPLOYEES' as "Custom Value 1",
    'School Email' as "Email Label 1",
    school_email as "Email 1",
    'Home Email' as "Email Label 2",
    '' as "Email 2",
    'Employee Personal' as "Email Label 3",
    home_email as "Email 3",
    'Parent Work Email' as "Email Label 4",
    '' as "Email 4",
    'Home Phone' as "Phone 1 Label",
    '1' as "Phone 1 Country Code",
    phone_home as "Phone 1",
    '' as "Phone 1 Extension",
    '' as "Phone 1 Cascade",
    'Mobile Phone' as "Phone 2 Label",
    '1' as "Phone 2 Country Code",
    phone_cell as "Phone 2",
    '' as "Phone 2 Extension",
    '' as "Phone 2 Cascade",
    'Office Phone' as "Phone 3 Label",
    '1' as "Phone 3 Country Code",
    '' as "Phone 3",
    '' as "Phone 3 Extension",
    '' as "Phone 3 Cascade"
  from users
  where population = 'EMP'
  order by unique_id
