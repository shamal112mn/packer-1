#!/usr/bin/env bash
deploymentName="$1"
deploymentImage="$2"

helm upgrade -i $deploymentName $deploymentImage 
if [[ $(helm ls $deploymentName | grep -ic failed) = 1 ]] ; then
      echo 'UPGRADE FAILED ROLLING BACK TO PREVIOUS REVISION'
      revision=$(helm history $deploymentName | tail -1 | awk '{print $1 -1}')    
      helm rollback $deploymentName $revision  
      echo ROLLED BACK TO REVISION $revision
else
      echo 'Deployment succesfully finished'
fi

