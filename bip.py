#! /usr/bin/env python

#################################################################################################
#
# Script Name:    bip.py
# Script Usage:   This script is the menu system and runs everything else.  Do not use other
#                 files unless you are comfortable with the code.
#
#                 It has the following:
#                   1.
#                   2.
#                   3.
#                   4.
#
#                 You will probably want to do the following:
#                   1.  Make sure the info in bip_config.py is correct.
#                   2.  Make sure GAM (Google Apps Manager) is installed and the path is correct.
#                   3.  Make sure the AD scripts in toos/ are present on the DC running run.ps1.
#
# Script Updates:
#     201709191243 - rdegennaro@sscps.org - copied boilerplate.
#
#################################################################################################

import os         # os.system for clearing screen and simple gam calls
import subprocess # subprocess.Popen is to capture gam output (needed for user info in particular)
import MySQLdb    # MySQLdb is to get data from relevant tables
import csv        # CSV is used to read output of drive commands that supply data in CSV form

import bip_config # declare installation specific variables
# setup for MySQLdb connection
varMySQLHost = bip_config.mysqlconfig['host']
varMySQLUser = bip_config.mysqlconfig['user']
varMySQLPassword = bip_config.mysqlconfig['password']
varMySQLDB = bip_config.mysqlconfig['db']
# setup to find GAM
varCommandGam = bip_config.gamconfig['fullpath']


#################################################################################################
#
#################################################################################################
