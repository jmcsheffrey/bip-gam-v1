#! /usr/bin/env python

#################################################################################################
#
# Script Name:    00.generic_tools.py
# Script Usage:   This script is to house generic functions that are used in other scripts
#
#                 It has the following:
#                   1.
#                   2.
#                   3.
#                   4.
#
#                 You will probably want to do the following:
#                   1.  make sure the path the gam is correct
#                   2.  make sure the connection to the SQL database is correct
#
# Script Updates:
#     201510070902 - rdegennaro@sscps.org - created boilerplate & copied stuff from testing.
#
#################################################################################################

import os         # os.system for clearing screen and simple gam calls
import subprocess # subprocess.Popen is to capture gam output (needed for user info in particular)
import MySQLdb    # MySQLdb is to get data from relevant tables
import csv        # CSV is used to read output of drive commands that supply data in CSV form


### Variables that are used more for config then processing
# setup to find GAM
varCommandGam = "python ./gam/gam.py"
# setup for MySQLdb connection
varMySQLHost = "localhost"
varMySQLUser = "sscpssynctest"
varMySQLPassword = "longwater1009"
varMySQLDB = "sscpssynctest"


##################################################
#  function area - for use by other files
##################################################
