-- ****************************************************
-- Extract data to upload to Naviance via CSV upload
-- ****************************************************

-- ****************************************************
-- Export all students,
--   existing will be ignored on import to Naviance
-- ****************************************************
select
    unique_id as 'Student_ID',
    expected_grad_year as 'Class_Year',
    last_name,
    'SSCPS' as 'Campus_ID',
    first_name,
    middle_name,
    gender,
    homeroom_room,
    -- household_id as 'FC Registration Code',
    '' as 'FC Registration Code',
    user_name as 'FC User Name',
    'sscps123' as 'FC Password',
    grade,
    school_email
  from users
  where users.status = 'ACTIVE'
    and users.population = 'STU'
    and grade in ('09','10','11','12')
  order by grade, first_name, last_name

-- ****************************************************
-- Export new parents, no Naviance ID
-- ****************************************************
select
    users.unique_id as 'Student_ID',
    parents.CONTACT_GUID as 'Parent_ID',
    parents.NAVIANCE_PARENT_ID as 'Naviance_ID',
    parents.CONTACT_FIRST_NAME as 'first_name',
    parents.CONTACT_LAST_NAME as 'last_name',
    parents.CONTACT_HOME_EMAIL as 'Parent_Email',
    parents.HOMEPHONE as 'HomePhone',
    parents.PRIMARY_CONTACT as 'Has_Financial_Responsibility',
    parents.PRIMARY_CONTACT as 'Custodial'
  from import_contacts as parents
  inner join users on users.current_year_id = parents.APID
  where users.status = 'ACTIVE'
    and users.population = 'STU'
    and users.grade in ('09','10','11','12')
    and parents.NAVIANCE_PARENT_ID = ''
    and parents.PRIMARY_CONTACT = 'Y'

-- *****************************************************
-- Export parents already in Naviance (has Naviance ID)
-- *****************************************************
select
    users.unique_id as 'Student_ID',
    parents.CONTACT_GUID as 'Parent_ID',
    parents.NAVIANCE_PARENT_ID as 'Naviance_ID',
    parents.CONTACT_FIRST_NAME as 'first_name',
    parents.CONTACT_LAST_NAME as 'last_name',
    parents.CONTACT_HOME_EMAIL as 'Parent_Email',
    parents.HOMEPHONE as 'HomePhone',
    parents.PRIMARY_CONTACT as 'Has_Financial_Responsibility',
    parents.PRIMARY_CONTACT as 'Custodial'
  from import_contacts as parents
  inner join users on users.current_year_id = parents.APID
  where parents.NAVIANCE_PARENT_ID !=  ''
    and users.status = 'ACTIVE'
    and users.population = 'STU'
    and users.grade in ('09','10','11','12')
    and parents.PRIMARY_CONTACT = 'Y'
