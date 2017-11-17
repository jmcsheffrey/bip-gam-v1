#! /usr/bin/env python

#################################################################################################
#
# Script Name:    test.py
# Script Usage:   This script is to test various generic ideas for using python & GAM.
#
#################################################################################################


# import libraries, tells why
import os         # os.system for clearing screen and calling GAM
import subprocess # subprocess.Popen is to capture gam output (needed for user info in particular)
import MySQLdb    # MySQLdb is to get data from relevant tables
import csv        # CSV is used to read output of drive commands that supply data in CSV form


# variable to find GAM and not rely on another file
varCommandGam = "../../bin/gam/gam"

varUserName = "sstaff@sscps.org"
varFirstName = "Sam"
varLastName = `"S'taff"`
varPassword = "a;o4e64vnslghv"
varUserAlias = "SomeOtherSam"
varCalendarEmail = "sscps.org_hvj4dnr5jebek8srk9q09l91tc@group.calendar.google.com"

# Create user
#varArguments = " create user " + varUserName + " firstname " + varFirstName + " lastname " + varLastName + " password " + varPassword
#varCommandToExecute = varCommandGam + varArguments
#print varCommandToExecute
#os.system(varCommandToExecute)

# Create alias on user
#varArguments = " create alias " + varUserAlias + " user " + varUserName
#varCommandToExecute = varCommandGam + varArguments
#print varCommandToExecute
#os.system(varCommandToExecute)

# Add calendar to user
#varArguments = " user " + varUserName + " add calendar " + varCalendarEmail + " selected true hidden false"
#varCommandToExecute = varCommandGam + varArguments
#print varCommandToExecute
#os.system(varCommandToExecute)

# get list of all users
#gam print users allfields
#varArguments = " print users allfields"
#varCommandToExecute = varCommandGam + varArguments
#print varCommandToExecute
#os.system(varCommandToExecute)
