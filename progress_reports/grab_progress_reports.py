#! /usr/bin/env python

# downloads Progress Reports for mass printing
# local folders need to be created manually
# see print_progress_reports.sh to print the downloaded files

# imports are required for both GAM & CSV processing
import os         # os.system for clearing screen and simple gam calls
import subprocess # subprocess.Popen is to capture gam output (needed for user info in particular)
import csv        # CSV is used to read output of drive commands that supply data in CSV form


### Variables that are used more for config then processing
# setup to find GAM
varCommandGam = "python ../gam/gam.py"


# download all files in a folder
varRunTest = True
if varRunTest:
  varUserName = "rdegennaro@sscps.org"
  #varFolderIDToFind = `'0B8RgM3B2REzvd05tWGwta0xVVEE'` # Amy's Pod
  #varTargetDownloadFolder = '/home/rdegennaro/Documents/ProgressReportsQ2/Amy/'
  #varFolderIDToFind = `'0B8RgM3B2REzvejVoVXZhdS1OSGc'` # Judy's Pod
  #varTargetDownloadFolder = '/home/rdegennaro/Documents/ProgressReportsQ2/Judy/'
  #varFolderIDToFind = `'0B8RgM3B2REzvTWdUOWNZaGpWRnM'` # June's Pod
  #varTargetDownloadFolder = '/home/rdegennaro/Documents/ProgressReportsQ2/June/'
  #varFolderIDToFind = `'0B8RgM3B2REzvZ3U2QmtKREtQWkU'` # Kassandra's Pod
  #varTargetDownloadFolder = '/home/rdegennaro/Documents/ProgressReportsQ2/Kassandra/'
  #varFolderIDToFind = `'0B8RgM3B2REzvWEo3Yi15d3BNeWM'` # Nora's Pod
  #varTargetDownloadFolder = '/home/rdegennaro/Documents/ProgressReportsQ2/Nora/'
  #varFolderIDToFind = `'0B8RgM3B2REzvMDk2XzdlYWdZRTg'` # Velma's Pod
  #varTargetDownloadFolder = '/home/rdegennaro/Documents/ProgressReportsQ2/Velma/'
  #
  # first get all files in the class folder
  varFolderNameQueryToPass = ' query "' + varFolderIDToFind + ' in parents"'
  os.system('clear')
  varArgList=["user", varUserName, "show filelist", varFolderNameQueryToPass, " id"]
  #print varArgList
  varCommandToExecute = varCommandGam + ' %s' % ' '.join(varArgList)
  #print varCommandToExecute
  varResultsProc = subprocess.Popen([varCommandToExecute], stdout=subprocess.PIPE, shell=True)
  (varResults, varErrors) = varResultsProc.communicate()
  #print varResults
  # now check to see if something in folder
  if varResults.find(",title,") < 0:
    print "Folder does not exist or is empty."
  else:
    #print varResults
    # setup to parse out ID of files to step through
    varCSVDataSet = csv.reader(varResults.split('\n'), delimiter=',')
    varCSVHeaders=[]
    varCSVData=[]
    varIDColumn = 999999
    varRowCount = 0
    for row in varCSVDataSet:
      varColCount = 0
      if varRowCount != 0:
        for col in row:
	  if varColCount == 2:
	    #print col
	    varCSVData.append(col)
	  varColCount += 1
      varRowCount += 1
    #print varCSVData
    # now step through list of file ID's & download each as PDF
    for i in varCSVData:
      varFileIDToDownload = chr(39) + i + chr(39)
      print 'Downloading:  ' + varFileIDToDownload
      varArgList=["user", varUserName, "get drivefile id", varFileIDToDownload, " format pdf targetfolder ", varTargetDownloadFolder]
      #print varArgList
      varCommandToExecute = varCommandGam + ' %s' % ' '.join(varArgList)
      #print varCommandToExecute
      varResultsProc = subprocess.Popen([varCommandToExecute], stdout=subprocess.PIPE, shell=True)
      (varResults, varErrors) = varResultsProc.communicate()

