-- *******************************************************
-- Export data from Naviance to keep track of Naviance ID
-- *******************************************************
-- This might not be needed because Naviance can now store GUID for contacts.
-- Doing it now just to cleanup the data in Naviance to have GUID for contacts.
-- Might also be useful until get contacts into USERS table.

-- ****************************************************
-- Parents data from Naviance to get imported
-- ****************************************************

-- first empty import table
truncate import_naviance_parents;

-- check that data looks good
select users.unique_id as student_school_id,
    navi.succeed_parent_id,
    parents.CONTACT_GUID as 'parent_school_id',
    parents.CONTACT_FIRST_NAME as 'first_name',
    parents.CONTACT_LAST_NAME as 'last_name',
    parents.CONTACT_HOME_EMAIL as 'Parent_Email',
    parents.HOMEPHONE as 'HomePhone',
    parents.PRIMARY_CONTACT as 'Has_Financial_Responsibility',
    parents.PRIMARY_CONTACT as 'Custodial'
  from import_naviance_parents as navi
  inner join import_contacts as parents on navi.email = parents.CONTACT_HOME_EMAIL
  inner join users on parents.APID = users.current_year_id
  where users.status = 'ACTIVE'
    and users.population = 'STU'
    and users.grade in ('09','10','11','12')
    and parents.NAVIANCE_PARENT_ID = ''
  order by parents.CONTACT_GUID, users.unique_id

-- now update import_contacts with Naviance ID
update import_contacts as parents
  inner join import_naviance_parents as navi on navi.email = parents.CONTACT_HOME_EMAIL
  set parents.NAVIANCE_PARENT_ID = navi.succeed_parent_id
