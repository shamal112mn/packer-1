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
HELM_HOME='/usr/local/bin'
if curl --version >/dev/null; then

  # Getting all available versions from github .
  foundHelmVersions=$(curl -s 'https://api.github.com/repos/helm/helm/releases'  | jq '.[].tag_name' | grep -Ev 'beta|alpha|rc'| sed 's/"//g')
  echo "$release"
  # If releases founded script will continue
  if [[ $foundHelmVersions ]]; then
    if wget --version > /dev/null; then
      if [[ "$OSTYPE" == "darwin"* ]]; then

        # If OS type is Apple then script will provide available versions
        echo -e  "$foundHelmVersions"
        if helm version --client > /dev/null; then
          INSTALLED_HELM=$(helm version --client  | awk '{print $2}' | cut -c 25-33 | sed 's/"//g')
          echo -e "${GREEN}Current version: ${INSTALLED_HELM}${RESET}"
        fi
        echo -e "${GREEN}Please sellect one version to download: ${RESET}"  && read SELLECTEDVERSION
        if [[ "$SELLECTEDVERSION" ]]; then
          echo -e "$(tput setaf 2)#--- Downloading the kubectl for this MAC. ---#"
          wget -q --show-progress --progress=bar:force  "https://get.helm.sh/helm-${SELLECTEDVERSION}-darwin-amd64.tar.gz" 2>&1

          # after user select existing kubectl version

          tar -xzvf "helm-${SELLECTEDVERSION}-darwin-amd64.tar.gz"
          mv "./darwin-amd64/helm" "$HELM_HOME/helm"
          rm -rf "helm-${SELLECTEDVERSION}-darwin-amd64.tar.gz"

          echo -e "${GREEN}#---    Moving kubectl to bin folder.      ---#${RESET}"
        else
          echo -e "${RED}#---    Error Kubectl versions is not selecrted.      ---#${RESET}"
        fi


      elif [[ "$OSTYPE" == "linux"* ]]; then

        WHEEL_ACCESS=$(groups $USER | grep -o "wheel")

        if [[ $WHEEL_ACCESS ]]; then
          # If OS type is Apple then script will provide available versions
          echo -e  "$foundHelmVersions"
          if helm version --client > /dev/null; then
            INSTALLED_HELM=$(helm version --client  | awk '{print $2}' | cut -c 25-33 | sed 's/"//g')
            echo -e "${GREEN}Current version: ${INSTALLED_HELM}${RESET}"
          fi
          echo -e "${GREEN}Please sellect one version to download: ${RESET}"  && read SELLECTEDVERSION
          if [[ "$SELLECTEDVERSION" ]]; then
            echo -e "$(tput setaf 2)#--- Downloading the kubectl for this MAC. ---#"
            wget -q --progress=bar:force  "https://get.helm.sh/helm-${SELLECTEDVERSION}-linux-amd64.tar.gz" 2>&1

            # after user select existing kubectl version

            tar -xzvf "helm-${SELLECTEDVERSION}-linux-amd64.tar.gz"
            sudo mv "./linux-amd64/helm" "$HELM_HOME/helm"
            sudo rm -rf "helm-${SELLECTEDVERSION}-linux-amd64.tar.gz"

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
