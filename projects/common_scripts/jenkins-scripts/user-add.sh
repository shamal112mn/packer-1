#!/usr/bin/env bash

HOST='jenkins.fuchicorp.com'
USER="$JENKINS_USER"
PASSWORD="$JENKINS_PASSWORD"

if ls "./jenkins-cli.jar"; then
  echo "jenkins.model.Jenkins.instance.securityRealm.createAccount('user1', 'password123')" |
  java -jar jenkins-cli.jar -s "https://${USER}:${PASSWORD}@${HOST}/" groovy =
else
  wget "https://${HOST}/jnlpJars/jenkins-cli.jar"
fi


var = ["fsadykov", "NadiradSaip", "amdade", "seedoffd", "addiani", "daudmu21", "Nurjan87", "LeilaDev", "Khuslentuguldur", "chaglare", "leventelibal", "jsartbaeva90", "mcalik77", "jipara"]
