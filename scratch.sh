
# print list of courses for a student
#python ./gam/gam.py print course-participants student ldohert101@student.sscps.org todrive

# list everyone who sees a calendar
#echo PE Space-Project and Workshop
#python ./gam/gam.py calendar sscps.org_adir45ii0ale3reas48meesnfk@group.calendar.google.com showacl
#echo PE Space Use
#python ./gam/gam.py calendar sscps.org_go6pig0m7ovfoosrojei6nuv9o@group.calendar.google.com showacl

# list all calendars a users sees
#python ./gam/gam.py user apepin@sscps.org show calendar

# add users to a calendar
#python ./gam/gam.py calendar <calendar email> add freebusy|read|editor|owner <user email>
#python ./gam/gam.py calendar sscps.org_adir45ii0ale3reas48meesnfk@group.calendar.google.com add owner rdegennaro@sscps.org
#python ./gam/gam.py calendar sscps.org_adir45ii0ale3reas48meesnfk@group.calendar.google.com add read mbuckleycurran@sscps.org
#python ./gam/gam.py calendar sscps.org_adir45ii0ale3reas48meesnfk@group.calendar.google.com add read mflanagan@sscps.org

#python ./gam/gam.py user admin.google@sscps.org add drivefileacl 0Byc5mfoLgdM3MDE0YjEyOWEtMjIxNi00YTE0LTgxZDgtODQxOGEwODU5YjE3 user jen_student@student.sscps.org role reader

#python ./gam/gam.py user admin.google@sscps.org show filelist todrive allfields

#python ./gam/gam.py print courses teacher rdegennaro@sscps.org
#python ./gam/gam.py course 2245052193 add alias 5620-01-fy17

#manually add students to classrooms
#python ./gam/gam.py create course alias 4304-01-fy17 add student joe_student@student.sscps.org


# manually create classrooms
#python ./gam/gam.py create course alias 4304-01-fy17 teacher mlappas@sscps.org name "Spanish L3 - Yellow (Maria)" section "4304/01-FY17" status ACTIVE
#python ./gam/gam.py create course alias 4304-02-fy17 teacher mlappas@sscps.org name "Spanish L3 - Purple (Maria)" section "4304/02-FY17" status ACTIVE
#python ./gam/gam.py create course alias 4304-03-fy17 teacher mlappas@sscps.org name "Spanish L3 - Blue (Maria)" section "4304/03-FY17" status ACTIVE
#python ./gam/gam.py create course alias 4304-04-fy17 teacher mlappas@sscps.org name "Spanish L3 - Orange (Maria)" section "4304/04-FY17" status ACTIVE
#python ./gam/gam.py create course alias 4304-05-fy17 teacher mlappas@sscps.org name "Spanish L3 - Green (Maria)" section "4304/05-FY17" status ACTIVE
#python ./gam/gam.py create course alias 4304-06-fy17 teacher mlappas@sscps.org name "Spanish L3 - Red (Maria)" section "4304/06-FY17" status ACTIVE
###
#python ./gam/gam.py create course alias 7403-01-fy17 teacher tleonard@sscps.org name "Music L3 - Blue (Theron)" section "7403/01-FY17" status ACTIVE
#python ./gam/gam.py create course alias 7403-02-fy17 teacher tleonard@sscps.org name "Music L3 - Orange (Theron)" section "7403/02-FY17" status ACTIVE
#python ./gam/gam.py create course alias 7403-03-fy17 teacher tleonard@sscps.org name "Music L3 - Yellow (Theron)" section "7403/03-FY17" status ACTIVE
#python ./gam/gam.py create course alias 7403-04-fy17 teacher tleonard@sscps.org name "Music L3 - Green (Theron)" section "7403/04-FY17" status ACTIVE
#python ./gam/gam.py create course alias 7403-05-fy17 teacher tleonard@sscps.org name "Music L3 - Purple (Theron)" section "7403/05-FY17" status ACTIVE
#python ./gam/gam.py create course alias 7403-06-fy17 teacher tleonard@sscps.org name "Music L3 - Red (Theron)" section "7403/06-FY17" status ACTIVE
#python ./gam/gam.py create course alias 7302-01-fy17 teacher tleonard@sscps.org name "Music L4 - Yellow (Theron)" section "7302/01-FY17" status ACTIVE
#python ./gam/gam.py create course alias 7302-02-fy17 teacher tleonard@sscps.org name "Music L4 - Purple (Theron)" section "7302/02-FY17" status ACTIVE
#python ./gam/gam.py create course alias 7302-03-fy17 teacher tleonard@sscps.org name "Music L4 - Orange (Theron)" section "7302/03-FY17" status ACTIVE
#python ./gam/gam.py create course alias 7302-04-fy17 teacher tleonard@sscps.org name "Music L4 - Green (Theron)" section "7302/04-FY17" status ACTIVE
#python ./gam/gam.py create course alias 7302-05-fy17 teacher tleonard@sscps.org name "Music L4 - Blue (Theron)" section "7302/05-FY17" status ACTIVE
#python ./gam/gam.py create course alias 7302-06-fy17 teacher tleonard@sscps.org name "Music L4 - Red (Theron)" section "7302/06-FY17" status ACTIVE
###
###
#python ./gam/gam.py create course alias 4407-01-fy17 teacher hedmondson@sscps.org name "Spanish Gr 7 - Blue (Haley)" section "4407/01-FY17" status ACTIVE
#python ./gam/gam.py create course alias 4407-02-fy17 teacher hedmondson@sscps.org name "Spanish Gr 7 - Yellow (Haley)" section "4407/02-FY17" status ACTIVE
#python ./gam/gam.py create course alias 4407-03-fy17 teacher hedmondson@sscps.org name "Spanish Gr 7 - Green (Haley)" section "4407/03-FY17" status ACTIVE
#python ./gam/gam.py create course alias 4408-01-fy17 teacher hedmondson@sscps.org name "Spanish Gr 8 - Orange (Haley)" section "4408/01-FY17" status ACTIVE
#python ./gam/gam.py create course alias 4408-02-fy17 teacher hedmondson@sscps.org name "Spanish Gr 8 - Red (Haley)" section "4408/02-FY17" status ACTIVE
#python ./gam/gam.py create course alias 4408-03-fy17 teacher hedmondson@sscps.org name "Spanish Gr 8 - Purple (Haley)" section "4408/03-FY17" status ACTIVE
###
#python ./gam/gam.py create course alias 2407-01-fy17 teacher kodonnell@sscps.org name "World Cultures 1 - Orange (Katie O.)" section "2407/01-FY17" status ACTIVE
#python ./gam/gam.py create course alias 2407-02-fy17 teacher kodonnell@sscps.org name "World Cultures 1 - Red (Katie O.)" section "2407/02-FY17" status ACTIVE
#python ./gam/gam.py create course alias 2407-03-fy17 teacher kodonnell@sscps.org name "World Cultures 1 - Purple (Katie O.)" section "2407/03-FY17" status ACTIVE
#python ./gam/gam.py create course alias 2411-01-fy17 teacher kodonnell@sscps.org name "Ancient Civ - Blue (Katie O.)" section "2411/01-FY17" status ACTIVE
#python ./gam/gam.py create course alias 2411-02-fy17 teacher kodonnell@sscps.org name "Ancient Civ - Yellow (Katie O.)" section "2411/02-FY17" status ACTIVE
#python ./gam/gam.py create course alias 2411-03-fy17 teacher kodonnell@sscps.org name "Ancient Civ - Green (Katie O.)" section "2411/03-FY17" status ACTIVE
###
#python ./gam/gam.py create course alias 1407-02-fy17 teacher kantonowicz@sscps.org name "ELA7 - Yellow (Katie A.)" section "1407/02-FY17" status ACTIVE
#python ./gam/gam.py create course alias 1407-03-fy17 teacher kantonowicz@sscps.org name "ELA7 - Blue (Katie A.)" section "1407/03-FY17" status ACTIVE
#python ./gam/gam.py create course alias 1408-03-fy17 teacher kantonowicz@sscps.org name "ELA8 - Orange (Katie A.)" section "1408/03-FY17" status ACTIVE
###
#python ./gam/gam.py create course alias 1407-01-fy17 teacher sconnors@sscps.org name "ELA7 - Green (Shawn)" section "1407/01-FY17" status ACTIVE
#python ./gam/gam.py create course alias 1408-01-fy17 teacher sconnors@sscps.org name "ELA8 - Red (Shawn)" section "1408/01-FY17" status ACTIVE
#python ./gam/gam.py create course alias 1408-02-fy17 teacher sconnors@sscps.org name "ELA8 - Purple (Shawn)" section "1408/02-FY17" status ACTIVE
###
#python ./gam/gam.py create course alias 5525-01-fy17 teacher jkostka@sscps.org name "Makers (Jenny)" section "5525/01-FY17" status ACTIVE

#add students to google classrooms
#python ./gam/gam.py course 9901-01-fy17 add student ssenior101@student.sscps.org
#python ./gam/gam.py course 9902-01-fy17 add student ttender102@student.sscps.org
#python ./gam/gam.py course 9902-01-fy17 add student ddiscip101@student.sscps.org
#python ./gam/gam.py course 9902-01-fy17 add student llearne124@student.sscps.org
#python ./gam/gam.py course 9903-01-fy17 add student pprefro102@student.sscps.org
#python ./gam/gam.py course 9904-01-fy17 add student pprefro101@student.sscps.org
#python ./gam/gam.py course 9905-01-fy17 add student llearne125@student.sscps.org
#python ./gam/gam.py course 9906-01-fy17 add student ffreshm101@student.sscps.org
#python ./gam/gam.py course 9907-01-fy17 add student bbookwo102@student.sscps.org
#python ./gam/gam.py course 9908-01-fy17 add student sschola102@student.sscps.org
#python ./gam/gam.py course 9909-01-fy17 add student bbookwo103@student.sscps.org
#python ./gam/gam.py course 9909-01-fy17 add student sschola103@student.sscps.org
#python ./gam/gam.py course 9909-01-fy17 add student llearne126@student.sscps.org
#python ./gam/gam.py course 9909-01-fy17 add student ttender102@student.sscps.org
#python ./gam/gam.py course 9909-01-fy17 add student pprefro102@student.sscps.org
#python ./gam/gam.py course 9909-01-fy17 add student pprefro101@student.sscps.org
#python ./gam/gam.py course 9909-01-fy17 add student ddiscip101@student.sscps.org
#python ./gam/gam.py course 9909-01-fy17 add student llearne125@student.sscps.org
#python ./gam/gam.py course 9909-01-fy17 add student ffreshm101@student.sscps.org
#python ./gam/gam.py course 9909-01-fy17 add student bbookwo102@student.sscps.org
#python ./gam/gam.py course 9909-01-fy17 add student ssophom101@student.sscps.org
#python ./gam/gam.py course 9909-01-fy17 add student ttender101@student.sscps.org
#python ./gam/gam.py course 9909-01-fy17 add student sschola102@student.sscps.org
#python ./gam/gam.py course 9909-01-fy17 add student sschola101@student.sscps.org
#python ./gam/gam.py course 9909-01-fy17 add student jjunior101@student.sscps.org
#python ./gam/gam.py course 9909-01-fy17 add student bbookwo101@student.sscps.org
#python ./gam/gam.py course 9909-01-fy17 add student llearne124@student.sscps.org
#python ./gam/gam.py course 9909-01-fy17 add student ssenior101@student.sscps.org
#python ./gam/gam.py course 9911-01-fy17 add student bbookwo103@student.sscps.org
#python ./gam/gam.py course 9911-01-fy17 add student sschola103@student.sscps.org
#python ./gam/gam.py course 9911-01-fy17 add student sschola101@student.sscps.org
#python ./gam/gam.py course 9911-02-fy17 add student jjunior101@student.sscps.org
#python ./gam/gam.py course 9912-01-fy17 add student ttender101@student.sscps.org
#python ./gam/gam.py course 9912-02-fy17 add student ssophom101@student.sscps.org
#python ./gam/gam.py course 9921-01-fy17 add student bbookwo103@student.sscps.org
#python ./gam/gam.py course 9921-01-fy17 add student llearne126@student.sscps.org
#python ./gam/gam.py course 9921-01-fy17 add student ttender102@student.sscps.org
#python ./gam/gam.py course 9921-01-fy17 add student pprefro101@student.sscps.org
#python ./gam/gam.py course 9921-01-fy17 add student ffreshm101@student.sscps.org
#python ./gam/gam.py course 9921-01-fy17 add student sschola102@student.sscps.org
#python ./gam/gam.py course 9921-01-fy17 add student ttender101@student.sscps.org
#python ./gam/gam.py course 9921-01-fy17 add student jjunior101@student.sscps.org
#python ./gam/gam.py course 9921-01-fy17 add student llearne124@student.sscps.org
#python ./gam/gam.py course 9922-01-fy17 add student sschola103@student.sscps.org
#python ./gam/gam.py course 9922-01-fy17 add student pprefro102@student.sscps.org
#python ./gam/gam.py course 9922-01-fy17 add student ddiscip101@student.sscps.org
#python ./gam/gam.py course 9922-01-fy17 add student llearne125@student.sscps.org
#python ./gam/gam.py course 9922-01-fy17 add student bbookwo102@student.sscps.org
#python ./gam/gam.py course 9922-01-fy17 add student ssophom101@student.sscps.org
#python ./gam/gam.py course 9922-01-fy17 add student sschola101@student.sscps.org
#python ./gam/gam.py course 9922-01-fy17 add student bbookwo101@student.sscps.org
#python ./gam/gam.py course 9922-01-fy17 add student ssenior101@student.sscps.org
#python ./gam/gam.py course 9931-02-fy17 add student llearne126@student.sscps.org
#python ./gam/gam.py course 9931-02-fy17 add student bbookwo101@student.sscps.org

# create classrooms
#python ./gam/gam.py create course alias 9901-01-fy17 teacher mmentor@sscps.org name "American Lit - Block A (Mary)" section "9901/01-FY17" status ACTIVE
#python ./gam/gam.py create course alias 9902-01-fy17 teacher ttutor@sscps.org name "AP Lit - Block B (Tim)" section "9902/01-FY17" status ACTIVE
#python ./gam/gam.py create course alias 9903-01-fy17 teacher llecturer@sscps.org name "AP Lang Comp - Block C (Lennie)" section "9903/01-FY17" status ACTIVE
#python ./gam/gam.py create course alias 9904-01-fy17 teacher eexpert@sscps.org name "British Lit - Block E (Ed)" section "9904/01-FY17" status ACTIVE
#python ./gam/gam.py create course alias 9905-01-fy17 teacher mmentor@sscps.org name "English 10 - Block C (Mary)" section "9905/01-FY17" status ACTIVE
#python ./gam/gam.py create course alias 9906-01-fy17 teacher ttutor@sscps.org name "English 10H - Block D (Tim)" section "9906/01-FY17" status ACTIVE
#python ./gam/gam.py create course alias 9907-01-fy17 teacher llecturer@sscps.org name "Intro CompH - Block B (Lennie)" section "9907/01-FY17" status ACTIVE
#python ./gam/gam.py create course alias 9908-01-fy17 teacher eexpert@sscps.org name "Intro Comp - Block E (Ed)" section "9908/01-FY17" status ACTIVE
#python ./gam/gam.py create course alias 9909-01-fy17 teacher hhomeroom@sscps.org name "Statistics - Block C (Harry)" section "9909/01-FY17" status ACTIVE
#python ./gam/gam.py create course alias 9911-01-fy17 teacher ttutor@sscps.org name "ELA7 - Block A (Tim)" section "9911/01-FY17" status ACTIVE
#python ./gam/gam.py create course alias 9911-02-fy17 teacher ttutor@sscps.org name "ELA7 - Block E (Tim)" section "9911/02-FY17" status ACTIVE
#python ./gam/gam.py create course alias 9912-01-fy17 teacher eexpert@sscps.org name "ELA8 - Block D (Ed)" section "9912/01-FY17" status ACTIVE
#python ./gam/gam.py create course alias 9912-02-fy17 teacher eexpert@sscps.org name "ELA8 - Block D (Ed)" section "9912/02-FY17" status ACTIVE
#python ./gam/gam.py create course alias 9921-01-fy17 teacher hhomeroom@sscps.org name "Technology Solutions - Workshop (Harry)" section "9921/01-FY17" status ACTIVE
#python ./gam/gam.py create course alias 9922-01-fy17 teacher sscholar@sscps.org name "Theater Workshop - Block C (Susan)" section "9922/01-FY17" status ACTIVE
#python ./gam/gam.py create course alias 9931-01-fy17 teacher sscholar@sscps.org name "ELA5 - JCJ (Susan)" section "9931/01-FY17" status ACTIVE
#python ./gam/gam.py create course alias 9931-02-fy17 teacher mmentor@sscps.org name "ELA5 - BD (Mary)" section "9931/02-FY17" status ACTIVE

# create new users
#python ./gam/gam.py create user eexpert@sscps.org firstname Edward lastname Expert password sscps123 changepassword on org /Test/Users-Normal/Employees externalid organization 99999895
#python ./gam/gam.py create user llecturer@sscps.org firstname Leonard lastname Lecturer password sscps123 changepassword on org /Test/Users-Normal/Employees externalid organization 99999896
#python ./gam/gam.py create user mmentor@sscps.org firstname Mary lastname Mentor password sscps123 changepassword on org /Test/Users-Normal/Employees externalid organization 99999894
#python ./gam/gam.py create user sscholar@sscps.org firstname Susan lastname Scholar password sscps123 changepassword on org /Test/Users-Normal/Employees externalid organization 99999897
#python ./gam/gam.py create user ttutor@sscps.org firstname Timothy lastname Tutor password sscps123 changepassword on org /Test/Users-Normal/Employees externalid organization 99999898
#python ./gam/gam.py create user bbookwo101@student.sscps.org firstname Boris lastname Bookworm password sscps123 changepassword on org /Test/Users-Normal/Students/Level-HS externalid organization 99999996
#python ./gam/gam.py create user bbookwo102@student.sscps.org firstname Brian lastname Bookworm password sscps123 changepassword on org /Test/Users-Normal/Students/Level-HS externalid organization 99999990
#python ./gam/gam.py create user bbookwo103@student.sscps.org firstname Bob lastname Bookworm password sscps123 changepassword on org /Test/Users-Normal/Students/Level-4 externalid organization 99999981
#python ./gam/gam.py create user ddiscip101@student.sscps.org firstname Devin lastname Disciple password sscps123 changepassword on org /Test/Users-Normal/Students/Level-HS externalid organization 99999987
#python ./gam/gam.py create user ffreshm101@student.sscps.org firstname Frank lastname Freshman password sscps123 changepassword on org /Test/Users-Normal/Students/Level-HS externalid organization 99999989
#python ./gam/gam.py create user jjunior101@student.sscps.org firstname Janet lastname Junior password sscps123 changepassword on org /Test/Users-Normal/Students/Level-HS externalid organization 99999995
#python ./gam/gam.py create user llearne124@student.sscps.org firstname Larry lastname Learner password sscps123 changepassword on org /Test/Users-Normal/Students/Level-HS externalid organization 99999997
#python ./gam/gam.py create user llearne125@student.sscps.org firstname Louis lastname Learner password sscps123 changepassword on org /Test/Users-Normal/Students/Level-HS externalid organization 99999988
#python ./gam/gam.py create user llearne126@student.sscps.org firstname Linda lastname Learner password sscps123 changepassword on org /Test/Users-Normal/Students/Level-4 externalid organization 99999983
#python ./gam/gam.py create user pprefro101@student.sscps.org firstname Pamela lastname Prefrosh password sscps123 changepassword on org /Test/Users-Normal/Students/Level-4 externalid organization 99999986
#python ./gam/gam.py create user pprefro102@student.sscps.org firstname Patricia lastname Prefrosh password sscps123 changepassword on org /Test/Users-Normal/Students/Level-4 externalid organization 99999985
#python ./gam/gam.py create user sschola101@student.sscps.org firstname Scott lastname Scholar password sscps123 changepassword on org /Test/Users-Normal/Students/Level-HS externalid organization 99999994
#python ./gam/gam.py create user sschola102@student.sscps.org firstname Sarah lastname Scholar password sscps123 changepassword on org /Test/Users-Normal/Students/Level-HS externalid organization 99999991
#python ./gam/gam.py create user sschola103@student.sscps.org firstname Sherry lastname Scholar password sscps123 changepassword on org /Test/Users-Normal/Students/Level-4 externalid organization 99999982
#python ./gam/gam.py create user ssophom101@student.sscps.org firstname Samuel lastname Sophomore password sscps123 changepassword on org /Test/Users-Normal/Students/Level-HS externalid organization 99999992
#python ./gam/gam.py create user ttender101@student.sscps.org firstname Tabitha lastname Tenderfoot password sscps123 changepassword on org /Test/Users-Normal/Students/Level-HS externalid organization 99999993
#python ./gam/gam.py create user ttender102@student.sscps.org firstname Terrance lastname Tenderfoot password sscps123 changepassword on org /Test/Users-Normal/Students/Level-4 externalid organization 99999984



# archive users from extract sql
#python ./gam/gam.py update user ssenior@sscps.org suspended on org /Test/Archive/Aging/Employees
#python ./gam/gam.py update user llearne100@student.sscps.org suspended on org /Test/Archive/Aging/Students
#python ./gam/gam.py update user llearne123@student.sscps.org suspended on org /Test/Archive/Aging/Students
#python ./gam/gam.py update user ssenior106@student.sscps.org suspended on org /Test/Archive/Aging/Students
#python ./gam/gam.py update user ssenior992@student.sscps.org suspended on org /Test/Archive/Aging/Students
