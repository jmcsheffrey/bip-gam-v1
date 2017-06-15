-- ****************************************************
-- Library data for Gibbon
--    Gibbon has different entities for import then AdminPlus
-- ****************************************************

-- create import file for users, which includes all teachers and students (see note below about parents)
select '' as Title
    , users.last_name as Surname
    , users.first_name as FirstName
    , (case when users.referred_to_as = '' then users.first_name
          when users.referred_to_as is null then users.first_name
          else users.referred_to_as end) as PreferredName
    , concat(users.first_name, " ", users.last_name) as OfficialName
    , '' as NameInCharacters
    , users.gender as Gender
    , (case when users.user_name is null then ''
          else users.user_name end) as Username
    , '' as Password
    , '' as House
    , '' as DOB
    , (case when users.population = 'EMP' then 'Teacher'
          when users.population = 'STU' then 'Student'
          else 'ERROR' end) as Role
    , (case when users.school_email is null then ''
          else users.school_email end) as Email
    , '' as Image
    , (case when users.street is null then ''
          else users.street end) as UnitBuildingStreet1
    , concat(
        (if(users.city is null, '', users.city))
        , ", "
        , (if(users.state is null, '', users.state))
        , " "
        , (if(users.zipcode is null, '', users.zipcode))) as District1
    , "USA" as County1
    , "" as UnitBuildingStreet2
    , "" as District2
    , "" as County2
    , "Home" as PhoneType1
    , "" as IDDCode1
    , replace(replace(replace(users.phone_home, "-", ""),"(",""),")","") as Phone1
    , "" as PhoneType2
    , "" as IDDCode2
    , "" as Phone2
    , "" as PhoneType3
    , "" as IDDCode3
    , "" as Phone3
    , "" as PhoneType4
    , "" as IDDCode4
    , "" as Phone4
    , "" as Website
    , "" as FirstLanguage
    , "" as SecondLanguage
    , "" as Profession
    , "" as Employer
    , "" as JobTitle
    , contacts.CONTACT_FULL_NAME as Emergency1Name
    , replace(replace(replace(contacts.HOMEPHONE, "-", ""),"(",""),")","") as Emergency1Number1
    , replace(replace(replace(contacts.MOBILEPHONE, "-", ""),"(",""),")","") as Emergency1Number2
    , "" as Emergency1Relationship
    , "" as Emergency2Name
    , "" as Emergency2Number1
    , "" as Emergency2Number2
    , "" as Emergency2Relationship
    , "" as StartDate
  from users
  left join import_contacts as contacts on users.current_year_id = contacts.APID and contacts.PRIMARY_CONTACT = "Y"
  where status = 'ACTIVE' and (population = 'STU' or population = 'EMP')
  order by population DESC, last_name, first_name;

-- create SQL update statement for unique_id, alternateEmail (parent's) for all users
select concat(
    "update gibbonPerson"
    , " set studentID = ", char(34), users.unique_id, char(34)
    , char(44), " dateStart = NULL"
    , char(44), " emailAlternate = ", char(34), (case when users.population = 'EMP' then ''
                                                   when users.population = 'STU' then contacts.CONTACT_HOME_EMAIL
                                                   else 'ERROR' end), char(34)
    , " where username = ", char(34), users.user_name, char(34)
    , char(59)) as sql_output
  from users
  left join import_contacts as contacts on users.current_year_id = contacts.APID and contacts.PRIMARY_CONTACT = "Y"
  where status = 'ACTIVE' and (population = 'STU' or population = 'EMP')
  order by population DESC, user_name

-- for import enrollement, which is just Homerooms (Roll Groups in Gibbon terms)
--get list of Homerooms
--rows from the SQL below should be all unique
--create them in Gibbon manually
select *
  from (select
            substring(concat (users.homeroom_teacher_first, users.homeroom_teacher_last),1,10) as LongRollGroup
            , concat (substring(users.homeroom_teacher_first,1,4), substring(users.homeroom_teacher_last,1,1)) as ShortRollGroup
          from users
          where users.status = 'ACTIVE' and users.population = 'STU'
            and users.homeroom_teacher_first != ''
            and users.homeroom_teacher_last != ''
  ) as RollGroupsCheck
  group by LongRollGroup, ShortRollGroup;

--if rows above are unique, use below to export data to CSV
select *
  from (select
      users.user_name as Username
      , concat (substring(users.homeroom_teacher_first,1,4), substring(users.homeroom_teacher_last,1,1)) as RollGroup
      , users.grade as YearGroup
      , '' as RollOrder
    from users
    where users.status = 'ACTIVE'
      and users.population = 'STU'
    order by users.user_name) as rollgroups
  where rollgroups.RollGroup != '';

-- import families, which is just connection between users to a family
--   it has three separate CSVs: family file, parent file, child file
--NOTE: IGNORING FAMILY STUFF:
--   AdminPlus does not give household_id to parents that are not living with student but still primary.

-- family file
--Family Sync Key * - Unique ID for family, according to source system.
--Name * - Name by which family is known.
--Address Name - Name to appear on written communication to family.
--Home Address - Unit, Building, Street
--Home Address (District) - County, State, District
--Home Address (Country)
--{leave empty} Marital Status - Married, Separated, Divorced, De Facto or Other
--{leave empty} Home Language - Primary
--select tblmany.FamilySyncKey from
--  (select
--      CONTACT_HOUSEHOLD_ID as FamilySyncKey,
--      left(CONTACT_HOME_EMAIL,20) as Username
--    from import_contacts
--    where PRIMARY_CONTACT = "Y") as tblmany
--  where Username != ''
--    and FamilySyncKey in (select household_id from users where status = 'ACTIVE' and population = 'STU')
--  group by Username, FamilySyncKey

-- parent file
--Family Sync Key * - Unique ID for family, according to source system.
--Username * - Parent username.
--{only import PRIMARY_CONTACT, so = 1} Contact Priority * - 1, 2 or 3 (each family needs one and only one 1).
--select
--    CONTACT_HOUSEHOLD_ID as FamilySyncKey
--    , left(CONTACT_HOME_EMAIL,20) as Username
--    , 1 as ContactPriority
--  from import_contacts
--  where PRIMARY_CONTACT = "Y"
--    and CONTACT_HOME_EMAIL != '' an
--    and CONTACT_HOUSEHOLD_ID in (select household_id from users where status = 'ACTIVE' and population = 'STU')
--  order by CONTACT_HOUSEHOLD_ID, CONTACT_HOME_EMAIL

-- child file
--select
--    users.household_id as FamilySyncKey,
--    users.user_name as Username
--  from users
--  where users.status = 'ACTIVE' and users.population = 'STU'
