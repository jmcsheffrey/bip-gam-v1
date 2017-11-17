-- TODO - overall
--  * When marking things INACTIVE, do set records already INACTIVE so timestamp isn't messed up.
--  * I'm starting to think that "business logic" should be in PowerShell or Python code.
--    So that means output of BIP should be CSVs that have all the information for PowerShell or Python/GAM.
--    Then PowerShell calls our own "APIs for AD" code and Python calls GAM (for now?).
--  * For inactiving users, should have option to run by date.  Basically grab all users with last modified
--    date entered or more recent (that is marked INACTIVE of course).
--  * To be safe, all automated processes should have manual_entry = N
--  * need way to track different OU for employees (Standard, Trend Setters, Full Services)
--  * need to auto populate profile_server (or home folder server) for new 100L users (students & employees)
--      * this should be "round-robin"
--      * only for those without value in users (of course), so should copy value first
--  * allow for students in lower levels (no login, but needed for Library)
--      * check all extraction scripts for appropriate levels (e.g. Google is 3rd & above)
--  * check out feasibility of putting contacts into users.
--      * 09.data_reimport_naviance.sql might not be needed
--      * 08.data_extraction_naviance.sql needs to change to users
--      * other extraction scripts need to be with correct population

-- TODO - 02.sanity_check_after_import.sql
--  * check for missing grade on students
--  * check for malformed email addresses
--  * after import of courses, check for over lapping "pretty names"
--  * allow homerooms similar to "1107 & 7201" or alter how to ignore or just check for dupes on numbered homerooms
--  * check for malformed phone numbers
--  * for dates, check that import is correctly formatted: birthdate (stu & emp), date_of_hire (emp)

-- TODO - 03.populate_staging.sql
--  * fixup groupings to keep PKEY in staging like other data areas
--  * use cohorts for both level 3 & level 4
--  * don't need the google data fields in the staging table for sections
--  * for groupings stage statements, there should be "import" or "stage" as prefix, not sections
--  * remove email creation to 06.finalize_info.sql

-- TODO - 04.sanity_check_before_updates.sql
--  * check for any unique_id changed by using school_email to connect tables
--  * check for any unique_id changed by using name fields to connect tables
--  * check bad unique_id for sections unique_id

-- TODO - 05.update_insert.sql

-- TODO - 06.finalize_info.sql
--  * move email creation from 03.populate_staging.sql because can have multiple student new
--    in same year that have overlapping prefix

-- TODO - 07.sanity_check_before_extraction.sql
--  * check for missing grade on students

-- TODO - 08.data_extraction_activedirectory.sql
--   * need to create users for all 3 graders

-- TODO - 08.data_extraction_google.sql
--   * need to create users for all 3 graders
--   * for all groups, should have command to remove inactive users, don't empty & re-add
--   * fix issue with pre-3rd graders that exist in users without UID confuse newthisrun
--   * add field that is "newthisyear"
--   * add Level calendars to folks?
--   * create table for "owners" of email lists & then adjust SQL to add users
--   * figure out how to deal with archiving last year classrooms
--   * have a table for calendars & who should be added, sorta like groupings
--   * need to figure out how to test for a folder & create if missing, specifically for ePortfolio
--   * add teachers to "Classroom Teachers" google group

-- TODO - 08.data_extraction_sendwordnow.sql
--   * there are multiple contacts per household_id & data could be different, but needs to be separate fields

-- TODO - 09.data_reimport_naviance.sql
--  * might not need it all if can reimport based on GUID
