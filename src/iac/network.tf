
# create the VPC, subnets, and required routing tables
resource "aws_vpc" "iic_vpc" {
    cidr_block  = var.vpc_cidr

    tags = {
        Name = "iic VPC"
    }
}

resource "aws_internet_gateway" "iic_igw" {
    vpc_id = aws_vpc.iic_vpc.id
}

resource "aws_subnet" "iic_public_subnet" {
    vpc_id = aws_vpc.iic_vpc.id
    cidr_block = var.subnet_cidr
    availability_zone = var.aws_availability_zone

    tags = {
        "Name" = "public subnet"
    }
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.iic_vpc.id
    tags = {
        "Name" = "public route table"
    }
}

resource "aws_route_table_association" "public_subnet_rt" {
    subnet_id = aws_subnet.iic_public_subnet.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_route" "public_igw" {
    route_table_id = aws_route_table.public_rt.id
    gateway_id = aws_internet_gateway.iic_igw.id
    destination_cidr_block = "0.0.0.0/0"        # everything out the default route
}

resource "aws_security_group" "egress_all" {
    name = "egress all"
    description = "Allow everything out"
    vpc_id = aws_vpc.iic_vpc.id

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# horrible security
resource "aws_security_group" "ingress_all" {
    name = "ingress all"
    description = "Allow everything in"
    vpc_id = aws_vpc.iic_vpc.id

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# write the IP address of the server to a local file, for use in the front-end
# resource "local_file" "server_data" {
#     content = xxx.id
#     filename = "${path.module}"     # adjust
  
# }