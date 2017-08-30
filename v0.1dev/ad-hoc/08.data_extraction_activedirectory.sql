-- ****************************************************
-- NOTE:  Keep order of items for everything.
-- NOTE:  This is first & for users, their groups,
--        drive & calendars.
-- ****************************************************

--NOTE:  This is in flux because moving to integration such that AD updates/modifies Google Domain

-- ****************************************************
-- Create / Update / ARCHIVE ACTIVE users in AD
-- ****************************************************

-- create/update/archive actual Active Directory object for user
-- .\aduser.ps1 -cmd_type "ADD" -unique_id "TST99999" -population "STU"
--     -school_email "some_dude@student.sscps.org" -user_name "some_dude" -first_name "S'ome" -last_name "Dude"
--     -description "SSCPS Test ID" -fileserver "ROWLEY" -grade "06"
select concat(
      '.', char(92), 'aduser.ps1'
      , ' -cmd_type ', char(34), (case when users.status = 'INACTIVE' then 'ARCHIVE'
                                    when users.newthisrun = 'Y' then 'ADD'
                                    when users.newthisrun = 'N' then 'UPDATE'
                                    else 'ERROR' end), char(34)
      , ' -unique_id ', char(34), users.unique_id, char(34)
      , ' -population ', char(34), users.population, char(34)
      , ' -school_email ', char(34), users.school_email, char(34)
      , ' -user_name ', char(34), users.user_name, char(34)
      , ' -first_name ', char(34), users.first_name, char(34)
      , ' -last_name ', char(34), users.last_name, char(34)
      , ' -description ', char(34), users.description, char(34)
      , ' -fileserver ', char(34), users.profile_server, char(34)
      , ' -grade ', char(34), (case when users.grade is null then 'n/a'
                               when users.grade = '' then 'n/a'
                               else users.grade end), char(34)
    ) as '# create or update AD users'
  from users
  where users.school_email != '' and not (school_email is null)
    and (users.population = 'EMP'
         or users.grade in ('03', '04', '05', '06', '07', '08', '09', '10', '11', '12', 'LF')
        )
  order by users.population, users.status, users.newthisrun, users.grade, users.school_email;

-- add/update groups in Active Directory user
-- .\aduser_groups.ps1 -unique_id "TST99999" -population "STU" -user_name "some_dude"
--     -fileserver "ROWLEY" -grade "06" - gco "2020"
select concat(
      '.', char(92), 'aduser_groups.ps1'
      , ' -unique_id ', char(34), users.unique_id, char(34)
      , ' -population ', char(34), users.population, char(34)
      , ' -user_name ', char(34), users.user_name, char(34)
      , ' -fileserver ', char(34), users.profile_server, char(34)
      , ' -grade ', char(34), (case when users.grade is null then 'n/a'
                               when users.grade = '' then 'n/a'
                               else users.grade end), char(34)
      , ' -gco ', char(34), (case when users.expected_grad_year is null then 'n/a'
                               when users.expected_grad_year = '' then 'n/a'
                               else users.expected_grad_year end), char(34)
    ) as '# adjust groups in AD for users'
  from users
  where users.school_email != ''
    and users.status = 'ACTIVE'
    and (users.population = 'EMP'
         or users.grade in ('03', '04', '05', '06', '07', '08', '09', '10', '11', '12')
        )
  order by users.population, users.grade, users.school_email;
