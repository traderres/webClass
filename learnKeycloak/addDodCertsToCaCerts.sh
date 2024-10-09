#!/bin/bash
#######################################################
# Filename:  addDodCertsToCaCerts.sh
#######################################################
# Purpose:
#   Loop through the list of users in the system
#
# Usage:
#   unix> chmod u+x ./addDodCertsToCaCerts.sh
#   unix> ./addDodCertsToCaCerts.sh
#######################################################
declare -A listOfFileNames

export CACERTS_FILE_PATH=/home/adam/intellijProjects/custom-oidc-provider/src/main/dev-resources/cacerts
export CERTS_DIR=/home/adam/Downloads/certs


echo "Script started as of `date`"

# Get a list of file names
listOfFileNames=` ls -b ${CERTS_DIR}  `

declare -i index=100

OIFS="$IFS"
IFS=$'\n'

# Loop through the list, removing the role
for filepath in `find $CERTS_DIR -type f -print`; do

    echo -e "\tfilepath=${filepath}"

  
    index+=1
    echo -e "\tAttempting to add this file to cacerts:  ${filepath}   index=${index}"

    # Add this file to cacerts
    echo \e "\tkeytool -import -alias ca${index} -file \"$filepath\" -keystore ${CACERTS_FILE_PATH} -storepass changeit  -trustcacerts   -noprompt "
    keytool -import -alias ca${index} -file "$filepath" -keystore ${CACERTS_FILE_PATH} -storepass changeit  -trustcacerts   -noprompt 

    if [ $? -ne 0 ]; then
        # The last command had a problem.
        echo -e "\nkeytool import command failed for ${filepath}"

        # Exit with an error code
        exit 1
    fi
done

echo "Script finished as of `date`"

exit 0

