#! /usr/bin/env python

# below is code to run gam.py from this script, import is required for both

import os         # os.system for clearing screen and simple gam calls
import subprocess # subprocess.Popen is to capture gam output (needed for user info in particular)
import MySQLdb    # MySQLdb is to get data from relevant tables
import csv        # CSV is used to read output of drive commands that supply data in CSV form


# setup to find GAM
varCommandGam = "python ./gam/gam.py"
# setup for MySQLdb connection
varMySQLHost = "localhost"
varMySQLUser = "sscpssynctest"
varMySQLPassword = "longwater1009"
varMySQLDB = "sscpssynctest"


varUserName = "joe_student@student.sscps.org"
varFirstName = "Joe"
varLastName = `"Student"`
varPassword = ""
varUserAlias = ""

# general testing
varRunTest = False
if varRunTest:
  argList=["info", "domain"]
  argList=["create", "user", varUserName, "firstname", varFirstName, "lastname", varLastName, "password", varPassword]
  print argList
  os.system(varCommandGam + ' %s' % ' '.join(argList))

# test get user information
varRunTest = False
if varRunTest:
  os.system('clear')
  varArgList=["info", "user", varUserName, "noaliases nogroups"]
  #print varArgList
  os.system(varCommandGam + ' %s' % ' '.join(varArgList))


# test user exists & grab output
varRunTest = False
#varUserName = "blahblahblah@student.sscps.org"
#varUserName = "joe_student@student.sscps.org"
#varUserName = "whatever@sscps.org"
#varUserName = "sstaff@sscps.org"
if varRunTest:
  os.system('clear')
  varArgList=["info", "user", varUserName, "noaliases nogroups"]
  varResultsProc = subprocess.Popen([varCommandGam + ' %s' % ' '.join(varArgList)], stdout=subprocess.PIPE, shell=True)
  (varResults, varErrors) = varResultsProc.communicate()
  #print type(varResults)
  #print varResults
  if varResults.find("Error 404") < 0:
    print "User does not exist."
  else:
    print varResults

# find folder/file by name & get folderId, NOTE:  only outputs first hit for multiple folders/files with same name
varRunTest = False
varUserName = "admin.google@sscps.org"
varFolderNameToFind = `'SSCPS-TestDocs'`
varFolderNameQueryToPass = ' query "title = ' + varFolderNameToFind + '"'
if varRunTest:
  os.system('clear')
  varArgList=["user", varUserName, " show filelist ", varFolderNameQueryToPass, " id"]
  varResultsProc = subprocess.Popen([varCommandGam + ' %s' % ' '.join(varArgList)], stdout=subprocess.PIPE, shell=True)
  (varResults, varErrors) = varResultsProc.communicate()
  #to remove header row, not necessary if parse for CSV
  #varResults = ''.join(varResults.splitlines(True)[1:])
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
varUserName = "sstaff@sscps.org"
varFolderNameToCreate = '"TPS Reports"'
if varRunTest:
  os.system('clear')
  varArgList=["user", varUserName, "add drivefile drivefilename ", varFolderNameToCreate, " mimetype gfolder"]
  varResultsProc = subprocess.Popen([varCommandGam + ' %s' % ' '.join(varArgList)], stdout=subprocess.PIPE, shell=True)
  (varResults, varErrors) = varResultsProc.communicate()
  varFolderID = varResults[varResults.rfind("ID ") + 3:]
  print varFolderID

# get data from MySQLdb
varRunTest = False
if varRunTest:
  os.system('clear')
  varDBConnection = MySQLdb.connect(host=varMySQLHost, db=varMySQLDB, user=varMySQLUser, passwd=varMySQLPassword)
  varDBCursor = varDBConnection.cursor()
  varDBCursor.execute('SELECT first_name, last_name, user_name, email_address FROM users WHERE email_address like %s',('%@student.sscps.org%',))
  #varDBResults = varDBCursor.fetchall()
  #print varDBResults[2]
  for (first_name, last_name, user_name, email_address) in varDBCursor:
    print "user_name:  ", user_name
  varDBCursor.close()
  varDBConnection.close()






