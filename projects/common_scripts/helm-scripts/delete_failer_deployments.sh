#!/usr/bin/env bash

deploymentName="us-mte01-us-menu-wsmqconsumer"
if [[ $(helm get "$deploymentName" --tiller-namespace "tiller" 2>/dev/null ) && $(helm  ls --tiller-namespace tiller "$deploymentName" | grep -i failed)  ]]; then
      echo 'Failed deployment found'
else
      echo 'Deployment does not exist '
fi
