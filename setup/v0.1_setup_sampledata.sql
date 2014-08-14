-- insert sample data

-- for groupings
INSERT INTO `sscpssynctest`.`groupings` (`unique_id`, `population`, `name_short`, `name_long`, `google_id_folder`) VALUES (NULL, 'STU', 'HS', 'Level HS', '0Byc5mfoLgdM3anpjY3Bpek1va0U');
INSERT INTO `sscpssynctest`.`groupings` (`unique_id`, `population`, `name_short`, `name_long`, `google_id_folder`) VALUES (NULL, 'STU', '1', 'Level 1', '0Byc5mfoLgdM3ZWNvSUkxSUNzNUk');
INSERT INTO `sscpssynctest`.`groupings` (`unique_id`, `population`, `name_short`, `name_long`, `google_id_folder`) VALUES (NULL, 'STU', '2', 'Level 2', '0Byc5mfoLgdM3ajhaMTJTRUs1Y0E');
INSERT INTO `sscpssynctest`.`groupings` (`unique_id`, `population`, `name_short`, `name_long`, `google_id_folder`) VALUES (NULL, 'STU', '3', 'Level 3', '0Byc5mfoLgdM3SVFvZDJsbGU4b1U');
INSERT INTO `sscpssynctest`.`groupings` (`unique_id`, `population`, `name_short`, `name_long`, `google_id_folder`) VALUES (NULL, 'STU', '4', 'Level 4', '0Byc5mfoLgdM3Z2Z0YjdZcG9zSWs');

-- for groups
INSERT INTO `groups` VALUES ('0013-01', 'CLS - Math5 - CJD (Sam)', 'cls-math5-cjd-sam@sscps.org', 'Math5 - CJD (Sam)', '03', 'MATH', 'CJD', '', '');
INSERT INTO `groups` VALUES ('0013-02', 'CLS - Math5 - CJD (Mr. T)', 'cls-math5-cjd-mrt@sscps.org', 'Math5 - CJD (Mr. T)', '03', 'MATH', 'CJD', '', '');
INSERT INTO `groups` VALUES ('0019-01', 'CLS - Geometry - Block C (Sam)', 'cls-geometry-blockc-sam@sscps.org', 'Geometry - Block C (Sam)', 'HS', 'MATH', '', 'C12345', '');
INSERT INTO `groups` VALUES ('0020-01', 'CLS - Stats - Block C (Mr. T)', 'CLS-stats-blockc-mrt@sscps.org', 'Stats - Block C (Mr. T)', 'HS', 'MATH', '', 'C12345', '');
INSERT INTO `groups` VALUES ('0022-01', 'CLS - Another Thing for HS FIT - Block A (Sam)', 'cls-anotherthingforhsfit-blocka-sam@sscps.org', 'Another Thing for HS FIT - Block A (Sam)', 'HS', 'FIT', '', 'A12345', '');

-- for groups_members
INSERT INTO `groups_members` VALUES ("0013-01","98101000","OWN");
INSERT INTO `groups_members` VALUES ("0013-02","98101001","OWN");
INSERT INTO `groups_members` VALUES ("0019-01","98101000","OWN");
INSERT INTO `groups_members` VALUES ("0020-01","98101001","OWN");
INSERT INTO `groups_members` VALUES ("0022-01","98101000","OWN");
INSERT INTO `groups_members` VALUES ("0013-01","99101002","MEM");
INSERT INTO `groups_members` VALUES ("0013-01","99101005","MEM");
INSERT INTO `groups_members` VALUES ("0013-02","99101008","MEM");
INSERT INTO `groups_members` VALUES ("0013-02","99101004","MEM");
INSERT INTO `groups_members` VALUES ("0013-02","99101006","MEM");
INSERT INTO `groups_members` VALUES ("0019-01","99101001","MEM");
INSERT INTO `groups_members` VALUES ("0019-01","99101009","MEM");
INSERT INTO `groups_members` VALUES ("0020-01","99101003","MEM");
INSERT INTO `groups_members` VALUES ("0020-01","99101000","MEM");
INSERT INTO `groups_members` VALUES ("0020-01","99101007","MEM");
INSERT INTO `groups_members` VALUES ("0022-01","99101001","MEM");
INSERT INTO `groups_members` VALUES ("0022-01","99101003","MEM");
INSERT INTO `groups_members` VALUES ("0022-01","99101000","MEM");
INSERT INTO `groups_members` VALUES ("0022-01","99101007","MEM");
INSERT INTO `groups_members` VALUES ("0022-01","99101009","MEM");


-- for users table
insert into users values ("97101000", "TST", "PRT", "Hank", "", "Parent", "rmdegennaro@aol.com", "rmdegennaro@aol.com", "Mr. Parent");
insert into users values ("97101001", "TST", "PRT", "George", "", "Guardian", "rmdegennaro@hotmail.com", "rmdegennaro@hotmail.com", "George");
insert into users values ("98101000", "TST", "EMP", "Sam", "", "Staff", "sstaff", "sstaff@sscps.org", "Sam");
insert into users values ("98101001", "TST", "EMP", "Tom", "", "Teacher", "tteacher", "tteacher@sscps.org", "Mr. T");
insert into users values ("98101002", "TST", "EMP", "Pam", "", "Professor", "pprofessor", "pprofessor@sscps.org", "Pam");
insert into users values ("99101000", "TST", "STU", "Joe", "", "Student", "joe_student", "joe_student@student.sscps.org", "Joseph");
insert into users values ("99101001", "TST", "STU", "Jen", "", "Student", "jen_student", "jen_student@student.sscps.org", "Jen");
insert into users values ("99101002", "TST", "STU", "Jack", "", "Student", "jack_student", "jack_student@student.sscps.org", "Jack");
insert into users values ("99101003", "TST", "STU", "Jess", "", "Student", "jess_student", "jess_student@student.sscps.org", "Jess");
insert into users values ("99101004", "TST", "STU", "Jeff", "", "Student", "jeff_student", "jeff_student@student.sscps.org", "Jeff");
insert into users values ("99101005", "TST", "STU", "Peter", "", "Pupil", "peter_pupil", "peter_pupil@student.sscps.org", "Pete");
insert into users values ("99101006", "TST", "STU", "Patrice", "", "Pupil", "patrice_pupil", "patrice_pupil@student.sscps.org", "");
insert into users values ("99101007", "TST", "STU", "Patrick", "", "Pupil", "patrick_pupil", "patrick_pupil@student.sscps.org", "");
insert into users values ("99101008", "TST", "STU", "Penny", "", "Pupil", "penny_pupil", "penny_pupil@student.sscps.org", "");
insert into users values ("99101009", "TST", "STU", "Paul", "", "Pupil", "paul_pupil", "paul_pupil@student.sscps.org", "");
insert into users values ("99101010", "TST", "STU", "Kenny", "Kyle", "Kid", "kyle_kid", "kyle_kid@student.sscps.org", "");
insert into users values ("99101011", "TST", "STU", "Kerry", "Kate", "Kid", "kery_kid", "kery_kid@student.sscps.org", "");
insert into users values ("99999999", "TEST", "TST", "First", "Middle", "Last", "first_last", "first_last@test.sscps.org", "To Be Called");

-- for users_stuviewers table
insert into users_stuviewers values ("98101000", "97101000", "parent");
insert into users_stuviewers values ("98101001", "97101000", "parent");
insert into users_stuviewers values ("98101002", "97101000", "parent");
insert into users_stuviewers values ("98101003", "97101000", "parent");
insert into users_stuviewers values ("98101004", "97101000", "parent");
insert into users_stuviewers values ("98101005", "97101001", "parent");
insert into users_stuviewers values ("99101000", "98101000", "teacher");

-- for sync_config
INSERT INTO `sync_config` VALUES ('google_admin_owner', 'admin.google@sscps.org');
INSERT INTO `sync_config` VALUES ('google_folder_base', '0Byc5mfoLgdM3WU82MS1WeWVDc2M');
INSERT INTO `sync_config` VALUES ('google_folder_student', '0Byc5mfoLgdM3RG9fZnFrckwwOGM');

-- for sync_destination table
insert into sync_destination values ("1001", "Active Directory");
insert into sync_destination values ("1002", "Google Apps");


