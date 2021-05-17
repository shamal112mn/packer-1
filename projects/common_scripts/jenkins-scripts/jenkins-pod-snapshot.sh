#!/bin/bash

## Color codes
green=$(tput setaf 2)
red=$(tput setaf 1)
reset=$(tput sgr0)

## If JENKINS_HOME environment variable exist will take backup to that location
if [[ -z "${JENKINS_HOME}" ]]; then
  JENKINS_HOME='./jenkins_home'
  echo "Taking backup to default folder ${JENKINS_HOME}"
else
  echo "Found environment variable <JENKINS_HOME> taking backup to <${JENKINS_HOME}>"
fi


## Creates jenkins_home folder under current directory if it doesn't exist.
if [ ! -d "$JENKINS_HOME" ]; then
  mkdir -p "$JENKINS_HOME"

  echo "${green}<$JENKINS_HOME)> directory is created${reset}"
fi


## Getting Jenkins pod name
JENKINS_POD_NAME="$(kubectl get pods -n tools | grep jenkins-deploy | awk '{print $1}')"

## Copies important folders from jenkins server to jenkins_home directory under ./
if [ "$1" = "--sync" ]; then
  kubectl cp tools/$JENKINS_POD_NAME:/var/jenkins_home/secrets $JENKINS_HOME/secrets  2 > /dev/null
  kubectl cp tools/$JENKINS_POD_NAME:/var/jenkins_home/secret.key $JENKINS_HOME/secret.key 2 > /dev/null
  kubectl cp tools/$JENKINS_POD_NAME:/var/jenkins_home/jobs $JENKINS_HOME/jobs 2 > /dev/null
  kubectl cp tools/$JENKINS_POD_NAME:/var/jenkins_home/credentials.xml $JENKINS_HOME/credentials.xml 2 > /dev/null
  kubectl cp tools/$JENKINS_POD_NAME:/var/jenkins_home/config.xml  $JENKINS_HOME/config.xml  2 > /dev/null

  echo "${green}Successfully copied necessary folders from jenkins server to jenkins_home <($JENKINS_HOME)> directory!${reset}" 
fi



## Copies folders under ./jenkins_home directory back to jenkins server
if [ "$1" = "--restore" ]; then
  kubectl cp $JENKINS_HOME/secrets tools/$JENKINS_POD_NAME:/var/jenkins_home 2 > /dev/null
  kubectl cp $JENKINS_HOME/secret.key tools/$JENKINS_POD_NAME:/var/jenkins_home 2 > /dev/null
  kubectl cp $JENKINS_HOME/jobs tools/$JENKINS_POD_NAME:/var/jenkins_home 2 > /dev/null
  kubectl cp $JENKINS_HOME/credentials.xml tools/$JENKINS_POD_NAME:/var/jenkins_home 2 > /dev/null
  kubectl cp $JENKINS_HOME/config.xml tools/$JENKINS_POD_NAME:/var/jenkins_home 2 > /dev/null

  echo "${green}Successfully copied jenkins folders from <($JENKINS_HOME)> directory back to jenkins server!${reset}"

      ## Output - ask to restart Jenkins_pod
  read -p ""${green}"Should I ${red}restart "${green}"the Jenkins? [Y/n]:${reset} " yes

         ## give 3 option to agree "yes", "y", "Y"
      if [[ $yes == yes ]] || [[ $yes == y ]] || [[ $yes == Y ]];
      then
          kubectl delete pod "$JENKINS_POD_NAME" -n tools
                 ## set Variable for new Jenkins_pod
          JENKINS_POD_NAME="$(kubectl get pods -n tools | grep jenkins-deploy | awk '{print $1}' )"
    
               ## wait for Jenkins_pod to be in STATE "Running"    
            until [ "$(kubectl get pod  $JENKINS_POD_NAME -n tools | awk '{print $2}' | tail -1)" == "1/1" ]
            do
                echo "Jenkins pod is restarting ..." && sleep 10
            done
                      if [ "$(kubectl get pod  $JENKINS_POD_NAME -n tools | awk '{print $2}' | tail -1)" == "1/1" ];
                      then 
                              echo "${green}Jenkins is restarted and ready to use!!!${reset}"
                      fi
      elif  [[ $yes == no ]] || [[ $yes == n ]] || [[ $yes == N ]];
      then  
          echo "Skipping deleting Jenkins."
      else
          echo "Misspelling, but anyway skipping deleting Jenkins"
      fi
fi

