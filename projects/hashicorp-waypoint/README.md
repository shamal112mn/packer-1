<img src="https://i.ibb.co/W3Rdchy/waypoint-logo.jpg" alt="waypoint-logo" border="0"><br>

# Resources & Videos for Waypoint to review for further understanding

## Videos
- Official Hashicorp Waypoint Intro and Demo [Click here to view](https://www.youtube.com/watch?v=nasVKN7Wbtk) <br>

- Hashicorp Waypoint Deep-Dive [Click here to view](https://www.youtube.com/watch?v=0Q0VE5oPL8Y&t=671s) <br>

- Introduction to Hashicorp Wapoint with Armon Dadgar [Click here to view](https://www.youtube.com/watch?v=JL0Qeq4A6So) <br>
This goes more into the thinking behind Waypoint much more and I highly recommend. 

## Documentation
- Waypoint Official Documentation [Click here to view](https://www.waypointproject.io/docs)
- Waypoint Hashicorp Learn Tutorials [Click here to view](https://learn.hashicorp.com/waypoint)
- Waypoint Hashicorp Example Repo [Click here to view](https://github.com/hashicorp/waypoint-examples.git)
# Installing Prerequisites on Localhost 
You will to install Brew package manager and Docker Desktop before you are able to install Waypoint CLI. 

- Install Brew on Mac OS <br>
Go to https://brew.sh/ and copy and paste the command under "Install Homebrew" to your terminal.
- Install Docker desktop <br>
Go to "https://www.docker.com/products/docker-desktop" and select your OS and download. <br>
Click on the dmg file and follow the instructions to install.
When install is complete test to ensure its installed by running <br>
`docker version`
- (Optional) Please see more about this under Hello-world deploy of this wiki [Click here](https://github.com/ksalrin/wayhello-salrin/wiki/Hello-world-example-deploy) <br>
Install Helm if you are deploying a helm chart with the waypoint.hcl exec option.  
```
brew install helm@2
brew install helm
cd /usr/local/bin
ln -s /usr/local/opt/helm@2/bin/tiller tiller
ln -s /usr/local/opt/helm@2/bin/helm helm2
ln -s helm helm3
```

## Accessing your Google Cluster
Now we are ready to install the Waypoint CLI, we do not deploy the Waypoint Server until we are connected to the our Gcloud cluster. 

- Install waypoint CLI<br>
`brew tap hashicorp/tap`<br>
`brew install hashicorp/tap/waypoint`<br>
`brew upgrade hashicorp/tap/waypoint`<br>
When installed test by running<br>
`waypoint`<br>

- Now we need to connect to the gcloud cluster from the local host.  You will need to run the gcloud auth command to gain access.<br>
`gcloud auth login` 

- You will be asked if you would like to continue, type y. Copy and paste the link given in your browser and follow the steps to chose your google account and allow access. 

- You will then receive a token on the browser to copy and then paste that in your command line. If successful it will say "You are now logged in as ["your google email"], Your current project is ["project_name"].

- Now that you are logged to your gcloud and have verified your credentials.  Run this to set your kubeconfig with the environment variable to allow access to cluster.<br>
`gcloud container clusters get-credentials fuchicorp-cluster --zone us-west1-b`

- Test that you are able to see your cluster resources <br>
`kubectl get pods -n tools`

## Installing Waypoint CLI on Localhost (NOT THE WAYPOINT SERVER)

- Install waypoint server <br>
`waypoint install --platform=kubernetes -accept-tos --namespace tools` <br>

- Check that the server installed  <br>
`kubectl get pods -n tools` <br>
You should see  <br>
`waypoint-server-0`

- Connect with the UI of the Waypoint Server to confirm. You can do this easily via CLI, type the command below and it will open a window to your waypoint automatically. <br>
`waypoint ui`

- Waypoint Server UI will ask you to provide a token, you will just need to copy the command that it supplies and run it in your command line. It will return with a token that you copy and paste back into the UI to login. 
## Creating Hello-world example with waypoint.hcl file 
<br>
<img src="https://i.ibb.co/mhPcwGY/waypointmap.jpg" alt="waypointmap" border="0"><br>

# Creating waypoint.hcl file
We used the example repo from provided by Waypoint documentation to get started with configuring our hello-world. 

- git cloned the example repo provided by Hashicorp <br>
`git clone https://github.com/hashicorp/waypoint-examples.git`

- We took the kubernetes nodejs waypoint.hcl file code to build off of and started with the docker image build. 

## Project and App Stanzas:
- First changes we made were to name the project.  The project name can be whatever you would like to name it, it will show up as this name in your server ui. 

- We then add an app name.  Much like the project this name can be whatever you would like to help identify what app you are deploying in this file. In this case we kept it simple and named the project and app the same name. 

- We added the path to the app waypoint would be building. In this case we have the Dockerfile and app.py located in the deployment/docker path which we specified. 

- We added labels for service and env.  We did this for testing purposes but when deployed we did see that these labels are not added to the pod, so I'm not sure the source case for this label definition. 

```
project = "hello-world"

app "hello-world" {
  path = "./deployments/docker"
  labels = {
      "service" = "hello-world"
      "env" = "dev"
  }
```

## Build Stanza:  

- We are building the Dockerfile image and pushing it to our Dockerhub. Which is why the use is specified as "docker".  
- Next we add registry stanza and again specify that we are pushing this image with "docker".  
- In this registry docker stanza we input our image name which is your docker_username/Docker_image_name. Then we can add the tag for the version if we would like.  If you do not add this by default it will be named "latest".   

- Now we need to add our credentails for dockerhub to be able to push the image.  We accomplish this by making a simple auth json file with that information.  Its very easy to configure, I have an example below. If you are using this sample name is dockerAuth.json to make is simple. <br>
*Note: do not have spaces
```
{"username":"xxx","password":"xxx","email":"xxx"}
```
- Now we add encoded_auth = filebase64("path/to/json/file"), it will pull those credentials to take with dockerhub to push. 

```
 build {
    use "docker" {
    }
    registry {
        use "docker" {
          image = "ksalrin/hello-world"
          tag = "v4"
          encoded_auth = filebase64("./deployments/docker/dockerAuth.json")
        }
    }
 }
```
- You can test this stanza only by running the waypoint build command.  This helps to troubleshoot the sections of our code. You do need to run the waypoint init first before the build command. 
```
waypoint init
waypoint build
```
## Deploy Stanza:
- We set use as "kubernetes" because this is the platform we will be using to deploy the docker image to.
- We add the service_port of the Dockerfile app which for Flask is port 5000.  
- We define the namespace "tools" to deploy the pod to
```
   deploy {
     use "kubernetes" {
       service_port = 5000 
       namespace = "tools"
       annotations = {"kubernetes.io/ingress.class":"nginx","cert-manager.io/cluster-issuer":"letsencrypt-prod"}
    }
  }
```
## Release Stanza
- We set use as "kubernetes" because we are using this platform to expose our deploy service to the 80 port to be accessible. This is also the area where we run into an issue with trying to add the ingress annotation or how to define a url.  Please see issues and related tickets here [Please click see this page](https://github.com/ksalrin/wayhello-salrin/wiki/Waypoint-Issues). <br>
- Another option we explored is using the exec deploy with helm, to explore this option [Please click see this page](https://github.com/ksalrin/wayhello-salrin/wiki/Exec-Deploy-Hello-world-work-around-with-Helm). <br> There are positives and negatives to this option as well.  

```
   release {
      use "kubernetes" {
        port = 80
        namespace = "tools"
     }
   }
```
# Full code of the waypoint.hcl

```
  
project = "hello-world"

app "hello-world" {
  path = "./deployments/docker"
  labels = {
      "service" = "hello-world"
      "env" = "dev"
  }

  build {
    use "docker" {
    }
    registry {
        use "docker" {
          image = "ksalrin/hello-world"
          tag = "v4"
          encoded_auth = filebase64("./deployments/docker/dockerAuth.json")
        }
    }
 }

   deploy {
     use "kubernetes" {
       service_port = 5000 
       namespace = "tools"
       annotations = {"kubernetes.io/ingress.class":"nginx","cert-manager.io/cluster-issuer":"letsencrypt-prod"}
    }
  }

   release {
      use "kubernetes" {
        namespace = "tools"
        port = 80
     }
   }
  
}
```
## Let's deploy this hello-world example
- Save your full code and in the folder where your waypoint.hcl is located we will run the waypoint up command.  This command will run each stanza sequentially in the code to build, deploy and release your code.   
```
waypoint init
waypoint up
```
<br>
<img src="https://i.ibb.co/42ytcxW/waypoint-up.jpg" alt="waypoint-up" border="0"> 
<br>
# How to remove the Waypoint server from K8

Waypoint install for Kubernetes creates a StatefulSet, Service and PersistentVolumeClaim. These resources should be removed when Waypoint Server is no longer needed. These are some example kubectl commands that should clean up after a Waypoint Server installation.

```
kubectl delete statefulset waypoint-server -n tools
kubectl delete pvc data-waypoint-server-0 -n tools
kubectl delete svc waypoint -n tools

```

For further info on how to remove server from other platforms. https://www.waypointproject.io/docs/troubleshooting
# Waypoint Issues
To review our other issues please see Waypoint Issues Wikipage
[Click here to view](https://github.com/fuchicorp/hashicorp-waypoint/wiki/Waypoint-Issues)
