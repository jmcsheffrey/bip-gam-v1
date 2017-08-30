##################################
# Student commands
##################################
# create student email
../bin/gam/gam create user <replace_me>@student.sscps.org firstname "<replace_me>" lastname "<replace_me>" password sscps123 changepassword on org /Prod/Users-Normal/Students/Level-<set to HS, 04, 03, 02> externalid organization <replace_me>
# populate students@student.sscps.org
../bin/gam/gam update group students@student.sscps.org add member <replace_me>@student.sscps.org
# populate <level>@student.sscps.org
../bin/gam/gam update group students_<replace_me>@student.sscps.org add member <replace_me>@student.sscps.org
# populate gco groups
 ../bin/gam/gam update group gco-fy2019@student.sscps.org add member <replace_me>@student.sscps.org
# add users to SSCPS-GroupDocs - the user's "My Drive" is not created until they log in
../bin/gam/gam user <replace_me>@student.sscps.org update drivefile id "0Byc5mfoLgdM3MDE0YjEyOWEtMjIxNi00YTE0LTgxZDgtODQxOGEwODU5YjE3" parentid root

##################################
# Employee commands
##################################
# create employee email
../bin/gam/gam create user <replace_me>@sscps.org firstname "<replace_me>" lastname "<replace_me>" password sscps123 changepassword on org /Prod/Users-Normal/Students/Level-<set to HS, 04, 03, 02> externalid organization <replace_me>
# populate employees@sscps.org
../bin/gam/gam update group employees@sscps.org add member <replace_me>@sscps.org
# populate facstaff@sscps.org
../bin/gam/gam update group facstaff@sscps.org add member <replace_me>@sscps.org
# add users to SSCPS-GroupDocs - the user's "My Drive" is not created until they log in
../bin/gam/gam user <replace_me>@sscps.org update drivefile id 0Byc5mfoLgdM3MDE0YjEyOWEtMjIxNi00YTE0LTgxZDgtODQxOGEwODU5YjE3 parentid root
