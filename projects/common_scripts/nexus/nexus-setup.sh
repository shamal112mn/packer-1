#!/bin/bash

NEXUS_URL=$1
NEXUS_OLD_PWD=$2
NEXUS_NEW_PWD=$3

SCRIPT_NAME="pwd"

SCRIPT_JSON="$(cat << EOF
{
  "name": "${SCRIPT_NAME}",
  "type": "groovy",
  "content": "security.securitySystem.changePassword('admin', '${NEXUS_NEW_PWD}')"
}
EOF
)"

## Checking the nexus and waiting until its up 
if [ $(curl -X GET -s -o /dev/null -w "%{http_code}" -u admin:${NEXUS_OLD_PWD} ${NEXUS_URL}) == 200 ]; then
  echo "> Nexus us up and running"
else
  while true;
  do 
    echo "> waiting for nexus server..."
    sleep 4
  done
fi 

# echo "> creating the repository"
# REPO_CHECK=`curl -L -X POST -o /dev/null -w "%{http_code}" ${NEXUS_URL}/service/rest/beta/repositories/docker/hosted \
# -H 'Content-Type: application/json' -H 'Content-Type: text/plain' -u admin:${NEXUS_OLD_PWD} \
# --data '{"name": "fuchicorp","online": true,"storage": {"blobStoreName": "default","strictContentTypeValidation": true,"writePolicy": "allow"},"cleanup": {"policyNames": ["cleanup"]},"docker": {"v1Enabled": true,"forceBasicAuth": true,"httpPort": 8085}}'`

# if [ "${REPO_CHECK}" == "201" ];then
#   echo "> succeed! repository is created. "
# else
#   echo "> failed to create the repository, error code ${REPO_CHECK}"
# fi


CHECK_SCRIPT_STATUS=`curl  -s -o /dev/null -I -w "%{http_code}" -u "admin:${NEXUS_OLD_PWD}" "${NEXUS_URL}/service/rest/v1/script/${SCRIPT_NAME}"`


if [ "${CHECK_SCRIPT_STATUS}" == "404" ];then
  echo "> ${SCRIPT_NAME} is not found (${CHECK_SCRIPT_STATUS})"
  echo "> creating script... (${SCRIPT_NAME}) ..."
  curl -H "Accept: application/json" -H "Content-Type: application/json" -d "${SCRIPT_JSON}" -u "admin:${NEXUS_OLD_PWD}" "${NEXUS_URL}/service/rest/v1/script/"
elif [ "${CHECK_SCRIPT_STATUS}" == "200" ];then
  echo "> ${SCRIPT_NAME} is found (${CHECK_SCRIPT_STATUS})"
  echo "> updating script (${SCRIPT_NAME}) ..."
  curl -X PUT -H "Accept: application/json" -H "Content-Type: application/json" -d "${SCRIPT_JSON}" -u "admin:${NEXUS_OLD_PWD}" "${NEXUS_URL}/service/rest/v1/script/${SCRIPT_NAME}"
else
  echo "> unauthorized! (${CHECK_SCRIPT_STATUS})"
fi


echo "> changing password ..."
CHECK_RUN_STATUS=`curl -X POST -s -o /dev/null -w "%{http_code}" -H "Content-Type: text/plain" -u "admin:${NEXUS_OLD_PWD}" "${NEXUS_URL}/service/rest/v1/script/${SCRIPT_NAME}/run"`

if [ "${CHECK_RUN_STATUS}" == "200" ];then
  echo "> succeeded!"
else
  echo "> failed! (${CHECK_RUN_STATUS})"
fi



