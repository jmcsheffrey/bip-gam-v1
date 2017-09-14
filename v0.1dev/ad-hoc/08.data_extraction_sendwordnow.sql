-- ****************************************************
-- SendWordNow data via CSV upload
-- ****************************************************
-- export students & employees at the same time for loading
-- students contacts
select import.contact_household_id as unique_id
    , import.contact_first_name as First
    , import.contact_last_name as Last
    , import.addressstreet as "Address 1"
    , import.addresscity as city
    , import.addressstate as state
    , import.addresszip as zip
    , 'UNITED STATES' as country
    , 'TITLE' as "Custom Label 1"
    , 'PARENTS' as "Custom Value 1"
    , 'School Email' as "Email Label 1"
    , '' as "Email 1"
    , 'Home Email' as "Email Label 2"
    , import.contact_home_email as "Email 2"
    , 'Employee Personal' as "Email Label 3"
    , '' as "Email 3"
    , 'Parent Work Email' as "Email Label 4"
    , import.contact_office_email as "Email 4"
    , 'Home Phone' as "Phone 1 Label"
    , '1' as "Phone 1 Country Code"
    , (case when import.NO_CALL_HOME != 'Y' then import.homephone
                  else '' end) as "Phone 1"
    , import.homephoneextension as "Phone 1 Extension"
    , '' as "Phone 1 Cascade"
    , 'Mobile Phone' as "Phone 2 Label"
    , '1' as "Phone 2 Country Code"
    , (case when import.NO_CALL_CELL != 'Y' then import.mobilephone
                  else '' end) as "Phone 2"
    , '' as "Phone 2 Extension"
    , '' as "Phone 2 Cascade"
    , 'Office Phone' as "Phone 3 Label"
    , '1' as "Phone 3 Country Code"
    , import.officephone as "Phone 3"
    , import.officephoneextension as "Phone 3 Extension"
    , '' as "Phone 3 Cascade"
  from import_contacts as import
  inner join users on import.APID = users.current_year_id
  where users.status = 'ACTIVE'
  group by import.contact_household_id
union
select users.unique_id as unique_id
    , users.first_name as First
    , users.last_name as Last
    , '' as "Address 1"
    , '' as city
    , '' as state
    , '' as zip
    , 'UNITED STATES' as country
    , 'TITLE' as "Custom Label 1"
    , 'EMPLOYEES' as "Custom Value 1"
    , 'School Email' as "Email Label 1"
    , users.school_email as "Email 1"
    , 'Home Email' as "Email Label 2"
    , '' as "Email 2"
    , 'Employee Personal' as "Email Label 3"
    , users.home_email as "Email 3"
    , 'Parent Work Email' as "Email Label 4"
    , '' as "Email 4"
    , 'Home Phone' as "Phone 1 Label"
    , '1' as "Phone 1 Country Code"
    , users.phone_home as "Phone 1"
    , '' as "Phone 1 Extension"
    , '' as "Phone 1 Cascade"
    , 'Mobile Phone' as "Phone 2 Label"
    , '1' as "Phone 2 Country Code"
    , users.phone_cell as "Phone 2"
    , '' as "Phone 2 Extension"
    , '' as "Phone 2 Cascade"
    , 'Office Phone' as "Phone 3 Label"
    , '1' as "Phone 3 Country Code"
    , '' as "Phone 3"
    , '' as "Phone 3 Extension"
    , '' as "Phone 3 Cascade"
  from users
  where population = 'EMP'
    and status - 'ACTIVE'
  order by unique_id


-- ****************************************************
-- another version with contacts without household_id
-- NOTE:  This has too many contacts.  Will need to de-normalize
-- ****************************************************
-- export students & employees at the same time for loading
-- students contacts
select import.CONTACT_GUID as unique_id
    , import.contact_first_name as First
    , import.contact_last_name as Last
    , import.addressstreet as "Address 1"
    , import.addresscity as city
    , import.addressstate as state
    , import.addresszip as zip
    , 'UNITED STATES' as country
    , 'TITLE' as "Custom Label 1"
    , 'PARENTS' as "Custom Value 1"
    , 'School Email' as "Email Label 1"
    , '' as "Email 1"
    , 'Home Email' as "Email Label 2"
    , import.contact_home_email as "Email 2"
    , 'Employee Personal' as "Email Label 3"
    , '' as "Email 3"
    , 'Parent Work Email' as "Email Label 4"
    , import.contact_office_email as "Email 4"
    , 'Home Phone' as "Phone 1 Label"
    , '1' as "Phone 1 Country Code"
    , (case when import.NO_CALL_HOME != 'Y' then import.homephone
                  else '' end) as "Phone 1"
    , import.homephoneextension as "Phone 1 Extension"
    , '' as "Phone 1 Cascade"
    , 'Mobile Phone' as "Phone 2 Label"
    , '1' as "Phone 2 Country Code"
    , (case when import.NO_CALL_CELL != 'Y' then import.mobilephone
                  else '' end) as "Phone 2"
    , '' as "Phone 2 Extension"
    , '' as "Phone 2 Cascade"
    , 'Office Phone' as "Phone 3 Label"
    , '1' as "Phone 3 Country Code"
    , import.officephone as "Phone 3"
    , import.officephoneextension as "Phone 3 Extension"
    , '' as "Phone 3 Cascade"
  from import_contacts as import
  inner join users on import.APID = users.current_year_id
  where users.status = 'ACTIVE'
union
select users.unique_id as unique_id
    , users.first_name as First
    , users.last_name as Last
    , '' as "Address 1"
    , '' as city
    , '' as state
    , '' as zip
    , 'UNITED STATES' as country
    , 'TITLE' as "Custom Label 1"
    , 'EMPLOYEES' as "Custom Value 1"
    , 'School Email' as "Email Label 1"
    , users.school_email as "Email 1"
    , 'Home Email' as "Email Label 2"
    , '' as "Email 2"
    , 'Employee Personal' as "Email Label 3"
    , users.home_email as "Email 3"
    , 'Parent Work Email' as "Email Label 4"
    , '' as "Email 4"
    , 'Home Phone' as "Phone 1 Label"
    , '1' as "Phone 1 Country Code"
    , users.phone_home as "Phone 1"
    , '' as "Phone 1 Extension"
    , '' as "Phone 1 Cascade"
    , 'Mobile Phone' as "Phone 2 Label"
    , '1' as "Phone 2 Country Code"
    , users.phone_cell as "Phone 2"
    , '' as "Phone 2 Extension"
    , '' as "Phone 2 Cascade"
    , 'Office Phone' as "Phone 3 Label"
    , '1' as "Phone 3 Country Code"
    , '' as "Phone 3"
    , '' as "Phone 3 Extension"
    , '' as "Phone 3 Cascade"
  from users
  where population = 'EMP'
    and status - 'ACTIVE'
  order by unique_id
