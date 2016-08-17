#python ./gam/gam.py info domain


# create new users
# gam create user <email address> firstname <First Name> lastname <Last Name> password <Password> changepassword on org <Org Name>


# "archive" users
# python ./gam/gam.py update user <employee>@sscps.org suspended on org /Archive/Aging/Employees
# python ./gam/gam.py update user <student>@student.sscps.org suspended on org /Archive/Aging/Students



# create google classroom classes manually
# gam create course [alias <alias>] [name <name>] [section <section>] [heading <heading>] [description <description>] [room <room>] [teacher <teacher email>] [status <PROVISIONED|ACTIVE|ARCHIVED|DECLINED>]
#python ./gam/gam.py create course alias <####-##-fy##> name "<name> - <block> (<teacher>)" section "####/##-FY##" teacher <teacher>@sscps.org status ACTIVE
#python ./gam/gam.py course <####-##-fy##> add student <joe_student>@student.sscps.org
#  classes for FY16 are listed below
#updateTime,name,alternateLink,enrollmentCode,section,creationTime,ownerId,courseState,id,description,descriptionHeading,room
#2016-03-02T21:03:39.210Z,AP Language Comp - Block C (Katie Cianelli),http://classroom.google.com/c/OTQzMDg5ODkx,20u598,1506/01-FY16,2016-03-02T21:03:40.129Z,117806591858634121010,ACTIVE,943089891,,,
#2016-03-02T21:03:32.373Z,English 10 - Block D (Katie Cianelli),http://classroom.google.com/c/OTQzMjYwMDYx,besfbv,1415/02-FY16,2016-03-02T21:03:33.041Z,117806591858634121010,ACTIVE,943260061,,,
#2016-03-02T21:03:18.164Z,English 10 - Block B (Katie Cianelli),http://classroom.google.com/c/OTQ0MTk4Mzc2,qu3etv,1415/01-FY16,2016-03-02T21:03:20.269Z,117806591858634121010,ACTIVE,944198376,,,
#2016-03-02T21:02:54.343Z,English 10H - Block A (Katie Cianelli),http://classroom.google.com/c/OTQzMjgwMTQ2,45repe,1416/01-FY16,2016-03-02T21:02:55.135Z,117806591858634121010,ACTIVE,943280146,,,
#2016-03-02T21:01:18.477Z,Makers - Workshop (Jenny Kostka),http://classroom.google.com/c/OTQ0NjgyNjk3,4d6gbs,5525/01-FY16,2016-03-02T21:01:19.098Z,113236831552186806887,ACTIVE,944682697,,,
#2016-03-02T21:00:08.303Z,Technology Solutions - Workshop (Ralph deGennaro),http://classroom.google.com/c/OTQ0MDE1MjA3,,5620/01-FY16,2016-03-02T20:58:58.497Z,106216400574391631599,ACTIVE,944015207,,,
#2016-01-11T19:07:31.859Z,Teacher Practice,http://classroom.google.com/c/MjM3NDEzMjgw,,Teacher as Student Section,2015-09-14T14:05:53.196Z,106216400574391631599,ACTIVE,237413280,"In this class, teachers are setup as students.  Feel free to look around, especially at the discussion and assignment items in the Stream.",See what a student sees,
#2015-10-08T13:46:16.555Z,ELA8 - Block E (Shawn),http://classroom.google.com/c/MjM3Mzk1MDAz,,1408/01-FY16,2015-09-14T13:58:03.484Z,106216400574391631599,ACTIVE,237395003,,,
#2015-09-18T14:17:56.635Z,ELA8 - Block B (Shawn),http://classroom.google.com/c/MjM3Mzk0OTky,,1408/02-FY16,2015-09-14T13:57:16.314Z,106216400574391631599,ACTIVE,237394992,,,
#2015-09-18T15:43:32.984Z,ELA7 - Block D (Shawn),http://classroom.google.com/c/MjM3Mzg5NTcy,,1407/01-FY16,2015-09-14T13:56:24.970Z,106216400574391631599,ACTIVE,237389572,,,
#2015-09-17T12:03:59.636Z,ELA7 - Block A (Shawn),http://classroom.google.com/c/MjM3NDAwMDA5,,1407/02-FY16,2015-09-14T13:54:48.754Z,106216400574391631599,ACTIVE,237400009,,,
#2016-02-18T19:09:17.643Z,Physics,http://classroom.google.com/c/MTI1NjQ5NjMy,wukc0wo,,2015-08-16T11:44:51.248Z,113236831552186806887,ARCHIVED,125649632,,,
#2016-02-18T19:09:08.700Z,Astronomy,http://classroom.google.com/c/MTI1NjUxNjUz,f3s10y,2,2015-08-16T11:44:20.091Z,113236831552186806887,ARCHIVED,125651653,,,
#2016-02-18T19:09:03.951Z,Astronomy,http://classroom.google.com/c/MTI1NjUwOTk2,455d1ce,1,2015-08-16T11:41:53.538Z,113236831552186806887,ARCHIVED,125650996,,,
#2016-02-23T15:00:14.438Z,Workshop,http://classroom.google.com/c/MTI1NjUxNDAx,75c5qrh,,2015-08-16T11:39:48.058Z,113236831552186806887,ACTIVE,125651401,,Maker's Workshop,111
#2016-02-18T19:09:13.683Z,AP Physics,http://classroom.google.com/c/MTI1MjM0NzE2,mwfx3p,,2015-08-12T12:40:41.364Z,113236831552186806887,ARCHIVED,125234716,,,
#2016-02-12T13:59:26.760Z,Teacher Practice,http://classroom.google.com/c/MTQ3ODIyODg3,,Co-Teacher Section,2015-05-15T20:28:59.595Z,106216400574391631599,ACTIVE,147822887,"All the teachers can add stuff to play with it.  If you create an assignment or anything and want to see what it looks like when a student does something, let Rio know.  He will have the test students do something or show you how to login as them.",Teacher Practice (Co-Teacher Section),
#2015-11-27T18:11:35.772Z,Test Course A/02,http://classroom.google.com/c/OTg4MTM3Nlpa,syi51q,CLSA/02,2014-09-25T12:51:27.628Z,106216400574391631599,ARCHIVED,9881376,,Custom Title for Test Course A/02,
#2015-11-27T18:11:28.569Z,Test Course A/01,http://classroom.google.com/c/NjQxOTI4,bkr0wj,CLSA/01,2014-08-06T23:47:21.011Z,106216400574391631599,ARCHIVED,641928,What can we do with Google Classrooms?,Test Course 101,OFC 14



# "change owner" or "archive" of folder/files
# first set sharing permission
#python ./gam/gam.py user <current owner>@sscps.org update drivefile id 1sVD54ocoCWdJYyKBKix84T0MzlVfo7tgW-rrH0skqg4 writerscantshare
# second remove specific users
#python ./gam/gam.py user <current owner>@sscps.org delete drivefileacl 1sVD54ocoCWdJYyKBKix84T0MzlVfo7tgW-rrH0skqg4 <wrong user/group>@sscps.org
# third change owner of file
#python ./gam/gam.py user <current owner>@sscps.org update drivefileacl 1sVD54ocoCWdJYyKBKix84T0MzlVfo7tgW-rrH0skqg4 <new owner>@sscps.org role owner transferownership true
# fourth remove old owner
#python ./gam/gam.py user <new owner>@sscps.org delete drivefileacl 1sVD54ocoCWdJYyKBKix84T0MzlVfo7tgW-rrH0skqg4 <old/current owner>@sscps.org
# fifth add appropriate user & group permisions
#python ./gam/gam.py user <newowner>@sscps.org add drivefileacl 1sVD54ocoCWdJYyKBKix84T0MzlVfo7tgW-rrH0skqg4 group <new read-only user/group>@sscps.org role reader withlink
#python ./gam/gam.py user <newowner>@sscps.org add drivefileacl 1sVD54ocoCWdJYyKBKix84T0MzlVfo7tgW-rrH0skqg4 group <new edit user/group>@sscps.org role writer withlink



# update parents email list manually
# GAM command:
#   gam update group <group email> add owner|member|manager {user <email address> | group <group address> | org <org name> | file <file name> | all users}
# SHEETS formula:
#   =concatenate("python ./gam/gam.py update group parents@sscps.org add member " & B2)
#  Add test email addresses, don't actually use this, just examples
#python ./gam/gam.py update group parents@sscps.org add member testemailxyz@gmail.com
#python ./gam/gam.py update group parents@sscps.org add member testemailabc@aim.com
#python ./gam/gam.py update group parents@sscps.org add member testemail123@yahoo.com
