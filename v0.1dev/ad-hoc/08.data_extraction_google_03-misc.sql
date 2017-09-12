-- ****************************************************
-- Integration for Weekly Update & Parent lists.
-- NOTE:  Keep order of items for everything.
-- NOTE:  This is third & misc queries:
--        1.  parents@sscps.org
--        2.  weeklyupdate@sscps.org
-- ****************************************************


-- ****************************************************
-- Setup weeklyupdate@sscps.org
-- NOTE:  Sometimes phpMyAdmin seems to add the initial
--        remove & add owner statements to each page.
-- ****************************************************
-- cut & paste, do not run in SQL
# update weeklyupdate@sscps.org
../bin/gam/gam update group weeklyupdate@sscps.org remove group weeklyupdate@sscps.org
../bin/gam/gam update group weeklyupdate@sscps.org add owner palgera@sscps.org
-- now run each SQL below
-- add in Board of Trustees
select concat(
      '../bin/gam/gam update'
      , ' group', ' weeklyupdate@sscps.org'
      , ' add member ', users.home_email
    ) as '# update weeklyupdate@sscps.org'
  from users
  where users.home_email != ''
    and users.status = 'ACTIVE'
    and users.population = 'BOT'
-- add in vendors
select concat(
      '../bin/gam/gam update'
      , ' group', ' weeklyupdate@sscps.org'
      , ' add member ', users.home_email
    ) as '# update weeklyupdate@sscps.org'
  from users
  where users.home_email != ''
    and users.status = 'ACTIVE'
    and users.population = 'VND'
-- add in other contacts
select concat(
      '../bin/gam/gam update'
      , ' group', ' weeklyupdate@sscps.org'
      , ' add member ', users.home_email
    ) as '# update weeklyupdate@sscps.org'
  from users
  where users.home_email != ''
    and users.status = 'ACTIVE'
    and users.population = 'OTH'
-- add in employees
select concat(
      '../bin/gam/gam update'
      , ' group', ' weeklyupdate@sscps.org'
      , ' add member ', users.school_email
    ) as '# update weeklyupdate@sscps.org'
  from users
  where users.school_email != ''
    and users.status = 'ACTIVE'
    and users.population = 'EMP'
-- add in parents primary address unless requested to not
select concat(
      '../bin/gam/gam update'
      , ' group', ' weeklyupdate@sscps.org'
      , ' add member ', import.CONTACT_HOME_EMAIL
    ) as '# update weeklyupdate@sscps.org'
  from import_contacts as import
  inner join users on import.APID = users.current_year_id
  where import.CONTACT_HOME_EMAIL != ''
    and import.NO_EMAIL != 'Y'
    and users.status = 'ACTIVE'
  group by import.CONTACT_HOME_EMAIL
-- add in parents secondary address if requested to add
select concat(
      '../bin/gam/gam update'
      , ' group', ' weeklyupdate@sscps.org'
      , ' add member ', import.CONTACT_OFFICE_EMAIL
    ) as '# update weeklyupdate@sscps.org'
  from import_contacts as import
  inner join users on import.APID = users.current_year_id
  where import.CONTACT_OFFICE_EMAIL != ''
    and import.EMAIL_ALTERNATE = 'Y'
    and users.status = 'ACTIVE'
  group by import.CONTACT_HOME_EMAIL;


-- ****************************************************
-- Setup parents@sscps.org
-- NOTE:  Sometimes phpMyAdmin seems to add the initial
--        remove & add owner statements to each page.
-- ****************************************************
-- cut & paste, do not run in SQL
# update parents@sscps.org
../bin/gam/gam update group parents@sscps.org remove group parents@sscps.org
../bin/gam/gam update group parents@sscps.org add owner asavage@sscps.org
../bin/gam/gam update group parents@sscps.org add owner mtondorf@sscps.org
../bin/gam/gam update group parents@sscps.org add member rdegennaro@sscps.org
../bin/gam/gam update group parents@sscps.org add member palgera@sscps.org
-- now run the SQL below
select concat(
      '../bin/gam/gam update'
      , ' group', ' parents@sscps.org'
      , ' add member ', import.CONTACT_HOME_EMAIL
    ) as '# update parents@sscps.org'
  from import_contacts as import
  inner join users on import.APID = users.current_year_id and users.status = 'ACTIVE'
  where import.CONTACT_HOME_EMAIL != ''
    and import.NO_EMAIL != 'Y'
  group by import.CONTACT_HOME_EMAIL;

-- ****************************************************
-- Setup parents_<levels>@sscps.org
-- ****************************************************
-- cut & paste, do not run in SQL, level 1
# update parents_level1@sscps.org
../bin/gam/gam update group parents_level1@sscps.org remove group parents_level1@sscps.org
../bin/gam/gam update group parents_level1@sscps.org add owner asavage@sscps.org
../bin/gam/gam update group parents_level1@sscps.org add owner mtondorf@sscps.org
../bin/gam/gam update group parents_level1@sscps.org add member rdegennaro@sscps.org
../bin/gam/gam update group parents_level1@sscps.org add member palgera@sscps.org
-- now run the SQL below, level 1 parents
select concat(
      '../bin/gam/gam update'
      , ' group', ' parents_level1@sscps.org'
      , ' add member ', import.CONTACT_HOME_EMAIL
    ) as '# update parents_<levels>@sscps.org'
  from import_contacts as import
  inner join users on import.APID = users.current_year_id and users.status = 'ACTIVE'
    and users.grade in ('0K','01','02')
  where import.CONTACT_HOME_EMAIL != ''
    and import.NO_EMAIL != 'Y'
  group by import.CONTACT_HOME_EMAIL
-- cut & paste, do not run in SQL, level 2
# update parents_level2@sscps.org
../bin/gam/gam update group parents_level2@sscps.org remove group parents_level2@sscps.org
../bin/gam/gam update group parents_level2@sscps.org add owner asavage@sscps.org
../bin/gam/gam update group parents_level2@sscps.org add owner mtondorf@sscps.org
../bin/gam/gam update group parents_level2@sscps.org add member rdegennaro@sscps.org
../bin/gam/gam update group parents_level2@sscps.org add member palgera@sscps.org
-- now run the SQL below, level 2 parents
select concat(
      '../bin/gam/gam update'
      , ' group', ' parents_level2@sscps.org'
      , ' add member ', import.CONTACT_HOME_EMAIL
    ) as '# update parents_<levels>@sscps.org'
  from import_contacts as import
  inner join users on import.APID = users.current_year_id and users.status = 'ACTIVE'
    and users.grade in ('03','04')
  where import.CONTACT_HOME_EMAIL != ''
    and import.NO_EMAIL != 'Y'
  group by import.CONTACT_HOME_EMAIL
-- cut & paste, do not run in SQL, level 3
# update parents_level3@sscps.org
../bin/gam/gam update group parents_level3@sscps.org remove group parents_level3@sscps.org
../bin/gam/gam update group parents_level3@sscps.org add owner asavage@sscps.org
../bin/gam/gam update group parents_level3@sscps.org add owner mtondorf@sscps.org
../bin/gam/gam update group parents_level3@sscps.org add member rdegennaro@sscps.org
../bin/gam/gam update group parents_level3@sscps.org add member palgera@sscps.org
-- now run the SQL below, level 3 parents
select concat(
      '../bin/gam/gam update'
      , ' group', ' parents_level3@sscps.org'
      , ' add member ', import.CONTACT_HOME_EMAIL
    ) as '# update parents_<levels>@sscps.org'
  from import_contacts as import
  inner join users on import.APID = users.current_year_id and users.status = 'ACTIVE'
    and users.grade in ('05','06')
  where import.CONTACT_HOME_EMAIL != ''
    and import.NO_EMAIL != 'Y'
  group by import.CONTACT_HOME_EMAIL
-- cut & paste, do not run in SQL, level 4
# update parents_level4@sscps.org
../bin/gam/gam update group parents_level4@sscps.org remove group parents_level4@sscps.org
../bin/gam/gam update group parents_level4@sscps.org add owner asavage@sscps.org
../bin/gam/gam update group parents_level4@sscps.org add owner mtondorf@sscps.org
../bin/gam/gam update group parents_level4@sscps.org add member rdegennaro@sscps.org
../bin/gam/gam update group parents_level4@sscps.org add member palgera@sscps.org
-- now run the SQL below, level 4 parents
select concat(
      '../bin/gam/gam update'
      , ' group', ' parents_level4@sscps.org'
      , ' add member ', import.CONTACT_HOME_EMAIL
    ) as '# update parents_<levels>@sscps.org'
  from import_contacts as import
  inner join users on import.APID = users.current_year_id and users.status = 'ACTIVE'
    and users.grade in ('07','08')
  where import.CONTACT_HOME_EMAIL != ''
    and import.NO_EMAIL != 'Y'
  group by import.CONTACT_HOME_EMAIL
-- cut & paste, do not run in SQL, level highschool
# update parents_highschool@sscps.org
../bin/gam/gam update group parents_highschool@sscps.org remove group parents_highschool@sscps.org
../bin/gam/gam update group parents_highschool@sscps.org add owner asavage@sscps.org
../bin/gam/gam update group parents_highschool@sscps.org add owner mtondorf@sscps.org
../bin/gam/gam update group parents_highschool@sscps.org add member rdegennaro@sscps.org
../bin/gam/gam update group parents_highschool@sscps.org add member palgera@sscps.org
-- now run the SQL below, highschool parents
select concat(
      '../bin/gam/gam update'
      , ' group', ' parents_highschool@sscps.org'
      , ' add member ', import.CONTACT_HOME_EMAIL
    ) as '# update parents_<levels>@sscps.org'
  from import_contacts as import
  inner join users on import.APID = users.current_year_id and users.status = 'ACTIVE'
    and users.grade in ('09','10','11','12')
  where import.CONTACT_HOME_EMAIL != ''
    and import.NO_EMAIL != 'Y'
  group by import.CONTACT_HOME_EMAIL;
