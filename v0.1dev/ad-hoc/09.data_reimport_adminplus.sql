-- ****************************************************
-- Get school_email field for reimport to AdminPlus
-- ****************************************************
-- AdminPlus wants on file for students, one for staff/employees
--students for export
select unique_id, school_email
  from users
  where users.school_email != ''
    and users.status = 'ACTIVE'
    and users.population = 'STU'
    and not (users.unique_id like '%TST%')
--employees for export
select unique_id, school_email
  from users
  where users.school_email != ''
    and users.status = 'ACTIVE'
    and users.population = 'EMP'
    and not (users.unique_id like '%TST%')
