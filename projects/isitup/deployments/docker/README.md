# How to run the isitup with docker compose?
This documentation describes how to run the isitup using [docker compose](https://docs.docker.com/compose/gettingstarted/). 

## Before you begin
1. Make sure you have docker is installed
2. Make sure docker-compose is installed 


First you will need to clone the repo 
```
git clone git@github.com:fuchicorp/isitup.git
```


after you cloned you will need to get into `isitup/deployments/docker` 
```
cd isitup/deployments/docker
```


You should see docker file and docker-compose file to build and make it up and running
```
ls -la
drwxrwxr-x. 3 vrodi18 vrodi18  82 May 12 16:19 .
drwxrwxr-x. 4 vrodi18 vrodi18  37 May  7 04:05 ..
-rw-rw-r--. 1 vrodi18 vrodi18 885 May 10 00:24 docker-compose.yaml
-rw-rw-r--. 1 vrodi18 vrodi18 549 May  7 04:05 Dockerfile
drwxrwxr-x. 5 vrodi18 vrodi18 125 May  7 04:05 isitup
-rw-rw-r--. 1 vrodi18 vrodi18   0 May 12 16:19 README.md
```


Docker compose has environment variables configured see below all env 
```
export GIT_TOKEN='<YOUR GITHUB TOKEN>'
```


After you have everything set up you can go ahead and start build and deploy
```
docker-compose build
docker-compose up
```


## List of environment variables
| Environment variable  | Required      | Description
| --------------------- |-------------- | -----------
| GIT_TOKEN             | yes           | To pull information from github 
| GITHUB_CLIENT_ID      | no            | To configuration github auth 
| GITHUB_CLIENT_SECRET  | no            | To configuration github auth 










