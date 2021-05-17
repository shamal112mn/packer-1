#!/usr/bin/env bash

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`


COMPANY_NAME="Acirrustech"
echo """
${green}
####################################################################################################
###################################### Welcome to $COMPANY_NAME ######################################
####################################################################################################
${reset}

${red}
      Make sure before doing something you got approval and you have ticket.
      If you do not have ticket you will be responsible your steps
${reset}

Your username: ${red}$USER${reset}
Your home:     ${red}$HOME${reset}
"""
