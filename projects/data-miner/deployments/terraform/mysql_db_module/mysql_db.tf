resource "aws_db_instance" "aws_db" {
  allocated_storage      = 5
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = "${var.mysql_name}"
  username               = "${var.username}"
  password               = "${var.password}"
  parameter_group_name   = "default.mysql5.7"
  vpc_security_group_ids = ["${aws_security_group.your_RDS_sg.id}"] 
  skip_final_snapshot    = "true"
  deletion_protection    = "false"
  publicly_accessible    = "true"
}