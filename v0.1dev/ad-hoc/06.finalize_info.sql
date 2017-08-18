-- ***********************************************************
-- data that needs to be updated once everything updated from
-- outside source
-- ***********************************************************
-- don't ever empty import_ tables until process is done, only do it when importing
-- stuff below is for "down & dirty" direct workings on the database


------------------------
-- SCRIPTS FOR ALL USERS
------------------------
-- clean profile_server field
update users
  set profile_server = null
  where profile_server = ''

-- mark all INACTIVE students with grade of "LF" for left students
update users
  set grade = 'LF'
  where status = 'INACTIVE'
    and population = 'STU'

------------------------
-- SCRIPTS FOR STUDENTS
------------------------
-- set file server for all 700L students (High School)
update users
  set profile_server = 'RODRICK'
  where status = 'ACTIVE'
    and population = 'STU'
    and grade in ('09','10','11','12');

-- set file server for students at 100L, assumes 700L already set above
--this load balances students across servers,
--ignores 9-12 because they are assigned RODRICK above
--ignores 0K, 01, 02 because they use generic login
--only uses GREG, FREGLEY, ROWLEY because they are at 100L
--run until 0 rows updated
update users
  set profile_server = (select profile_server from nextprofileserver_100l_stu)
  where unique_id = (select next_unique_id from nextuserneedprofileserver_100l_stu);


-------------------------
-- SCRIPTS FOR EMPLOYEES
-------------------------
-- IMPORTANT: set file server manually for all 700L employees
-- set file server for employees at 100L, assumes 700L already set above
--this load balances students across servers,
--only uses GREG, FREGLEY, ROWLEY because they are at 100L
--run until 0 rows updated
update users
  set profile_server = (select profile_server from nextprofileserver_100l_emp)
  where unique_id = (select next_unique_id from nextuserneedprofileserver_100l_emp);
