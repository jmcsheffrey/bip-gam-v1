# update parents email list manually
# GAM command:
#   gam update group <group email> add owner|member|manager {user <email address> | group <group address> | org <org name> | file <file name> | all users}
# SLIDES formula:
#   =concatenate("python ./gam/gam.py update group parents@sscps.org add member " & B2)

#
#  Add test email addresses, don't actually use this, just examples
#
#python ./gam/gam.py update group parents@sscps.org add member testemailxyz@gmail.com
#python ./gam/gam.py update group parents@sscps.org add member testemailabc@aim.com
#python ./gam/gam.py update group parents@sscps.org add member testemail123@yahoo.com
