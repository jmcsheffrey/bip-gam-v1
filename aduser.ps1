########################################################################################################
# Purpose:  Just testing out ideas for BIP now.  Need to create user with info as parameters
#
# Arguments, all but grade required:
#   - cmd_type, choices: ADD, UPDATE
#   - unique_id
#   - population, choices: STUDENT|EMPLOYEE
#   - school_email
#   - first_name
#   - last_name
#   - description
#   - fileserver
#   - grade
#
# Example invocation:
#   testing_for_bip.ps1 -unique_id TST99999 -population EMPLOYEE -school_email "sstaff@sscps.org" -first_name "Sam" -last_name "Staff" -description "SSCPS Test ID" -fileserver ROWLEY
#
# REQUIRES:  subinacl tool must be installed on server you run this from
#            https://www.microsoft.com/en-us/download/details.aspx?id=23510
#            Then add the following to the server's PATH:
#            C:\Program Files (x86)\Windows Resource Kits\Tools\
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
$default_OU_employee = "OU=Standard (EMP)"
$default_OU_student_level1 = "OU=Level 1"
$default_OU_student_level2 = "OU=Level 2"
$default_OU_student_level3 = "OU=Level 3"
$default_OU_student_level4 = "OU=Level 4"
$default_OU_student_levelhs = "OU=Level HS"

###############################
#
# Building variables
#
###############################
# build full name
$full_name = $first_name + " " + $last_name
$secure_password = ConvertTo-SecureString $default_password -AsPlainText -Force
$user_object = Get-ADuser -Identity $user_name

# determine values depending on passed fileserver
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

# determine values depending on population
if ( $population -eq "EMPLOYEE" ) {
  $user_path = $fac_user_folder + $user_name + "\"
  $other_path = $fac_other_folder + $user_name + "\"
  $organizational_unit = $default_OU_employee + ",OU=Employees,OU=Prod,OU=SSCPS,DC=ad,DC=sscps,DC=org"
}
if ( $population -eq "STUDENT" ) {
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
# Fuction to create folders if needed
# Accepts UNC (e.g. \\GREG\c$\Storage\FacStaffUserFiles\jmcsheffrey\)
function check_user_folders($f) {
   $folders = "Documents","Downloads","Desktop","Movies","Music","Public","Pictures"
   Foreach ($folder in $folders) {
      if( ! ( Test-Path $f\$folder) ) {
         New-Item -path $f -name $folder -type directory
      }
   }
}

# Function to set up permissions on folder
# Accepts a UNC (e.g. \\GREG\c$\Storage\FacStaffUserFiles\jmcsheffrey\)
function process_permissions($f) {
   $u = $f | Split-Path -leaf
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
Write-Host "---------------------"
Write-Host "Passed Variables"
Write-Host "---------------------"
Write-Host "unique_id:           "$unique_id
Write-Host "population:          "$population
Write-Host "school_email:        "$school_email
Write-Host "user_name:           "$user_name
Write-Host "first_name:          "$first_name
Write-Host "last_name:           "$last_name
Write-Host "full_name:           "$full_name
Write-Host "description:         "$description
Write-Host "fileserver:          "$fileserver
Write-Host "grade:               "$grade
Write-Host "---------------------"
Write-Host "Internal Variables"
Write-Host "---------------------"
Write-Host "password:            "$default_password
Write-Host "enabled:             "$default_enabled
Write-Host "homedrive:           "$default_homedrive
Write-Host "user_path:           "$user_path
Write-Host "other_path:          "$other_path
Write-Host "organizational_unit: "$organizational_unit
Write-Host "user_object:         "$user_object

# create/update users
if ( $cmd_type -eq "ADD" ) {
  New-ADUser -Name $full_name -AccountPassword $secure_password -ChangePasswordAtLogon $change_password -Description $description -DisplayName $full_name -EmailAddress $school_email -EmployeeID $unique_id -Enabled $default_enabled -GivenName $first_name -HomeDirectory $user_path -HomeDrive $default_homedrive -Path $organizational_unit -SamAccountName $user_name -Surname $last_name -UserPrincipalName $school_email
} else {
  Set-ADUser -Identity $user_name -Description $description -DisplayName $full_name -EmailAddress $school_email -EmployeeID $unique_id -Enabled $default_enabled -GivenName $first_name -HomeDirectory $user_path -HomeDrive $default_homedrive -SamAccountName $user_name -Surname $last_name -UserPrincipalName $school_email
  Move-ADObject -Identity $user_object -TargetPath $organizational_unit
  Rename-ADObject -Identity $user_object -NewName $full_name
}

# create home folders & set permissions
#check_user_folders($user_path)
#process_permissions($user_path)
#process_permissions($other_path)




<# stuff below is generic stuff copied from script that fixes folders & permissions, kept for for loop stuff
# user not supplied, fix all folders for given fileserver
# subinacl /subdirectories type fails if trailing backslash is missing
# so it has been added in when array is built, or specified user above
if ( $population -eq "facstaff" ) {
   $user_folder_array = @(Get-ChildItem -Path $fac_user_folder | ?{ $_.PSIsContainer } | Foreach-Object {$_.FullName+"\"})
   $other_folder_array = @(Get-ChildItem -Path $fac_other_folder | ?{ $_.PSIsContainer } | Foreach-Object {$_.FullName+"\"})
}

if ( $population -eq "student" ) {
   $user_folder_array = @(Get-ChildItem -Path $stu_user_folder | ?{ $_.PSIsContainer } | Foreach-Object {$_.FullName+"\"})
   $other_folder_array = @(Get-ChildItem -Path $stu_other_folder | ?{ $_.PSIsContainer } | Foreach-Object {$_.FullName+"\"})
}

Foreach ($f in $user_folder_array) {
   check_user_folders($f)
   process_permissions($f)
}
Foreach ($f in $other_folder_array) {
   process_permissions($f)
}
#>
