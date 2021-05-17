output "MySQL_DB_endpoint" {
    value = "${aws_db_instance.aws_db.endpoint}"
}

output "MySQL_DB_name" {
    value = "${aws_db_instance.aws_db.name}"
}

output "MySQL_DB_password" {
    value = "${aws_db_instance.aws_db.password}"
}

output "MySQL_DB_username" {
    value = "${aws_db_instance.aws_db.username}"
}