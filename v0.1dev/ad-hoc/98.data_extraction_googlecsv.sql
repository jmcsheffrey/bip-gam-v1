-- ****************************************************
-- New users for Google, via CSV upload
-- ****************************************************
-- export students
select
    users.first_name as 'First Name',
    users.last_name as 'Last Name',
    users.school_email as 'Email Address',
    'sscps123' as 'Password',
    '' as 'Secondary Email',
    '' as 'Work Phone 1',
    '' as 'Home Phone 1',
    '' as 'Mobile Phone 1',
    '' as 'Work address 1',
    '' as 'Home address 1',
    users.unique_id as 'Employee Id',
    '' as 'Employee Type',
    '' as 'Employee Title',
    '' as 'Manager',
    users.grade as 'Department',
    users.status as 'Cost Center'
  from users
  left join import_students as import on users.unique_id = import.unique_id
  where users.status = 'ACTIVE' and users.population = 'STU'
    and users.school_email != '' and import.school_email = ''
  order by users.school_email
-- export employees
select
    first_name as 'First Name',
    last_name as 'Last Name',
    school_email as 'Email Address',
    'sscps123' as 'Password',
    '' as 'Secondary Email',
    '' as 'Work Phone 1',
    '' as 'Home Phone 1',
    '' as 'Mobile Phone 1',
    '' as 'Work address 1',
    '' as 'Home address 1',
    unique_id as 'Employee Id',
    '' as 'Employee Type',
    '' as 'Employee Title',
    '' as 'Manager',
    '' as 'Department',
    users.status as 'Cost Center'
  from users
  where users.status = 'ACTIVE' and users.population = 'STU'
    and users.school_email != '' and import.school_email = ''
  order by school_email
