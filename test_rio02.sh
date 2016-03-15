# "change owner" or "archive" of folder/files
#
# first set sharing permission
python ./gam/gam.py user <current owner>@sscps.org update drivefile id 1sVD54ocoCWdJYyKBKix84T0MzlVfo7tgW-rrH0skqg4 writerscantshare
# second remove specific users
python ./gam/gam.py user <current owner>@sscps.org delete drivefileacl 1sVD54ocoCWdJYyKBKix84T0MzlVfo7tgW-rrH0skqg4 <wrong user/group>@sscps.org
# third change owner of file
python ./gam/gam.py user <current owner>@sscps.org update drivefileacl 1sVD54ocoCWdJYyKBKix84T0MzlVfo7tgW-rrH0skqg4 <new owner>@sscps.org role owner transferownership true
# fourth remove old owner
python ./gam/gam.py user <new owner>@sscps.org delete drivefileacl 1sVD54ocoCWdJYyKBKix84T0MzlVfo7tgW-rrH0skqg4 <old/current owner>@sscps.org
# fifth add appropriate user & group permisions
python ./gam/gam.py user <newowner>@sscps.org add drivefileacl 1sVD54ocoCWdJYyKBKix84T0MzlVfo7tgW-rrH0skqg4 group <new read-only user/group>@sscps.org role reader withlink
python ./gam/gam.py user <newowner>@sscps.org add drivefileacl 1sVD54ocoCWdJYyKBKix84T0MzlVfo7tgW-rrH0skqg4 group <new edit user/group>@sscps.org role writer withlink
