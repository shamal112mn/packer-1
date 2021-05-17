#!/bin/bash

chmod 764 transfer.sh
#get your username and assigned to the variable
usernameBastion=$(whoami) && cd
#username@remoteIP:~/source ~/destination
[ -f "cluster-infrastructure/kube-cluster/cluster.tfvars" ] && rsync -rvh $usernameBastion@old.bastion.fuchicorp.com:~/cluster-infrastructure/kube-cluster/fuchicorp-service-account.json  ~/fuchicorp/
[ -f "cluster-infrastructure/kube-cluster/fuchicorp-service-account.json" ] && rsync -rvh $usernameBastion@old.bastion.fuchicorp.com:~/cluster-infrastructure/kube-cluster/cluster.tfvars  ~/fuchicorp/
[ -f "cluster-infrastructure/kube-cluster/cluster.tfvars" ] && rsync -rvh $usernameBastion@old.bastion.fuchicorp.com:~/common_tools/common_tools.tfvars  ~/fuchicorp/


