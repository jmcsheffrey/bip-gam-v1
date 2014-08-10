#! /usr/bin/env python

# below is code to run gam.py from this script, import is required for both
# first os.system call is simple, second lets you build arguments
import os

# setup to find GAM
varCommandGam = "python ./gam/gam.py"

varUserName = "crashtestdummy"
varFirstName = "Crash"
varLastName = `"Test Dummy"`
varPassword = "BuckleUp"
varUserAlias = "idontwearseatbelts"

#argList=["info", "domain"]
#argList=["create", "user", varUserName, "firstname", varFirstName, "lastname", varLastName, "password", varPassword]
#print argList
#os.system('python ./gam/gam.py %s' % ' '.join(argList))

varArguments = " create user " + varUserName + " firstname " + varFirstName + " lastname " + varLastName + " password " + varPassword
varCommandToExecute = varCommandGam + varArguments
print varCommandToExecute
os.system(varCommandToExecute)

varArguments = " create alias " + varUserAlias + " user " + varUserName
varCommandToExecute = varCommandGam + varArguments
print varCommandToExecute
os.system(varCommandToExecute)

