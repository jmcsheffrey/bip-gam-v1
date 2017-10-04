-- ****************************************************
-- Integration for Santillana contect delivery via schoology.com.
-- NOTE:  Keep order of items for everything.
-- NOTE:  This is first & for users, their groups,
--        drive & calendars.
-- ****************************************************


-- users
-- NOTE:  Double check course codes are correct, as don't need whole school
select '' as schoologoy_id
    , first_name
    , '' as middle_name
    , last_name
    , '' as name_prefix
    , '' as position
    , user_name
    , school_email
    , unique_id
    , (case when users.population = 'EMP' then 'longwater'
            when users.population = 'STU' then 'sscps123'
            else 'ERROR' end) as password
    , gender
    , expected_grad_year
    , (case when users.population = 'EMP' then 'Teacher'
            when users.population = 'STU' then 'Student'
            else 'ERROR' end) as role
    , 'SSCPS'
    , '' as additional_schools
  from users
  where users.school_email != ''
    and users.status = 'ACTIVE'
    and (users.population = 'EMP'
         or users.grade in ('03', '04', '05', '06', '07', '08', '09', '10', '11', '12')
        )
    and unique_id in (select gu.unique_id_user
                        from groupings_users as gu
                        where g.status = 'ACTIVE'
                          and (gu.unique_id_grouping like '%4407-%'
                               or gu.unique_id_grouping like '%4710-%'
                               or gu.unique_id_grouping like '%4720-%')
                        group by gu.unique_id_user)
  order by users.population, users.grade, users.school_email;

-- courses:
-- NOTE:  Double check course codes are correct, as don't need whole school
select g.name as course_name
    , '' as department_name
    , g.course_id
    , '' as credits
    , '' as course_description
    , concat(g.name, ' - ', g.time_block, ' (', (case
        when teachers.referred_to_as != ''
        then teachers.referred_to_as
        else teachers.first_name
        end), ')') as section_name
    , g.unique_id as section_school_code
    , g.unique_id as section_code
    , '' as section_description
    , '' as location
    , '' as school
    , '' as grading_periods
  from groupings as g
  left join groupings_users as gu
    on (g.unique_id = gu.unique_id_grouping) and gu.user_type = 'TCH'
  left join users as teachers on gu.unique_id_user = teachers.unique_id
  where g.status = 'ACTIVE'
    and (gu.unique_id_grouping like '%4407-%'
         or gu.unique_id_grouping like '%4710-%'
         or gu.unique_id_grouping like '%4720-%')
  order by teachers.referred_to_as, teachers.first_name, g.unique_id;


-- course enrollments:
-- NOTE:  Double check course codes are correct, as don't need whole school
--   Cource Code*
--   Section Code**
--   Section School Code**
--   User Unique ID*
--   Enrollment Type* (Admin | Member)
--   Grading Periods*
select g.course_id
    , gu.unique_id_grouping as section_school_code
    , gu.unique_id_grouping as section_code
    , gu.unique_id_user
    , (case when users.population = 'EMP' then 'Admin'
            when users.population = 'STU' then 'Member'
            else 'ERROR' end) as enrollment_type
    , '' as grading_periods
  from groupings_users as gu
  inner join groupings as g
    on gu.unique_id_grouping = g.unique_id
  inner join users
    on gu.unique_id_user = users.unique_id
  where g.status = 'ACTIVE'
    and (gu.unique_id_grouping like '%4407-%'
         or gu.unique_id_grouping like '%4710-%'
         or gu.unique_id_grouping like '%4720-%')
