-- ****************************************************
-- SendWordNow data via CSV upload
-- ****************************************************
-- export students & employees at the same time for loading
-- students contacts
select
      users.first_name
      , users.last_name
      , users.unique_id as zipgrade_id
      , users.unique_id as external_id
  from users
  where users.school_email != ''
    and users.status = 'ACTIVE'
    and users.grade in ('07', '08')
  order by users.unique_id
