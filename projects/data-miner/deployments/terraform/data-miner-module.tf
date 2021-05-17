module "MySQL_DB" {
  source = "./mysql_db_module"

  region                                 = "${var.mysql_db["region"]}"
  mysql_name                             = "${var.mysql_db["mysql_name"]}"
  username                               = "${var.mysql_db["username"]}" 
  password                               = "${var.mysql_db["password"]}"
 
}

output "MYSQL_HOST" { value = "${module.MySQL_DB.MySQL_DB_endpoint}" }
output "MYSQL_DATABASE" { value = "${module.MySQL_DB.MySQL_DB_name}" }
output "MYSQL_USER" {  value = "${module.MySQL_DB.MySQL_DB_username}" }
output "MYSQL_PASSWORD" {  value = "${module.MySQL_DB.MySQL_DB_password}" }



module "data-miner-deploy" {
  source  = "fuchicorp/chart/helm"
  

  deployment_name        = "data-miner"
  deployment_environment = "${var.deployment_environment}"
  deployment_endpoint    = "${lookup(var.deployment_endpoint, "${var.deployment_environment}")}.${var.google_domain_name}" 
  deployment_path        = "data-miner-chart"

  template_custom_vars   = {     
    deployment_image     = "${var.deployment_image}"    
    username             = "${module.MySQL_DB.MySQL_DB_username}"
    password             = "${module.MySQL_DB.MySQL_DB_password}"
    mysql_name           = "${module.MySQL_DB.MySQL_DB_name}"
    database_endpoint    = "${module.MySQL_DB.MySQL_DB_endpoint}"
    whitelisted_cidrs     = "${lookup(var.whitelisted_cidrs, "${var.deployment_environment}")}" 

  }
}


