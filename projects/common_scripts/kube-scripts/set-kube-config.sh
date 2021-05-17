#!/bin/bash

## Script to create two service accounts and onboard list of people
if [[ ! $1 ]]; then
  echo "Use following way: ./set-kube-config.sh 192.168.1.0"
  exit 1
fi

KUBERNETES_ENDPOINT="https://$1:443"
NAMESPACE="$2"
SERVICE_ACCOUNT="$3"

function generate_kube_config() {
  local SERVICE_ACCOUNT="$1"
  local NAMESPACE="$2"
  local KUBE_CONFIG_NAME="$3"
  SECRET_NAME=$(kubectl get "serviceaccount/${SERVICE_ACCOUNT}" -n "${NAMESPACE}" -o jsonpath='{.secrets[].name}')
  ca=$(kubectl get "secret/$SECRET_NAME" -n "${NAMESPACE}" -o jsonpath='{.data.ca\.crt}')
  token=$(kubectl get "secret/$SECRET_NAME" -n "${NAMESPACE}"  -o jsonpath='{.data.token}' | base64 --decode)
  echo "apiVersion: v1
kind: Config
clusters:
- name: default-cluster
  cluster:
    certificate-authority-data: ${ca}
    server: ${KUBERNETES_ENDPOINT}
contexts:
- name: default-context
  context:
    cluster: default-cluster
    namespace: default
    user: default-user
current-context: default-context
users:
- name: default-user
  user:
    token: ${token}
  " > ./"${KUBE_CONFIG_NAME}"
  echo "Crated config file: ./${KUBE_CONFIG_NAME}"
}

generate_kube_config "${SERVICE_ACCOUNT}" "${NAMESPACE}" "kube_config"