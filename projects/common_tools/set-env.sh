#!/bin/bash

## Color codes
green="\033[0;32m"
red="\033[0;31m"
reset="\033[0m"

DIR=$(pwd)
DATAFILE="$DIR/$1"
#
# FuchiCorp common script to set up Google terraform environment variables
# these all variables should be created on your config file before you run script.
# <ENVIRONMENT> <BUCKET> <DEPLOYMENT> <PROJECT> <CREDENTIALS>

if [ ! -f "$DATAFILE" ]; then
  echo -e "setenv: Configuration file not found: $DATAFILE"
  return 1
fi
BUCKET=$(sed -nr 's/^google_bucket_name\s*=\s*"([^"]*)".*$/\1/p'             "$DATAFILE")
PROJECT=$(sed -nr 's/^google_project_id\s*=\s*"([^"]*)".*$/\1/p'             "$DATAFILE")
ENVIRONMENT=$(sed -nr 's/^deployment_environment\s*=\s*"([^"]*)".*$/\1/p'    "$DATAFILE")
DEPLOYMENT=$(sed -nr 's/^deployment_name\s*=\s*"([^"]*)".*$/\1/p'            "$DATAFILE")
CREDENTIALS=$(sed -nr 's/^credentials\s*=\s*"([^"]*)".*$/\1/p'               "$DATAFILE") 

if [ -z "$ENVIRONMENT" ]
then
    echo -e "setenv: 'deployment_environment' variable not set in configuration file."
    return 1
fi

if [ -z "$BUCKET" ]
then
  echo -e "setenv: 'google_bucket_name' variable not set in configuration file."
  return 1
fi

if [ -z "$PROJECT" ]
then
    echo -e "setenv: 'google_project_id' variable not set in configuration file."
    return 1
fi

if [ -z "$CREDENTIALS" ]
then
    echo -e "setenv: 'credentials' file not set in configuration file."
    return 1
fi

if [ -z "$DEPLOYMENT" ]
then
    echo -e "setenv: 'deployment_name' variable not set in configuration file."
    return 1
fi

cat << EOF > "$DIR/backend.tf"
terraform {
  backend "gcs" {
    bucket  = "${BUCKET}"
    prefix  = "${ENVIRONMENT}/${DEPLOYMENT}"
    project = "${PROJECT}"
  }
}
EOF
cat "$DIR/backend.tf"

GOOGLE_APPLICATION_CREDENTIALS="${DIR}/${CREDENTIALS}"
export GOOGLE_APPLICATION_CREDENTIALS
export DATAFILE
/bin/rm -rf "$DIR/.terraform" 2>/dev/null
/bin/rm -rf "$PWD/common_configuration.tfvars" 2>/dev/null

if [[ $HOSTNAME != *"jenkins"* ]]; then  
  # Checking for updates and merges in remote branch
  echo -e "${green}Checking your branch for merges/updates${reset}"
  git remote update &> /dev/null
  BRANCH=$(git branch | grep '*' | awk '{print $2}') 
  git status -uno | grep -i "Your branch is behind 'origin/${BRANCH}'"  &> /dev/null

  if [ $? -eq 0 ]; then
    read -p "${red}There has been changes in ${BRANCH} barnch do you want to git pull: ${reset}" yes
    if [[ $yes == yes ]] || [[ $yes == y ]] || [[ $yes == Y ]]; then
      git pull
      echo -e "${green}Your local branch is up to date with remote ${BRANCH} now${reset}"
    else
      echo -e "${red}Skipping git pull, your local branch is not up to date with remote ${BRANCH} branch${reset}"
    fi
  elif [ $? -eq 1 ]; then
    echo -e "${green}You branch is up to date'${reset}"
  fi
fi 

echo -e "${green} Checking for common_tools_config secret update ${reset}"

echo -e "setenv: Initializing terraform"
terraform init #> /dev/null

if kubectl get pods &> /dev/null; then
  kubectl get secret common-tools-config -n tools &> /dev/null
  if [ $? -eq 0 ]; then
    echo -e "${green} Updated <common-tools-config> to newer version ${reset}"
    terraform apply -var-file=common_tools.tfvars  -target=kubernetes_secret.common_tools_config -auto-approve  &> /dev/null
  fi
else
  echo -e "${red}Cluster is not up and running skipping update <common-tools-config> update ${reset}"
fi

