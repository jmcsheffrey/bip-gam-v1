# Introduction
Right now, this project is more a conglomeration of ad-hoc database tables and
scripts.  Hopefully in the future a more complete "system" of some sort will
evolve.  

# Random Notes
1. Each version should have its own setup script.
2. The mods_for_tracking is just Rio keeping track of changes to replicate on different machines (mini dev upgrades)

# Notes on data structure
Below are notes about expected values or other nuances for information in fields.

## Table: users
* status: either 'ACTIVE' or 'INACTIVE'
* manual_entry: This is a 2 character VARCHAR with the following expected values:
    N  = data comes from (SIS) AdminPlus
    YA = Manually entered, needs Network ID & Email Address
    YE = Manually entered, needs Email Address only
    YN = Manually entered, needs Network ID only
* population:  valid values are:
    EMP = Employee
    STU = Student
    TST = Test
* grade:  should only be empty if population != STU

# ToDo, forget me nots
* Login mapping needs some folders to exist before first time login on windows creates them (https://sscps.freshdesk.com/helpdesk/tickets/159832).
