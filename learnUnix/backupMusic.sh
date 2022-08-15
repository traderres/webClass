#!/bin/bash
######################################################################################################
# Filename:  backupMusic.sh
# Author:    Adam
######################################################################################################
# Purpose:   To backup files to my google drive
#
# Usage:  
#  1. Start the backup
#     unix> chmod u+x ./backupMusic.sh
#     unix> ./backupMusic.sh > backupMusic.log 2>&1  &
#
#  2. Watch the log file:
#     unix> tail -f backupMusic.log
#
# Assumptions:
#  A. The rclone config file (found in ~/.config/rclone/rclone.conf) holds something like this:
#      [google-drive]
#      type = drive
#      client_id = client_id_is_here
#      client_secret = client_secret_is_here
#      scope = drive
#      token = {"access_token":"really-long-token-is-here","token_type":"Bearer","refresh_token":"1//another-really-long-string-here","expiry":"2022-08-14T23:45:34.520070061-04:00"}
#      root_folder_id = root_folder_id
#
# NOTE:
#   --transfers 10 means to transfer 10 files in parallel  (if you go too high then google complains)
######################################################################################################

readonly SCRIPT_NAME=`basename $0`                   # Holds the name of this bash script


function main()
{
  # Sync the source and destination so that they are *identical*
  # NOTE:  For a list of options, go to https://rclone.org/flags/ 
  rclone sync --verbose --transfers 10 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s  "/mnt/windows/iTunes" "google-drive:/backup/iTunes"


  if [ $? -ne 0 ]; then
    # The rclone had a problem
    echo -e "\tCritical Error:  The rclone command did not finish successfully\n"
    exit 1
  fi
}


echo "${SCRIPT_NAME} started as of `date`"

# Run the main method (and show the actual running time)
time main

# Script finishd successfully
echo "${SCRIPT_NAME} finished as of `date`"

exit 0

