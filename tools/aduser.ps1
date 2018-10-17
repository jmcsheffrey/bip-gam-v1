########################################################################################################
# Purpose:  Create, update or fix AD User & profile folders based on passed parameters
#
# Arguments, all but grade required:
#   - cmd_type; choices: ADD|UPDATE|ARCHIVE|FIX, anything only displays info
#   - unique_id
#   - population, choices: STU|EMP
#   - school_email
#   - first_name
#   - last_name
#   - description
#   - fileserver
#   - grade
#
# Example invocation:
#    .\aduser.ps1 -cmd_type "ADD" -unique_id "TST99999" -population "STU" -school_email "some_dude@student.sscps.org" -user_name "some_dude" -first_name "Some" -last_name "Dude" -description "SSCPS Test ID" -fileserver "ROWLEY" -grade "06"
#
# REQUIRES:  subinacl tool must be installed on server you run this from
#            https://www.microsoft.com/en-us/download/details.aspx?id=23510
#            Then add the following to the server's PATH:
#            C:\Program Files (x86)\Windows Resource Kits\Tools\
#
# TODO:
#   - add wrapper to check for valid cmd_type and population arguments
########################################################################################################

###############################
#
# arguments
#
###############################
param(
   [Parameter(Mandatory=$true)]
   [string]$cmd_type,
   [Parameter(Mandatory=$true)]
   [string]$unique_id,
   [Parameter(Mandatory=$true)]
   [string]$population,
   [Parameter(Mandatory=$true)]
   [string]$school_email,
   [Parameter(Mandatory=$true)]
   [string]$user_name,
   [Parameter(Mandatory=$true)]
   [string]$first_name,
   [Parameter(Mandatory=$true)]
   [string]$last_name,
   [Parameter(Mandatory=$true)]
   [string]$description,
   [Parameter(Mandatory=$true)]
   [string]$fileserver,
   [Parameter(Mandatory=$false)]
   [string]$grade
)

###############################
#
# "Static" variables
#
###############################
$change_password = $TRUE
$default_enabled = $TRUE
$default_password = "sscps123"
$default_homedrive = "h:"
$default_homepathshare_employee = "FacStaffUserFiles$\"
$default_homepathshare_student = "StudentUserFiles$\"
$default_OU_employee = "OU=Standard (EMP)"
$default_OU_student_level1 = "OU=Level 1"
$default_OU_student_level2 = "OU=Level 2"
$default_OU_student_level3 = "OU=Level 3"
$default_OU_student_level4 = "OU=Level 4"
$default_OU_student_levelhs = "OU=Level HS"
$default_OUPath_employee_archive = "OU=Employees,OU=Aging,OU=Archive,OU=SSCPS,DC=ad,DC=sscps,DC=org"
$default_OUPath_student_archive = "OU=Students,OU=Aging,OU=Archive,OU=SSCPS,DC=ad,DC=sscps,DC=org"
$logfile = "C:\TechTools\bin\bip\logs\aduser.log"

###############################
#
# Generated variables
#
###############################
# build full name
$full_name = $first_name + " " + $last_name
$secure_password = ConvertTo-SecureString $default_password -AsPlainText -Force
if ( $cmd_type -eq "ADD" ) {
  $user_object = "n/a, not updating user"
} else {
  $user_object = Get-ADuser -Identity $user_name
}

# determine paths for folder creation/permissions depending on passed fileserver
if ( $fileserver -eq "rowley" ) {
   $fac_user_folder = "\\ROWLEY\e$\Storage\FacStaffUserFiles\"
   $fac_other_folder = "\\ROWLEY\e$\Storage\FacStaffOtherFiles\"
   $stu_user_folder = "\\ROWLEY\e$\Storage\StudentUserFiles\"
   $stu_other_folder = "\\ROWLEY\e$\Storage\StudentOtherFiles\"
}
else {
   $fac_user_folder = "\\" + $fileserver + "\c$\Storage\FacStaffUserFiles\"
   $fac_other_folder = "\\" + $fileserver + "\c$\Storage\FacStaffOtherFiles\"
   $stu_user_folder = "\\" + $fileserver + "\c$\Storage\StudentUserFiles\"
   $stu_other_folder = "\\" + $fileserver + "\c$\Storage\StudentOtherFiles\"
}

# finish variables based on population
if ( $population -eq "EMP" ) {
  $homepath = "\\" + $fileserver + "\" + $default_homepathshare_employee + $user_name
  $user_path = $fac_user_folder + $user_name + "\"
  $other_path = $fac_other_folder + $user_name + "\"
  $organizational_unit = $default_OU_employee + ",OU=Employees,OU=Prod,OU=SSCPS,DC=ad,DC=sscps,DC=org"
}
if ( $population -eq "STU" ) {
  $homepath = "\\" + $fileserver + "\" + $default_homepathshare_student + $user_name
  $user_path = $stu_user_folder + $user_name + "\"
  $other_path = $stu_other_folder + $user_name + "\"
  if ( $grade -eq "0K" -Or $grade -eq "01" -Or $grade -eq "02" ) {
    $organizational_unit = $default_OU_student_level1 + ",OU=Students,OU=Prod,OU=SSCPS,DC=ad,DC=sscps,DC=org"
  } elseif ( $grade -eq "03" -Or $grade -eq "04" ) {
    $organizational_unit = $default_OU_student_level2 + ",OU=Students,OU=Prod,OU=SSCPS,DC=ad,DC=sscps,DC=org"
  } elseif ( $grade -eq "05" -Or $grade -eq "06" ) {
    $organizational_unit = $default_OU_student_level3 + ",OU=Students,OU=Prod,OU=SSCPS,DC=ad,DC=sscps,DC=org"
  } elseif ( $grade -eq "07" -Or $grade -eq "08" ) {
    $organizational_unit = $default_OU_student_level4 + ",OU=Students,OU=Prod,OU=SSCPS,DC=ad,DC=sscps,DC=org"
  } elseif ( $grade -eq "09" -Or $grade -eq "10" -Or $grade -eq "11" -Or $grade -eq "12" ) {
    $organizational_unit = $default_OU_student_levelhs + ",OU=Students,OU=Prod,OU=SSCPS,DC=ad,DC=sscps,DC=org"
  }
}

###############################
#
# functions used in MAIN
#
###############################

Function Log {
   Param ([string]$logstring)
   Add-content $Logfile -value $logstring
}

# Fuction to create folders if needed
# Accepts UNC (e.g. \\GREG\c$\Storage\FacStaffUserFiles\jmcsheffrey\)
function check_user_folders($f) {
   $folders = "Documents","Downloads","Desktop","Movies","Music","Public","Pictures"
   Foreach ($folder in $folders) {
      if( ! ( Test-Path $f\$folder) ) {
         New-Item -path $f -name $folder -type directory -force
      }
   }
}

# Function to set up permissions on folder
# Accepts a UNC (e.g. \\GREG\c$\Storage\FacStaffUserFiles\jmcsheffrey\)
function process_permissions($f) {
   $u = $f | Split-Path -leaf
   Log "process_permissions() f = $f"
   Log "process_permissions() u = $u"
   # subinacl /subdirectories does NOT modify the root folder of path given, so we have to do it manually
   subinacl /file $f /setowner=AD\Administrator
   # Set users content owner to AD\Administrator
   subinacl /subdirectories $f /setowner=AD\Administrator
   $grant_perms = $u + ":(OI)(CI)F"
   icacls $f /reset /t
   # Do not use /t with /grant - subfolders are handled by inheritence
   icacls $f /grant "$grant_perms"
   # Set the owner of the parent user folder back to user (e.g. jmcsheffrey)
   subinacl /file $f /setowner=$u
   # Now set the owner for all the users content back to user
   subinacl /subdirectories $f /setowner=$u
}

###############################
#
# "MAIN" body of script
#
###############################

# echo variables for varification when debugging
Log "---------------------"
Log "Passed Variables"
Log "---------------------"
Log "cmd_type:            "$cmd_type
Log "unique_id:           "$unique_id
Log "population:          "$population
Log "school_email:        "$school_email
Log "user_name:           "$user_name
Log "first_name:          "$first_name
Log "last_name:           "$last_name
Log "full_name:           "$full_name
Log "description:         "$description
Log "fileserver:          "$fileserver
Log "grade:               "$grade
Log "---------------------"
Log "Internal Variables"
Log "---------------------"
Log "password:            "$default_password
Log "enabled:             "$default_enabled
Log "homedrive:           "$default_homedrive
Log "homepath:            "$homepath
Log "user_path:           "$user_path
Log "other_path:          "$other_path
Log "organizational_unit: "$organizational_unit
Log "user_object:         "$user_object

# create/update users
if ( $cmd_type -eq "ADD" ) {
  # create active directory object
  Log "---------------------"
  Log "creating new AD User:  "$user_name
  Log "---------------------"
  New-ADUser -Name $full_name -AccountPassword $secure_password -ChangePasswordAtLogon $change_password -Description $description -DisplayName $full_name -EmailAddress $school_email -EmployeeID $unique_id -Enabled $default_enabled -GivenName $first_name -HomeDirectory $homepath -HomeDrive $default_homedrive -Path $organizational_unit -SamAccountName $user_name -Surname $last_name -UserPrincipalName $school_email
  # create home folders & set permissions
  Log "creating home folders for user:  "$user_name
  check_user_folders($user_path)
  process_permissions($user_path)
  if( ! ( Test-Path $other_path) ) {
    New-Item -path $other_path -type directory -force
  }
  process_permissions($other_path)
} elseif ( $cmd_type -eq "UPDATE" ) {
  # update active directory object
  Log "---------------------"
  Log "updating existing AD User:  "$user_name
  Log "---------------------"
  Set-ADUser -Identity $user_name -Description $description -DisplayName $full_name -EmailAddress $school_email -EmployeeID $unique_id -Enabled $default_enabled -GivenName $first_name -HomeDirectory $homepath -HomeDrive $default_homedrive -SamAccountName $user_name -Surname $last_name -UserPrincipalName $school_email
  Move-ADObject -Identity $user_object -TargetPath $organizational_unit
  Rename-ADObject -Identity $user_object -NewName $full_name
  # because powershell/ad is weird and I'm lazy - Rio
  $user_object = Get-ADuser -Identity $user_name
  # create home folders & set permissions
  Log "checking/updating/fixing permissions on home folders for user:  "$user_name
  check_user_folders($user_path)
  process_permissions($user_path)
  if( ! ( Test-Path $other_path) ) {
    New-Item -path $other_path -type directory -force
  }
  process_permissions($other_path)
} elseif ( $cmd_type -eq "ARCHIVE" ) {
  Log "Disabling user:  "$user_name
  Set-ADUser -Identity $user_name -Enabled $FALSE
  # not sure want to remove user from all groups because of sharing in Google Drive
  #Get-ADPrincipalGroupMembership -Identity $user_name| where {$_.Name -notlike "Domain Users"} |% {Remove-ADPrincipalGroupMembership -Identity $user_name -MemberOf $_ -Confirm:$FALSE}
  if ( $population -eq "EMP" ) {
    $message = "Moving user: "+ $user_name + " to OU:  " + $default_OUPath_employee_archive
    Log $message
    Move-ADObject -Identity $user_object -TargetPath $default_OUPath_employee_archive
  } elseif ( $population -eq "STU" ) {
    $message = "Moving user: "+ $user_name + " to OU:  " + $default_OUPath_student_archive
    Log $message
    Move-ADObject -Identity $user_object -TargetPath $default_OUPath_student_archive
  } else {
    Log "---------------------"
    Log "Invalid population during archive."
    Log "---------------------"
  }
} elseif ( $cmd_type -eq "FIX" ) {
  Log "FIX: user_name = $user_name"
  Log "FIX: user_object = $user_object"
  # We don't want to create folders if the AD user doesn't exist or is invalid
  if ( ! ($user_object) ) {
    Log "FIX: No or invalid AD object, aborting"
    Exit
  }
  Log "FIX: Fixing folders for $user_name"
  check_user_folders($user_path)
  process_permissions($user_path)
} else {
  # invalid cmd_type
  Log "---------------------"
  Log "Invalid command type."
  Log "---------------------"
}
