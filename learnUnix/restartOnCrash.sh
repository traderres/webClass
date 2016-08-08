#! /bin/bash
############################################################################
# Filename:  restartOnCrash.sh
# Author:    <author>
############################################################################
#
# Purpose:
#   To automatically attempt to restart services if they fail
#
# Design:
#   For each service
#     a) Get the name of the service 
#     b) Get the running-status message regular expression
#     c) Get the status of the servic
#     d) If the service is not running
#          Get the number of restarts performed in the last 30 minutes
#          If the number of restarts < 3
#             Attempt to restart
#             Record the restart attempt in a log file
#             If restart succeeds, send an email saying so
#             If restart fails, send an email saying restart failed
#
# key=serviceName value=running string
#
# Usage:
#   1) chmod ugo+x ./restartOnCrash.sh
#   2) crontab -e
#          # Add an entry in the crontab to run this program once every 20 minutes
#          
# 
# Create Date:  8/1/2016
############################################################################


#-------------------------------------------------------------------------
# shouldRestartBeAttempted()
#   Pass-in a service name and determine if a restart should be attempted
#
# Returns an exit code==1 to mean attempt-a-restart
# Returns an exit code==0 to mean do not attempt restart
#-------------------------------------------------------------------------
function shouldRestartBeAttempted 
{
  local sServiceName=$1
  local attemptServiceRestart=0
  echo "shouldRestartBeAttempted()  sServiceName=$sServiceName  attemptServiceRestart=$attemptServiceRestart"

  if [ -e $statsFilePath ]; then
	# The stats file exists

	# Look at the stats file to see if there have been too many failed restarts 
	local currentTimeInSecs=`date +"%s"`
  
	# Find all records for this service name that are greater than currentTimeInSecs - 3600
	local startTime=`expr $currentTimeInSecs - $totalFailedRetriesInterval`


	# Get a count of the total number of failed attempts over the last hour
	local awk_command=$(printf '{if (($4 == "%s") && ($1 >= %s)) { print $0 }}'  "$sServiceName" "$startTime")

	local totalFailureCountInLastHour=`awk '$awk_command' $statsFilePath | grep failed | wc -l`
	echo -e "\ttotalFailureCountInLastHour=$totalFailureCountInLastHour"

	if [ $totalFailureCountInLastHour -lt $totalFailedRetriesAllowed ]; then
		# I counted less than 3 failed attempts in the last hour.  So, attempt to restart the service
  		attemptServiceRestart=1
	fi
  else
	# The stats file does not exist
	# So, Return 1 to indicate that a restart should be attempted
  	attemptServiceRestart=1
  fi


  # This method returns an exit code holding 2 possible values:
  # -- A returned exit code of 1 means that we should attempt a restart
  # -- A returned exit code of 0 means that we should not attempt any more restarts
  echo -e "\tattemptServiceRestart=$attemptServiceRestart"
  return $attemptServiceRestart
}


# S C R I P T        S T A R T S         H E R E
scriptName=`basename $0`
echo "${scriptName} started as of `date`"

statsFilePath=/tmp/restartOnCrashStats.txt
totalFailedRetriesAllowed=3       # Try to restart it 3 times
totalFailedRetriesInterval=3600   # Try to restart it 3 times within an hour


# Initialize an associative array to hold key=service_name  value="status string holding UP"
declare -A services
services["postgres"]='postgres.* is running'
services["ntpd"]='ntpd.* is running'


# Loop through all of the keys (holding the serivce name) in the assoc array
for serviceName in "${!services[@]}"; do 
	serviceUpMesg=${services[$serviceName]};
	echo -e "\nVerifying ${serviceName} is running...."; 
	service $serviceName status | grep -E "$serviceUpMesg" > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		# This service is not running
   		echo "$serviceName is *NOT* running"

		# Have 3 restarts been attempted in the last hour?
		shouldRestartBeAttempted $serviceName 
                attemptRestart=$?

		if [ $attemptRestart -eq 1 ]; then
		 
			# A T T E M P T       T O    S T A R T    S E R V I C E
			service $serviceName start

			# Verify that the service is now up
			service $serviceName status | grep -E "$serviceUpMesg" > /dev/null 2>&1
			if [ $? -ne 0 ]; then
				# Service *failed* to restart.  So, add an entry to the stats file
				date +"%s %Y%m%d %H:%M:%S $serviceName failed to restart" >> $statsFilePath

			else
				# Service succesfully restarted.  So, add an entry to the stats file
				date +"%s %Y%m%d %H:%M:%S $serviceName successfully restarted" >> $statsFilePath
			fi
		else
			# Do not attempt to start the service
			echo "I will not restart $serviceName:  I have tried to restart this service too many times and failed.  Giving up on it."
		fi
	else
		# This service is running
   		echo "$serviceName is running.  Nothing to do."
	fi
done


echo "${scriptName} finished as of `date`"
exit 0

