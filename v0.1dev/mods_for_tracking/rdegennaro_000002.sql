-- insert sample data

-- for users table
insert into users values ("97101000", "TST", "PRT", "Hank", "", "Parent", "rmdegennaro@aol.com", "rmdegennaro@aol.com", "Mr. Parent");
insert into users values ("97101001", "TST", "PRT", "George", "", "Guardian", "rmdegennaro@hotmail.com", "rmdegennaro@hotmail.com", "George");
insert into users values ("98101000", "TST", "EMP", "Sam", "", "Staff", "sstaff", "sstaff@sscps.org", "Sam");
insert into users values ("99101000", "TST", "STU", "Joe", "", "Student", "joe_student", "joe_student@student.sscps.org", "Joseph");
insert into users values ("99101001", "TST", "STU", "Jen", "", "Student", "jen_student", "jen_student@student.sscps.org", "Jen");
insert into users values ("99101002", "TST", "STU", "Jack", "", "Student", "jack_student", "jack_student@student.sscps.org", "Jack");
insert into users values ("99101003", "TST", "STU", "Jess", "", "Student", "jess_student", "jess_student@student.sscps.org", "Jess");
insert into users values ("99101004", "TST", "STU", "Jeff", "", "Student", "jeff_student", "jeff_student@student.sscps.org", "Jeff");
insert into users values ("99101005", "TST", "STU", "Peter", "", "Pupil", "peter_pupil", "peter_pupil@student.sscps.org", "Pete");
insert into users values ("99999999", "TEST", "TST", "First", "Middle", "Last", "first_last", "first_last@test.sscps.org", "To Be Called");

-- for users_stuviewers table
insert into users_stuviewers values ("98101000", "97101000", "parent");
insert into users_stuviewers values ("98101001", "97101000", "parent");
insert into users_stuviewers values ("98101002", "97101000", "parent");
insert into users_stuviewers values ("98101003", "97101000", "parent");
insert into users_stuviewers values ("98101004", "97101000", "parent");
insert into users_stuviewers values ("98101005", "97101001", "parent");
insert into users_stuviewers values ("99101000", "98101000", "teacher");

-- for sync_destination table
insert into sync_destination values ("1001", "Active Directory");
insert into sync_destination values ("1002", "Google Apps");

