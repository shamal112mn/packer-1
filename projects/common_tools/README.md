**THE COMMON_TOOLS DEPLOYMENT STEPS**



Prerequisites:

Make sure you have finished with [cluster-infrastructure](https://github.com/fuchicorp/cluster-infrastructure) deployment


Required Packages
```
terraform v1.14
kubectl (configured )
helm v2.14.0
Cert-manager v1.0.2
Kube Cluster v1.16
```

**A - THE STEPS OF CONFIGURATION:**


1. Clone the repository from GitHub

```
git clone https://github.com/fuchicorp/common_tools.git
cd common_tools
```

2. Copy and paste your credentials `fuchicorp-service-account.json` from cluster-infrustrature/kube-cluster folder to your common_tools folder. 

3. Create an organization to house your oAuth Apps. This is your own person organization and not your Github account or Fuchicorp. 
   - Go to your name in the right hand corner and click "Your Organizations" 
   - Click "New organizations"
   - Click "Join for Free"
   - Create a name for organization and add your email.  Click "My personal account".
   - Click next to finish

4. Create Github oAuth Credentials under your organization. </br>
Please note that once you generate your client secret you will not be able to repull this information.  You can generate new secret if you lose your inital seceret text.  You will need both the Client ID and Client secret for each App for the common_tools.tvars configuration in the next step. </br>

   - Go to your github organization page than go Settings>> Developer Settings >>  oAuth Apps </br>
   - You have to create a new oAuth application for each of the resource ( Jenkins, Kube-Dashboard, Grafana, Sonarqube )</br>
   - Replace "fuchicorp.com" with your domain name. <br>
- Jenkins
```
     Register a new oAuth application:
     Application Name: Jenkins
     HomePage URL, add your domain name: https://jenkins.yourdomain.com
     Authorization callback URL: https://jenkins.yourdomain.com/securityRealm/finishLogin
     
```
- Grafana
 ```    
     Register a new oAuth application:
     Application Name: Grafana
     HomePage URL, add your domain name: https://grafana.yourdomain.com/login
     Authorization callback URL: https://grafana.yourdomain.com/login
     
```
- Dashboard Kubernetes
 ```  
     Register a new oAuth application:
     Application Name: Dashboard Kubernetes
     HomePage URL, add your domain name: https://dashboard.yourdomain.com
     Authorization callback URL: https://dashboard.yourdomain.com/oauth2/callback
     
```
- Sonarqube
 ```
     Register a new oAuth application:
     Application Name: Sonarqube 
     HomePage URL, add your domain name: https://sonarqube.yourdomain.com
     Authorization callback URL: https://sonarqube.yourdomain.com/oauth2/callback
```
5. Create `common_tools.tfvars` file inside common_tools directory. </br>
#Spelling of `common_tools.tfvars` must be exactly same syntax see [WIKI](https://github.com/fuchicorp/common_tools/wiki/Create-a-jenkins-secret-type-SecretFile-on-kubernetes-using-terraform) for more info

6. Configure  the `common_tools.tfvars` file 

```
google_bucket_name        = ""          # Write your bucket name from google cloud
deployment_name           = ""          # Configure a deployment name
google_project_id         = ""          # Write your project id from google cloud
google_domain_name        = ""          # your domain name
credentials               = ""          # file name your credentials located
deployment_environment    = ""          # namespace you like to deploy
vault_token               = ""          # LEAVE BLANK
jenkins = {
  admin_user             = ""           # Configure jenkins admin username
  admin_password         = ""           # Configure strong password for Jenkins admin
  jenkins_auth_client_id = ""           # Client ID for jenkins from your github oAuth Apps
  jenkins_auth_secret    = ""           # Client Secret for jenkins from your github oAuth Apps
  git_token              = ""           # Github token
  git_username           = ""           # Github username
}
nexus = {
  admin_password        = ""            # Configure strong password for Nexus admin  
}
grafana = {
  grafana_username                = ""      # Configure grafana admin username
  grafana_password                = ""      # Configure strong password for Grafana
  grafana-name                    = ""      # Configure a name for your grafana
  grafana_auth_client_id          = ""      # Client ID for grafana from your github oAuth Apps
  grafana_client_secret           = ""      # Client Secret for grafana from your github oAuth Apps
  smtp_username                   = ""      # Client ID for grafana from your github oAuth Apps
  smtp_password                   = ""      # Client ID for grafana from your github oAuth Apps
  slack_url                       = ""      # Slack channel url for alerts
  github_organization             = ""      # your organization name from github
}
kube_dashboard = {
  github_auth_client_id = ""        # Client ID for kube dashboard from your github oAuth Apps
  github_auth_secret    = ""        # Client Secret for kube dashboard from your github oAuth Apps
  github_organization   = ""        # Your organiation name from github
}
sonarqube = {
  sonarqube_auth_client_id  = ""        # Client ID for Sonarqube from your github oAuth Apps
  sonarqube_auth_secret     = ""        # Client Secret for Sonarqube from your github oAuth Apps
  admin_password            = ""        # Configure a strong password for sonarqube admin
}

#create lists of trusted IP addresses or IP ranges from which your users can access your domains
common_tools_access = [ 
                        "10.16.0.27/8",         ## Cluster access
                        "50.194.68.229/32",     ## Office IP1 
                        "50.194.68.230/32",     ## Office IP2
                        "50.194.68.237/32",     ## fsadykov home
                        "#.#.#.#",              ## Add your IP address (Required)
]
show_passwords                = "true"


```

7. The name servers that respond to DNS queries for this domain. Your DNS and cluster/cloud DNS (name servers) should be matched for connection.
   if you use Route53, you have to check and edit your name servers. 

   ### Registered Zones
   - To find your GCP NS record to copy from, go to your GCloud console, type in search bar "Cloud DNS"
   - Click "cluster-infrastructure-zone" and look for NS record
   - You will see something similar to this
      ```
      ns-cloud-b1.googledomains.com.
      ns-cloud-b2.googledomains.com.
      ns-cloud-b3.googledomains.com.
      ns-cloud-b4.googledomains.com.
      ```
   - Now open Route53 in AWS and go to Domains > Register domains. 
   - Click on your domain name and you will see "Name Servers" on the far right.  You will need to click "Add or edit name servers"
   - Copy and paste each record from your GCP NS into this area and save.  </br>**This will take some time to update, be patient.  You will recieve an email from AWS when updated. 
   
   ### Hosted Zones
    - To find your GCP SOA record to copy, go to your GCloud console, type in search bar "Cloud DNS"
   - Click "cluster-infrastructure-zone" and look for SOA record
   - You will see something similar to this
      ```
      ns-cloud-b1.googledomains.com. cloud-dns-hostmaster.google.com. 1 21600 3600 259200 300
      ```
   - Now we will configure our Hosted Zones record. 
   - Click on "Hosted zones" on the left hand panel of Route53
   - Click your domain name
   - Check mark your SOA record and click "Edit" 
   - Copy your SOA record from your GCP Cloud DNS into this record. Similar to below. 
   - Copy and paste the SOA record from your GCP SOA into this area and save.
   

8. After you have configured all of the above now you run commands below to create the resources.
commands:

```
source set-env.sh common_tools.tfvars
terraform apply -var-file=$DATAFILE
```
