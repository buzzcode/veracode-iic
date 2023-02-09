
# create the VPC
resource "aws_vpc" "IIC_vpc" {
    cidr_block  = var.vpc_cidr
}
