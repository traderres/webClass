#!/bin/bash
#######################################################
# Filename:  backupMusic.sh
# Author:    Adam
#######################################################
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
# NOTE: 
#   --transfers 50 means to transfer 50 files in parallel
#######################################################

readonly SCRIPT_NAME=`basename $0`                   # Holds the name of this bash script


function main()
{
  # Sync the source and destination so that they are *identical*
  # NOTE:  For a list of options, go to https://rclone.org/flags/ 
  rclone sync --verbose --transfers 50 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s  "/mnt/windows/iTunes" "google-drive:/backup/iTunes"


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

