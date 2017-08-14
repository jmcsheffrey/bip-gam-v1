-- user related tables
CREATE TABLE `users` (
 `unique_id` varchar(8) NOT NULL DEFAULT '',
 `current_year_id` varchar(5) DEFAULT NULL,
 `update_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 `status` varchar(8) NOT NULL,
 `archive_acct` varchar(1) NOT NULL,
 `newthisrun` varchar(1) NOT NULL,
 `manual_entry` varchar(2) NOT NULL DEFAULT 'N',
 `population` varchar(3) NOT NULL,
 `household_id` varchar(20) DEFAULT NULL,
 `first_name` varchar(50) NOT NULL,
 `middle_name` varchar(50) NOT NULL,
 `last_name` varchar(50) NOT NULL,
 `user_name` varchar(20) DEFAULT NULL,
 `profile_server` varchar(100) DEFAULT NULL,
 `school_email` varchar(100) DEFAULT NULL,
 `school_ext` varchar(100) DEFAULT NULL,
 `home_email` varchar(250) DEFAULT NULL,
 `phone_home` varchar(250) DEFAULT NULL,
 `phone_cell` varchar(250) DEFAULT NULL,
 `street` varchar(250) DEFAULT NULL,
 `city` varchar(250) DEFAULT NULL,
 `state` varchar(250) DEFAULT NULL,
 `zipcode` varchar(250) DEFAULT NULL,
 `grade` varchar(2) DEFAULT NULL,
 `expected_grad_year` int(11) DEFAULT NULL,
 `homeroom_room` varchar(25) DEFAULT NULL,
 `homeroom_teacher_first` varchar(50) DEFAULT NULL,
 `homeroom_teacher_last` varchar(50) DEFAULT NULL,
 `referred_to_as` varchar(50) DEFAULT NULL,
 `gender` varchar(1) NOT NULL,
 `birthdate` date DEFAULT NULL,
 `startdate` varchar(11) DEFAULT NULL,
 `school_year_hired` varchar(6) DEFAULT NULL,
 `position` varchar(100) NOT NULL,
 `description` varchar(100) NOT NULL,
 PRIMARY KEY (`unique_id`),
 UNIQUE KEY `current_year_id` (`current_year_id`),
 UNIQUE KEY `unique_user_name` (`user_name`),
 UNIQUE KEY `unique_email_address` (`school_email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8

CREATE TABLE `import_students` (
 `PKEY` int(11) NOT NULL AUTO_INCREMENT,
 `APID` varchar(5) DEFAULT NULL,
 `full_name` varchar(100) DEFAULT NULL,
 `unique_id` varchar(8) DEFAULT NULL,
 `status` varchar(8) DEFAULT NULL,
 `household_id` varchar(20) DEFAULT NULL,
 `first_name` varchar(50) DEFAULT NULL,
 `middle_name` varchar(50) DEFAULT NULL,
 `last_name` varchar(50) DEFAULT NULL,
 `school_email` varchar(100) DEFAULT NULL,
 `phone_home` varchar(250) DEFAULT NULL,
 `phone_cell` varchar(250) DEFAULT NULL,
 `street` varchar(250) DEFAULT NULL,
 `city` varchar(250) DEFAULT NULL,
 `state` varchar(250) DEFAULT NULL,
 `zipcode` varchar(250) DEFAULT NULL,
 `grade` varchar(2) DEFAULT NULL,
 `expected_grad_year` varchar(4) DEFAULT NULL,
 `homeroom` varchar(3) DEFAULT NULL,
 `homeroom_teacher_first` varchar(50) DEFAULT NULL,
 `homeroom_teacher_last` varchar(50) DEFAULT NULL,
 `referred_to_as` varchar(50) DEFAULT NULL,
 `gender` varchar(1) DEFAULT NULL,
 `birthdate` varchar(50) DEFAULT NULL,
 `entry_date` varchar(50) DEFAULT NULL,
 PRIMARY KEY (`PKEY`),
 UNIQUE KEY `unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8

CREATE TABLE `staging_students` (
 `PKEY` int(11) NOT NULL AUTO_INCREMENT,
 `APID` varchar(5) DEFAULT NULL,
 `full_name` varchar(100) DEFAULT NULL,
 `unique_id` varchar(8) DEFAULT NULL,
 `status` varchar(8) DEFAULT NULL,
 `newthisrun` varchar(1) DEFAULT NULL,
 `household_id` varchar(20) DEFAULT NULL,
 `first_name` varchar(50) DEFAULT NULL,
 `middle_name` varchar(50) DEFAULT NULL,
 `last_name` varchar(50) DEFAULT NULL,
 `profile_server` varchar(100) DEFAULT NULL,
 `school_email` varchar(100) DEFAULT NULL,
 `phone_home` varchar(250) DEFAULT NULL,
 `phone_cell` varchar(250) DEFAULT NULL,
 `street` varchar(250) DEFAULT NULL,
 `city` varchar(250) DEFAULT NULL,
 `state` varchar(250) DEFAULT NULL,
 `zipcode` varchar(250) DEFAULT NULL,
 `grade` varchar(2) DEFAULT NULL,
 `expected_grad_year` int(11) DEFAULT NULL,
 `homeroom_room` varchar(4) DEFAULT NULL,
 `homeroom_teacher_first` varchar(50) DEFAULT NULL,
 `homeroom_teacher_last` varchar(50) DEFAULT NULL,
 `referred_to_as` varchar(50) DEFAULT NULL,
 `gender` varchar(1) DEFAULT NULL,
 `birthdate` date DEFAULT NULL,
 `entry_date` varchar(11) DEFAULT NULL,
 PRIMARY KEY (`PKEY`),
 UNIQUE KEY `unique_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8

CREATE VIEW staging_students_prefix AS
select PKEY, unique_id, first_name, last_name
  , concat(
      replace(
        replace(
          replace(
            replace(
              replace(substring(lower(first_name),1,1),
                char(46),char(0)),char(45),char(0)),char(44),char(0)),char(39),char(0)),char(32),char(0))
      ,replace(
        replace(
          replace(
            replace(
              replace(substring(lower(last_name),1,6),
                char(46),char(0)),char(45),char(0)),char(44),char(0)),char(39),char(0)),char(32),char(0))
      ) as prefix
from staging_students
where (school_email is null or school_email = '')
group by prefix

CREATE VIEW users_nextsuffix AS
select substring(max(school_email),1,instr(school_email, '@')-4) as max_name,
  substring(max(school_email),instr(school_email, '@')-3,3) as max_number,
  substring(max(school_email),instr(school_email, '@')-3,3)+1 as next_number
from users
where population = 'STU'
group by substring(school_email,1,instr(school_email, '@')-4)

CREATE VIEW staging_students_nextsuffix AS
select substring(max(school_email),1,instr(school_email, '@')-4) as max_name,
  substring(max(school_email),instr(school_email, '@')-3,3) as max_number,
  substring(max(school_email),instr(school_email, '@')-3,3)+1 as next_number
from staging_students
where school_email is not null and school_email != ''
group by substring(school_email,1,instr(school_email, '@')-4)

CREATE VIEW overall_nextsuffix AS
select max_name, max_number, next_number from users_nextsuffix
union
select max_name, max_number, next_number from staging_students_nextsuffix

CREATE VIEW nextsuffix AS
select max_name, max(max_number) as max_number, max(next_number) as next_number
from overall_nextsuffix
group by max_name

CREATE VIEW profile_server_by_population AS
select population, profile_server, count(profile_server) AS profile_server_count
from users
where profile_server is not null and profile_server != '(n/a)'
group by population, profile_server

CREATE TABLE `import_employees` (
 `PKEY` int(11) NOT NULL AUTO_INCREMENT,
 `APID` varchar(5) DEFAULT NULL,
 `full_name` varchar(100) DEFAULT NULL,
 `unique_id` varchar(8) DEFAULT NULL,
 `status` varchar(8) DEFAULT NULL,
 `archive_acct` varchar(1) DEFAULT NULL,
 `first_name` varchar(50) DEFAULT NULL,
 `middle_name` varchar(50) DEFAULT NULL,
 `last_name` varchar(50) DEFAULT NULL,
 `school_email` varchar(100) DEFAULT NULL,
 `school_ext` varchar(100) DEFAULT NULL,
 `home_email` varchar(250) DEFAULT NULL,
 `phone_home` varchar(250) DEFAULT NULL,
 `phone_cell` varchar(250) DEFAULT NULL,
 `street` varchar(250) DEFAULT NULL,
 `city` varchar(250) DEFAULT NULL,
 `state` varchar(250) DEFAULT NULL,
 `zipcode` varchar(250) DEFAULT NULL,
 `homeroom` varchar(250) DEFAULT NULL,
 `referred_to_as` varchar(50) DEFAULT NULL,
 `gender` varchar(1) DEFAULT NULL,
 `birthdate` varchar(10) DEFAULT NULL,
 `date_of_hire` varchar(10) DEFAULT NULL,
 `school_year_hired` varchar(6) DEFAULT NULL,
 `position` varchar(100) DEFAULT NULL,
 PRIMARY KEY (`PKEY`),
 UNIQUE KEY `unique_unique_id` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8

CREATE TABLE `staging_employees` (
 `PKEY` int(11) NOT NULL AUTO_INCREMENT,
 `APID` varchar(5) DEFAULT NULL,
 `full_name` varchar(100) DEFAULT NULL,
 `unique_id` varchar(8) DEFAULT NULL,
 `status` varchar(8) DEFAULT NULL,
 `archive_acct` varchar(1) DEFAULT NULL,
 `newthisrun` varchar(1) DEFAULT NULL,
 `first_name` varchar(50) DEFAULT NULL,
 `middle_name` varchar(50) DEFAULT NULL,
 `last_name` varchar(50) DEFAULT NULL,
 `profile_server` varchar(100) DEFAULT NULL,
 `school_email` varchar(100) DEFAULT NULL,
 `school_ext` varchar(100) DEFAULT NULL,
 `home_email` varchar(250) DEFAULT NULL,
 `phone_home` varchar(250) DEFAULT NULL,
 `phone_cell` varchar(250) DEFAULT NULL,
 `street` varchar(250) DEFAULT NULL,
 `city` varchar(250) DEFAULT NULL,
 `state` varchar(250) DEFAULT NULL,
 `zipcode` varchar(250) DEFAULT NULL,
 `homeroom` varchar(250) DEFAULT NULL,
 `referred_to_as` varchar(50) DEFAULT NULL,
 `gender` varchar(1) DEFAULT NULL,
 `birthdate` date DEFAULT NULL,
 `date_of_hire` varchar(11) DEFAULT NULL,
 `school_year_hired` varchar(6) DEFAULT NULL,
 `position` varchar(100) DEFAULT NULL,
 PRIMARY KEY (`PKEY`),
 UNIQUE KEY `unique_unique_id` (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8

CREATE TABLE `import_contacts` (
 `PKEY` int(11) NOT NULL AUTO_INCREMENT,
 `APID` varchar(5) DEFAULT NULL,
 `STUDENT_FULL_NAME` varchar(24) DEFAULT NULL,
 `CONTACT_GUID` varchar(32) DEFAULT NULL,
 `CONTACT_HOUSEHOLD_ID` varchar(7) DEFAULT NULL,
 `NAVIANCE_PARENT_ID` varchar(250) DEFAULT NULL,
 `CONTACT_FULL_NAME` varchar(250) DEFAULT NULL,
 `SALUTATION` varchar(250) NOT NULL,
 `CONTACT_FIRST_NAME` varchar(250) DEFAULT NULL,
 `CONTACT_MIDDLE_NAME` varchar(250) DEFAULT NULL,
 `CONTACT_LAST_NAME` varchar(250) DEFAULT NULL,
 `SUFFIX` varchar(250) NOT NULL,
 `LANGUAGE` varchar(250) NOT NULL,
 `ADDRESSLINE1` varchar(250) NOT NULL,
 `ADDRESSLINE2` varchar(250) NOT NULL,
 `ADDRESSSTREET` varchar(250) NOT NULL,
 `ADDRESSCITY` varchar(250) NOT NULL,
 `ADDRESSSTATE` varchar(250) NOT NULL,
 `ADDRESSCOUNTRY` varchar(250) NOT NULL,
 `ADDRESSZIP` varchar(250) NOT NULL,
 `HOMEPHONE` varchar(250) DEFAULT NULL,
 `HOMEPHONEEXTENSION` varchar(250) NOT NULL,
 `MOBILEPHONE` varchar(250) DEFAULT NULL,
 `OFFICEPHONE` varchar(250) NOT NULL,
 `OFFICEPHONEEXTENSION` varchar(250) NOT NULL,
 `CONTACT_HOME_EMAIL` varchar(250) DEFAULT NULL,
 `CONTACT_OFFICE_EMAIL` varchar(250) DEFAULT NULL,
 `RELATIONSHIP` varchar(250) DEFAULT NULL,
 `PRIMARY_CONTACT` varchar(1) DEFAULT NULL,
 `DB_REPORTS` varchar(1) DEFAULT NULL,
 `AT_REPORTS` varchar(1) DEFAULT NULL,
 `RC_REPORTS` varchar(1) DEFAULT NULL,
 `SC_REPORTS` varchar(1) DEFAULT NULL,
 `DS_REPORTS` varchar(1) DEFAULT NULL,
 `BI_REPORTS` varchar(1) DEFAULT NULL,
 `PARENT_PORTAL_ACCESS` varchar(1) DEFAULT NULL,
 `NO_CALL_HOME` varchar(1) DEFAULT NULL,
 `NO_CALL_CELL` varchar(1) DEFAULT NULL,
 `NO_EMAIL` varchar(1) DEFAULT NULL,
 `NOTIFY_OFFICE` varchar(1) DEFAULT NULL,
 PRIMARY KEY (`PKEY`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8

CREATE VIEW import_contacts_contactpoints AS
select
    import.APID
    , import.STUDENT_FULL_NAME
    , import.CONTACT_HOUSEHOLD_ID
    , import.CONTACT_GUID
    , import.PRIMARY_CONTACT
    , 'Primary Home' as contact_point_type
    , import.HOMEPHONE as contact_point_value
  from import_contacts as import
  inner join users on import.APID = users.current_year_id
  where users.status = 'ACTIVE'
    and import.NO_CALL_HOME != 'Y'
union
select
    import.APID
    , import.STUDENT_FULL_NAME
    , import.CONTACT_HOUSEHOLD_ID
    , import.CONTACT_GUID
    , import.PRIMARY_CONTACT
    , concat(import.RELATIONSHIP, ' Cell') as contact_point_type
    , import.MOBILEPHONE as contact_point_value
  from import_contacts as import
  inner join users on import.APID = users.current_year_id
  where users.status = 'ACTIVE'
    and import.NO_CALL_HOME != 'Y'
union
select
    import.APID
    , import.STUDENT_FULL_NAME
    , import.CONTACT_HOUSEHOLD_ID
    , import.CONTACT_GUID
    , import.PRIMARY_CONTACT
    , concat(import.RELATIONSHIP, ' Office') as contact_point_type
    , import.OFFICEPHONE as contact_point_value
  from import_contacts as import
  inner join users on import.APID = users.current_year_id
  where users.status = 'ACTIVE'
    and import.NOTIFY_OFFICE = 'Y'
union
select
    import.APID
    , import.STUDENT_FULL_NAME
    , import.CONTACT_HOUSEHOLD_ID
    , import.CONTACT_GUID
    , import.PRIMARY_CONTACT
    , concat(import.RELATIONSHIP, ' Home Email') as contact_point_type
    , import.CONTACT_HOME_EMAIL as contact_point_value
  from import_contacts as import
  inner join users on import.APID = users.current_year_id
  where users.status = 'ACTIVE'
    and import.NO_EMAIL != 'Y'


-- parent data that is downloaded from Naviance
CREATE TABLE `import_naviance_parents` (
 `succeed_parent_id` int(8) DEFAULT NULL,
 `hs_parent_id` varchar(10) DEFAULT NULL,
 `parent_full_name` varchar(26) DEFAULT NULL,
 `parent_last_name` varchar(15) DEFAULT NULL,
 `parent_first_name` varchar(9) DEFAULT NULL,
 `succeed_student_id` int(8) DEFAULT NULL,
 `hs_student_id` int(8) DEFAULT NULL,
 `state_student_id` varchar(10) DEFAULT NULL,
 `student_first_name` varchar(11) DEFAULT NULL,
 `student_last_name` varchar(12) DEFAULT NULL,
 `email` varchar(29) DEFAULT NULL,
 `home_phone` varchar(12) DEFAULT NULL,
 `work_phone` varchar(10) DEFAULT NULL,
 `mobile_phone` varchar(12) DEFAULT NULL,
 `use_student_address` int(8) DEFAULT NULL,
 `street` varchar(10) DEFAULT NULL,
 `apt_suite` varchar(10) DEFAULT NULL,
 `city` varchar(10) DEFAULT NULL,
 `state` varchar(10) DEFAULT NULL,
 `zip` varchar(10) DEFAULT NULL,
 `country` varchar(10) DEFAULT NULL,
 `occupation` varchar(10) DEFAULT NULL,
 `custodial` varchar(3) DEFAULT NULL,
 `receives_communication` varchar(3) DEFAULT NULL,
 `has_financial_responsibility` varchar(3) DEFAULT NULL,
 `fc_registration_code` varchar(6) DEFAULT NULL,
 `alma_mater_name` varchar(10) DEFAULT NULL,
 `alma_mater_ceeb_code` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8

-- groups for users related tables
CREATE TABLE `import_courses` (
 `PKEY` int(11) NOT NULL AUTO_INCREMENT,
 `num` varchar(4) NOT NULL,
 `alias` varchar(8) NOT NULL,
 `name` varchar(254) NOT NULL,
 `level` varchar(3) NOT NULL,
 `description` varchar(254) NOT NULL,
 `credits` decimal(11,0) NOT NULL,
 `weight` decimal(11,0) NOT NULL,
 `gpa` decimal(11,0) NOT NULL,
 `opt` decimal(11,0) NOT NULL,
 `length` varchar(3) NOT NULL,
 `department` varchar(254) NOT NULL,
 `prior` varchar(254) NOT NULL,
 `link` varchar(254) NOT NULL,
 `count_honorroll` varchar(3) NOT NULL,
 `count_gpa` varchar(3) NOT NULL,
 `long_description` varchar(254) NOT NULL,
 `skip` varchar(4) NOT NULL,
 `letter` varchar(2) NOT NULL,
 `instruction_level` varchar(254) NOT NULL,
 `district_coursecode` varchar(254) NOT NULL,
 `state_coursecode` varchar(254) NOT NULL,
 `display_name` varchar(254) NOT NULL,
 `display_level` varchar(254) NOT NULL,
 `display_department` varchar(254) NOT NULL,
 `ignore_for_sync` varchar(1) NOT NULL,
 `wa08_teacher_assign` varchar(254) NOT NULL,
 `job_classification` varchar(254) NOT NULL,
 `highly_qual_wa14` varchar(254) NOT NULL,
 `sub_mat_comp_wa15` varchar(254) NOT NULL,
 `nclb_wa13` varchar(254) NOT NULL,
 PRIMARY KEY (`PKEY`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1

CREATE TABLE `import_sections` (
 `PKEY` int(11) NOT NULL AUTO_INCREMENT,
 `course_name` varchar(254) NOT NULL,
 `course_id` varchar(254) NOT NULL,
 `section_id` varchar(254) NOT NULL,
 `department` varchar(254) NOT NULL,
 `teacher_id` varchar(5) NOT NULL,
 `teacher_name` varchar(254) NOT NULL,
 `room_number` varchar(254) NOT NULL,
 `schedule` varchar(254) NOT NULL,
 `term` varchar(254) NOT NULL,
 `credits` decimal(10,0) NOT NULL,
 `weight` decimal(10,0) NOT NULL,
 `gpa` decimal(10,0) NOT NULL,
 `opt` varchar(254) NOT NULL,
 `max_students` int(11) NOT NULL,
 `course_alias` varchar(254) NOT NULL,
 `course_level` varchar(254) NOT NULL,
 `course_description` varchar(254) NOT NULL,
 `priority` varchar(254) NOT NULL,
 `course_link` varchar(254) NOT NULL,
 `count_honorroll` varchar(3) NOT NULL,
 `count_gpa` varchar(3) NOT NULL,
 `table_name` varchar(254) NOT NULL,
 `field_name` varchar(254) NOT NULL,
 `field_value` varchar(254) NOT NULL,
 PRIMARY KEY (`PKEY`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1

CREATE TABLE `import_schedules` (
 `PKEY` int(11) NOT NULL AUTO_INCREMENT,
 `unique_id` varchar(8) NOT NULL,
 `apid` varchar(5) NOT NULL,
 `formal_name` varchar(254) NOT NULL,
 `course_number` varchar(254) NOT NULL,
 `section_number` varchar(254) NOT NULL,
 `course_name` varchar(254) NOT NULL,
 `course_description` varchar(254) NOT NULL,
 `course_alias` varchar(254) NOT NULL,
 `teacher_id` varchar(5) NOT NULL,
 `teacher_name` varchar(254) NOT NULL,
 `schedules` varchar(254) NOT NULL,
 `term` varchar(254) NOT NULL,
 `room_number` varchar(254) NOT NULL,
 `min_grade` varchar(254) NOT NULL,
 `max_grade` varchar(254) NOT NULL,
 `size_best` int(11) NOT NULL,
 `size_current` int(11) NOT NULL,
 `locked` varchar(3) NOT NULL,
 `sectionx_record_num` varchar(254) NOT NULL,
 `long_description` varchar(254) NOT NULL,
 `skip` varchar(4) NOT NULL,
 `letter` varchar(254) NOT NULL,
 `instruction_level` varchar(254) NOT NULL,
 `district_course_code` varchar(254) NOT NULL,
 `state_course_code` varchar(254) NOT NULL,
 `display_name` varchar(254) NOT NULL,
 `display_level` varchar(254) NOT NULL,
 `display_department` varchar(254) NOT NULL,
 `ignore_for_sync` varchar(254) NOT NULL,
 `wa08_teacher_assign` varchar(254) NOT NULL,
 `job_classification` varchar(254) NOT NULL,
 `highly_qual_wa14` varchar(254) NOT NULL,
 `sub_mat_comp_wa15` varchar(254) NOT NULL,
 `nclb_wa13` varchar(254) NOT NULL,
 PRIMARY KEY (`PKEY`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1

CREATE TABLE `staging_groupings` (
 `PKEY` int(11) NOT NULL AUTO_INCREMENT,
 `unique_id` varchar(250) NOT NULL,
 `update_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 `status` varchar(10) NOT NULL,
 `current_year` varchar(4) NOT NULL,
 `time_block` varchar(8) NOT NULL,
 `level` varchar(2) NOT NULL,
 `name` varchar(250) NOT NULL,
 `course_id` varchar(250) NOT NULL,
 `section_id` varchar(250) NOT NULL,
 `email_teachers` varchar(250) NOT NULL,
 `email_students` varchar(250) NOT NULL,
 `folder_teachers` varchar(250) NOT NULL,
 `google_id` varchar(250) NOT NULL,
 PRIMARY KEY (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8

CREATE TABLE `groupings` (
 `unique_id` varchar(250) NOT NULL,
 `update_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 `status` varchar(10) NOT NULL,
 `current_year` varchar(4) NOT NULL,
 `time_block` varchar(8) NOT NULL,
 `level` varchar(2) NOT NULL,
 `name` varchar(250) NOT NULL,
 `course_id` varchar(250) NOT NULL,
 `section_id` varchar(250) NOT NULL,
 `email_teachers` varchar(250) NOT NULL,
 `email_students` varchar(250) NOT NULL,
 `folder_teachers` varchar(250) NOT NULL,
 `google_id` varchar(250) NOT NULL,
 PRIMARY KEY (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8

CREATE VIEW section_cohorts AS
select `import_sections`.`PKEY` AS `PKEY`
  ,`import_sections`.`course_id` AS `course_id`
  ,`import_sections`.`section_id` AS `section_id`
  ,`import_sections`.`teacher_id` AS `teacher_id`
  ,`import_sections`.`schedule` AS `schedule`
  ,`import_sections`.`field_value` AS `cohort`
from `import_sections`
where ((`import_sections`.`table_name` = 'TEACHERS') and (`import_sections`.`field_name` = 'COHORT'))

CREATE TABLE `staging_groupings_users` (
 `PKEY` int(11) NOT NULL AUTO_INCREMENT,
 `course_id` varchar(250) CHARACTER SET utf8 NOT NULL,
 `section_id` varchar(250) CHARACTER SET utf8 NOT NULL,
 `current_year` varchar(4) CHARACTER SET utf8 NOT NULL,
 `person_id` varchar(8) CHARACTER SET utf8 NOT NULL,
 `person_population` varchar(250) CHARACTER SET utf8 NOT NULL,
 `tobe_unique_id` varchar(250) CHARACTER SET utf8 NOT NULL,
 PRIMARY KEY (`PKEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8

CREATE TABLE `groupings_users` (
 `unique_id_grouping` varchar(250) NOT NULL,
 `unique_id_user` varchar(8) NOT NULL,
 `user_type` varchar(3) NOT NULL,
 `status` varchar(8) NOT NULL,
 PRIMARY KEY (`unique_id_grouping`,`unique_id_user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
