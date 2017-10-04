-- ****************************************************
-- NOTE:  Keep order of items for everything.
-- NOTE:  This is second & for Google Classroom only.
-- ****************************************************


-- ****************************************************
-- Archive prior year Google Classrooms, via GAM script
-- ****************************************************
-- unique_id must be alias to be able to connect to classroom without knowing Google ID

-- mark all google classrooms from prior year as INACTIVE
update groupings
  set status = 'INACTIVE'
  where current_year != 'FY18';

-- archive appropriate classrooms
-- gam update course <alias> status ARCHIVED
select concat(
      '../../bin/gam/gam'
      , ' update course ', g.unique_id
      , ' status ARCHIVED'
    ) as '# archive classrooms'
  from groupings as g
  where g.status = 'INACTIVE'
  order by g.unique_id;

-- ****************************************************
-- Setup current year Google Classrooms, via GAM script
-- ****************************************************
-- unique_id must be alias to be able to connect to classroom without knowing Google ID

-- create classrooms; teacher must be set so admin user is not added by default
-- gam create course [alias <alias>] [name <name>] [section <section>] teacher <teacher email> status ACTIVE
select concat(
      '../../bin/gam/gam create course'
      , ' alias ', g.unique_id
      , ' teacher ', teachers.school_email
      , ' name ', char(34), concat(g.name, ' - ', g.time_block, ' (', (case
        when teachers.referred_to_as != ''
        then teachers.referred_to_as
        else teachers.first_name
        end), ')'), char(34)
      , ' section ', char(34), concat(g.course_id, '/', g.section_id,'-',g.current_year), char(34)
      , ' status', ' ACTIVE'
    ) as '# create classrooms with teacher'
  from groupings as g
  left join groupings_users as gu
    on g.unique_id = gu.unique_id_grouping and gu.user_type = 'TCH'
  left join users as teachers on gu.unique_id_user = teachers.unique_id
  where g.status = 'ACTIVE'
  order by teachers.referred_to_as, teachers.first_name, g.unique_id;

-- assign teachers to Classrooms
-- gam course <alias> add teacher <email address>
-- not needed until set multiple teachers to one section (manually or from adminplus)

-- assign students to Classrooms
-- gam course <alias> add student <email address>
select concat(
      '../../bin/gam/gam course'
      , ' ', gu.unique_id_grouping
      , ' add student ', students.school_email
    ) as '# assign classrooms to students'
  from groupings_users as gu
  inner join users as students on gu.unique_id_user = students.unique_id
  where gu.user_type = 'STU' and gu.status = 'ACTIVE'
    -- comment in/out depending if want to update everyone or not
    and students.newthisrun = 'Y'
