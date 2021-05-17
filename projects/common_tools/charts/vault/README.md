# Vault Helm Chart

> :warning: **Please note**: We take Vault's security and our users' trust very seriously. If 
you believe you have found a security issue in Vault Helm, _please responsibly disclose_ 
by contacting us at [security@hashicorp.com](mailto:security@hashicorp.com).

This repository contains the official HashiCorp Helm chart for installing
and configuring Vault on Kubernetes. This chart supports multiple use
cases of Vault on Kubernetes depending on the values provided.

For full documentation on this Helm chart along with all the ways you can
use Vault with Kubernetes, please see the
[Vault and Kubernetes documentation](https://www.vaultproject.io/docs/platform/k8s/).

## Prerequisites

To use the charts here, [Helm](https://helm.sh/) must be configured for your
Kubernetes cluster. Setting up Kubernetes and Helm and is outside the scope of
this README. Please refer to the Kubernetes and Helm documentation.

The versions required are:

  * **Helm 3.0+** - This is the earliest version of Helm tested. It is possible
    it works with earlier versions but this chart is untested for those versions.
  * **Kubernetes 1.9+** - This is the earliest version of Kubernetes tested.
    It is possible that this chart works with earlier versions but it is
    untested. Other versions verified are Kubernetes 1.10, 1.11.

## Usage

To install the latest version of this chart, add the Hashicorp helm repository
and run `helm install`:

```console
$ helm repo add hashicorp https://helm.releases.hashicorp.com
"hashicorp" has been added to your repositories

$ helm install vault hashicorp/vault
```

Please see the many options supported in the `values.yaml` file. These are also
fully documented directly on the [Vault
website](https://www.vaultproject.io/docs/platform/k8s/helm) along with more
detailed installation instructions.


# Upgrade Vault Chart to 0.7.0 App Version 1.5.2

## Steps taken to upgrade to Chart 0.7.0 App Version 1.5.2
1. Removed the vault chart from /common_tools/charts/ directory <br>
`rm -rf vault`<br>
2. Add the hashicorp/vault repo <br>
`helm repo add hashicorp https://helm.releases.hashicorp.com`<br>
3. To update helm repos<br>
`helm repo update`<br>
4. Fetched the chart Vault version 0.7.0<br>
`helm fetch --untar vault hashicorp/vault --version 0.7.0`<br>
5. Change the chart.yaml apiVersion from  "v2" to "v1"
6. The following updates need to be added the value.yaml file below: <br>
*  Under injector update to the following:
```
 injector: 
    enabled: false
```
*  Under ingress in hosts update to the following:
 ```
    hosts:
      - host: ${deployment_endpoint}
        paths:
        - /
    pathOverride: ""
```
*  Under ingress in tls update to the following:
```
    tls:
    - secretName: chart-vault-tls
      hosts:
      - ${deployment_endpoint}
```
9. Before apply the new vault chart, make sure to purge the old vault helm chart, otherwise you will recieve this error: <br>
* helm_release.helm_deployment: rpc error: code = Unknown desc = StatefulSet.apps "vault-tools" is invalid: spec: Forbidden: updates to statefulset spec for fields other than 'replicas', 'template', and 'updateStrategy' are forbidden<br>
`helm delete --purge vault-tools` <br>

8. Go back to the common_tools directory and run these commands to apply helm chart updates<br>
`source set-env.sh common-tools.tfvars` <br>
`terraform plan -var-file $DATAFILE`<br>
`terraform apply -var-file $DATAFILE -auto-approve`<br><br>

## How to log into Vault and get your keys and tokens
Please remember to save your keys and tokens somewhere safe.  Once generated, you will not be able to retrieve these keys and tokens again. <br>
1. You can click on Vault main page to initialize to generate your keys and tokens.  It will link you to this [page
](https://learn.hashicorp.com/tutorials/vault/getting-started-deploy#initializing-the-vault) with commands on how to retrieve your keys and tokens.
2. To execute those commands you will need to log into the vault pod <br>
`kubectl exec -it vault-tools-0   -n tools -- /bin/sh`
3. Once in the pod, use this command to generate the keys and token: <br>
`vault operator init`
4. Copy all the keys and go back to your vault page. Enter one Unseal Key into the box.  You will need to put in three of the five keys. 
5. It will ask for the token which would be the Initial Root Token given last under the Unseal Keys.  Enter that token and vault is unsealed and ready to use. 

## Lost your keys and token?
Since you cannot retrieve your keys and token after generating them, you will need to delete vault and the vault pvc to generate new ones.
1. Helm purge vault first <br>
`helm delete --purge vault-tools` <br>
2. You will also need to delete the pvc, otherwise it will not allow you to generate new keys <br>
`kubectl delete pvc -n tools data-vault-tools-0` <br>
3. Go back to the common_tools directory and run these commands to re-apply<br>
`source set-env.sh common-tools.tfvars` <br>
`terraform plan -var-file $DATAFILE`<br>
`terraform apply -var-file $DATAFILE -auto-approve`<br><br>
4. Follow the "How to log into Vault and get your keys and token" steps above. 
