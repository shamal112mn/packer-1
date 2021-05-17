#!/bin/bash

# Author <sadykovfarkhod@gmail.com>
# Script to download terraform and set up for the user.
# source ${PWD}/use-terraform.sh

# if [ "$0" = "$BASH_SOURCE" ]
# then
#     echo "$0: Please source this file."
#     echo "# source ${PWD}/use-terraform.sh"
#     exit 1
# fi

#Some collors for human friendly
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 2`
RESET=`tput sgr0`


# Change this if you would like to move your terraform home folder
TERRAFORM_HOME='/usr/local/bin'
if curl --version >/dev/null; then

  # Getting all available versions from hashicorp.
  release=$(curl --connect-timeout 3 -s -X GET "https://releases.hashicorp.com/terraform/")
  foundTerraformVersions=$(echo "$release" | awk -F '/' '{print $3}' | grep -v '\s' | grep -v '<\|alpha\|beta\|rc\|oci' |  sed  '/^$/d;' | head -n 30)
  echo "$release"
  echo "$foundTerraformVersions"
  # If releases founded script will continue
  if [[ $foundTerraformVersions ]]; then
    if wget --version > /dev/null; then
      if [[ "$OSTYPE" == "darwin"* ]]; then

        # If OS type is Apple then script will provide available versions
        echo -e  "$foundTerraformVersions"
        if terraform -version > /dev/null; then
          INSTALLED_TERRAFORM=$(terraform -version  | head -n1   | awk '{print $2}')
          echo -e "${GREEN}Current version: ${INSTALLED_TERRAFORM}${RESET}"
        fi
        echo -e "${GREEN}Please sellect one version to download: ${RESET}"  && read SELLECTEDVERSION
        if [[ "$SELLECTEDVERSION" ]]; then
          echo -e "$(tput setaf 2)#--- Downloading the terraform for this MAC. ---#"
          wget -q --show-progress --progress=bar:force  "https://releases.hashicorp.com/terraform/${SELLECTEDVERSION}/terraform_${SELLECTEDVERSION}_darwin_amd64.zip" 2>&1

          # after user select existing terraform version
          # script will extract the zip file and move terraform to executable place </usr/local/bin>
          echo -e "${GREEN}#---    Moving terraform to bin folder.      ---#${RESET}"
          unzip "terraform_${SELLECTEDVERSION}_darwin_amd64.zip" && /bin/mv "./terraform" "$TERRAFORM_HOME/terraform"
          /bin/rm -rf "terraform_${SELLECTEDVERSION}_darwin_amd64.zip"
        else
          echo -e "${RED}#---    Error Terraform versions is not selecrted.      ---#${RESET}"
        fi

      elif [[ "$OSTYPE" == "linux"* ]]; then

        WHEEL_ACCESS=$(groups $USER | grep -o "wheel")

        if [[ $WHEEL_ACCESS ]]; then

          # If OS type is Linux then script will provide available versions
          echo -e  "$foundTerraformVersions"
          if terraform -version > /dev/null; then
            INSTALLED_TERRAFORM=$(terraform -version  | head -n1 | awk '{print $2}')
            echo -e "${GREEN}Current version: ${INSTALLED_TERRAFORM}${RESET}"
          fi
          read -p "${GREEN}Please sellect one version to download: ${RESET}" SELLECTEDVERSION
          if [[ "$SELLECTEDVERSION" ]]; then
            echo -e "$(tput setaf 2)#--- Downloading the terraform for this linux. ---#"
            wget -q --progress=bar:force  "https://releases.hashicorp.com/terraform/${SELLECTEDVERSION}/terraform_${SELLECTEDVERSION}_linux_amd64.zip" 2>&1

            # after user select existing terraform version
            # script will extract the zip file and move terraform to executable place </usr/local/bin>


            echo -e "${GREEN}#---    Moving terraform to bin folder.      ---#${RESET}"
            unzip "terraform_${SELLECTEDVERSION}_linux_amd64.zip" && sudo mv "./terraform" "$TERRAFORM_HOME/terraform"
            rm -rf "terraform_${SELLECTEDVERSION}_linux_amd64.zip"
          else
            echo -e "${RED}#---    Error terraform versions is not selecrted.      ---#${RESET}"
          fi
        fi
      fi
    else
      echo -e "${RED}#---    Error wget command not found.      ---#${RESET}"
      exit 1
    fi
  else
    echo -e "${RED}#--- Error Terraform versions not found or connections issue. ---#${RESET}"
    exit 1
  fi

else
  echo -e "${RED}#--- Error curl command not found. ---#${RESET}"
  exit 1
fi
