#!/bin/bash

# Author <sadykovfarkhod@gmail.com>
# Script to download kubectl and set up for the user.
# source ${PWD}/use-kubectl.sh

# if [ "$0" = "$BASH_SOURCE" ]
# then
#     echo "$0: Please source this file."
#     echo "# source ${PWD}/use-kubectl.sh"
#     exit 1
# fi

#Some collors for human friendly
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 2`
RESET=`tput sgr0`



# Change this if you would like to move your kubectl home folder
KUBECTL_HOME='/usr/local/bin'
if curl --version >/dev/null; then

  # Getting all available versions from github .
  foundKubectlVersions=$(curl -s 'https://api.github.com/repos/kubernetes/kubernetes/releases'  | jq '.[].tag_name' | grep -Ev 'beta|alpha|rc'|  sed 's/"//g')
  echo "$release"
  # If releases founded script will continue
  if [[ $foundKubectlVersions ]]; then
    if wget --version > /dev/null; then
      if [[ "$OSTYPE" == "darwin"* ]]; then

        # If OS type is Apple then script will provide available versions
        echo -e  "$foundKubectlVersions"
        if kubectl version > /dev/null; then
          INSTALLED_KUBECTL=$(kubectl version  --client  | awk '{print $5}' | sed -nr 's/^GitVersion\s*:\s*"([^"]*)".*$/\1/p')
          echo -e "${GREEN}Current version: ${INSTALLED_KUBECTL}${RESET}"
        fi
        echo -e "${GREEN}Please sellect one version to download: ${RESET}"  && read SELLECTEDVERSION
        if [[ "$SELLECTEDVERSION" ]]; then
          echo -e "$(tput setaf 2)#--- Downloading the kubectl for this MAC. ---#"
          wget -q --show-progress --progress=bar:force  "https://storage.googleapis.com/kubernetes-release/release/${SELLECTEDVERSION}/bin/darwin/amd64/kubectl" 2>&1

          # after user select existing kubectl version

          chmod +x kubectl
          mv kubectl "${KUBECTL_HOME}/kubectl"

          echo -e "${GREEN}#---    Moving kubectl to bin folder.      ---#${RESET}"
        else
          echo -e "${RED}#---    Error Kubectl versions is not selecrted.      ---#${RESET}"
        fi


      elif [[ "$OSTYPE" == "linux"* ]]; then
        WHEEL_ACCESS=$(groups $USER | grep -o "wheel")

        if [[ $WHEEL_ACCESS ]]; then
          # If OS type is Linux then script will provide available versions
          echo -e  "$foundKubectlVersions"
          if kubectl version > /dev/null; then
            INSTALLED_KUBECTL=$(kubectl version  --client  | awk '{print $5}' | sed -nr 's/^GitVersion\s*:\s*"([^"]*)".*$/\1/p')
            echo -e "${GREEN}Current version: ${INSTALLED_KUBECTL}${RESET}"
          fi
          read -p "${GREEN}Please sellect one version to download: ${RESET}" SELLECTEDVERSION
          if [[ "$SELLECTEDVERSION" ]]; then
            echo -e "$(tput setaf 2)#--- Downloading the kubectl for this linux. ---#"
            wget -q --progress=bar:force  "https://storage.googleapis.com/kubernetes-release/release/${SELLECTEDVERSION}/bin/linux/amd64/kubectl" 2>&1

            # after user select existing kubectl version
            # script will extract the zip file and move kubectl to executable place </usr/local/bin>
            sudo chmod +x kubectl
            sudo mv kubectl "${KUBECTL_HOME}/kubectl"

            echo -e "${GREEN}#---    Moving kubectl to bin folder.      ---#${RESET}"
          else
            echo -e "${RED}#---    Error Kubectl versions is not selecrted.      ---#${RESET}"
          fi
        fi
      fi
    else
      echo -e "${RED}#---    Error wget command not found.      ---#${RESET}"
      exit 1
    fi
  else
    echo -e "${RED}#--- Error Kubectl versions not found or connections issue. ---#${RESET}"
    exit 1
  fi

else
  echo -e "${RED}#--- Error curl command not found. ---#${RESET}"
  exit 1
fi
