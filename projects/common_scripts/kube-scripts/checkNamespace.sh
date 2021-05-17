#!/usr/bin/env bash
NAMESPACE='awdawd'
if [[ $(kubectl get ns "$NAMESPACE" 2>/dev/null ) ]]; then
  echo 'Name space is exist'
else
  echo 'namespace is not exist'
fi


if [[ ! $(kubectl get ns "$NAMESPACE" 2>/dev/null ) ]]; then
  echo 'name space does not exist'
fi
