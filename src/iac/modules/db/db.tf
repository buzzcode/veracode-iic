
resource "aws_db_instance" "iic_db" {
    allocated_storage = 10
    db_name = "iic-rds"
    engine = "mysql"
    db_subnet_group_name = ""
    instance_class = "db.t2.micro"
    username = var.db_username
    password = var.db_password
}