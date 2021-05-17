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
