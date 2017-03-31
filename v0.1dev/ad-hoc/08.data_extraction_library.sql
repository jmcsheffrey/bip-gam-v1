-- ****************************************************
-- Library data for Gibbon
--    Gibbon has different entities for import then AdminPlus
-- ****************************************************

-- import users, which includes all teachers, students and parents
--{leave empty} Title - e.g. Ms., Miss, Mr., Mrs., Dr.
--Surname * - Family name
--First Name * - Given name
--Preferred Name * - Most common name, alias, nickname, handle, etc
--Official Name * - Full name as shown in ID documents.
--{leave empty} Name In Characters - e.g. Chinese name
--Gender * - F or M
--Username * - Must be unique
--{leave empty} Password - If blank, default password or random password will be used.
--{leave empty} House - House short name, as set in School Admin. Must already exist).
--{leave empty} DOB - Date of birth (yyyy-mm-dd)
--Role * - Teacher, Support Staff, Student or Parent
--Email
--{leave empty} Image (240) - path from /uploads/ to medium portrait image (240px by 320px)
--{leave empty} Address 1 - Unit, Building, Street
--{leave empty} Address 1 (District) - County, State, District
--{leave empty} Address 1 (Country)
--{leave empty} Address 2 - Unit, Building, Street
--{leave empty} Address 2 (District) - County, State, District
--{leave empty} Address 2 (Country)
--Phone 1 (Type) - Mobile, Home, Work, Fax, Pager, Other
--Phone 1 (Country Code) - IDD code, without 00 or +
--Phone 1 - No spaces or punctuation, just numbers
--Phone 2 (Type) - Mobile, Home, Work, Fax, Pager, Other
--Phone 2 (Country Code) - IDD code, without 00 or +
--Phone 2 - No spaces or punctuation, just numbers
--Phone 3 (Type) - Mobile, Home, Work, Fax, Pager, Other
--Phone 3 (Country Code) - IDD code, without 00 or +
--Phone 3 - No spaces or punctuation, just numbers
--Phone 4 (Type) - Mobile, Home, Work, Fax, Pager, Other
--Phone 4 (Country Code) - IDD code, without 00 or +
--Phone 4 - No spaces or punctuation, just numbers
--{leave empty} Website - Must start with http:// or https://
--{leave empty} First Language
--{leave empty} Second Language
--{leave empty} Profession - For parents only
--{leave empty} Employer - For parents only
--{leave empty} Job Title - For parents only
--{leave empty} Emergency 1 Name - For students and staff only
--{leave empty} Emergency 1 Number 1 - For students and staff only
--{leave empty} Emergency 1 Number 2 - For students and staff only
--{leave empty} Emergency 1 Relationship - For students and staff only
--{leave empty} Emergency 2 Name - For students and staff only
--{leave empty} Emergency 2 Number 1 - For students and staff only
--{leave empty} Emergency 2 Number 2 - For students and staff only
--{leave empty} Emergency 2 Relationship - For students and staff only
--{leave empty} Start Date - yyyy-mm-dd

-- import families, which is just connection between users to a family
--   it has three separate CSVs: family file, parent file, child file

-- family file
--Family Sync Key * - Unique ID for family, according to source system.
--Name * - Name by which family is known.
--Address Name - Name to appear on written communication to family.
--Home Address - Unit, Building, Street
--Home Address (District) - County, State, District
--Home Address (Country)
--{leave empty} Marital Status - Married, Separated, Divorced, De Facto or Other
--{leave empty} Home Language - Primary

-- parent file
--Family Sync Key * - Unique ID for family, according to source system.
--Username * - Parent username.
--{only import PRIMARY_CONTACT, so = 1} Contact Priority * - 1, 2 or 3 (each family needs one and only one 1).

-- child file
--Family Sync Key * - Unique ID for family, according to source system.
--Username * - Child username.
select
    users.household_id as FamilySyncKey,
    users.user_name as Username
  from users
  where users.status = 'ACTIVE' and users.population = 'STU'


-- import enrollement, which is just Homerooms (Roll Groups in Gibbon terms)
--below should be all unique
select *
  from (select
            substring(concat (users.homeroom_teacher_first, users.homeroom_teacher_last),1,10) as LongRollGroup,
            substring(concat (users.homeroom_teacher_first, users.homeroom_teacher_last),1,5) as ShortRollGroup
          from users
          where users.status = 'ACTIVE' and users.population = 'STU'
            and users.homeroom_teacher_first != ''
            and users.homeroom_teacher_last != ''
  ) as RollGroupsCheck
  group by LongRollGroup, ShortRollGroup

--if rows above are unique, export with data below
select
    users.user_name as Username,
    as RollGroup,
    'FY2017' as YearGroup,
    '' as RollOrder
  from users
  where users.status = 'ACTIVE' and users.population = 'STU'
