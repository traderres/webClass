#!/bin/bash
#######################################################
# Filename:  addDodCertsToCaCerts.sh
#######################################################
# Purpose:
#   Loop through the list of certs and add them to a destination cacerts (or trust) file
#
# Usage:
#   unix> chmod u+x ./addDodCertsToCaCerts.sh
#   unix> ./addDodCertsToCaCerts.sh
#######################################################
export CACERTS_FILE_PATH=/tmp/cacerts
export CERTS_DIR=/home/adam/Downloads/certs


if [ ! -f $CACERTS_FILE_PATH ]; then
   # The destination cacerts file does not exist.  So, provide procedure on how to create an empty one.
   echo -e "\nThe CACERTS_FILE_PATH does NOT exist:   $CACERTS_FILE_PATH"
   echo -e "\nRun these commands to create an empty cacerts file:"
   echo -e "\tkeytool -genkeypair -alias boguscert -storepass changeit -keypass changeit -keystore $CACERTS_FILE_PATH -keysize 4096 -keyalg RSA  -dname 'CN=Developer, OU=Department, O=Company, L=City, ST=State, C=CA' "
   echo -e "\tkeytool -delete -alias boguscert -storepass changeit -keystore $CACERTS_FILE_PATH"
   exit 1
fi


echo "Script started as of `date`"


# Start the index with 100
declare -i index=100

IFS=$'\n'

# Loop through the files  (this will work with filenames that have spaces)
for filepath in `find $CERTS_DIR -type f -print`; do

    index+=1
    echo -e "\n\tAttempting to add this file to cacerts:  ${filepath}   index=${index}"

    # Add this file to cacerts
    echo -e "\tkeytool -import -alias ca${index} -file \"$filepath\" -keystore ${CACERTS_FILE_PATH} -storepass changeit  -trustcacerts   -noprompt "
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
