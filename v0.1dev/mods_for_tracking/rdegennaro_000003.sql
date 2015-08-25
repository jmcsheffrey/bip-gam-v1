-- insert more sample data

-- for users table
insert into users values ("98101001", "TST", "EMP", "Tom", "", "Teacher", "tteacher", "tteacher@sscps.org", "Mr. T");
insert into users values ("98101002", "TST", "EMP", "Pam", "", "Professor", "pprofessor", "pprofessor@sscps.org", "Pam");
insert into users values ("99101006", "TST", "STU", "Patrice", "", "Pupil", "patrice_pupil", "patrice_pupil@student.sscps.org", "");
insert into users values ("99101007", "TST", "STU", "Patrick", "", "Pupil", "patrick_pupil", "patrick_pupil@student.sscps.org", "");
insert into users values ("99101008", "TST", "STU", "Penny", "", "Pupil", "penny_pupil", "penny_pupil@student.sscps.org", "");
insert into users values ("99101009", "TST", "STU", "Paul", "", "Pupil", "paul_pupil", "paul_pupil@student.sscps.org", "");
insert into users values ("99101010", "TST", "STU", "Kenny", "Kyle", "Kid", "kyle_kid", "kyle_kid@student.sscps.org", "");
insert into users values ("99101011", "TST", "STU", "Kerry", "Kate", "Kid", "kery_kid", "kery_kid@student.sscps.org", "");

-- for groups
INSERT INTO `groups` VALUES ('0022-01', 'Another Thing for HS FIT - Block A (Sam)', 'CLS-AnotherThingforHSFIT-BlockA-Sam', 'HS', 'FIT', '', 'A12345');
INSERT INTO `groups` VALUES ('0013-01', 'Math5 - CJD (Sam)', 'CLS-Math5-CJD-Sam', '03', 'MATH', 'CJD', '');
INSERT INTO `groups` VALUES ('0013-02', 'Math5 - CJD (Mr. T)', 'CLS-Math5-CJD-MrT', '03', 'MATH', 'CJD', '');
INSERT INTO `groups` VALUES ('0019-01', 'Geometry - Block C (Sam)', 'CLS-Geometry-BlockC-Sam', 'HS', 'MATH', '', 'C12345');
INSERT INTO `groups` VALUES ('0020-01', 'Stats - Block C (Mr. T)', 'CLS-Stats-BlockC-MrT', 'HS', 'MATH', '', 'C12345');

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

-- modify tables
ALTER TABLE  `groups` DROP  `name` ;
ALTER TABLE  `groups` ADD  `grouping` VARCHAR( 8 ) NOT NULL ,
ADD  `department` VARCHAR( 50 ) NOT NULL ,
ADD  `cohort` VARCHAR( 50 ) NOT NULL ;
ALTER TABLE  `groups` ADD  `schedule` VARCHAR( 100 ) NOT NULL ;

