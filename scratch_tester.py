#! /usr/bin/env python

# below is code to run gam.py from this script, import is required for both
# first os.system call is simple, second lets you build arguments
import os

# setup to find GAM
varCommandGam = "python ./gam/gam.py"

varUserName = "crashtestdummy3"
varFirstName = "Crash3"
varLastName = `"Test Dummy"`
varPassword = "BuckleUp"
varUserAlias = "idontwearseatbelts3"

#argList=["info", "domain"]
argList=["create", "user", varUserName, "firstname", varFirstName, "lastname", varLastName, "password", varPassword]
print argList
#os.system('python ./gam/gam.py %s' % ' '.join(argList))
os.system(varCommandGam + ' %s' % ' '.join(argList))

