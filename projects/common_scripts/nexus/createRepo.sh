#!/bin/bash
# Script to create docker hosted repository in nexus


URL='nexus.fuchicorp.com'
PASSWORD='admmin123'
USER='admin'
REPO_NAME='docker'
HTTP_PORT='8086'
HTTPS_PORT='8087'



BODY_DATA='{
  "name": "'${REPO_NAME}'",
  "online": true,
  "storage": {
    "blobStoreName": "default",
    "strictContentTypeValidation": true,
    "writePolicy": "allow_once"
  },
  "docker": {
    "v1Enabled": true,
    "forceBasicAuth": true,
    "httpPort": "'${HTTP_PORT}'",
    "httpsPort": "'${HTTPS_PORT}'"
  }
}'

STATUS_CODE=$(curl --request POST "https://${URL}/service/rest/beta/repositories/docker/hosted" \
-s -o /dev/null -w '%{http_code}' \
--header 'Content-Type: application/json' \
--user "${USER}:${PASSWORD}" \
--header 'Content-Type: text/plain' \
--data-raw "${BODY_DATA}")


if [[ "$STATUS_CODE" == '201' ]]; then
    echo "Repository <$REPO_NAME> has been created!!"

elif [[ "$STATUS_CODE" == '400'* ]]; then
    echo "The repository already exist!! <$REPO_NAME>"

else
    echo "Something went wrong please check nexus"
fi

