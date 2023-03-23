#!/bin/bash
################################################################################
# Filename:  bulkImportUsersIntoCitadel.sh
################################################################################
# Purpose:
#   Bulk import a list of users (by pulling info from a csv file)
#
# Design
#   1. Loop the lines of standard input
#      a. Get one line
#      b. Get the username (found in the 1st column)
#      c. Get a space-separated list of roles (in the 2nd column)
#      d. Construct the command to create the user
#      e. Execute the commands
#
# Usage:
#   A. ssh to the puppet master
#      unix> sudo -s
#      unix> chmod u+x ./bulkImportUsersIntoCitadel.sh               # Make the script executable
#      unix> dos2unix /path/to/csv/file                              # Remove the windows \r characters
#      unix> ./bulkImportUsersIntoCitadel.sh < /path/to/csv/file
################################################################################
# shellcheck disable=SC2120

readonly SCRIPT_NAME=$(basename $0)                   # Holds the name of this bash script

#######################################################
# main()
#
#######################################################
function main()
{
  # S C R I P T        S T A R T S       H E R E
  echo "${SCRIPT_NAME} started as of `date`"

  # Part 1:  Process the flie
  processCsvFile

  # S C R I P T         E N D S        H E R E
  echo -e "\n${SCRIPT_NAME} finished successfully as of `date`"
  exit 0
}


#######################################################
# Loop through the text in standard input
#   a. Get one line
#   b. Get the username (found in the 1st column)
#   c. Get a space-separated list of roles (in the 2nd column)
#   d. Construct the command to create the user
#   e. Execute the commands
#######################################################
function processCsvFile()
{
  echo -e "processCsvFile() started\n";
  local line;
  local username;
  local rolesAsString;
  local commandToCreateAccount;
  local commandToAddRoles;
  local roleName;

  # Loop through all of the lines from the files in standard input
  while read line
  do
    # Convert the $line string into an array
    if [ -z "$line" ]; then
        # The username is an empty string
        echo -e "\tWARNING:  csv line is empty.  Skipping to the next line"
        continue
    fi

    arr=(); while read -rd,|| [[ -n "$REPLY" ]]; do arr+=("$REPLY"); done <<<"$line"; declare -p arr;

     username=${arr[0]};
     rolesAsString=${arr[1]};
 
     if [ -z "$username" ]; then
        # The username is an empty string
        echo -e "\tWARNING:  username is empty....Skipping to next"
        continue
     fi

     # Convert the $rolesAsString string into an array of roles
     read -a roles <<< "$rolesAsString"; declare -p roles;

     # Loop through the role names to create the command to grant roles to this user
     commandToAddRoles="";

     for roleName in  ${roles[*]}; do
        commandToAddRoles="${commandToAddRoles} -a ROLE:${roleName} "
        echo -e "\tcommandToAddRoles=${commandToAddRoles}"
     done

     # Run the command to create the certificate
     certificates create --username ${username} -p bdppassword1
     if [ $? -ne 0 ]; then
        # The last command had a problem.
        echo -e "\nFailed to create the certificate for this user: ${username} "
        exit 1
     fi

     # Run the command to add the user to the system
     citadel user:add --username ${username} -a AUTH:U  -a AUTH:FOUO   -a AUTH:USA -a GROUP:USERS 
     if [ $? -ne 0 ]; then
        # The last command had a problem.
        echo -e "\nFailed to create the citadel account for this user: ${username} "
        exit 1
     fi

     # Run the command to assign attributes to this user
     citadel attribute:add --username ${username} ${commandToAddRoles}
     if [ $? -ne 0 ]; then
        # The last command had a problem.
        echo -e "\nFailed to add roles to this user:  ${username} "
        exit 1
     fi

     citadel attribute:add --username ${username}  -a AUTH:CTP

     if [ $? -ne 0 ]; then
        # The last command had a problem.
        echo -e "\nFailed to add the CTP authorizatoin for this user: ${username} "
        exit 1
     fi

     # Copy the p12 cert to the /tmp directory  (so it can be easily downloaded)
     cp /var/simp/environments/production/FakeCA/output/users/${username}/${username}.p12 /tmp

     if [ $? -ne 0 ]; then
        # The last command had a problem.
        echo -e "\nFailed to copy the p12 file to the /tmp directory for thi suser:  ${username}"
        exit 1
     fi

     chmod ugo+r /tmp/${username}.p12;

     if [ $? -ne 0 ]; then
        # The last command had a problem.
        echo -e "\nFailed to make this p12 file in the /tmp directory as readable to all:  ${username} "
        exit 1
     fi

     echo -e "Successfully created ${username}"


  done < "${1:-/dev/stdin}"

}


# Run the main() function
main
