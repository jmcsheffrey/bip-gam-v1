########################################################################################################
# Purpose:  Set AD User to groups as defined:
#              * all users to group for passed fileserver & remove from other fileserver groups
#              * all employees to employees@sscps.org
#              * all employees to facstaff@sscps.org
#              * all students to students@student.sscps.org
#              * all students to level's group (students_<level>@students.sscps.org)
#
# Arguments, all required:
#   - unique_id
#   - population; choices: STU|EMP
#   - user_name
#   - fileserver
#   - grade
#   - gco; "Graduating Class Of"; format=YYYY; can be empty string
#
# Example invocation:
#    .\aduser.ps1 -cmd_type "ADD" -unique_id "TST99999" -population "STU" -school_email "some_dude@student.sscps.org" -user_name "some_dude" -first_name "S'ome" -last_name "Dude" -description "SSCPS Test ID" -fileserver "ROWLEY" -grade "06"
#
# REQUIRES:  nothing yet :-)
# TODO:
#   - after adjust fields for current fileserver and previous fileserver,
#     add in stuff to move directories between servers
########################################################################################################

###############################
#
# arguments
#
###############################
param(
   [Parameter(Mandatory=$true)]
   [string]$unique_id,
   [Parameter(Mandatory=$true)]
   [string]$population,
   [Parameter(Mandatory=$true)]
   [string]$user_name,
   [Parameter(Mandatory=$true)]
   [string]$fileserver,
   [Parameter(Mandatory=$true)]
   [string]$grade,
   [Parameter(Mandatory=$true)]
   [string]$gco
)

###############################
#
# "Static" variables
#
###############################
# IMPORTANT:  The fileservers and related groups MUST be in same order!!!!!!
$fileservers = "GREG","FREGLEY","RODRICK","ROWLEY"
$hfgroups_employees = "HF_Employees_FREGLEY", "HF_Employees_GREG", "HF_Employees_RODRICK", "HF_Employees_ROWLEY"
$hfgroups_students = "HF_Students_FREGLEY", "HF_Students_GREG", "HF_Students_RODRICK", "HF_Students_ROWLEY"

###############################
#
# Generated variables
#
###############################
# translate fileserver to destination homefolder group
$hfgroup_destination = "HF_"
if ( $population -eq "EMP" ) {
  $hfgroup_destination = $hfgroup_destination + "Employees_"
}
if ( $population -eq "STU" ) {
  $hfgroup_destination = $hfgroup_destination + "Students_"
}
$hfgroup_destination = $hfgroup_destination + $fileserver
# determine which set of groups based on population
if ( $population -eq "EMP" ) {
  $working_hfgroups = $hfgroups_employees
}
if ( $population -eq "STU" ) {
  $working_hfgroups = $hfgroups_students
}

# determine actual fileserver & ones to remove
$hfgroups_toremove = @()
Foreach ($working_hfgroup in $working_hfgroups) {
  if( $working_hfgroup -eq $hfgroup_destination ) {
    Write-Host "verified found "$working_hfgroup
  } else {
    $hfgroups_toremove += $working_hfgroup
  }
}

# determine the name of the gcogroup
$gcogroup = "gco-fy" + $gco

###############################
#
# functions used in MAIN
#
###############################



###############################
#
# "MAIN" body of script
#
###############################

# echo variables for varification when debugging
Write-Host "---------------------"
Write-Host "Passed Variables"
Write-Host "---------------------"
Write-Host "unique_id:           "$unique_id
Write-Host "population:          "$population
Write-Host "user_name:           "$user_name
Write-Host "fileserver:          "$fileserver
Write-Host "grade:               "$grade
Write-Host "gco:                 "$gco
Write-Host "---------------------"
Write-Host "Internal Variables"
Write-Host "---------------------"
Write-Host "working_hfgroups:    "$working_hfgroups
Write-Host "hfgroup_destination: "$hfgroup_destination
Write-Host "hfgroups_toremove:   "$hfgroups_toremove
Write-Host "gcogroup:            "$gcogroup

# add to homefolder group
Write-Host "adding to"$hfgroup_destination
Add-ADGroupMember $hfgroup_destination $user_name

# remove from old homefolder groups
Foreach ($hfgroup_toremove in $hfgroups_toremove) {
  Write-Host "removing from "$hfgroup_toremove
  Remove-ADGroupMember -Identity $hfgroup_toremove -Members $user_name -Confirm:$FALSE
}

if ( $population -eq "EMP" ) {
  Write-Host "adding to employee groups"
  Add-ADGroupMember "employees" $user_name
  Add-ADGroupMember "facstaff" $user_name
  Add-ADGroupMember "GW_FacStaff" $user_name
}
if ( $population -eq "STU" ) {
  Write-Host "adding to student group"
  Add-ADGroupMember "students" $user_name
  Write-Host "adjusting student level groups and GW group"
  if ( $grade -eq "0K" -Or $grade -eq "01" -Or $grade -eq "02" ) {
    Add-ADGroupMember "students_l1" $user_name
    Remove-ADGroupMember -Identity "students_l2" -Members $user_name -Confirm:$FALSE
    Remove-ADGroupMember -Identity "students_l3" -Members $user_name -Confirm:$FALSE
    Remove-ADGroupMember -Identity "students_l4" -Members $user_name -Confirm:$FALSE
    Remove-ADGroupMember -Identity "students_lhs" -Members $user_name -Confirm:$FALSE
    Add-ADGroupMember "GW_Students_Lower" $user_name
  } elseif ( $grade -eq "03" -Or $grade -eq "04" ) {
    Remove-ADGroupMember -Identity "students_l1" -Members $user_name -Confirm:$FALSE
    Add-ADGroupMember "students_l2" $user_name
    Remove-ADGroupMember -Identity "students_l3" -Members $user_name -Confirm:$FALSE
    Remove-ADGroupMember -Identity "students_l4" -Members $user_name -Confirm:$FALSE
    Remove-ADGroupMember -Identity "students_lhs" -Members $user_name -Confirm:$FALSE
    Add-ADGroupMember "GW_Students_Lower" $user_name
  } elseif ( $grade -eq "05" -Or $grade -eq "06" ) {
    Remove-ADGroupMember -Identity "students_l1" -Members $user_name -Confirm:$FALSE
    Remove-ADGroupMember -Identity "students_l2" -Members $user_name -Confirm:$FALSE
    Add-ADGroupMember "students_l3" $user_name
    Remove-ADGroupMember -Identity "students_l4" -Members $user_name -Confirm:$FALSE
    Remove-ADGroupMember -Identity "students_lhs" -Members $user_name -Confirm:$FALSE
    Add-ADGroupMember "GW_Students_Middle" $user_name
  } elseif ( $grade -eq "07" -Or $grade -eq "08" ) {
    Remove-ADGroupMember -Identity "students_l1" -Members $user_name -Confirm:$FALSE
    Remove-ADGroupMember -Identity "students_l2" -Members $user_name -Confirm:$FALSE
    Remove-ADGroupMember -Identity "students_l3" -Members $user_name -Confirm:$FALSE
    Add-ADGroupMember "students_l4" $user_name
    Remove-ADGroupMember -Identity "students_lhs" -Members $user_name -Confirm:$FALSE
    Add-ADGroupMember "GW_Students_Middle" $user_name
  } elseif ( $grade -eq "09" -Or $grade -eq "10" -Or $grade -eq "11" -Or $grade -eq "12" ) {
    Remove-ADGroupMember -Identity "students_l1" -Members $user_name -Confirm:$FALSE
    Remove-ADGroupMember -Identity "students_l2" -Members $user_name -Confirm:$FALSE
    Remove-ADGroupMember -Identity "students_l3" -Members $user_name -Confirm:$FALSE
    Remove-ADGroupMember -Identity "students_l4" -Members $user_name -Confirm:$FALSE
    Add-ADGroupMember "students_lhs" $user_name
    Add-ADGroupMember "GW_Students_Upper" $user_name
  }
  Write-Host "adding to Graduating Class Of group"
  Add-ADGroupMember $gcogroup $user_name
}
