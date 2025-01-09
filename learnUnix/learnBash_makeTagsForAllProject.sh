#!/bin/bash
#######################################################
# Filename:  makeTagsForAllProject.sh
#######################################################
# Purpose:
#   Provide a way to destroy and re-create tags of the default branch on all projects
#
# Usage:
#   1) Set the IL4_USERID, IL4_TOKEN, IL5_USERID, and IL5_TOKEN
#   2) unix> chomd u+x ./makeTagsForAllProject.sh
#   3) unix> ./makeTagsForAllProject.sh  --tag-name="sprint-2.5"  --overwrite-tags=Y
#
#
# Assumptions:
#   1) Your environment has these variables set
#         IL4_USERID
#         IL4_TOKEN
#         IL5_USERID
#         IL5_TOKEN
#######################################################
TAG_NAME=""
OVERWRITE_EXISTING_TAGS=""

readonly SCRIPT_NAME=`basename $0`                   # Holds the name of this bash script
readonly SCRIPT_ARGS="$@"                            # Holds the command line arguments
readonly TMP_DIR="$PWD/temp_tags"


#######################################################
# main()
#
#######################################################
function main()
{
  # S C R I P T        S T A R T S       H E R E
  echo "${SCRIPT_NAME} started as of `date`"

  # Part 1:  Parse Command Line Arguments
  parseCommandLineArguments

  # Part 2:  Make the tags
  makeTags

  # S C R I P T         E N D S        H E R E
  echo -e "\n${SCRIPT_NAME} finished successfully as of `date`"
  exit 0
}



#######################################################
# cleanup()
#
# This method is always called before the script ends
#######################################################
function cleanup() 
{
  	# Clean-up the tmp file
	if  [ -d "$TMP_DIR" ]; then
	  echo -e "\nRemoving this directory: $TMP_DIR"
	  cd "$TMP_DIR"
	  cd ..
	  rm -rf "$TMP_DIR"
    fi
}



function makeTags()
{

	# Create the directory

	rm -rf "$TMP_DIR"
	mkdir -p "$TMP_DIR"
	cd "$TMP_DIR"


	declare -a projectNamesInIl5=("refresh-cage-code-service" "core-account-watcher-service" "fortis-ai" "core-library"  "foci-library" "core-sync-service" "foci-sync-service" "core-welcome-webapp" "core-admin-webapp" "core-govt-registration-webapp" "core-industry-registration-webapp" "foci-webapp") 

	for projectName in "${projectNamesInIl5[@]}"; do
		echo -e "\nBuilding a tag for ${projectName}"
		git clone https://${IL5_USERID}:${IL5_TOKEN}@code.il5.dso.mil/platform-one/products/DCSA/ni2/${projectName}.git
		cd ${projectName}

		if   [[ "$OVERWRITE_EXISTING_TAGS" == "Y" ]]; then
			# Delete the local tag
			git tag -d "${TAG_NAME}"

		 	# Destroy existing tags
		 	git push --delete origin "${TAG_NAME}"
		fi  


		# Build the tag
		git tag -a "${TAG_NAME}"   -m "This is the ${TAG_NAME} build created on `date +"%m/%d/%Y"`"
	
		# Push the tag
		git push origin ${TAG_NAME}

		cd ..
	done


	# Build a tag for the one project in IL4:  sit-webapp
	projectName="sit-webapp"
	echo -e "\nBuilding a tag for ${projectName}"
	git clone https://${IL4_USERID}:${IL4_TOKEN}@code.il4.dso.mil/platform-one/products/dcsa/sit/${projectName}.git
	cd ${projectName}

	if   [[ "$OVERWRITE_EXISTING_TAGS" == "Y" ]]; then
		# Delete the local tag
		git tag -d "${TAG_NAME}"

	 	# Destroy existing tags
	 	git push --delete origin "${TAG_NAME}"
	fi  


	# Build the tag
	git tag -a "${TAG_NAME}"   -m "This is the ${TAG_NAME} build created on `date +"%m/%d/%Y"`"

	# Push the tag
	git push origin ${TAG_NAME}
	cd ..
}


#######################################################
# displayUsage()
# -- Display the usage statement
#######################################################
function displayUsage()
{
  # Display a multi-line-string with the usage statement
  cat << EOF

   ${SCRIPT_NAME}  --tag-name="name-of-new-tag"  --overwrite-tags=Y

   Assumptions:
      Your environment has these 4 variables set
           IL4_USERID
           IL4_TOKEN
           IL5_USERID
           IL5_TOKEN 

EOF
}



#######################################################
# parseCommandLineArguments()
#
# Examine the command line arguments
# Verify that the command line arguments are valid
# If valid, set the global vars
#######################################################
function parseCommandLineArguments()
{

  # Parse Command Line Arguments
  for arg in ${SCRIPT_ARGS[*]}; do
    case $arg in
        --tag-name=*)        TAG_NAME="${arg#*=}"; shift 1;;
        --overwrite-tags=*)  OVERWRITE_EXISTING_TAGS="${arg#*=}"; shift 1;;
    esac
  done

 
  if [[ -z "$TAG_NAME" ]]; then
     # The user did not pass-in --tag-name
     displayUsage
     echo "The --tag-name value was not set"
     exit 1
   elif   [[ -z "$OVERWRITE_EXISTING_TAGS" ]]; then
     # The user did not pass-in --overwrite-tags
     displayUsage
     echo "The --overwrite-tags value must be set to either N or Y"
     exit 1
  fi  

  echo -e "Command line arguments were successfully parsed:"
  echo -e "\tTAG_NAME=${TAG_NAME}"
  echo -e "\tOVERWRITE_EXISTING_TAGS=${OVERWRITE_EXISTING_TAGS}"
}



# Tell bash to call cleanup() when the program ends
# NOTE:  Whether the program crashes or succeeds, this method is the last method called
trap cleanup EXIT


# Run the main() function
main



