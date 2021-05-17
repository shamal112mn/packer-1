# Jenkins-snapshots-script to automate the process 

Jenkins-pod-snapshot.sh is a bash script that will do the following

* Copies important files and folders from Jenkins server/pod to a directory called `jenkins_home` 
* Restores those files and folders back to the jenkins server/pod when needed.


## Use Cases: 

* Taking backups of the following files and folders from Jenkins server regularly in case those files/folders deleted accidentally. (can be used with cronjob)
```
jobs
credentials.xml
config.xml
secrets
secret.key
```

* When switching to a new cluster.

### Steps to take jenkins snapshot

* Step 1
``` 
git clone https://github.com/fuchicorp/common_scripts.git
```
* Step 2
```
cd common_scripts/jenkins-scripts
```
* Step 3

*If you have environment variable JENKINS_HOME='/tmp/jenkins_home' the script will take a back up to that folder*

```
sh jenkins-pod-snapshot.sh --sync
```


You should see the following output:
```
<./jenkins_home)> directory is created
Successfully copied necessary folders from jenkins server to jenkins_home <(./jenkins_home)> directory!
```

Run:
```
ls ./jenkins_home
```

You will  see the following files and folders copied from jenkins:
  
```
jobs
credentials.xml
config.xml
secrets
secret.key

```


### Command to run to restore files and folders back to jenkins server/pod:

```
cd common_scripts/jenkins-scripts
```

Run:
```
sh jenkins-pod-snapshot.sh --restore
```
You should see the following output:
```
Successfully copied jenkins folders from <(./jenkins_home)> directory back to jenkins server!
```
This command will copy the above files and folders inside `jenkins_home` back to the Jenkins server/pod. 



 To run the cronjob do `crontab -e` and add the following line  `0 0 * * FRI bash /common_scripts/jenkins-scripts/jenkins-pod-snapshot.sh —sync`  which is located under `jenkins-backup_cronjob`and it will run every Friday at midnight. 

 To be able to see the list of cronjob run `crontab -l`

