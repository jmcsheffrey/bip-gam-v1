-- TODO - overall
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

-- TODO - 03.populate_staging.sql
--  * fixup groupings to keep PKEY in staging like other data areas
--  * use cohorts for both level 3 & level 4
--  * don't need the google data fields in the staging table for sections
--  * for groupings stage statements, there should be "import" or "stage" as prefix, not sections
--  * add in "newthisyear" vs. "newthisrun" (did not exist from FY vs. did not exist this specific running of scripts)

-- TODO - 05.sanity_check_before_updates.sql
--  * check for any unique_id changed by using school_email to connect tables
--  * check for any unique_id changed by using name fields to connect tables
--  * check bad unique_id for sections unique_id

-- TODO - 07.sanity_check_before_extraction.sql
--  * check for missing grade on students

-- TODO - 08.data_extraction_google.sql
--   * for all groups, should have command to remove inactive users, don't empty & re-add
--   * fix issue with pre-3rd graders that exist in users without UID confuse newthisrun
--   * add field that is "newthisyear"
--   * add Level calendars to folks?
--   * create table for "owners" of email lists & then adjust SQL to add users
--   * figure out how to deal with archiving last year classrooms
--   * have a table for calendars & who should be added, sorta like groupings
--   * need to figure out how to test for a folder & create if missing, specifically for ePortfolio

-- TODO - 08.data_extraction_sendwordnow.sql
--   * there are multiple contacts per household_id & data could be different, but needs to be separate fields

-- TODO - 09.data_reimport_naviance.sql
--  * might not need it all if can reimport based on GUID
