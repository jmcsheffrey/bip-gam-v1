#! /usr/bin/env python

# below is code to run gam.py from this script, import is required for both
# first os.system call is simple, second lets you build arguments
import os

# setup to find GAM
varCommandGam = "python ./gam/gam.py"

varUserName = "dcostin@sscps.org"
varFirstName = "Crash"
varLastName = `"Test Dummy"`
varPassword = "BuckleUp"
varUserAlias = "idontwearseatbelts"
varCalendarEmail = "sscps.org_hvj4dnr5jebek8srk9q09l91tc@group.calendar.google.com"

#argList=["info", "domain"]
#argList=["create", "user", varUserName, "firstname", varFirstName, "lastname", varLastName, "password", varPassword]
#print argList
#os.system('python ./gam/gam.py %s' % ' '.join(argList))

#varArguments = " create user " + varUserName + " firstname " + varFirstName + " lastname " + varLastName + " password " + varPassword
#varCommandToExecute = varCommandGam + varArguments
#print varCommandToExecute
#os.system(varCommandToExecute)

#varArguments = " create alias " + varUserAlias + " user " + varUserName
#varCommandToExecute = varCommandGam + varArguments
#print varCommandToExecute
#os.system(varCommandToExecute)

varArguments = " user " + varUserName + " add calendar " + varCalendarEmail + " selected true hidden false"
varCommandToExecute = varCommandGam + varArguments
print varCommandToExecute
os.system(varCommandToExecute)
