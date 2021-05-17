#!/usr/bin/env bash
# Color codes & helper functions
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
reset=$(tput sgr0)
debug=0


## if you would like to enable a DebugMode change debug=1
debugMode () {
if [ "$debug" -eq 1 ]; then
  echo "$1"
fi
}


## Making sure you provide more then 3 arguments 
if [ "$#" -lt 3 ]; then
  debugMode "${red}More arguments required.${reset}"
  debugMode -e "$0 username \"Person's Name <email@example.com\" \"ssh-key\" [--admin]"
  exit 1
fi


## Making sure that script is runned as a root privilleges
if [[ $EUID -ne 0 ]]; then
  debugMode "This script must be run as root"
  exit 1
fi


## if debug mode On printing some outputs
debugMode "${yellow}Username:${reset} $1"
debugMode "${yellow}Name and Email:${reset} $2"
debugMode "${yellow}SSH PublicKey file:${reset} $3"


## If the folder home/user does not exist, user will be created
if [ ! -d "/home/$1/" ]; then
  useradd "$1" --comment "$2"
  echo "${green}Created user <$1>.${reset}"
else
  echo "${yellow}User already exist.${reset}"
fi


## if the folder SSH does not exist for the user, it will be created and copied for the user
if [ ! -d "/home/$1/.ssh" ]; then
  mkdir -p "/home/$1/.ssh"
  debugMode "${green}Creating user's SSH directory.${reset}"
else
  debugMode "${yellow}User's ssh folder already exist.${reset}"
fi


## printing some outputs on debugMode and configuring SSH for the user
debugMode "${yellow}Updating the authorized_keys file${reset}"
cat "$3" > "/home/$1/.ssh/authorized_keys"
debugMode "${yellow}Setting permissions.${reset}"
chmod 700 "/home/$1/.ssh"
chmod 600 "/home/$1/.ssh/authorized_keys"
chown -R "$1":"$1" "/home/$1/.ssh"


## if the script is running for users with admin privilleges
if [ "$4" = "--admin" ]; then
  echo "${yellow}Setting Admin privileges.${reset}"
  usermod -aG wheel "$1"
  sed 's/# %wheel/%wheel/g' -i /etc/sudoers
  if [ -d  "/home/$1/.kube" ]; then
    echo "Copy kube-config to home directory."
    if [ -f  "/fuchicorp/admin_config" ]; then 


      ## if the kube-folder exist if admin-config exist cp admin-config file to users home dir.
      cp -rf "/fuchicorp/admin_config" "/home/$1/.kube/fuchicorp-config"
    fi
  else
    mkdir "/home/$1/.kube"     
    if [ -f  "/fuchicorp/admin_config" ]; then 


      ## if the user does not have a kube-folder it will be create and copied admin-config file
      cp -rf "/fuchicorp/admin_config"  "/home/$1/.kube/config"
    else
      echo "${red}/fuchicorp/admin_config not found and ~/.kube/config not created${reset}"
    fi 
  fi
else
  echo "${red}Removing Admin privileges.${reset}"
  gpasswd -d  "$1"  wheel 2> /dev/null
fi


if [ -d  "/home/$1/.kube" ]; then
  if [ -f  "/fuchicorp/view_config" ]; then 
    cp -rf "/fuchicorp/view_config" "/home/$1/.kube/fuchicorp-config"
  fi
else
  mkdir "/home/$1/.kube"
  if [ -f  "/fuchicorp/view_config" ]; then 
    

    ## if the user does not have a kube-folder it will be create and copied admin-config file
    echo "Copy kube-config to home directory."
    cp -rf "/fuchicorp/view_config"  "/home/$1/.kube/config"  
  else
    echo "${red}/fuchicorp/view_config not found and ~/.kube/config not created${reset}"
  fi
fi


## making sure that kube-folder is belong to the user
chown -R "$1." "/home/$1/.kube"
cp -rf aliases.sh  "/home/$1/.bashrc"


## If user doesn't have ssh keys it will create for user 
if [ ! -f "/home/$1/.ssh/id_rsa" ]; then
  su - $1 -c "ssh-keygen -t rsa -f /home/$1/.ssh/id_rsa -q -N '' "
fi 
echo "${green}Created user (${yellow}$1${green}) for $2.${reset}"