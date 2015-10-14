#! /usr/bin/env python

# below are code samples to run gam.py from this script & capture output where can
# imports are required for both GAM & MySQL stuff
# for logging, the varCommandToExecute is the final GAM command that is run

import os         # os.system for clearing screen and simple gam calls
import subprocess # subprocess.Popen is to capture gam output (needed for user info in particular)
import MySQLdb    # MySQLdb is to get data from relevant tables
import csv        # CSV is used to read output of drive commands that supply data in CSV form


### Variables that are used more for config then processing
# setup to find GAM
varCommandGam = "python ./gam/gam.py"
# setup for MySQLdb connection
varMySQLHost = "localhost"
varMySQLUser = "sscpssyncprod"
varMySQLPassword = "ZEN@2014sufu"
varMySQLDB = "sscpssyncprod"


# test if user exists, if not create.  then adds user to group
varRunTest = False
if varRunTest:

# get list of all users, check if user in DB & ACTIVE, if not mark suspended
varRunTest = True
if varRunTest:
    os.system('clear')
    varArgList=["info", "user", varGroupName]
    varResultsProc = subprocess.Popen([varCommandGam + ' %s' % ' '.join(varArgList)], stdout=subprocess.PIPE, shell=True)
    (varResults, varErrors) = varResultsProc.communicate()
    os.system('clear')
    #print varResults
    #print type(varResults)
    #print varResults.find("Group Settings:")
    if varResults.find("Group Settings:") < 0:
        print "Group does not exist."
    else:
        print varResults


# test if group exists, grab list of users, add calendar to all those users
# NOT complete
varRunTest = False
if varRunTest:
    varGroupName = "facstaff_lhs@sscps.org"
    os.system('clear')
    varArgList=["info", "group", varGroupName]
    varResultsProc = subprocess.Popen([varCommandGam + ' %s' % ' '.join(varArgList)], stdout=subprocess.PIPE, shell=True)
    (varResults, varErrors) = varResultsProc.communicate()
    os.system('clear')
    #print varResults
    #print type(varResults)
    #print varResults.find("Group Settings:")
    if varResults.find("Group Settings:") < 0:
        print "Group does not exist."
    else:
        print varResults
    # generic way to add calendar to user
    #varArguments = " user " + varUserName + " add calendar " + varCalendarEmail + " selected true hidden false"
    #varCommandToExecute = varCommandGam + varArguments
    #print varCommandToExecute
    #os.system(varCommandToExecute)


# test group exists & grab output
varRunTest = False
if varRunTest:
  #varGroupName = "prn-prnadmin@sscps.org"
  #varGroupName = "somenamethatshouldnotexist@sscps.org"
  varGroupName = "admin.google@sscps.org"
  os.system('clear')
  varArgList=["info", "group", varGroupName]
  varResultsProc = subprocess.Popen([varCommandGam + ' %s' % ' '.join(varArgList)], stdout=subprocess.PIPE, shell=True)
  (varResults, varErrors) = varResultsProc.communicate()
  os.system('clear')
  #print varResults
  #print type(varResults)
  #print varResults.find("Group Settings:")
  if varResults.find("Group Settings:") < 0:
    print "Group does not exist."
  else:
    print varResults


# create a user
varRunTest = False
if varRunTest:
  varUserName = '"deletemenow@student.sscps.org"'
  varFirstName = '"GET RID"'
  varLastName = '"OF THIS GUY"'
  varPassword = '"this is a really long password that isnt too hard to guess"'
  os.system('clear')
  #varArgList = ["info", "domain"]
  varArgList = ["create", "user", varUserName, "firstname", varFirstName, "lastname", varLastName, "password", varPassword]
  #print varArgList
  varCommandToExecute = varCommandGam + ' %s' % ' '.join(varArgList)
  #print varCommandToExecute
  varResultsProc = subprocess.Popen([varCommandToExecute], stdout=subprocess.PIPE, shell=True)
  (varResults, varErrors) = varResultsProc.communicate()
  os.system('clear')
  # can't capture the "Error 404" on the console to check for errors?!?!?!
  print varResults


# test get user information
varRunTest = False
if varRunTest:
  #varUserName = "blahblahblah@student.sscps.org"
  #varUserName = "joe_student@student.sscps.org"
  varUserName = "whatever@sscps.org"
  #varUserName = "sstaff@sscps.org"
  os.system('clear')
  varArgList=["info", "user", varUserName, "noaliases nogroups"]
  #print varArgList
  varCommandToExecute = varCommandGam + ' %s' % ' '.join(varArgList)
  #print varCommandToExecute
  varResultsProc = subprocess.Popen([varCommandToExecute], stdout=subprocess.PIPE, shell=True)
  (varResults, varErrors) = varResultsProc.communicate()
  #os.system('clear')
  # can't capture the "Error 404" on the console to check for errors?!?!?!
  print varResults

# test user exists & grab output
varRunTest = False
if varRunTest:
  #varUserName = "blahblahblah@student.sscps.org"
  #varUserName = "joe_student@student.sscps.org"
  varUserName = "whatever@sscps.org"
  #varUserName = "sstaff@sscps.org"
  os.system('clear')
  varArgList=["info", "user", varUserName, "noaliases nogroups"]
  #print varArgList
  varCommandToExecute = varCommandGam + ' %s' % ' '.join(varArgList)
  #print varCommandToExecute
  varResultsProc = subprocess.Popen([varCommandToExecute], stdout=subprocess.PIPE, shell=True)
  (varResults, varErrors) = varResultsProc.communicate()
  os.system('clear')
  #print varResults
  #print type(varResults)
  #print varResults.find("User: ")
  if varResults.find("User: ") < 0:
    print "User does not exist."
  else:
    print varResults

# find folder/file by name & get folderId, NOTE:  only outputs first hit for multiple folders/files with same name
varRunTest = False
if varRunTest:
  varUserName = "admin.google@sscps.org"
  #varFolderNameToFind = `'SSCPS-TestDocs'`
  varFolderNameToFind = `'Some folder I really hope does not exist!!!'`
  varFolderNameQueryToPass = ' query "title = ' + varFolderNameToFind + '"'
  os.system('clear')
  varArgList=["user", varUserName, " show filelist ", varFolderNameQueryToPass, " id"]
  #print varArgList
  varCommandToExecute = varCommandGam + ' %s' % ' '.join(varArgList)
  #print varCommandToExecute
  varResultsProc = subprocess.Popen([varCommandToExecute], stdout=subprocess.PIPE, shell=True)
  (varResults, varErrors) = varResultsProc.communicate()
  os.system('clear')
  #to remove header row, not necessary if parse for CSV
  #varResults = ''.join(varResults.splitlines(True)[1:])
  if varResults.find(",title,") < 0:
    print "Folder does not exist."
  else:
    #print varResults
    varCSVDataSet = csv.reader(varResults.split('\n'), delimiter=',')
    varCSVHeaders=[]
    varCSVData=[]
    varIDColumn = 999
    varRowCount = 0
    for row in varCSVDataSet:
      varColCount = 0
      for col in row:
        if varRowCount == 0:
          varCSVHeaders.append(col)
          if col == 'id':
            varIDColumn = varColCount
        elif varRowCount == 1:
          varCSVData.append(col)
        varColCount += 1
      varRowCount += 1
    print varCSVData[varIDColumn]

# create folder for user & grab folderId
varRunTest = False
varUserName = "admin.google@sscps.org"
varFolderNameToCreate = '"TPS Reports"'
if varRunTest:
  os.system('clear')
  varArgList=["user", varUserName, "add drivefile drivefilename ", varFolderNameToCreate, " mimetype gfolder"]
  #print varArgList
  varCommandToExecute = varCommandGam + ' %s' % ' '.join(varArgList)
  #print varCommandToExecute
  varResultsProc = subprocess.Popen([varCommandToExecute], stdout=subprocess.PIPE, shell=True)
  (varResults, varErrors) = varResultsProc.communicate()
  os.system('clear')
  varFolderID = varResults[varResults.rfind("ID ") + 3:]
  print varFolderID

# get data from MySQLdb
varRunTest = False
if varRunTest:
  os.system('clear')
  varDBConnection = MySQLdb.connect(host=varMySQLHost, db=varMySQLDB, user=varMySQLUser, passwd=varMySQLPassword)
  varDBCursor = varDBConnection.cursor()
  varDBCursor.execute('SELECT first_name, last_name, user_name, email_address FROM users WHERE email_address like %s',('%@student.sscps.org%',))
  os.system('clear')
  #varDBResults = varDBCursor.fetchall()
  #print varDBResults[2]
  for (first_name, last_name, user_name, email_address) in varDBCursor:
    print "user_name:  ", user_name
  varDBCursor.close()
  varDBConnection.close()
