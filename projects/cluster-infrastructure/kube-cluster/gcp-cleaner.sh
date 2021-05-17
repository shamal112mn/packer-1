#!/bin/sh
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

read -p  "Do you wish to delete GCP resources, Yes/No?   " ANSWER

if [ "$ANSWER" != "${ANSWER#[Yy]}" ] ;then
    echo "Deleting project.."
    GOOGLE_CLOUD_PROJECT=$(gcloud projects list)
    echo "${green}$GOOGLE_CLOUD_PROJECT${reset}"
    read -p 'Which project would you like to delete?' PROJECT
    echo "${red}$PROJECT${reset} will be deleted"
    gcloud projects delete $PROJECT --quiet 

else
    echo "Cancelled deletion of project. Thank you!"
fi
