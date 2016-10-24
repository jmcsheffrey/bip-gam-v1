-- ****************************************************
-- Naviance data via CSV upload
-- ****************************************************
-- export students
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

-- export parents
select
    users.unique_id as 'Student_ID',
    parents.CONTACT_GUID as 'Parent_ID',
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
    and parents.CONTACT_HOME_EMAIL != ''
    and parents.PRIMARY_CONTACT = 'Y'
