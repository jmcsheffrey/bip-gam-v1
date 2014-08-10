#! /usr/bin/env python

# below is code to run gam.py from this script, import is required for both
# first os.system call is simple, second lets you build arguments
import os

# setup to find GAM
varCommandGam = "python ./gam/gam.py"

varUserName = "joe_student@student.sscps.org"
varFirstName = "Joe"
varLastName = `"Student"`
varPassword = ""
varUserAlias = ""

# general testing
#argList=["info", "domain"]
#argList=["create", "user", varUserName, "firstname", varFirstName, "lastname", varLastName, "password", varPassword]
#print argList
#os.system(varCommandGam + ' %s' % ' '.join(argList))

# test get user information
argList=["info", "user", varUserName, "noaliases nogroups"]
print argList
os.system(varCommandGam + ' %s' % ' '.join(argList))
