#!/bin/bash 


USERS="$(cat /etc/passwd| grep -i none  | awk -F ':' '{print $1}')"

for user in $USERS; do
    echo "Setting up for user: $user"
    su - "$user" bash -c 'git config --global credential.helper store'
done