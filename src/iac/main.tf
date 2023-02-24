
module "frontend" {
    source = "./modules/frontend_module"
    frontend_bucket_name = var.frontend_bucket_name
}

module "backend" {
    source = "./modules/backend_module"
    backend_service_name = var.backend_service_name
    backend_image_name = var.backend_image_name
    ingress_sg = aws_security_group.ingress_all.id
    egress_sg = aws_security_group.egress_all.id
    iic_vpc = aws_vpc.iic_vpc.id
    subnet = aws_subnet.iic_public_subnet.id
}

module "db" {
    source = "./modules/db"
    db_subnet = aws_subnet.iic_public_subnet.id
}