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
KOPS_HOME='/usr/local/bin'
if curl --version >/dev/null; then

  # Getting all available versions from github .
  foundHelmVersions=$(curl -s 'https://api.github.com/repos/kubernetes/kops/releases'  | jq '.[].tag_name' | grep -Ev 'beta|alpha|rc'| sed 's/"//g')
  echo "$release"
  # If releases founded script will continue
  if [[ $foundHelmVersions ]]; then
    if wget --version > /dev/null; then
      if [[ "$OSTYPE" == "darwin"* ]]; then

        # If OS type is Apple then script will provide available versions
        echo -e  "$foundHelmVersions"
        if kops version  > /dev/null; then
          INSTALLED_KOPS=$(kops version | awk '{print $2}')
          echo -e "${GREEN}Current version: ${INSTALLED_KOPS}${RESET}"
        fi
        echo -e "${GREEN}Please sellect one version to download: ${RESET}"  && read SELLECTEDVERSION
        if [[ "$SELLECTEDVERSION" ]]; then
          echo -e "$(tput setaf 2)#--- Downloading the kops for this $OSTYPE. ---#"
          wget -q --show-progress --progress=bar:force  "https://github.com/kubernetes/kops/releases/download/${SELLECTEDVERSION}/kops-darwin-amd64" -O "./kops" 2>&1

          # after user select existing kubectl version
          mv "./kops" "$KOPS_HOME/kops" && chmod +x "$KOPS_HOME/kops"


          echo -e "${GREEN}#---    Moving kubectl to bin folder.      ---#${RESET}"
        else
          echo -e "${RED}#---    Error Kubectl versions is not selecrted.      ---#${RESET}"
        fi


      elif [[ "$OSTYPE" == "linux"* ]]; then
        WHEEL_ACCESS=$(groups $USER | grep -o "wheel")

        if [[ $WHEEL_ACCESS ]]; then
          # If OS type is Apple then script will provide available versions
          echo -e  "$foundHelmVersions"
          if kops version  > /dev/null; then
            INSTALLED_KOPS=$(kops version | awk '{print $2}')
            echo -e "${GREEN}Current version: ${INSTALLED_KOPS}${RESET}"
          fi
          echo -e "${GREEN}Please sellect one version to download: ${RESET}"  && read SELLECTEDVERSION
          if [[ "$SELLECTEDVERSION" ]]; then
            echo -e "$(tput setaf 2)#--- Downloading the kops for this $OSTYPE. ---#"
            wget -q --progress=bar:force  "https://github.com/kubernetes/kops/releases/download/${SELLECTEDVERSION}/kops-linux-amd64" -O "./kops" 2>&1
            # after user select existing kubectl version
            sudo mv "./kops" "$KOPS_HOME/kops" && sudo chmod +x "$KOPS_HOME/kops"


            echo -e "${GREEN}#---    Moving kubectl to bin folder.      ---#${RESET}"
          else
            echo -e "${RED}#---    Error Kubectl versions is not selecrted.      ---#${RESET}"
          fi
        fi
      else
        echo "Sorry this script does not support $OSTYPE"
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
