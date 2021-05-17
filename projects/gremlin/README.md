# Gremlin Helm Charts

This repository hosts the official **Gremlin Helm Charts** to deploy **Gremlin** products to [Kubernetes](https://kubernetes.io/)

## Install Helm

Get the latest [Helm release](https://github.com/kubernetes/helm#install).

## Install Charts

Description: Gremlin is a test tool for performance testing in stage environment

**Pre-requisites**

1. Navigate to Gremlin.com and set up a new account

2. Create a team

3. Get team ID and generate Secret ID

4. Navigate to your GCP and create a new cluster with only two nodes. (Free version only allows two nodes. More than two nodes will be charged by Gremlin.)

5. In your new cluster terminal generate kube-config

6. Create gremlin namespace 

	```kubectl namespace -n gremlin```

7. Clone this repo

	```https://github.com/fuchicorp/gremlin.git```

	```cd /gremlin```

8. Run this command:

```
helm install gremlin \
    --namespace gremlin \
    --set gremlin.secret.managed=true \
    --set gremlin.secret.type=secret \
    --set gremlin.secret.teamID=YOUR-TEAM-ID \
    --set gremlin.secret.clusterID=YOUR-PROJECT-ID \
    --set gremlin.secret.teamSecret=YOUR-TEAM-SECRET .
```

**Testing**


1. In your kubernetes cluster, create a sample deployment in default namespace

	```vim sample-deployment.yaml```
	
	```kubectl create -f sample-deployment.yaml```
	
	```kubectl get pods```

2. Autoscale your deployment similar to these criteria

	```kubectl autoscale deployment nginx-deployment --cpu-percent=75 --min=1 --max=10```

3. From your gremlin console navigate to attack tab

click "New attack" > kubernetes > choose your cluster > default namespace > click deployments and choose sample-deployment > click “choose a gremlin” > resource > CPU > choose length in seconds > CPU capacity( %90 for example) > exact container: name of the container >> unleash gremlin

4. Go to cluster terminal and run ```kubectl get pods``` to see whether the pod numbers increasing


For more detailed instructions, see the chart's documentation [here](https://github.com/gremlin/helm/blob/master/gremlin/README.md).

## Reporting Issues



Please report all issues via github issues [here](https://github.com/gremlin/helm/issues).
