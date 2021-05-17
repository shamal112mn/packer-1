#!/usr/bin/env bash


POD_ID="$(kubectl get pod -n prod  | grep webplatform-deployment | tail -n1 | awk '{print $1}')"

kubectl exec -ti -n prod $POD_ID  -- bash -c "python  " 
