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
