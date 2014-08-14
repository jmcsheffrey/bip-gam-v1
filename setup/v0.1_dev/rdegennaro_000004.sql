-- new tables
CREATE TABLE `groupings` (
 `unique_id` int(11) NOT NULL AUTO_INCREMENT,
 `population` varchar(3) CHARACTER SET latin1 NOT NULL,
 `name_short` varchar(2) CHARACTER SET latin1 NOT NULL,
 `name_long` varchar(100) CHARACTER SET latin1 NOT NULL,
 `google_id_folder` varchar(100) CHARACTER SET latin1 NOT NULL,
 PRIMARY KEY (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8

drop table groups;
CREATE TABLE `groups` (
 `unique_id` varchar(8) NOT NULL,
 `group_name` varchar(100) NOT NULL,
 `group_email` varchar(100) NOT NULL,
 `group_folder` varchar(100) NOT NULL,
 `grouping` varchar(8) NOT NULL,
 `department` varchar(50) NOT NULL,
 `cohort` varchar(50) NOT NULL,
 `schedule` varchar(100) NOT NULL,
 `google_id_folder` varchar(100) NOT NULL,
PRIMARY KEY (`unique_id`),
 UNIQUE KEY `unique_id` (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



-- table mods
ALTER TABLE  `groups` ADD  `google_id_folder` VARCHAR( 100 ) NOT NULL ;
ALTER TABLE  `sync_config` CHANGE  `config_name` `config_name` VARCHAR( 50 ) NOT NULL ;

-- table inserts
-- for sync_config
insert into sync_config values ("google_folder_base", "0Byc5mfoLgdM3WU82MS1WeWVDc2M");
insert into sync_config values ("google_folder_student", "0Byc5mfoLgdM3RG9fZnFrckwwOGM");

-- for groupings
INSERT INTO `sscpssynctest`.`groupings` (`unique_id`, `population`, `name_short`, `name_long`, `google_id_folder`) VALUES (NULL, 'STU', 'HS', 'Level HS', '0Byc5mfoLgdM3anpjY3Bpek1va0U');
INSERT INTO `sscpssynctest`.`groupings` (`unique_id`, `population`, `name_short`, `name_long`, `google_id_folder`) VALUES (NULL, 'STU', '1', 'Level 1', '0Byc5mfoLgdM3ZWNvSUkxSUNzNUk');
INSERT INTO `sscpssynctest`.`groupings` (`unique_id`, `population`, `name_short`, `name_long`, `google_id_folder`) VALUES (NULL, 'STU', '2', 'Level 2', '0Byc5mfoLgdM3ajhaMTJTRUs1Y0E');
INSERT INTO `sscpssynctest`.`groupings` (`unique_id`, `population`, `name_short`, `name_long`, `google_id_folder`) VALUES (NULL, 'STU', '3', 'Level 3', '0Byc5mfoLgdM3SVFvZDJsbGU4b1U');
INSERT INTO `sscpssynctest`.`groupings` (`unique_id`, `population`, `name_short`, `name_long`, `google_id_folder`) VALUES (NULL, 'STU', '4', 'Level 4', '0Byc5mfoLgdM3Z2Z0YjdZcG9zSWs');

-- for sync_config
INSERT INTO `sync_config` VALUES ('google_admin_owner', 'admin.google@sscps.org');

-- for groups (after dropped table)
INSERT INTO `groups` VALUES ('0013-01', 'CLS - Math5 - CJD (Sam)', 'cls-math5-cjd-sam@sscps.org', 'Math5 - CJD (Sam)', '03', 'MATH', 'CJD', '', '');
INSERT INTO `groups` VALUES ('0013-02', 'CLS - Math5 - CJD (Mr. T)', 'cls-math5-cjd-mrt@sscps.org', 'Math5 - CJD (Mr. T)', '03', 'MATH', 'CJD', '', '');
INSERT INTO `groups` VALUES ('0019-01', 'CLS - Geometry - Block C (Sam)', 'cls-geometry-blockc-sam@sscps.org', 'Geometry - Block C (Sam)', 'HS', 'MATH', '', 'C12345', '');
INSERT INTO `groups` VALUES ('0020-01', 'CLS - Stats - Block C (Mr. T)', 'CLS-stats-blockc-mrt@sscps.org', 'Stats - Block C (Mr. T)', 'HS', 'MATH', '', 'C12345', '');
INSERT INTO `groups` VALUES ('0022-01', 'CLS - Another Thing for HS FIT - Block A (Sam)', 'cls-anotherthingforhsfit-blocka-sam@sscps.org', 'Another Thing for HS FIT - Block A (Sam)', 'HS', 'FIT', '', 'A12345', '');
