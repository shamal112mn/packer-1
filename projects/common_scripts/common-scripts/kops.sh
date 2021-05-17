#!/bin/bash
export CLOUD=aws
MASTER_NUMBER=3
MASTER_ZONES="us-east-1a,us-east-1b,us-east-1c"
MASTER_SIZE="t2.medium"
WORKER_NUMBER=3
WORKER_ZONES="us-east-1a,us-east-1b,us-east-1c"
WORKER_SIZE="t2.medium"
CNI_PLUGIN="calico"
KOPS_BASE_IMAGE="ami-0947d2ba12ee1ff75"
CLUSTER_NAME="test.kops.awssss.k8s.local" # if ends in .k8s.local --> gossip-based cluster
K8S_VERSION=1.17.0
NETWORK_CIDR="10.0.0.0/16"
NW_TOPOLOGY="private" # public: uses a gateway | private
STORAGE_BUCKET="kops-aws-vitalie"
BUCKET_REGION="eu-west-1"

export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)
export KOPS_STATE_STORE="s3://${STORAGE_BUCKET}"

# configure cluster
kops create cluster --node-count ${WORKER_NUMBER} --zones ${WORKER_ZONES} \
    --image ${KOPS_BASE_IMAGE} \
    --master-zones ${MASTER_ZONES} --node-size ${WORKER_SIZE} \
    --master-size ${MASTER_SIZE} --kubernetes-version=${K8S_VERSION} \
    --network-cidr=${NETWORK_CIDR} --cloud=${CLOUD} \
    --topology ${NW_TOPOLOGY} --networking ${CNI_PLUGIN}   ${CLUSTER_NAME} \
    
kops update cluster --name ${CLUSTER_NAME} --yes
kops create secret --name ${CLUSTER_NAME} sshpublickey admin ~/.ssh/id_rsa.pub 
kops validate cluster --name ${CLUSTER_NAME}

echo "Build is finished"